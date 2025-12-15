FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install dependencies including aws-nitro-enclaves-cli for nsm-cli tool
RUN dnf update -y && \
    dnf install -y \
    nginx \
    socat \
    nc \
    iproute \
    procps-ng \
    python3 \
    python3-pip \
    aws-nitro-enclaves-cli \
    vim-common \
    --allowerasing

# Install Python dependencies
RUN pip3 install cbor2

# Setup NGINX
RUN echo "Hello from NGINX in Enclave via VSOCK proxy!" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf

# Create shell script to get attestation using nsm-cli
COPY <<EOFMARKER /opt/get_attestation.sh
#!/bin/bash

# Collect debug information
DEBUG_INFO=""

# Check if nsm-cli exists
if [ -x "/usr/bin/nsm-cli" ]; then
    NSM_CLI_EXISTS="true"
    NSM_CLI_VERSION=\$(/usr/bin/nsm-cli --version 2>&1 || echo "version unknown")
else
    NSM_CLI_EXISTS="false"
    NSM_CLI_VERSION="not found"
fi

# Check /dev/nsm
if [ -e "/dev/nsm" ]; then
    NSM_DEVICE_EXISTS="true"
    NSM_DEVICE_PERMS=\$(stat -c "%a" /dev/nsm 2>/dev/null || echo "unknown")
    NSM_DEVICE_TYPE=\$(stat -c "%F" /dev/nsm 2>/dev/null || echo "unknown")
else
    NSM_DEVICE_EXISTS="false"
    NSM_DEVICE_PERMS="N/A"
    NSM_DEVICE_TYPE="N/A"
fi

# Check if xxd is available
XXD_AVAILABLE=\$(command -v xxd >/dev/null 2>&1 && echo "true" || echo "false")

# Read nonce from stdin (base64 encoded)
read -r NONCE_B64

NONCE_RECEIVED=\$([ -n "\$NONCE_B64" ] && echo "true" || echo "false")
NONCE_LENGTH=\${#NONCE_B64}

# Get attestation document using nsm-cli
if [ -n "\$NONCE_B64" ] && [ "\$XXD_AVAILABLE" = "true" ]; then
    # Decode nonce from base64 to hex
    NONCE_HEX=\$(echo "\$NONCE_B64" | base64 -d 2>/dev/null | xxd -p -c 256 2>/dev/null)
    if [ -n "\$NONCE_HEX" ]; then
        RESULT=\$(/usr/bin/nsm-cli attestation --nonce "\$NONCE_HEX" 2>&1)
        NSM_EXIT_CODE=\$?
    else
        RESULT="Failed to decode nonce"
        NSM_EXIT_CODE=1
    fi
elif [ -n "\$NONCE_B64" ] && [ "\$XXD_AVAILABLE" = "false" ]; then
    RESULT="xxd not available for nonce conversion"
    NSM_EXIT_CODE=1
else
    RESULT=\$(/usr/bin/nsm-cli attestation 2>&1)
    NSM_EXIT_CODE=\$?
fi

# Build debug object
DEBUG_JSON="{\\\"nsm_cli_exists\\\":\\\"\$NSM_CLI_EXISTS\\\",\\\"nsm_cli_version\\\":\\\"\$NSM_CLI_VERSION\\\",\\\"nsm_device_exists\\\":\\\"\$NSM_DEVICE_EXISTS\\\",\\\"nsm_device_perms\\\":\\\"\$NSM_DEVICE_PERMS\\\",\\\"nsm_device_type\\\":\\\"\$NSM_DEVICE_TYPE\\\",\\\"xxd_available\\\":\\\"\$XXD_AVAILABLE\\\",\\\"nonce_received\\\":\\\"\$NONCE_RECEIVED\\\",\\\"nonce_length\\\":\$NONCE_LENGTH,\\\"nsm_exit_code\\\":\$NSM_EXIT_CODE,\\\"shell\\\":\\\"\$SHELL\\\",\\\"pwd\\\":\\\"\$PWD\\\"}"

# Check if nsm-cli succeeded
if [ \$NSM_EXIT_CODE -eq 0 ] && [ -n "\$RESULT" ]; then
    # nsm-cli outputs the attestation document in base64
    echo "{\"status\":\"success\",\"attestation\":\"\$RESULT\",\"debug\":\$DEBUG_JSON}"
else
    # Escape the error message for JSON
    RESULT_ESCAPED=\$(echo "\$RESULT" | sed 's/"/\\\\"/g' | tr '\n' ' ')
    echo "{\"status\":\"error\",\"message\":\"nsm-cli failed\",\"details\":\"\$RESULT_ESCAPED\",\"debug\":\$DEBUG_JSON}"
fi
EOFMARKER

RUN chmod +x /opt/get_attestation.sh

# Create startup script
RUN printf '#!/bin/bash\n\
\n\
# Bring up loopback interface\n\
ip link set lo up\n\
\n\
# Start NGINX in background\n\
nginx -g "daemon off;" &\n\
NGINX_PID=$!\n\
\n\
# VSOCK proxy for NGINX (port 5000 -> 8080)\n\
socat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\n\
VSOCK_PID=$!\n\
\n\
# VSOCK proxy for attestation service (port 5001)\n\
socat VSOCK-LISTEN:5001,fork EXEC:/opt/get_attestation.py &\n\
ATTEST_PID=$!\n\
\n\
echo "Enclave services started:"\n\
echo "  - NGINX: PID $NGINX_PID"\n\
echo "  - VSOCK proxy (NGINX): PID $VSOCK_PID (port 5000)"\n\
echo "  - VSOCK attestation: PID $ATTEST_PID (port 5001)"\n\
\n\
# Wait for all background processes\n\
wait\n' > /start.sh && \
    chmod +x /start.sh

# Verify NGINX configuration
RUN nginx -t

CMD ["/start.sh"]
