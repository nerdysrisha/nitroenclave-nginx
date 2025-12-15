# ===== Builder Stage =====
FROM public.ecr.aws/amazonlinux/amazonlinux:2023 AS builder

RUN dnf update -y && \
    dnf install -y git gcc make cmake json-c-devel openssl-devel libcurl-devel glibc-static --allowerasing

WORKDIR /opt

# 1) aws-c-common
RUN git clone https://github.com/awslabs/aws-c-common.git && \
    cd aws-c-common && cmake -B build -S . && cmake --build build && cmake --install build

# 2) aws-nitro-enclaves-nsm-api
RUN git clone https://github.com/aws/aws-nitro-enclaves-nsm-api.git && \
    cd aws-nitro-enclaves-nsm-api && cmake -B build -S . && cmake --build build && cmake --install build

# Register NSM lib path
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/nsm.conf && ldconfig

# Compile your attestation binary
COPY attest.c /opt/attest.c
RUN gcc /opt/attest.c -o /opt/attest_c -I/usr/local/include -L/usr/local/lib -lnsm && chmod +x /opt/attest_c

# ===== Runtime Stage =====
FROM public.ecr.aws/amazonlinux/amazonlinux:2023

RUN dnf update -y && dnf install -y nginx socat nc iproute procps-ng python3 python3-pip --allowerasing

RUN pip3 install cbor2

# Copy compiled attestation binary
COPY --from=builder /opt/attest_c /opt/attest_c

# Copy your attestation script
COPY get_attestation_document.sh /opt/get_attestation_document.sh
RUN chmod +x /opt/get_attestation_document.sh /opt/attest_c

# Static nginx page
RUN echo "Hello from NGINX in Enclave via VSOCK proxy!" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf

# Start script
RUN printf '#!/bin/bash\nip link set lo up\nnginx -g "daemon off;" &\nsocat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\nsocat VSOCK-LISTEN:5001,fork EXEC:/opt/get_attestation_document.sh &\nwait\n' > /start.sh && chmod +x /start.sh

RUN nginx -t

CMD ["/start.sh"]
