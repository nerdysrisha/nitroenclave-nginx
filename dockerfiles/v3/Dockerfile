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
COPY test_attestation.sh /opt/test_attestation.sh
RUN chmod +x /opt/test_attestation.sh


# Add this after your debug RUN
RUN test -f /opt/test_attestation.sh && echo "✅ File exists" || echo "❌ File missing"

# Create lean startup script without debug 
#RUN printf '#!/bin/bash\n\n# Run attestation test\n/test_attestation.sh\n\n# Bring up loopback\nip link set lo up\n\n# Start nginx\nnginx -g "daemon off;" &\nNGINX_PID=$!\n\n# Start VSOCK proxy\nsocat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\nVSOCK_PID=$!\n\n# Wait for both\nwait\n' > /start.sh && \
  #  chmod +x /start.sh

# Create lean startup script with debug
#RUN printf '#!/bin/bash\n\necho "=== STARTUP DEBUG: Starting container ==="\necho "=== DEBUG: Checking attestation file before execution ==="\nls -la /opt/test_attestation.sh\necho "=== DEBUG: Running attestation test ==="\n/opt/test_attestation.sh\necho "=== DEBUG: Attestation test completed, exit code: $? ==="\n\n# Bring up loopback\nip link set lo up\n\n# Start nginx\nnginx -g "daemon off;" &\nNGINX_PID=$!\n\n# Start VSOCK proxy\nsocat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\nVSOCK_PID=$!\n\n# Wait for both\nwait\n' > /start.sh && \
    #chmod +x /start.sh

RUN printf '#!/bin/bash\n\n# Run attestation test and capture results\necho "Running attestation test..."\nif /opt/test_attestation.sh > /tmp/attestation_result.log 2>&1; then\n    echo "{\\"status\\": \\"SUCCESS\\", \\"message\\": \\"Attestation passed\\", \\"details\\": \\"$(cat /tmp/attestation_result.log)\\"}" > /usr/share/nginx/html/attestation-status.json\nelse\n    echo "{\\"status\\": \\"FAILED\\", \\"message\\": \\"Attestation failed\\", \\"details\\": \\"$(cat /tmp/attestation_result.log)\\"}" > /usr/share/nginx/html/attestation-status.json\nfi\n\n# Bring up loopback\nip link set lo up\n\n# Start nginx\nnginx -g "daemon off;" &\nNGINX_PID=$!\n\n# Start VSOCK proxy\nsocat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\nVSOCK_PID=$!\n\n# Wait for both\nwait\n' > /start.sh && \
    chmod +x /start.sh






# Verify nginx config
RUN nginx -t && echo "✅ Nginx configuration is valid"

CMD ["/start.sh"]
