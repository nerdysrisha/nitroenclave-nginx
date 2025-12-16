# =========================
# Build stage
# =========================
FROM public.ecr.aws/amazonlinux/amazonlinux:2023 AS builder

RUN dnf update -y && \
    dnf install -y \
      gcc \
      make \
      cmake \
      git \
      python3 \
      python3-pip \
      openssl-devel \
      curl \
      tar \
      --allowerasing

# Get and build the Nitro Enclaves C SDK (includes NSM client)
RUN git clone https://github.com/aws/aws-nitro-enclaves-sdk-c.git /src/nitro-sdk && \
    cd /src/nitro-sdk && \
    mkdir build && cd build && \
    cmake .. && make && make install

# Simple attestation tool using the SDK's NSM client
RUN cat > /tmp/nsm_attestation.c <<'EOF'
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>

#include <nsm.h>   // Provided by aws-nitro-enclaves-sdk-c

#define NSM_MAX_ATTESTATION_DOC_SIZE (16 * 1024)

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

static void output_error(const char *stage, const char *message, int code) {
    fprintf(stdout,
            "{\"status\":\"error\",\"stage\":\"%s\",\"message\":\"%s\",\"error_code\":%d}\n",
            stage, message, code);
}

int main(void) {
    int nsm_fd = nsm_lib_init();
    if (nsm_fd < 0) {
        output_error("init", "Failed to init NSM", nsm_fd);
        return 1;
    }

    uint8_t att_doc_buff[NSM_MAX_ATTESTATION_DOC_SIZE];
    uint32_t att_doc_size = NSM_MAX_ATTESTATION_DOC_SIZE;

    int status = nsm_get_attestation_doc(
        nsm_fd,
        NULL, 0,   // user_data
        NULL, 0,   // public_key
        NULL, 0,   // nonce
        att_doc_buff, &att_doc_size
    );

    if (status != 0) {
        nsm_lib_exit(nsm_fd);
        output_error("attestation", "NSM attestation request failed", status);
        return 1;
    }

    printf("{\"status\":\"success\",\"attestation\":\"");
    base64_encode(att_doc_buff, att_doc_size);
    printf("\"}\n");

    nsm_lib_exit(nsm_fd);
    return 0;
}
EOF

RUN gcc -o /tmp/nsm_attestation /tmp/nsm_attestation.c -lnsm


# =========================
# Runtime stage
# =========================
FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install only runtime dependencies
RUN dnf update -y && \
    dnf install -y \
      nginx \
      socat \
      iproute \
      procps-ng \
      --allowerasing && \
    dnf clean all && \
    rm -rf /var/cache/dnf

# Copy attestation tool from builder
COPY --from=builder /tmp/nsm_attestation /opt/nsm_attestation
RUN chmod +x /opt/nsm_attestation

# Setup NGINX (same pattern you used)
RUN echo "Hello from NGINX in Enclave via VSOCK proxy!" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf && \
    nginx -t

# Wrapper script for attestation (keeps stdin contract)
RUN cat > /opt/get_attestation_document.sh <<'EOF'
#!/bin/bash
# Read optional base64 nonce (ignored by this minimal version)
read -r NONCE || true
/opt/nsm_attestation
EOF

RUN chmod +x /opt/get_attestation_document.sh

# Startup script: NGINX + vsock proxies
RUN cat > /start.sh <<'EOF'
#!/bin/bash
set -e

# Bring up loopback interface
ip link set lo up

# Start NGINX
nginx -g "daemon off;" &
NGINX_PID=$!

# VSOCK proxy for NGINX (port 5000 -> 8080)
socat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &
VSOCK_PID=$!

# VSOCK proxy for attestation service (port 5001)
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
