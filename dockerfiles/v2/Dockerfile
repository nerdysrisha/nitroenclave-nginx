FROM public.ecr.aws/amazonlinux/amazonlinux:2

# Single RUN command for all installations and setup
RUN yum update -y && yum install -y nginx socat nc curl iproute procps-ng && \
    mkdir -p /usr/share/nginx/html /etc/nginx/conf.d /var/log/nginx /var/cache/nginx && \
    echo "Hello from NGINX in Enclave via VSOCK proxy! PoC on Confidential Containers" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    (test -f /etc/nginx/nginx.conf || echo 'events { worker_connections 1024; } http { include /etc/nginx/conf.d/*.conf; }' > /etc/nginx/nginx.conf)

# Single RUN command for script creation
RUN echo '#!/bin/bash
set -x
echo "=== Starting nginx and VSOCK proxy inside enclave ==="
echo "Timestamp: $(date)"
echo "=== Pre-start system info ==="
echo "Hostname: $(hostname)"
ip addr show
echo "=== Bringing up loopback interface ==="
ip link set lo up
echo "Loopback status:"
ip addr show lo
echo "=== Nginx configuration check ==="
nginx -t
echo "=== Starting nginx ==="
nginx -g "daemon off;" &
NGINX_PID=$!
echo "Nginx PID: $NGINX_PID"
sleep 3
echo "=== Post-nginx start debugging ==="
ss -tlnp
echo "=== Testing local nginx connectivity ==="
curl -v --connect-timeout 5 http://127.0.0.1:8080/ 2>&1 || echo "127.0.0.1:8080 failed"
echo "=== Starting VSOCK proxy ==="
socat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &
VSOCK_PID=$!
echo "VSOCK proxy PID: $VSOCK_PID"
echo "=== Final system state ==="
ss -tlnp
echo "=== Startup complete - waiting for connections ==="
echo "Nginx PID: $NGINX_PID, VSOCK PID: $VSOCK_PID"
wait' > /start.sh && chmod +x /start.sh

CMD ["/start.sh"]
