FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install dependencies
RUN dnf update -y && \
    dnf install -y \
    nginx \
    socat \
    nc \
    iproute \
    procps-ng \
    python3 \
    python3-pip \
    gcc \
    make \
    vim-common \
    --allowerasing

# Install Python dependencies  
RUN pip3 install cbor2

# Setup NGINX
RUN echo "Hello from NGINX in Enclave via VSOCK proxy!" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf

# Create minimal NSM C library that uses ioctl directly
COPY <<'EOFMARKER' /tmp/nsm_simple.h
#ifndef NSM_SIMPLE_H
#define NSM_SIMPLE_H
#include <stdint.h>
#include <stddef.h>

int nsm_get_attestation(const uint8_t *nonce, size_t nonce_len, uint8_t **doc_out, uint32_t *doc_len_out);

#endif
EOFMARKER

COPY <<'EOFMARKER' /tmp/nsm_simple.c
#include "nsm_simple.h"
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#define NSM_REQUEST_MAX_SIZE 0x1000
#define NSM_RESPONSE_MAX_SIZE 0x3000
#define NSM_IOCTL_MAGIC 0x0A
#define NSM_IO_REQUEST _IOWR(NSM_IOCTL_MAGIC, 0, struct nsm_raw)

struct nsm_raw {
    uint8_t request[NSM_REQUEST_MAX_SIZE];
    uint8_t response[NSM_RESPONSE_MAX_SIZE];
    uint32_t request_len;
    uint32_t response_len;
};

// Minimal CBOR encoding for attestation request
static int build_attestation_request(const uint8_t *nonce, size_t nonce_len, uint8_t *out, size_t *out_len) {
    size_t idx = 0;
    
    // CBOR map with 1 key
    out[idx++] = 0xA1;
    
    // Key: "Attestation" (text string, length 11)
    out[idx++] = 0x6B;
    memcpy(&out[idx], "Attestation", 11);
    idx += 11;
    
    // Value: map with nonce
    if (nonce && nonce_len > 0) {
        out[idx++] = 0xA1; // map with 1 entry
        out[idx++] = 0x65; // "nonce" (5 chars)
        memcpy(&out[idx], "nonce", 5);
        idx += 5;
        
        // nonce as byte string
        if (nonce_len < 24) {
            out[idx++] = 0x40 | nonce_len;
        } else if (nonce_len < 256) {
            out[idx++] = 0x58;
            out[idx++] = nonce_len;
        } else {
            return -1;
        }
        memcpy(&out[idx], nonce, nonce_len);
        idx += nonce_len;
    } else {
        out[idx++] = 0xA0; // empty map
    }
    
    *out_len = idx;
    return 0;
}

int nsm_get_attestation(const uint8_t *nonce, size_t nonce_len, uint8_t **doc_out, uint32_t *doc_len_out) {
    int fd = open("/dev/nsm", O_RDWR);
    if (fd < 0) {
        return -1;
    }
    
    struct nsm_raw nsm_raw = {0};
    
    // Build CBOR request
    size_t req_len;
    if (build_attestation_request(nonce, nonce_len, nsm_raw.request, &req_len) != 0) {
        close(fd);
        return -2;
    }
    nsm_raw.request_len = req_len;
    nsm_raw.response_len = NSM_RESPONSE_MAX_SIZE;
    
    // Make ioctl call
    int ret = ioctl(fd, NSM_IO_REQUEST, &nsm_raw);
    close(fd);
    
    if (ret != 0 || nsm_raw.response_len == 0) {
        return -3;
    }
    
    // Allocate and copy response
    *doc_out = malloc(nsm_raw.response_len);
    if (!*doc_out) {
        return -4;
    }
    
    memcpy(*doc_out, nsm_raw.response, nsm_raw.response_len);
    *doc_len_out = nsm_raw.response_len;
    
    return 0;
}
EOFMARKER

