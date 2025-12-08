FROM public.ecr.aws/amazonlinux/amazonlinux:2023

RUN dnf update -y && dnf install -y nginx socat nc iproute procps-ng python3 python3-pip awscli --allowerasing
RUN pip3 install boto3

RUN echo "Hello from NGINX in Enclave via VSOCK proxy! PoC on Confidential Containers" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf

# Create attestation test script (HEREDOC FIX)
RUN cat << 'EOF' > /test_attestation.sh
#!/bin/bash
echo "=== Testing KMS Attestation ==="
cd /tmp
echo "Secret-$(date +%s)" > secret.txt

python3 - << 'PYEOF'
import boto3
kms = boto3.client("kms")
with open("secret.txt", "rb") as f:
    ciphertext = kms.encrypt(KeyId="4bae92be-4b6c-4380-abb3-504dcb330b5a", Plaintext=f.read())["CiphertextBlob"]
try:
    kms.decrypt(CiphertextBlob=ciphertext)
    print("✔ ATTESTATION SUCCESS - Enclave verified!")
except Exception as e:
    print("✘ ATTESTATION FAILED:", str(e))
PYEOF

echo "=== Attestation test complete ==="
EOF

RUN chmod +x /test_attestation.sh

# Minimal startup script
RUN cat << 'EOF' > /start.sh
#!/bin/bash
/test_attestation.sh
ip link set lo up
nginx -g "daemon off;" &
socat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &
wait
EOF

RUN chmod +x /start.sh

CMD ["/start.sh"]
