before that i want the 'enclave docker file' to be super simple just want it to get deployed and see if nginx is indeed running i will connect it via console etc. is this correct. give me one line ans "FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install nginx and socat for vsock communication

RUN dnf update -y && dnf install -y nginx socat nc

# Create a simple nginx configuration

RUN echo "Hello from NGINX in Enclave via VSOCK proxy! PoC on Confidential Containers" > /usr/share/nginx/html/index.html && \

    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \

    sed -i 's/listen.*80;/# listen 80;/' /etc/nginx/nginx.conf

# Create SIMPLE startup script - just run nginx

RUN printf '#!/bin/bash\n\necho "=== Starting nginx inside enclave === "\nnginx -g "daemon off;"\n' > /start.sh && \

    chmod +x /start.sh

# DEBUG: Verify nginx config

RUN nginx -t && echo "✅ Nginx configuration is valid"

CMD ["/start.sh"]
