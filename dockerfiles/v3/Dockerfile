
FROM public.ecr.aws/amazonlinux/amazonlinux:2023

RUN dnf update -y && \
    dnf install -y nginx socat nc iproute procps-ng python3 python3-pip --allowerasing && \
    dnf clean all

# Python NSM binding to call /dev/nsm and request attestation documents
RUN pip3 install --no-cache-dir aws-nsm-interface

RUN echo "Hello from NGINX in Enclave via VSOCK proxy!" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf

# Attestation script (exposed via VSOCK port 5001)
COPY attestation.sh /opt/attestation.sh
RUN chmod +x /opt/attestation.sh

RUN printf '#!/bin/bash\n\nset -e\nip link set lo up\n\nnginx -g "daemon off;" &\nNGINX_PID=$!\n\nsocat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\nVSOCK_PID=$!\n\nsocat VSOCK-LISTEN:5001,fork EXEC:/opt/attestation.sh &\nATTEST_PID=$!\n\nwait\n' > /start.sh && \
    chmod +x /start.sh

RUNRUN nginx -t

