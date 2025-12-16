# Build stage - compile everything here
FROM public.ecr.aws/amazonlinux/amazonlinux:2023 AS builder

RUN dnf update -y && \
    dnf install -y \
    gcc \
    make \
    python3 \
    python3-pip \
    --allowerasing

# Create and compile NSM library
RUN cat > /tmp/nsm_simple.h <<'EOF'
#ifndef NSM_SIMPLE_H
#define NSM_SIMPLE_H
#include <stdint.h>
#include <stddef.h>

int nsm_get_attestation(const uint8_t *nonce, size_t nonce_len, uint8_t **doc_out, uint32_t *doc_len_out);

#endif
EOF

RUN cat > /tmp/nsm_simple.c <<'EOF'
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

static int build_attestation_request(const uint8_t *nonce, size_t nonce_len, uint8_t *out, size_t *out_len) {
    size_t idx = 0;
    out[idx++] = 0xA1;
    out[idx++] = 0x6B;
    memcpy(&out[idx], "Attestation", 11);
    idx += 11;
    
    if (nonce && nonce_len > 0) {
        out[idx++] = 0xA1;
        out[idx++] = 0x65;
        memcpy(&out[idx], "nonce", 5);
        idx += 5;
        
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
        out[idx++] = 0xA0;
    }
    
    *out_len = idx;
    return 0;
}

int nsm_get_attestation(const uint8_t *nonce, size_t nonce_len, uint8_t **doc_out, uint32_t *doc_len_out) {
    int fd = open("/dev/nsm", O_RDWR);
    if (fd < 0) return -1;
    
    struct nsm_raw nsm_raw = {0};
    size_t req_len;
    if (build_attestation_request(nonce, nonce_len, nsm_raw.request, &req_len) != 0) {
        close(fd);
        return -2;
    }
    nsm_raw.request_len = req_len;
    nsm_raw.response_len = NSM_RESPONSE_MAX_SIZE;
    
    int ret = ioctl(fd, NSM_IO_REQUEST, &nsm_raw);
    close(fd);
    
    if (ret != 0 || nsm_raw.response_len == 0) return -3;
    
    *doc_out = malloc(nsm_raw.response_len);
    if (!*doc_out) return -4;
    
    memcpy(*doc_out, nsm_raw.response, nsm_raw.response_len);
    *doc_len_out = nsm_raw.response_len;
    
    return 0;
}
EOF

# Compile NSM library
RUN cd /tmp && \
    gcc -c -fPIC nsm_simple.c -o nsm_simple.o && \
    gcc -shared -o libnsm_simple.so nsm_simple.o

# Create attestation program
RUN cat > /tmp/nsm_attestation.c <<'EOF'
#include <nsm_simple.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

static int base64_decode(const char *input, uint8_t **output, size_t *output_len) {
    size_t input_len = strlen(input);
    if (input_len == 0) return 0;
    
    size_t out_len = (input_len * 3) / 4;
    uint8_t *out = malloc(out_len);
    if (!out) return -1;
    
    size_t j = 0;
    for (size_t i = 0; i < input_len; i += 4) {
        uint32_t v = 0;
        int valid_chars = 0;
        
        for (int k = 0; k < 4 && (i + k) < input_len; k++) {
            char c = input[i + k];
            if (c == '=') break;
            
            uint8_t val = 0;
            if (c >= 'A' && c <= 'Z') val = c - 'A';
            else if (c >= 'a' && c <= 'z') val = c - 'a' + 26;
            else if (c >= '0' && c <= '9') val = c - '0' + 52;
            else if (c == '+') val = 62;
            else if (c == '/') val = 63;
            else continue;
            
            v = (v << 6) | val;
            valid_chars++;
        }
        
        if (valid_chars >= 2 && j < out_len) out[j++] = (v >> 16) & 0xFF;
        if (valid_chars >= 3 && j < out_len) out[j++] = (v >> 8) & 0xFF;
        if (valid_chars >= 4 && j < out_len) out[j++] = v & 0xFF;
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
    fprintf(stdout, "{\"status\":\"error\",\"stage\":\"%s\",\"message\":\"%s\",\"error_code\":%d}\n",
            stage, message, error_code);
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
        output_error("attestation", "NSM attestation request failed", ret);
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
EOF

# Compile attestation program (statically link the NSM library)
RUN gcc -o /tmp/nsm_attestation /tmp/nsm_attestation.c -I/tmp -L/tmp -lnsm_simple -static-libgcc

# Runtime stage - minimal image with only what's needed
FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install only runtime dependencies (no build tools!)
RUN dnf update -y && \
    dnf install -y \
    nginx \
    socat \
    iproute \
    --allowerasing && \
    dnf clean all && \
    rm -rf /var/cache/dnf

# Copy compiled binaries from builder
COPY --from=builder /tmp/libnsm_simple.so /usr/lib64/
COPY --from=builder /tmp/nsm_attestation /opt/nsm_attestation

RUN ldconfig && chmod +x /opt/nsm_attestation

# Setup NGINX
RUN echo "Hello from NGINX in Enclave via VSOCK proxy!" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf && \
    nginx -t

# Create wrapper script
RUN cat > /opt/get_attestation_document.sh <<'EOF'
#!/bin/bash
read -r NONCE
echo "$NONCE" | /opt/nsm_attestation
EOF

RUN chmod +x /opt/get_attestation_document.sh

# Create startup script
RUN cat > /start.sh <<'EOF'
#!/bin/bash
ip link set lo up
nginx -g "daemon off;" &
NGINX_PID=$!
socat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &
VSOCK_PID=$!
socat VSOCK-LISTEN:5001,fork EXEC:/opt/get_attestation_document.sh &
ATTEST_PID=$!
echo "Enclave services started:"
echo "  - NGINX: PID $NGINX_PID"
echo "  - VSOCK proxy (NGINX): PID $VSOCK_PID (port 5000)"
echo "  - VSOCK attestation: PID $ATTEST_PID (port 5001)"
wait
EOF

RUN chmod +x /start.sh

CMD ["/start.sh"]
