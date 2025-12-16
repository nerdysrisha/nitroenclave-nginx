
FROM public.ecr.aws/amazonlinux/amazonlinux:2023

RUN dnf update -y && \
    dnf install -y nginx socat nc iproute procps-ng python3 python3-pip python3-setuptools gcc make --allowerasing && \
    dnf clean all

# Install Python NSM binding
RUN pip3 install --no-cache-dir aws-nsm-interface

# ✅ PATCH: Fix aws-nsm-interface to open /dev/nsm in binary mode (avoid seek error)
RUN sed -i "s/open(NSM_DEV_FILE, 'r+')/open(NSM_DEV_FILE, 'rb+', buffering=0)/" \
    /usr/local/lib/python3.9/site-packages/aws_nsm_interface/__init__.py

RUN echo "Hello from NGINX in Enclave via VSOCK proxy!" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf

# Attestation script (exposed via VSOCK port 5001)
COPY attestation.sh /opt/attestation.sh
RUN chmod +x /opt/attestation.sh

RUN printf '#!/bin/bash\n\nset -e\nip link set lo up\n\nnginx -g "daemon off;" &\nNGINX_PID=$!\n\nsocat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\nVSOCK_PID=$!\n\n# IMPORTANT: 2>&1 so failures are returned to the caller (no enclave console needed)\nsocat VSOCK-LISTEN:5001,fork EXEC:"/bin/bash -lc \\"/opt/attestation.sh 2>&1\\"" &\nATTEST_PID=$!\n\nwait\n' > /start.sh && \
    chmod +x /start.sh

RUN nginx -t

CMD ["/start.sh"]

