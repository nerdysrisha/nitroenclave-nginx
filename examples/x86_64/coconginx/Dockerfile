FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install nginx and socat for vsock communication
RUN dnf update -y && dnf install -y nginx socat nc

# Create a simple nginx configuration
RUN echo "Hello from NGINX in Enclave via VSOCK proxy! PoC on Confidential Containers" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i 's/listen.*80;/# listen 80;/' /etc/nginx/nginx.conf

# Create startup script with PROPER newlines
RUN printf '#!/bin/bash\n\n# Start nginx on port 8080 inside enclave\nnginx -g "daemon off;" &\n\n# Start VSOCK proxy: external VSOCK connections on port 5000 get forwarded to nginx on TCP 8080\nsocat VSOCK-LISTEN:5000,fork TCP:localhost:8080 &\n\n# Health check endpoint on VSOCK port 5001\nwhile true; do echo "HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK" | nc -l -p 5001 -s 0.0.0.0; done &\n\nwait\n' > /start.sh && \
    chmod +x /start.sh

CMD ["/start.sh"]
