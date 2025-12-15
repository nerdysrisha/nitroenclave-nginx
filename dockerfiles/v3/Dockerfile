# ===== Builder Stage: Compile Attestation C Program =====
FROM public.ecr.aws/aws-nitro-enclaves-sdk-c:latest AS builder
 
WORKDIR /opt/attest

# Copy your attestation C code
COPY attest.c /opt/attest/attest.c

# Compile attestation binary
RUN gcc -o /opt/attest/attest_c /opt/attest/attest.c -lnsm && chmod +x /opt/attest/attest_c

# ===== Runtime Stage: Amazon Linux 2023 + Nginx =====
FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install nginx and socat for VSOCK proxy
RUN dnf update -y && \
    dnf install -y nginx socat nc iproute procps-ng python3 python3-pip --allowerasing

RUN pip3 install cbor2

# Copy compiled attestation binary from builder
COPY --from=builder /opt/attest/attest_c /opt/attest/attest_c

# Copy attestation script wrapper
COPY get_attestation_document.sh /opt/get_attestation_document.sh
RUN chmod +x /opt/get_attestation_document.sh /opt/attest/attest_c

# Nginx static page
RUN echo "Hello from NGINX in Enclave via VSOCK proxy!" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf

# Start script: Nginx + VSOCK + Attestation service
RUN printf '#!/bin/bash\nip link set lo up\nnginx -g "daemon off;" &\nsocat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\nsocat VSOCK-LISTEN:5001,fork EXEC:/opt/get_attestation_document.sh &\nwait\n' > /start.sh && \
    chmod +x /start.sh

RUN nginx -t

CMD ["/start.sh"]
