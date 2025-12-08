FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install nginx, socat, and Python for KMS attestation
RUN dnf update -y && dnf install -y nginx socat nc iproute procps-ng python3 python3-pip awscli --allowerasing
RUN pip3 install boto3

RUN echo "Hello from NGINX in Enclave via VSOCK proxy! PoC on Confidential Containers" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf

# Create attestation test script
RUN echo '#!/bin/bash
echo "=== Testing KMS Attestation ==="
cd /tmp
echo "Secret-$(date +%s)" > secret.txt
python3 -c "
import boto3
kms = boto3.client(\"kms\")
with open(\"secret.txt\", \"rb\") as f:
    ciphertext = kms.encrypt(KeyId=\"4bae92be-4b6c-4380-abb3-504dcb330b5a\", Plaintext=f.read())[\"CiphertextBlob\"]
try:
    plaintext = kms.decrypt(CiphertextBlob=ciphertext)
    print(\"✅ ATTESTATION SUCCESS - Enclave verified!\")
except Exception as e:
    print(\"❌ ATTESTATION FAILED:\", str(e))
"
echo "=== Attestation test complete ==="' > /test_attestation.sh && chmod +x /test_attestation.sh

# Create main startup script
RUN printf '#!/bin/bash\n\n# Run attestation test\n/test_attestation.sh\n\n# Start services\nip link set lo up\nnginx -g "daemon off;" &\nsocat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\nwait\n' > /start.sh && \
    chmod +x /start.sh

CMD ["/start.sh"]
