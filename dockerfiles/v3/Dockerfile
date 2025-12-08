FROM public.ecr.aws/amazonlinux/amazonlinux:2023

RUN dnf update -y && dnf install -y nginx socat nc iproute procps-ng python3 python3-pip awscli --allowerasing
RUN pip3 install boto3

RUN echo "Hello from NGINX in Enclave via VSOCK proxy! PoC on Confidential Containers" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf
RUN pwd && ls -l && ls -l ../

COPY ../scripts/test_attestation.sh /test_attestation.sh
RUN chmod +x /test_attestation.sh


RUN printf '#!/bin/bash\n/test_attestation.sh\nip link set lo up\nnginx -g "daemon off;" &\nsocat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\nwait\n' > /start.sh && \
    chmod +x /start.sh

CMD ["/start.sh"]
