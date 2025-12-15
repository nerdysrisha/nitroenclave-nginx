FROM public.ecr.aws/amazonlinux/amazonlinux:2023

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
    git \
    cmake \
    clang \
    --allowerasing

# Install Python dependencies
RUN pip3 install cbor2

# Build NSM library from SDK-C which includes pre-built binaries
RUN cd /tmp && \
    git clone https://github.com/aws/aws-nitro-enclaves-sdk-c.git && \
    cd aws-nitro-enclaves-sdk-c && \
    git submodule update --init --recursive && \
    cd vendors/aws-nitro-enclaves-nsm-api/nsm-lib && \
    make && \
    cp include/nsm.h /usr/include/ && \
    cp target/release/libnsm.so /usr/lib64/ && \
    ldconfig && \
    cd / && \
    rm -rf /tmp/aws-nitro-enclaves-sdk-c

# Install Python dependencies
RUN pip3 install cbor2

# Setup NGINX
RUN echo "Hello from NGINX in Enclave via VSOCK proxy!" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf

# Copy and compile the C attestation program
COPY nsm_attestation.c /opt/nsm_attestation.c
RUN gcc -o /opt/nsm_attestation /opt/nsm_attestation.c -lnsm && \
    chmod +x /opt/nsm_attestation

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
