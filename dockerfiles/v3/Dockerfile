FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install nginx, socat, and debugging tools
RUN dnf update -y && dnf install -y nginx socat nc iproute procps-ng --allowerasing

# Add Python for attestation testing
RUN dnf install -y python3 python3-pip && \
    pip3 install boto3

    
# Create nginx configuration
RUN echo "Hello from NGINX in Enclave via VSOCK proxy! PoC on Confidential Containers" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf

# Copy attestation script (external file)
COPY test_attestation.sh /test_attestation.sh
RUN chmod +x /test_attestation.sh


# DEBUG: Verify the file was copied
RUN echo "=== DEBUG: Checking if attestation file exists ===" && \
    ls -la /test_attestation.sh && \
    echo "=== DEBUG: File contents ===" && \
    cat /test_attestation.sh && \
    echo "=== DEBUG: File verification complete ==="

# Create lean startup script with debug
RUN printf '#!/bin/bash\n\necho "=== STARTUP DEBUG: Starting container ==="\necho "=== DEBUG: Checking attestation file before execution ==="\nls -la /test_attestation.sh\necho "=== DEBUG: Running attestation test ==="\n/test_attestation.sh\necho "=== DEBUG: Attestation test completed, exit code: $? ==="\n\n# Bring up loopback\nip link set lo up\n\n# Start nginx\nnginx -g "daemon off;" &\nNGINX_PID=$!\n\n# Start VSOCK proxy\nsocat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\nVSOCK_PID=$!\n\n# Wait for both\nwait\n' > /start.sh && \
    chmod +x /start.sh





# Create lean startup script
#RUN printf '#!/bin/bash\n\n# Run attestation test\n/test_attestation.sh\n\n# Bring up loopback\nip link set lo up\n\n# Start nginx\nnginx -g "daemon off;" &\nNGINX_PID=$!\n\n# Start VSOCK proxy\nsocat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\nVSOCK_PID=$!\n\n# Wait for both\nwait\n' > /start.sh && \
  #  chmod +x /start.sh

# Verify nginx config
RUN nginx -t && echo "✅ Nginx configuration is valid"

CMD ["/start.sh"]
