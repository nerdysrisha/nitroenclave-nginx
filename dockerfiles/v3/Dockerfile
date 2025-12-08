FROM public.ecr.aws/amazonlinux/amazonlinux:2023

#RUN dnf update -y && dnf install -y nginx socat nc iproute procps-ng --allowerasing



# ADD python3, pip, awscli
RUN dnf update -y && dnf install -y nginx socat nc iproute procps-ng python3 python3-pip awscli --allowerasing
RUN pip3 install boto3  # ADD THIS LINE



RUN echo "Hello from NGINX in Enclave via VSOCK proxy! PoC on Confidential Containers" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf



RUN printf '#!/bin/bash\necho "=== Testing KMS Attestation === "\ncd /tmp\necho "Secret-test" > secret.txt\npython3 -c "\\\nimport boto3\\\nkms = boto3.client(\\\"kms\\\")\\\nwith open(\\\"secret.txt\\\", \\\"rb\\\") as f:\\\n    ciphertext = kms.encrypt(KeyId=\\\"4bae92be-4b6c-4380-abb3-504dcb330b5a\\\", Plaintext=f.read())[\\\"CiphertextBlob\\\"]\\\ntry:\\\n    plaintext = kms.decrypt(CiphertextBlob=ciphertext)\\\n    print(\\\"✅ ATTESTATION SUCCESS - Enclave verified!\\\")\\\nexcept Exception as e:\\\n    print(\\\"❌ ATTESTATION FAILED:\\\", str(e))\\\n"\necho "=== Attestation test complete === "' > /test_attestation.sh && \
    chmod +x /test_attestation.sh

    
# Main startup script - NO ATTESTATION
RUN printf '#!/bin/bash\nip link set lo up\nnginx -g "daemon off;" &\nsocat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\nwait\n' > /start.sh && \
   chmod +x /start.sh

# Main startup script - ADD ATTESTATION CALL
#RUN printf '#!/bin/bash\n/test_attestation.sh\nip link set lo up\nnginx -g "daemon off;" &\nsocat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\nwait\n' > /start.sh && \
    #chmod +x /start.sh

CMD ["/start.sh"]
