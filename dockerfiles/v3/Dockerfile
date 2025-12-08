FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install nginx, socat, and debugging tools
RUN dnf update -y && dnf install -y nginx socat nc iproute procps-ng --allowerasing

# Create nginx configuration
RUN echo "Hello from NGINX in Enclave via VSOCK proxy! PoC on Confidential Containers" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf

# Copy attestation script (external file)
COPY test_attestation.sh /test_attestation.sh
RUN chmod +x /test_attestation.sh

# Create lean startup script
RUN printf '#!/bin/bash\n\n# Run attestation test\n/test_attestation.sh\n\n# Bring up loopback\nip link set lo up\n\n# Start nginx\nnginx -g "daemon off;" &\nNGINX_PID=$!\n\n# Start VSOCK proxy\nsocat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\nVSOCK_PID=$!\n\n# Wait for both\nwait\n' > /start.sh && \
    chmod +x /start.sh

# Verify nginx config
RUN nginx -t && echo "✅ Nginx configuration is valid"

CMD ["/start.sh"]
