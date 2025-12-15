FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install packages including build tools for C compilation
RUN dnf update -y && \
    dnf install -y nginx socat nc iproute procps-ng python3 python3-pip \
    gcc aws-nitro-enclaves-nsm-api-devel --allowerasing

# Install Python dependencies
RUN pip3 install cbor2

# Setup nginx
RUN echo "Hello from NGINX in Enclave via VSOCK proxy! " > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf

# Copy and compile C attestation program
COPY attest.c /tmp/attest.c
RUN gcc -o /opt/attest_c /tmp/attest.c -lnsm && \
    chmod +x /opt/attest_c && \
    rm /tmp/attest.c

# Copy attestation shell script
COPY get_attestation_document.sh /opt/get_attestation_document.sh
RUN chmod +x /opt/get_attestation_document.sh

 

# Create startup script
RUN printf '#!/bin/bash\n\nip link set lo up\n\nnginx -g "daemon off;" &\nNGINX_PID=$!\n\nsocat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\nVSOCK_PID=$!\n\nsocat VSOCK-LISTEN:5001,fork EXEC:/opt/get_attestation_document.sh &\nATTEST_PID=$!\n\necho "Services started:"\necho "  - Nginx: PID $NGINX_PID"\necho "  - VSOCK proxy (5000): PID $VSOCK_PID"\necho "  - Attestation service (5001): PID $ATTEST_PID"\n\nwait\n' > /start.sh && chmod +x /start.sh

# Verify nginx config
RUN nginx -t

CMD ["/start.sh"]
