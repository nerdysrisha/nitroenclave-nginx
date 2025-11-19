FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install nginx, socat, and debugging tools
RUN dnf update -y && dnf install -y nginx socat nc curl iproute procps-ng

# Create a simple nginx configuration
RUN echo "Hello from NGINX in Enclave via VSOCK proxy! PoC on Confidential Containers" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i 's/listen.*80;/# listen 80;/' /etc/nginx/nginx.conf

# Create startup script with extensive debugging
RUN printf '#!/bin/bash\n\nset -x\necho "=== Starting nginx and VSOCK proxy inside enclave ==="\necho "Timestamp: $(date)"\n\necho "=== Pre-start system info ==="\necho "Hostname: $(hostname)"\necho "IP addresses:"\nip addr show\necho "Initial listening ports:"\nss -tlnp\n\necho "=== Nginx configuration check ==="\necho "Nginx config test:"\nnginx -t\necho "Nginx config files:"\nls -la /etc/nginx/\nls -la /etc/nginx/conf.d/\necho "Default config content:"\ncat /etc/nginx/conf.d/default.conf\necho "Main nginx.conf relevant lines:"\ngrep -v "^#" /etc/nginx/nginx.conf | grep -v "^$"\n\necho "=== Starting nginx ==="\nnginx -g "daemon off;" &\nNGINX_PID=$!\necho "Nginx PID: $NGINX_PID"\necho "Nginx started on port 8080"\n\necho "=== Waiting for nginx to initialize ==="\nsleep 3\n\necho "=== Post-nginx start debugging ==="\necho "Process list:"\nps aux\necho "Listening ports after nginx start:"\nss -tlnp\necho "Nginx process check:"\nps aux | grep nginx\n\necho "=== Testing local nginx connectivity ==="\necho "Testing 127.0.0.1:8080:"\ncurl -v --connect-timeout 5 http://127.0.0.1:8080/ 2>&1 || echo "127.0.0.1:8080 failed"\necho "Testing localhost:8080:"\ncurl -v --connect-timeout 5 http://localhost:8080/ 2>&1 || echo "localhost:8080 failed"\n\necho "=== Network interface details ==="\necho "/etc/hosts content:"\ncat /etc/hosts\n\necho "=== Starting VSOCK proxy ==="\necho "VSOCK proxy command: socat VSOCK-LISTEN:5000,fork TCP:127.0.0.1:8080"\nsocat -d -d VSOCK-LISTEN:5000,fork TCP:127.0.0.1:8080 &\nVSOCK_PID=$!\necho "VSOCK proxy PID: $VSOCK_PID"\necho "VSOCK proxy started on port 5000"\n\necho "=== Final system state ==="\necho "All processes:"\nps aux\necho "All listening ports:"\nss -tlnp\n\necho "=== Startup complete - waiting for connections ==="\necho "Nginx PID: $NGINX_PID, VSOCK PID: $VSOCK_PID"\n\nwait\n' > /start.sh && \
    chmod +x /start.sh

# DEBUG: Verify nginx config and startup script
RUN nginx -t && echo "✅ Nginx configuration is valid"
RUN echo "=== Startup script content ===" && cat /start.sh

CMD ["/start.sh"]
