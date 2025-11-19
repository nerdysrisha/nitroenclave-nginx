FROM public.ecr.aws/amazonlinux/amazonlinux:2

# Install nginx, socat, and debugging tools
RUN yum update -y && yum install -y nginx socat nc curl iproute procps-ng

# Create a simple nginx configuration
RUN echo "Hello from NGINX in Enclave via VSOCK proxy! PoC on Confidential Containers" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf

# Create startup script in multiple steps to avoid syntax errors
RUN echo '#!/bin/bash' > /start.sh
RUN echo 'set -x' >> /start.sh
RUN echo 'echo "=== Starting nginx and VSOCK proxy inside enclave ==="' >> /start.sh
RUN echo 'echo "Timestamp: $(date)"' >> /start.sh
RUN echo 'echo "=== Pre-start system info ==="' >> /start.sh
RUN echo 'echo "Hostname: $(hostname)"' >> /start.sh
RUN echo 'echo "IP addresses:"' >> /start.sh
RUN echo 'ip addr show' >> /start.sh
RUN echo 'echo "Initial listening ports:"' >> /start.sh
RUN echo 'ss -tlnp' >> /start.sh
RUN echo 'echo "=== Starting nginx ==="' >> /start.sh
RUN echo 'nginx -g "daemon off;" &' >> /start.sh
RUN echo 'NGINX_PID=$!' >> /start.sh
RUN echo 'echo "Nginx PID: $NGINX_PID"' >> /start.sh
RUN echo 'sleep 3' >> /start.sh
RUN echo 'echo "=== Starting VSOCK proxy ==="' >> /start.sh
RUN echo 'socat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &' >> /start.sh
RUN echo 'VSOCK_PID=$!' >> /start.sh
RUN echo 'echo "VSOCK proxy PID: $VSOCK_PID"' >> /start.sh
RUN echo 'echo "=== Waiting for connections ==="' >> /start.sh
RUN echo 'wait' >> /start.sh

RUN chmod +x /start.sh

# DEBUG: Verify nginx config
RUN nginx -t && echo "✅ Nginx configuration is valid"

CMD ["/start.sh"]
