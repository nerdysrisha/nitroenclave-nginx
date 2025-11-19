FROM public.ecr.aws/amazonlinux/amazonlinux:2

# Install nginx, socat, and debugging tools
RUN yum update -y && yum install -y nginx socat nc curl iproute procps-ng

# FORCE CREATE nginx directories since the package doesn't create them
RUN mkdir -p /usr/share/nginx/html /etc/nginx/conf.d /var/log/nginx /var/cache/nginx

# Simple nginx config - ONLY port 8080
RUN echo "Hello from NGINX in Enclave via VSOCK proxy! PoC on Confidential Containers" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf

# Create basic nginx.conf if it doesn't exist
RUN test -f /etc/nginx/nginx.conf || echo 'events { worker_connections 1024; } http { include /etc/nginx/conf.d/*.conf; }' > /etc/nginx/nginx.conf

# Create startup script with all debugging but simple port setup
RUN echo '#!/bin/bash' > /start.sh
RUN echo 'set -x' >> /start.sh
RUN echo 'echo "=== Starting nginx and VSOCK proxy inside enclave ==="' >> /start.sh
RUN echo 'echo "Timestamp: $(date)"' >> /start.sh
RUN echo 'echo "=== Pre-start system info ==="' >> /start.sh
RUN echo 'echo "Hostname: $(hostname)"' >> /start.sh
RUN echo 'echo "IP addresses:"' >> /start.sh
RUN echo 'ip addr show' >> /start.sh
RUN echo 'echo "=== Bringing up loopback interface ==="' >> /start.sh
RUN echo 'ip link set lo up' >> /start.sh
RUN echo 'echo "Loopback status:"' >> /start.sh
RUN echo 'ip addr show lo' >> /start.sh
RUN echo 'echo "=== Nginx configuration check ==="' >> /start.sh
RUN echo 'nginx -t' >> /start.sh
RUN echo 'echo "=== Starting nginx ==="' >> /start.sh
RUN echo 'nginx -g "daemon off;" &' >> /start.sh
RUN echo 'NGINX_PID=$!' >> /start.sh
RUN echo 'echo "Nginx PID: $NGINX_PID"' >> /start.sh
RUN echo 'sleep 3' >> /start.sh
RUN echo 'echo "=== Post-nginx start debugging ==="' >> /start.sh
RUN echo 'echo "Listening ports:"' >> /start.sh
RUN echo 'ss -tlnp' >> /start.sh
RUN echo 'echo "=== Testing local nginx connectivity ==="' >> /start.sh
RUN echo 'echo "Testing 127.0.0.1:8080:"' >> /start.sh
RUN echo 'curl -v --connect-timeout 5 http://127.0.0.1:8080/ 2>&1 || echo "127.0.0.1:8080 failed"' >> /start.sh
RUN echo 'echo "=== Starting VSOCK proxy ==="' >> /start.sh
RUN echo 'socat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &' >> /start.sh
RUN echo 'VSOCK_PID=$!' >> /start.sh
RUN echo 'echo "VSOCK proxy PID: $VSOCK_PID"' >> /start.sh
RUN echo 'echo "=== Final system state ==="' >> /start.sh
RUN echo 'echo "All listening ports:"' >> /start.sh
RUN echo 'ss -tlnp' >> /start.sh
RUN echo 'echo "=== Startup complete - waiting for connections ==="' >> /start.sh
RUN echo 'echo "Nginx PID: $NGINX_PID, VSOCK PID: $VSOCK_PID"' >> /start.sh
RUN echo 'wait' >> /start.sh

RUN chmod +x /start.sh

# REMOVE THIS LINE: RUN nginx -t && echo "✅ Nginx configuration is valid"

CMD ["/start.sh"]
