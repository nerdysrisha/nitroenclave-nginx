FROM public.ecr.aws/amazonlinux/amazonlinux:2

# Install all required packages
RUN dnf update -y && dnf install -y nginx socat nc iproute procps-ng python3 python3-pip fcgiwrap --allowerasing && \
    pip3 install boto3

# Create nginx configuration + KMS test endpoint
RUN echo "Hello from NGINX in Enclave via VSOCK proxy! PoC on Confidential Containers" > /usr/share/nginx/html/index.html && \
    mkdir -p /var/www/cgi-bin && \
    printf '#!/usr/bin/env python3\nimport boto3\nimport json\nfrom datetime import datetime\n\nprint("Content-Type: application/json\\n")\n\ntry:\n    kms = boto3.client("kms")\n    test_data = f"test-{datetime.now().isoformat()}"\n    encrypted = kms.encrypt(KeyId="4bae92be-4b6c-4380-abb3-504dcb330b5a", Plaintext=test_data.encode())\n    decrypted = kms.decrypt(CiphertextBlob=encrypted["CiphertextBlob"])\n    result = {"status": "SUCCESS", "message": "KMS attestation working", "original": test_data, "decrypted": decrypted["Plaintext"].decode()}\nexcept Exception as e:\n    result = {"status": "FAILED", "message": f"KMS attestation failed: {str(e)}"}\n\nprint(json.dumps(result, indent=2))\n' > /var/www/cgi-bin/test-kms.py && \
    chmod +x /var/www/cgi-bin/test-kms.py && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; } location /test-kms { gzip off; root /var/www; fastcgi_pass unix:/var/run/fcgiwrap.socket; include fastcgi_params; fastcgi_param SCRIPT_FILENAME /var/www/cgi-bin/test-kms.py; } }' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf

# Copy attestation script and create startup script
COPY test_attestation.sh /test_attestation.sh
RUN chmod +x /test_attestation.sh && \
    printf '#!/bin/bash\n\n# Run attestation test\n/test_attestation.sh\necho "Attestation test completed, exit code: $?"\n\n# Bring up loopback\nip link set lo up\n\n# Start fcgiwrap for CGI\nfcgiwrap -s unix:/var/run/fcgiwrap.socket &\n\n# Start nginx\nnginx -g "daemon off;" &\n\n# Start VSOCK proxy\nsocat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\n\n# Wait for all processes\nwait\n' > /start.sh && \
    chmod +x /start.sh

# Verify nginx config
RUN nginx -t

CMD ["/start.sh"]
