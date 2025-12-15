FROM public.ecr.aws/amazonlinux/amazonlinux:2023
 
RUN dnf update -y && dnf install -y nginx socat iproute procps-ng gcc make git cmake json-c-devel openssl-devel libcurl-devel glibc-static --allowerasing

WORKDIR /opt
 
 
RUN git clone https://github.com/awslabs/aws-c-common.git && cd aws-c-common && cmake -B build -S . && cmake --build build && cmake --install build
 
COPY attest.c /tmp/attest.c
RUN gcc /tmp/attest.c -o /opt/attest_c -lnsm && chmod +x /opt/attest_c && rm /tmp/attest.c

RUN echo "Hello from NGINX in Enclave via VSOCK proxy!" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf

COPY get_attestation_document.sh /opt/get_attestation_document.sh
RUN chmod +x /opt/get_attestation_document.sh

RUN printf '#!/bin/bash\nip link set lo up\nnginx -g "daemon off;" &\nsocat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\nsocat VSOCK-LISTEN:5001,fork EXEC:/opt/get_attestation_document.sh &\nwait\n' > /start.sh && chmod +x /start.sh

RUN nginx -t

CMD ["/start.sh"]
