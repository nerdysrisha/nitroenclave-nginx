FROM public.ecr.aws/amazonlinux/amazonlinux:2023

WORKDIR /opt

# --- 1. Install Dependencies ---
# FIX 1: Added 'pkgconf-pkg-config'. This is REQUIRED for CMake to find json-c.
RUN dnf update -y && \
    dnf install -y \
    nginx socat nc iproute procps-ng \
    gcc cmake make git \
    pkgconf-pkg-config \
    json-c-devel openssl-devel libcurl-devel glibc-static \
    doxygen graphviz --allowerasing

# --- 2. Build Dependencies ---

# A) aws-c-common
RUN git clone https://github.com/awslabs/aws-c-common.git
RUN cd aws-c-common && \
    cmake -B build -S . -DCMAKE_INSTALL_PREFIX=/usr/local && \
    cmake --build build && \
    cmake --install build

# B) aws-nitro-enclaves-sdk-c
# FIX 2: Added '-DCMAKE_PREFIX_PATH=/usr/local'. 
# This tells CMake exactly where to find the 'AwsCFlags' and 'aws-c-common' files we just installed.
RUN git clone https://github.com/aws/aws-nitro-enclaves-sdk-c.git
RUN cd aws-nitro-enclaves-sdk-c && \
    cmake -B build -S . \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DCMAKE_PREFIX_PATH=/usr/local && \
    cmake --build build && \
    cmake --install build

# Register Lib Path
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/nsm.conf && ldconfig

# --- 3. Compile Attestation Binary ---
COPY attest.c /opt/attest.c

# LINKING NOTE: The C SDK library is usually named 'aws-nitro-enclaves-sdk-c'.
# We also link 'aws-c-common' and 'json-c' explicitly to be safe for static linking.
RUN gcc /opt/attest.c -o /opt/attest_c -static \
    -I/usr/local/include \
    -L/usr/local/lib \
    -laws-nitro-enclaves-sdk-c -laws-c-common -ljson-c \
    && chmod +x /opt/attest_c

# --- 4. Setup Runtime ---
RUN echo "Hello from NGINX in Enclave via VSOCK proxy!" > /usr/share/nginx/html/index.html && \
    echo 'server { listen 8080; location / { root /usr/share/nginx/html; }}' > /etc/nginx/conf.d/default.conf && \
    sed -i '/listen.*80;/d' /etc/nginx/nginx.conf

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
