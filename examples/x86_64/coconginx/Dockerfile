FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install nginx and socat for vsock communication
RUN dnf update -y && dnf install -y nginx socat nc

# Create a simple nginx configuration (listens on standard TCP port 8080 inside enclave)
RUN echo "Hello from NGINX in Enclave via VSOCK proxy!" > /usr/share/nginx/html/index.html && \
    # Configure nginx to listen on TCP port 8080 inside the enclave
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    # Disable the default port 80 listener to avoid conflict
    sed -i 's/listen.*80;/# listen 80;/' /etc/nginx/nginx.conf

# Create startup script that:
# 1. Starts nginx on TCP port 8080 inside enclave
# 2. Starts VSOCK proxy that bridges VSOCK:5000 → TCP:8080
RUN echo '#!/bin/bash\n\
# Start nginx on port 8080 inside enclave\n\
nginx -g "daemon off;" &\n\
# Start VSOCK proxy: external VSOCK connections on port 5000 get forwarded to nginx on TCP 8080\n\
socat VSOCK-LISTEN:5000,fork TCP:localhost:8080 &\n\
# Health check endpoint on VSOCK port 5001\n\
while true; do echo "HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK" | nc -l -p 5001 -s 0.0.0.0; done &\n\
wait' > /start.sh && \
    chmod +x /start.sh

# Run the startup script
CMD ["/start.sh"]
