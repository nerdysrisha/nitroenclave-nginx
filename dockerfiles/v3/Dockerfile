# ===== Rust Builder Stage =====
FROM rust:1.77 AS builder

WORKDIR /opt/attest

# Copy Rust project files
COPY Cargo.toml .
RUN mkdir src
COPY attest.rs src/main.rs

# Build statically linked binary
RUN cargo build --release

# ===== Runtime Stage =====
FROM public.ecr.aws/amazonlinux/amazonlinux:2023

RUN dnf update -y && dnf install -y nginx socat iproute procps-ng --allowerasing

# Copy compiled Rust attestation binary
COPY --from=builder /opt/attest/target/release/attest /opt/attest

# Copy attestation script wrapper
COPY get_attestation_document.sh /opt/get_attestation_document.sh
RUN chmod +x /opt/get_attestation_document.sh /opt/attest

# Nginx setup
RUN echo "Hello from NGINX in Enclave via VSOCK proxy!" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf

# Start script (VSOCK + nginx + attestation)
RUN printf '#!/bin/bash\nip link set lo up\nnginx -g "daemon off;" &\nsocat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\nsocat VSOCK-LISTEN:5001,fork EXEC:/opt/get_attestation_document.sh &\nwait\n' > /start.sh && chmod +x /start.sh

RUN nginx -t

CMD ["/start.sh"]
