FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install nginx and socat for vsock communication
RUN dnf update -y && dnf install -y nginx socat nc

# Create a simple nginx configuration
RUN echo "Hello from NGINX in Enclave via VSOCK proxy! PoC on Confidential Containers" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i 's/listen.*80;/# listen 80;/' /etc/nginx/nginx.conf

# Create startup script with nginx + VSOCK proxy
RUN printf '#!/bin/bash\n\necho "=== Starting nginx and VSOCK proxy inside enclave === "\nnginx -g "daemon off;" &\necho "Nginx started on port 8080"\nsocat VSOCK-LISTEN:5000,fork TCP:localhost:8080 &\necho "VSOCK proxy started on port 5000"\nwait\n' > /start.sh && \
    chmod +x /start.sh

# DEBUG: Verify nginx config
RUN nginx -t && echo "✅ Nginx configuration is valid"

CMD ["/start.sh"]
