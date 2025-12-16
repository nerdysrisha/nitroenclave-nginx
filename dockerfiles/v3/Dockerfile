# =========================
# Build stage  (REMOVED – no longer needed)
# =========================
# FROM public.ecr.aws/amazonlinux/amazonlinux:2023 AS builder
#
# RUN dnf update -y && \
#     dnf install -y \
#       gcc \
#       make \
#       cmake \
#       git \
#       python3 \
#       python3-pip \
#       openssl-devel \
#       curl \
#       tar \
#       --allowerasing
#
# RUN git clone https://github.com/aws/aws-nitro-enclaves-sdk-c.git /src/nitro-sdk && \
#     cd /src/nitro-sdk && \
#     mkdir build && cd build && \
#     cmake .. && make && make install
#
# RUN cat > /tmp/nsm_attestation.c <<'EOF'
# ... old C code ...
# EOF
#
# RUN gcc -o /tmp/nsm_attestation /tmp/nsm_attestation.c -lnsm


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

# >>> NEW: copy prebuilt nsm-cli from build context
COPY nsm-cli /opt/nsm-cli
RUN chmod +x /opt/nsm-cli

# >>> REMOVED: no longer copying /opt/nsm_attestation from builder
# COPY --from=builder /tmp/nsm_attestation /opt/nsm_attestation
# RUN chmod +x /opt/nsm_attestation

# Setup NGINX (same pattern you used)
RUN echo "Hello from NGINX in Enclave via VSOCK proxy!" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf && \
    nginx -t

# >>> CHANGED: wrapper now calls nsm-cli and passes nonce if provided
RUN cat > /opt/get_attestation_document.sh <<'EOF'
#!/bin/bash
# Read optional base64 nonce from stdin
read -r NONCE || true

if [ -n "$NONCE" ]; then
  /opt/nsm-cli attest --nonce-b64 "$NONCE"
else
  /opt/nsm-cli attest
fi
EOF

RUN chmod +x /opt/get_attestation_document.sh

# Startup script: NGINX + vsock proxies (unchanged)
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
