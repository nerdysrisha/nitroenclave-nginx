#include <nsm.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    struct nsm_handle *nsm = NULL;
    uint8_t *doc = NULL;
    uint32_t doc_len = 0;
    
    // Initialize NSM
    if (nsm_lib_init() != 0) {
        fprintf(stderr, "Failed to initialize NSM library\n");
        return 1;
    }
    
    nsm = nsm_lib_nsm_process_request();
    if (!nsm) {
        fprintf(stderr, "Failed to open NSM device\n");
        nsm_lib_exit();
        return 1;
    }
    
    // Get attestation document (no nonce, public key, or user data)
    int ret = nsm_get_attestation_doc(nsm, NULL, 0, NULL, 0, NULL, 0, &doc, &doc_len);
    
    if (ret != 0 || !doc) {
        fprintf(stderr, "Failed to get attestation document (error: %d)\n", ret);
        if (nsm) nsm_lib_nsm_exit(nsm);
        nsm_lib_exit();
        return 1;
    }
    
    // Base64 encode and output
    const char *b64_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    for (uint32_t i = 0; i < doc_len; i += 3) {
        uint32_t octet_a = i < doc_len ? doc[i] : 0;
        uint32_t octet_b = i + 1 < doc_len ? doc[i + 1] : 0;
        uint32_t octet_c = i + 2 < doc_len ? doc[i + 2] : 0;
        uint32_t triple = (octet_a << 16) + (octet_b << 8) + octet_c;
        
        putchar(b64_chars[(triple >> 18) & 0x3F]);
        putchar(b64_chars[(triple >> 12) & 0x3F]);
        putchar(i + 1 < doc_len ? b64_chars[(triple >> 6) & 0x3F] : '=');
        putchar(i + 2 < doc_len ? b64_chars[triple & 0x3F] : '=');
    }
    putchar('\n');
    
    // Cleanup
    nsm_lib_nsm_exit(nsm);
    nsm_lib_exit();
    free(doc);
    
    return 0;
}
