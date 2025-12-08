# This is main application dockerfile. Here we are using nginx as application
FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install nginx, socat, and debugging tools (fix curl conflict)
# ADDED: python3, pip, awscli for KMS attestation
RUN dnf update -y && dnf install -y nginx socat nc iproute procps-ng python3 python3-pip awscli --allowerasing
RUN pip3 install boto3

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
from botocore.config import Config\n\
kms = boto3.client(''kms'')\n\
# Encrypt\n\
with open(''test.txt'', ''rb'') as f:\n\
    resp = kms.encrypt(KeyId=''4bae92be-4b6c-4380-abb3-504dcb330b5a'', Plaintext=f.read())\n\
    ciphertext = resp[''CiphertextBlob'']\n\
# Save ciphertext\n\
with open(''ciphertext.bin'', ''wb'') as f:\n\
    f.write(ciphertext)\n\
# Decrypt WITH attestation (should work only in verified enclave)\n\
try:\n\
    plaintext = kms.decrypt(CiphertextBlob=ciphertext)\n\
    print(''✅ ATTESTATION SUCCESS! Enclave verified by AWS KMS.'')\n\
    print(''   Decrypted secret:'', plaintext[''Plaintext''].decode())\n\
except Exception as e:\n\
    print(''❌ ATTESTATION FAILED:'', str(e))\n\
    print(''   This means:'')\n\
    print(''   1. Enclave not in release mode (still debug)'')\n\
    print(''   2. PCR measurements don'\''t match KMS policy'')\n\
    print(''   3. IAM permissions missing'')\n\
"\n\
echo "=== Attestation test complete ==="' > /test_attestation.sh && \
    chmod +x /test_attestation.sh

# Create startup script with extensive debugging
RUN printf '#!/bin/bash\n\nset -x\necho "=== Starting nginx and VSOCK proxy inside enclave ==="\necho "Timestamp: $(date)"\n\necho "=== Pre-start system info ==="\necho "Hostname: $(hostname)"\necho "IP addresses:"\nip addr show\necho "=== Bringing up loopback interface ==="\nip link set lo up\necho "Loopback status:"\nip addr show lo\necho "Initial listening ports:"\nss -tlnp\n\n# RUN ATTESTATION TEST - NEW LINE ADDED\n/test_attestation.sh\n\necho "=== Nginx configuration check ==="\necho "Nginx config test:"\nnginx -t\necho "Nginx config files:"\nls -la /etc/nginx/\nls -la /etc/nginx/conf.d/\necho "Default config content:"\ncat /etc/nginx/conf.d/default.conf\necho "Main nginx.conf relevant lines:"\ngrep -v "^#" /etc/nginx/nginx.conf | grep -v "^$"\n\necho "=== Starting nginx ==="\nnginx -g "daemon off;" &\nNGINX_PID=$!\necho "Nginx PID: $NGINX_PID"\necho "Nginx started on port 8080"\n\necho "=== Waiting for nginx to initialize ==="\nsleep 3\n\necho "=== Post-nginx start debugging ==="\necho "Process list:"\nps aux\necho "Listening ports after nginx start:"\nss -tlnp\necho "Nginx process check:"\nps aux | grep nginx\n\necho "=== Testing local nginx connectivity ==="\necho "Testing 127.0.0.1:8080:"\ncurl -v --connect-timeout 5 http://127.0.0.1:8080/ 2>&1 || echo "127.0.0.1:8080 failed"\necho "Testing localhost:8080:"\ncurl -v --connect-timeout 5 http://localhost:8080/ 2>&1 || echo "localhost:8080 failed"\necho "Testing 0.0.0.0:8080:"\ncurl -v --connect-timeout 5 http://0.0.0.0:8080/ 2>&1 || echo "0.0.0.0:8080 failed"\n\necho "=== Network interface details ==="\necho "/etc/hosts content:"\ncat /etc/hosts\n\necho "=== Starting VSOCK proxy ==="\necho "VSOCK proxy command: socat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080"\nsocat -d -d VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\nVSOCK_PID=$!\necho "VSOCK proxy PID: $VSOCK_PID"\necho "VSOCK proxy started on port 5000"\n\necho "=== Final system state ==="\necho "All processes:"\nps aux\necho "All listening ports:"\nss -tlnp\n\necho "=== Startup complete - waiting for connections ==="\necho "Nginx PID: $NGINX_PID, VSOCK PID: $VSOCK_PID"\n\nwait\n' > /start.sh && \
    chmod +x /start.sh

# DEBUG: Verify nginx config and startup script
RUN nginx -t && echo "✅ Nginx configuration is valid"
RUN echo "=== Startup script content ===" && cat /start.sh

# Add this line BEFORE the CMD line:
RUN mkdir -p /dev /proc /sys /tmp /run /var/run

#  simplify the CMD to bare minimum:
CMD ["sh", "-c", "nginx -g 'daemon off;' & socat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 & wait"]
