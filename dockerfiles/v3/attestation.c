#include <nsm.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

// Simple base64 decoding
static int base64_decode(const char *input, uint8_t **output, size_t *output_len) {
    static const uint8_t decode_table[256] = {
        ['A']=0,['B']=1,['C']=2,['D']=3,['E']=4,['F']=5,['G']=6,['H']=7,
        ['I']=8,['J']=9,['K']=10,['L']=11,['M']=12,['N']=13,['O']=14,['P']=15,
        ['Q']=16,['R']=17,['S']=18,['T']=19,['U']=20,['V']=21,['W']=22,['X']=23,
        ['Y']=24,['Z']=25,['a']=26,['b']=27,['c']=28,['d']=29,['e']=30,['f']=31,
        ['g']=32,['h']=33,['i']=34,['j']=35,['k']=36,['l']=37,['m']=38,['n']=39,
        ['o']=40,['p']=41,['q']=42,['r']=43,['s']=44,['t']=45,['u']=46,['v']=47,
        ['w']=48,['x']=49,['y']=50,['z']=51,['0']=52,['1']=53,['2']=54,['3']=55,
        ['4']=56,['5']=57,['6']=58,['7']=59,['8']=60,['9']=61,['+']=62,['/']=63
    };
    
    size_t input_len = strlen(input);
    if (input_len == 0) return 0;
    
    size_t out_len = (input_len * 3) / 4;
    uint8_t *out = malloc(out_len);
    if (!out) return -1;
    
    size_t j = 0;
    for (size_t i = 0; i < input_len; i += 4) {
        uint32_t v = 0;
        for (int k = 0; k < 4 && (i + k) < input_len; k++) {
            char c = input[i + k];
            if (c == '=') break;
            v = (v << 6) | decode_table[(uint8_t)c];
        }
        if (j < out_len) out[j++] = (v >> 16) & 0xFF;
        if (j < out_len) out[j++] = (v >> 8) & 0xFF;
        if (j < out_len) out[j++] = v & 0xFF;
    }
    
    *output = out;
    *output_len = j;
    return 0;
}

// Base64 encoding - outputs to stdout
static void base64_encode(const uint8_t *data, uint32_t len) {
    const char *b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    for (uint32_t i = 0; i < len; i += 3) {
        uint32_t octet_a = data[i];
        uint32_t octet_b = (i + 1 < len) ? data[i + 1] : 0;
        uint32_t octet_c = (i + 2 < len) ? data[i + 2] : 0;
        uint32_t triple = (octet_a << 16) + (octet_b << 8) + octet_c;
        
        putchar(b64[(triple >> 18) & 0x3F]);
        putchar(b64[(triple >> 12) & 0x3F]);
        putchar((i + 1 < len) ? b64[(triple >> 6) & 0x3F] : '=');
        putchar((i + 2 < len) ? b64[triple & 0x3F] : '=');
    }
}

// Output error as JSON, then base64 encode it
static void output_error(const char *stage, const char *message, int error_code) {
    char json[2048];
    int len = snprintf(json, sizeof(json),
        "{\"status\":\"error\",\"stage=\"%s\",\"message\":\"%s\",\"error_code\":%d}",
        stage, message, error_code);
    
    if (len > 0 && len < sizeof(json)) {
        base64_encode((uint8_t*)json, len);
        putchar('\n');
    } else {
        // Fallback if JSON building fails
        printf("eyJzdGF0dXMiOiJlcnJvciIsIm1lc3NhZ2UiOiJKU09OIGVycm9yIn0=\n");
    }
}

// Output success with attestation document in base64
static void output_success(const uint8_t *doc, uint32_t doc_len) {
    // Output format: {"status":"success","attestation":"<base64_doc>"}
    printf("{\"status\":\"success\",\"attestation\":\"");
    base64_encode(doc, doc_len);
    printf("\"}\n");
}

int main() {
    struct nsm_handle *nsm = NULL;
    uint8_t *doc = NULL;
    uint32_t doc_len = 0;
    uint8_t *nonce = NULL;
    size_t nonce_len = 0;
    char nonce_b64[1024] = {0};
    
    // Stage 1: Read nonce from stdin
    if (fgets(nonce_b64, sizeof(nonce_b64), stdin)) {
        nonce_b64[strcspn(nonce_b64, "\r\n")] = 0;
        
        // Decode nonce if provided
        if (strlen(nonce_b64) > 0) {
            if (base64_decode(nonce_b64, &nonce, &nonce_len) != 0) {
                output_error("nonce_decode", "Failed to decode base64 nonce", -1);
                return 1;
            }
        }
    } else {
        // No nonce provided, that's okay - continue without it
        nonce = NULL;
        nonce_len = 0;
    }
    
    // Stage 2: Initialize NSM library
    int init_ret = nsm_lib_init();
    if (init_ret != 0) {
        output_error("nsm_init", "NSM library initialization failed", init_ret);
        if (nonce) free(nonce);
        return 1;
    }
    
    // Stage 3: Open NSM device
    nsm = nsm_lib_nsm_process_request();
    if (!nsm) {
        output_error("nsm_open", "Failed to open NSM device - check if running in enclave", -2);
        nsm_lib_exit();
        if (nonce) free(nonce);
        return 1;
    }
    
    // Stage 4: Get attestation document
    int ret = nsm_get_attestation_doc(
        nsm,
        nonce, nonce_len,     // Include nonce in attestation
        NULL, 0,              // user_data (optional)
        NULL, 0,              // public_key (optional)
        &doc, &doc_len
    );
    
    if (ret != 0) {
        char msg[256];
        snprintf(msg, sizeof(msg), "NSM attestation request failed with code %d", ret);
        output_error("attestation", msg, ret);
        goto cleanup;
    }
    
    if (!doc || doc_len == 0) {
        output_error("attestation", "Received empty attestation document from NSM", -3);
        goto cleanup;
    }
    
    // Stage 5: Success - output the attestation document
    output_success(doc, doc_len);
    
cleanup:
    if (nonce) free(nonce);
    if (doc) free(doc);
    if (nsm) nsm_lib_nsm_exit(nsm);
    nsm_lib_exit();
    
    return 0;
}
