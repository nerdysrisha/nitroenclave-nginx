FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install dependencies
RUN dnf update -y && \
    dnf install -y \
    nginx \
    socat \
    nc \
    iproute \
    procps-ng \
    python3 \
    python3-pip \
    --allowerasing

# Install Python dependencies
RUN pip3 install cbor2

# Setup NGINX
RUN echo "Hello from NGINX in Enclave via VSOCK proxy!" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf

# Create Python script to get attestation document
COPY <<EOFMARKER /opt/get_attestation.py
#!/usr/bin/env python3
import sys
import json
import base64
import struct
import os
import traceback

def get_attestation_document(nonce=None):
    """Get attestation document from /dev/nsm"""
    debug_info = {
        'nsm_device_exists': os.path.exists('/dev/nsm'),
        'nsm_device_readable': False,
        'nsm_device_writable': False,
        'nsm_device_perms': None,
        'error_details': None
    }
    
    try:
        # Check permissions
        if os.path.exists('/dev/nsm'):
            stat_info = os.stat('/dev/nsm')
            debug_info['nsm_device_perms'] = oct(stat_info.st_mode)
            debug_info['nsm_device_readable'] = os.access('/dev/nsm', os.R_OK)
            debug_info['nsm_device_writable'] = os.access('/dev/nsm', os.W_OK)
        
        with open('/dev/nsm', 'r+b', buffering=0) as nsm_fd:
            # NSM request structure (simplified)
            # Build attestation request with optional nonce
            request = {
                'attestation': {
                    'nonce': nonce if nonce else None,
                    'user_data': None,
                    'public_key': None
                }
            }
            
            # Write request (this is simplified - actual NSM protocol is more complex)
            # In practice, /dev/nsm handles ioctl calls
            # We'll use a simple read which the NSM device provides
            response = nsm_fd.read(16384)
            
            return response, debug_info
    except Exception as e:
        debug_info['error_details'] = str(e)
        debug_info['error_traceback'] = traceback.format_exc()
        return None, debug_info

def main():
    try:
        # Read optional nonce from stdin
        nonce_input = sys.stdin.readline().strip()
        nonce = None
        
        debug_data = {
            'nonce_received': bool(nonce_input),
            'nonce_length': len(nonce_input) if nonce_input else 0,
            'python_version': sys.version,
            'working_directory': os.getcwd(),
            'user': os.getenv('USER', 'unknown'),
            'uid': os.getuid() if hasattr(os, 'getuid') else 'N/A'
        }
        
        if nonce_input:
            try:
                nonce = base64.b64decode(nonce_input)
                debug_data['nonce_decoded_length'] = len(nonce)
            except Exception as e:
                print(json.dumps({
                    'status': 'error',
                    'message': 'Invalid base64 nonce',
                    'debug': debug_data,
                    'decode_error': str(e)
                }))
                return 1
        
        # Get attestation document
        doc, nsm_debug = get_attestation_document(nonce)
        
        # Merge debug info
        debug_data.update(nsm_debug)
        
        if doc:
            # Return as base64 JSON
            result = {
                'status': 'success',
                'attestation': base64.b64encode(doc).decode('ascii'),
                'attestation_length': len(doc),
                'debug': debug_data
            }
            print(json.dumps(result))
            return 0
        else:
            print(json.dumps({
                'status': 'error',
                'message': 'Failed to get attestation document from NSM',
                'debug': debug_data
            }))
            return 1
            
    except Exception as e:
        print(json.dumps({
            'status': 'error',
            'message': str(e),
            'traceback': traceback.format_exc()
        }))
        return 1

if __name__ == '__main__':
    sys.exit(main())
EOFMARKER

RUN chmod +x /opt/get_attestation.py

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
