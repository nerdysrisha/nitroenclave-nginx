FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install nginx, socat, and debugging tools
RUN dnf update -y && dnf install -y nginx socat nc iproute procps-ng --allowerasing

# Add Python for attestation testing
RUN dnf install -y python3 python3-pip && \
    pip3 install boto3 flask

   
# Create nginx configuration
RUN echo "Hello from NGINX in Enclave via VSOCK proxy! PoC on Confidential Containers" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf




#########
# Add the Flask credentials server script
RUN cat > /opt/credentials_server.py << 'EOF'
from flask import Flask, request, jsonify
import os
import json

app = Flask(__name__)

@app.route('/set-credentials', methods=['POST'])
def set_credentials():
    try:
        if request.is_json:
            data = request.get_json()
        else:
            body = request.get_data(as_text=True)
            if body:
                data = json.loads(body)
            else:
                data = request.form.to_dict()
        
        if 'AWS_ROLE_ARN' in data:
            os.environ['AWS_ROLE_ARN'] = data['AWS_ROLE_ARN']
        if 'AWS_WEB_IDENTITY_TOKEN_FILE' in data:
            os.environ['AWS_WEB_IDENTITY_TOKEN_FILE'] = data['AWS_WEB_IDENTITY_TOKEN_FILE']
        if 'AWS_REGION' in data:
            os.environ['AWS_REGION'] = data['AWS_REGION']
        
        print(f"Credentials received and set!")
        print(f"AWS_ROLE_ARN: {os.environ.get('AWS_ROLE_ARN', 'Not set')}")
        print(f"AWS_REGION: {os.environ.get('AWS_REGION', 'Not set')}")
        
        return jsonify({"status": "success", "message": "Credentials set successfully"})
        
    except Exception as e:
        print(f"Error setting credentials: {str(e)}")
        return jsonify({"status": "error", "message": str(e)}), 400

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "healthy", "service": "credentials-server"})

if __name__ == '__main__':
    print("Starting Flask credentials server on port 5001...")
    app.run(host='0.0.0.0', port=5001, debug=True)
EOF



#########



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

#This is startup but without flask 
#RUN printf '#!/bin/bash\n\n# Run attestation test and capture results\necho "Running attestation test..."\nif /opt/test_attestation.sh > /tmp/attestation_result.log 2>&1; then\n    echo "{\\"status\\": \\"SUCCESS\\", \\"message\\": \\"Attestation passed\\", \\"details\\": \\"$(cat /tmp/attestation_result.log)\\"}" > /usr/share/nginx/html/attestation-status.json\nelse\n    echo "{\\"status\\": \\"FAILED\\", \\"message\\": \\"Attestation failed\\", \\"details\\": \\"$(cat /tmp/attestation_result.log)\\"}" > /usr/share/nginx/html/attestation-status.json\nfi\n\n# Bring up loopback\nip link set lo up\n\n# Start nginx\nnginx -g "daemon off;" &\nNGINX_PID=$!\n\n# Start VSOCK proxy\nsocat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\nVSOCK_PID=$!\n\n# Wait for both\nwait\n' > /start.sh && \
   # chmod +x /start.sh


#With attestation and flask 
RUN printf '#!/bin/bash\n\n# Run attestation test and capture results\necho "Running attestation test..."\nif /opt/test_attestation.sh > /tmp/attestation_result.log 2>&1; then\n    echo "{\\"status\\": \\"SUCCESS\\", \\"message\\": \\"Attestation passed\\", \\"details\\": \\"$(cat /tmp/attestation_result.log)\\"}" > /usr/share/nginx/html/attestation-status.json\nelse\n    echo "{\\"status\\": \\"FAILED\\", \\"message\\": \\"Attestation failed\\", \\"details\\": \\"$(cat /tmp/attestation_result.log)\\"}" > /usr/share/nginx/html/attestation-status.json\nfi\n\n# Bring up loopback\nip link set lo up\n\n# Start Flask credentials server\npython3 /opt/credentials_server.py &\nFLASK_PID=$!\n\n# Start nginx\nnginx -g "daemon off;" &\nNGINX_PID=$!\n\n# Start VSOCK proxy\nsocat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\nVSOCK_PID=$!\n\n# Wait for all\nwait\n' > /start.sh && \
    chmod +x /start.sh





# Verify nginx config
RUN nginx -t && echo "✅ Nginx configuration is valid"

CMD ["/start.sh"]