# Compile simple NSM library
RUN cd /tmp && \
    gcc -c -fPIC nsm_simple.c -o nsm_simple.o && \
    gcc -shared -o /usr/lib64/libnsm_simple.so nsm_simple.o && \
    cp nsm_simple.h /usr/include/ && \
    rm -f nsm_simple.c nsm_simple.o nsm_simple.h && \
    ldconfig

# Create simplified attestation program
COPY <<'EOFMARKER' /opt/nsm_attestation.c
#include <nsm_simple.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

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

static void output_error(const char *stage, const char *message, int error_code) {
    char json[2048];
    int len = snprintf(json, sizeof(json),
        "{\"status\":\"error\",\"stage\":\"%s\",\"message\":\"%s\",\"error_code\":%d}",
        stage, message, error_code);
    
    if (len > 0 && len < sizeof(json)) {
        printf("%s\n", json);
    } else {
        printf("{\"status\":\"error\",\"message\":\"JSON error\"}\n");
    }
}

static void output_success(const uint8_t *doc, uint32_t doc_len) {
    printf("{\"status\":\"success\",\"attestation\":\"");
    base64_encode(doc, doc_len);
    printf("\"}\n");
}

int main() {
    uint8_t *doc = NULL;
    uint32_t doc_len = 0;
    uint8_t *nonce = NULL;
    size_t nonce_len = 0;
    char nonce_b64[1024] = {0};
    
    if (fgets(nonce_b64, sizeof(nonce_b64), stdin)) {
        nonce_b64[strcspn(nonce_b64, "\r\n")] = 0;
        
        if (strlen(nonce_b64) > 0) {
            if (base64_decode(nonce_b64, &nonce, &nonce_len) != 0) {
                output_error("nonce_decode", "Failed to decode base64 nonce", -1);
                return 1;
            }
        }
    }
    
    int ret = nsm_get_attestation(nonce, nonce_len, &doc, &doc_len);
    
    if (ret != 0) {
        char msg[256];
        snprintf(msg, sizeof(msg), "NSM attestation request failed with code %d", ret);
        output_error("attestation", msg, ret);
        if (nonce) free(nonce);
        return 1;
    }
    
    if (!doc || doc_len == 0) {
        output_error("attestation", "Received empty attestation document from NSM", -3);
        if (nonce) free(nonce);
        return 1;
    }
    
    output_success(doc, doc_len);
    
    if (nonce) free(nonce);
    if (doc) free(doc);
    
    return 0;
}
EOFMARKER

RUN gcc -o /opt/nsm_attestation /opt/nsm_attestation.c -lnsm_simple && \
    chmod +x /opt/nsm_attestation && \
    rm /opt/nsm_attestation.c

# Create wrapper script for attestation
RUN printf '#!/bin/bash\n\
# Read nonce from stdin (optional, base64 encoded)\n\
read -r NONCE\n\
\n\
# Call the C program and pass the nonce\n\
echo "$NONCE" | /opt/nsm_attestation\n' > /opt/get_attestation_document.sh && \
    chmod +x /opt/get_attestation_document.sh

# Create startup script
RUN printf '#!/bin/bash\n\
\n\
# Bring up loopback interface\n\
ip link set lo up\n\
\n\
# Start NGINX in background\n\
nginx -g "daemon off;" &\n\
NGINX_PID=$!\n\
\n\
# VSOCK proxy for NGINX (port 5000 -> 8080)\n\
socat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\n\
VSOCK_PID=$!\n\
\n\
# VSOCK proxy for attestation service (port 5001)\n\
socat VSOCK-LISTEN:5001,fork EXEC:/opt/get_attestation_document.sh &\n\
ATTEST_PID=$!\n\
\n\
echo "Enclave services started:"\n\
echo "  - NGINX: PID $NGINX_PID"\n\
echo "  - VSOCK proxy (NGINX): PID $VSOCK_PID (port 5000)"\n\
echo "  - VSOCK attestation: PID $ATTEST_PID (port 5001)"\n\
\n\
# Wait for all background processes\n\
wait\n' > /start.sh && \
    chmod +x /start.sh

# Verify NGINX configuration
RUN nginx -t

CMD ["/start.sh"]
