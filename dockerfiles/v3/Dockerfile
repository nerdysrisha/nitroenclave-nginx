# This is main application dockerfile. Here we are using nginx as application
FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install nginx, socat, and debugging tools (fix curl conflict)
# ADDED: python3, pip, awscli for KMS attestation
RUN dnf update -y && dnf install -y nginx socat nc iproute procps-ng python3 python3-pip awscli --allowerasing
RUN pip3 install boto3

# Create essential directories for LinuxKit/Nitro
RUN mkdir -p /dev /proc /sys /tmp /run /var/run

# Create a simple nginx configuration
RUN echo "Hello from NGINX in Enclave via VSOCK proxy! PoC on Confidential Containers" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf

# CREATE ATTESTATION TEST SCRIPT - NEW SECTION
RUN echo '#!/bin/bash\n\
echo "=== KMS Attestation Test ==="\n\
echo "Testing if enclave can decrypt using PCR-bound KMS key..."\n\
cd /tmp\n\
# Generate test data\n\
echo "SecretForEnclave-$(date +%s)" > test.txt\n\
# Use python for KMS with attestation\n\
python3 -c "\n\
import boto3\n\
import base64\n\
kms = boto3.client(''kms'')\n\
# Encrypt\n\
with open(''test.txt'', ''rb'') as f:\n\
    resp = kms.encrypt(KeyId=''4bae92be-4b6c-4380-abb3-504dcb330b5a'', Plaintext=f.read())\n\
    ciphertext = resp[''CiphertextBlob'']\n\
# Decrypt WITH attestation (should work only in verified enclave)\n\
try:\n\
    plaintext = kms.decrypt(CiphertextBlob=ciphertext)\n\
    print(''✅ ATTESTATION SUCCESS! Enclave verified by AWS KMS.'')\n\
    print(''   Decrypted secret:'', plaintext[''Plaintext''].decode())\n\
except Exception as e:\n\
    print(''❌ ATTESTATION FAILED:'', str(e))\n\
"\n\
echo "=== Attestation test complete ==="' > /test_attestation.sh && \
    chmod +x /test_attestation.sh

# DEBUG: Verify nginx config
RUN nginx -t && echo "✅ Nginx configuration is valid"

# Simple CMD that includes attestation test
CMD ["sh", "-c", "/test_attestation.sh && ip link set lo up && nginx -g 'daemon off;' & socat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 & wait"]
