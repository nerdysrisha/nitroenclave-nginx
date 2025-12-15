FROM public.ecr.aws/amazonlinux/amazonlinux:2023

WORKDIR /opt

# --- 1. Install Dependencies ---
RUN dnf update -y && \
    dnf install -y \
        nginx socat nc iproute procps-ng \
        gcc make cmake git \
        json-c-devel openssl-devel libcurl-devel glibc-static --allowerasing

# --- 2. Build NSM Dependencies ---
# A) aws-c-common
RUN git clone https://github.com/awslabs/aws-c-common.git /opt/aws-c-common
RUN cd /opt/aws-c-common && cmake -B build -S . && cmake --build build && cmake --install build

# B) aws-nitro-enclaves-nsm-api (headers only, no build)
RUN git clone https://github.com/aws/aws-nitro-enclaves-nsm-api.git /opt/nsm-api

# Register NSM library path
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/nsm.conf && ldconfig

# --- 3. Compile Attestation Binary ---
COPY attest.c /opt/attest.c
RUN gcc /opt/attest.c -o /opt/attest_c -static -I/opt/nsm-api/include -L/usr/local/lib -lnsm && chmod +x /opt/attest_c

# --- 4. Setup Runtime ---
# NGINX setup
RUN echo "Hello from NGINX in Enclave via VSOCK proxy!" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf

# Attestation script and permissions
COPY get_attestation_document.sh /opt/get_attestation_document.sh
RUN chmod +x /opt/get_attestation_document.sh /opt/attest_c

# --- 5. Start Script ---
RUN printf '#!/bin/bash\n\
trap "kill -TERM 1" SIGINT SIGTERM\n\
ip link set lo up\n\
\n\
nginx -g "daemon off;" &\n\
socat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\n\
socat VSOCK-LISTEN:5001,fork EXEC:/opt/get_attestation_document.sh &\n\
\n\
wait\n' > /start.sh && chmod +x /start.sh

# NGINX config check
RUN nginx -t

CMD ["/start.sh"]
