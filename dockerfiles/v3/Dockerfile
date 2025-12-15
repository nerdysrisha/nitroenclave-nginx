FROM public.ecr.aws/aws-nitro-enclaves-sdk-c:latest as builder

COPY attest.c /tmp/
RUN gcc /tmp/attest.c -o /opt/attest_c -lnsm

FROM public.ecr.aws/amazonlinux/amazonlinux:2023
RUN dnf update -y && dnf install -y nginx socat iproute procps-ng --allowerasing

COPY --from=builder /opt/attest_c /opt/attest_c
COPY get_attestation_document.sh /opt/get_attestation_document.sh
RUN chmod +x /opt/attestation_document.sh /opt/attest_c

RUN echo "Hello from NGINX in Enclave via VSOCK proxy!" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf

RUN printf '#!/bin/bash\nip link set lo up\nnginx -g "daemon off;" &\nsocat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\nsocat VSOCK-LISTEN:5001,fork EXEC:/opt/get_attestation_document.sh &\nwait\n' > /start.sh && chmod +x /start.sh

RUN nginx -t
CMD ["/start.sh"]
