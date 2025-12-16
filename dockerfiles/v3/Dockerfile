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

# Copy and compile the C attestation program
COPY nsm_attestation.c /opt/nsm_attestation.c

# Modify to use our simple NSM library
RUN sed -i 's/#include <nsm.h>/#include <nsm_simple.h>/' /opt/nsm_attestation.c && \
    sed -i 's/nsm_lib_init()/0/g' /opt/nsm_attestation.c && \
    sed -i 's/nsm_lib_exit()//g' /opt/nsm_attestation.c && \
    sed -i 's/nsm_lib_nsm_process_request()/NULL/g' /opt/nsm_attestation.c && \
    sed -i 's/nsm_lib_nsm_exit(nsm)//g' /opt/nsm_attestation.c && \
    sed -i 's/nsm_get_attestation_doc(nsm, nonce, nonce_len, NULL, 0, NULL, 0, \&doc, \&doc_len)/nsm_get_attestation(nonce, nonce_len, \&doc, \&doc_len)/g' /opt/nsm_attestation.c

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
