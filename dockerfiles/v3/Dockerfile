FROM public.ecr.aws/amazonlinux/amazonlinux:2023

WORKDIR /opt

# --- 1. Install Dependencies ---
# Added: doxygen and graphviz (often needed for C SDK docs/builds)
RUN dnf update -y && \
    dnf install -y \
    nginx socat nc iproute procps-ng \
    gcc cmake make git \
    json-c-devel openssl-devel libcurl-devel glibc-static \
    doxygen graphviz --allowerasing

# --- 2. Build Dependencies ---

# A) aws-c-common (Base C lib)
RUN git clone https://github.com/awslabs/aws-c-common.git
RUN cd aws-c-common && cmake -B build -S . && cmake --build build && cmake --install build

# B) aws-nitro-enclaves-sdk-c (THE CORRECT C REPO)
# This replaces the Rust 'nsm-api' repo. This repo HAS a CMakeLists.txt.
RUN git clone https://github.com/aws/aws-nitro-enclaves-sdk-c.git
RUN cd aws-nitro-enclaves-sdk-c && \
    cmake -B build -S . -DCMAKE_INSTALL_PREFIX=/usr/local && \
    cmake --build build && \
    cmake --install build

# Register Lib Path
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/nsm.conf && ldconfig

# --- 3. Compile Attestation Binary ---
COPY attest.c /opt/attest.c

# IMPORTANT: The library name for the C SDK is usually '-laws-nitro-enclaves-sdk-c' 
# If your code specifically needs '-lnsm', you might need to create a symlink or adjust the flag.
# For now, I'm linking against the SDK we just built.
RUN gcc /opt/attest.c -o /opt/attest_c -static \
    -I/usr/local/include \
    -L/usr/local/lib \
    -laws-nitro-enclaves-sdk-c -laws-c-common \
    && chmod +x /opt/attest_c

# --- 4. Setup Runtime ---
# Nginx setup
RUN echo "Hello from NGINX in Enclave via VSOCK proxy!" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf

# Attestation script
COPY get_attestation_document.sh /opt/get_attestation_document.sh
RUN chmod +x /opt/get_attestation_document.sh

# --- 5. Start Script ---
RUN printf '#!/bin/bash\n\
trap "kill -TERM 1" SIGINT SIGTERM\n\
ip link set lo up\n\
\n\
nginx -g "daemon off;" &\n\
socat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 &\n\
socat VSOCK-LISTEN:5001,fork EXEC:/opt/get_attestation_document.sh &\n\
\n\
wait\n\
' > /start.sh && chmod +x /start.sh

RUN nginx -t

CMD ["/start.sh"]
