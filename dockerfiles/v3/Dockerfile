FROM public.ecr.aws/amazonlinux/amazonlinux:2023

WORKDIR /opt

# --- 1. Install Dependencies ---
RUN dnf update -y && \
    dnf install -y \
    nginx socat nc iproute procps-ng \
    gcc cmake make git \
    pkgconf-pkg-config \
    json-c-devel openssl-devel libcurl-devel glibc-static \
    doxygen graphviz --allowerasing

# --- 2. Build Dependencies ---

# A) aws-c-common
# FIX 1: We use -DCMAKE_INSTALL_LIBDIR=lib to FORCE installation to /usr/local/lib
# instead of /usr/local/lib64. This ensures consistency for the next step.
RUN git clone https://github.com/awslabs/aws-c-common.git
RUN cd aws-c-common && \
    cmake -B build -S . \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DCMAKE_INSTALL_LIBDIR=lib && \
    cmake --build build && \
    cmake --install build

# B) aws-nitro-enclaves-sdk-c
# FIX 2: We explicitly pass the CMAKE_PREFIX_PATH to find aws-c-common.
# FIX 3: We MANUALLY pass the json-c paths. Amazon Linux puts them in /usr/lib64, 
# but CMake often misses that. We point directly to the .so and .h files.
RUN git clone https://github.com/aws/aws-nitro-enclaves-sdk-c.git
RUN cd aws-nitro-enclaves-sdk-c && \
    cmake -B build -S . \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DCMAKE_PREFIX_PATH=/usr/local \
        -DLibJsonC_INCLUDE_DIR=/usr/include/json-c \
        -DLibJsonC_LIBRARY=/usr/lib64/libjson-c.so && \
    cmake --build build && \
    cmake --install build

# Register Lib Path (Use /usr/local/lib because we forced it above)
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/nsm.conf && ldconfig

# --- 3. Compile Attestation Binary ---
COPY attest.c /opt/attest.c

# LINKING: We link against the SDK, common, and json-c.
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
