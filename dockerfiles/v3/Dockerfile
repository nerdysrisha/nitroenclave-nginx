FROM public.ecr.aws/amazonlinux/amazonlinux:2023

RUN dnf update -y && \
    dnf install -y nginx socat nc iproute procps-ng python3 python3-pip --allowerasing

RUN pip3 install cbor2

RUN echo "Hello from NGINX in Enclave via VSOCK proxy!" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf

COPY test_attestation.sh /opt/test_attestation.sh
RUN chmod +x /opt/test_attestation.sh

RUN printf '#!/bin/bash\n\nip link set lo up\n\nnginx -g "daemon off;" &\nNGINX_PID=$!\n\nsocat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\nVSOCK_PID=$!\n\nsocat VSOCK-LISTEN:5001,fork EXEC:/opt/test_attestation.sh &\nATTEST_PID=$!\n\nwait\n' > /start.sh && \
    chmod +x /start.sh

RUN nginx -t

CMD ["/start.sh"]
