####Parent Docker File 

# Copyright 2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0
# THIS IS PARENT DOCKER FILE 

######## full image ########

FROM public.ecr.aws/amazonlinux/amazonlinux:2 as full_image

RUN amazon-linux-extras install aws-nitro-enclaves-cli && \
    yum install aws-nitro-enclaves-cli-devel jq socat -y  # ADDED: socat for vsock proxy

 
# ADD THIS HERE - Install VSOCK-enabled socat
RUN yum install -y gcc make tar && \
    curl -O http://www.dest-unreach.org/socat/download/socat-1.7.4.4.tar.gz && \
    tar xzf socat-1.7.4.4.tar.gz && \
    cd socat-1.7.4.4 && \
    ./configure --enable-vsock --prefix=/usr && \
    make && make install && \
    cd .. && rm -rf socat-1.7.4.4*

# Install full debugging/tooling toolbox (Amazon Linux 2 packages)
RUN yum update -y && \
    yum install -y \
      procps-ng \
      util-linux \
      iproute \
      iputils \
      net-tools \
      bind-utils \
      strace \
      lsof \
      curl \
      jq \
      vim-minimal \
      less \
      tree \
      socat && \
    yum clean all
    
    
# DEBUG: Verify socat has VSOCK support
RUN /usr/bin/socat -h | grep -i sock && echo " !!!! vsock support verified !!!!" 
    
WORKDIR /ne-deps

# Copy only the required binaries to /ne-deps folder.
#
RUN BINS="\
    /usr/bin/nitro-cli \
    /usr/bin/nitro-enclaves-allocator \
    /usr/bin/jq \
    /usr/bin/socat \
    " && \
    for bin in $BINS; do \
        { echo "$bin"; ldd "$bin" | grep -Eo "/.*lib.*/[^ ]+"; } | \
            while read path; do \
                mkdir -p ".$(dirname $path)"; \
                cp -fL "$path" ".$path"; \
            done \
    done

# Prepare other required files and folders for the final image.
RUN \
    mkdir -p /ne-deps/etc/nitro_enclaves && \
    mkdir -p /ne-deps/run/nitro_enclaves && \
    mkdir -p /ne-deps/var/log/nitro_enclaves && \
    cp -rf /usr/share/nitro_enclaves/ /ne-deps/usr/share/ && \
    cp -f /etc/nitro_enclaves/allocator.yaml /ne-deps/etc/nitro_enclaves/allocator.yaml

######## nginx image ########

FROM public.ecr.aws/amazonlinux/amazonlinux:2 as image

# Copying dependencies of the enclave apps from the 'full_image'
# to shrink the final image size.
#
COPY --from=full_image /ne-deps/etc /etc
COPY --from=full_image /ne-deps/lib64 /lib64
COPY --from=full_image /ne-deps/run /run
COPY --from=full_image /ne-deps/usr /usr
COPY --from=full_image /ne-deps/var /var

COPY bin/nginx.eif /home
COPY coconginx/run.sh  /home

####################################################### Create vsock-proxy.sh with PROPER newlines
RUN printf '#!/bin/bash\n\nENCLAVE_CID=$1\nTCP_PORT=${2:-80}\nVSOCK_PORT=${3:-5000}\n\necho "Starting VSOCK proxy: TCP:$TCP_PORT -> VSOCK:$ENCLAVE_CID:$VSOCK_PORT"\n\nexec socat TCP-LISTEN:$TCP_PORT,fork,reuseaddr VSOCK-CONNECT:$ENCLAVE_CID:$VSOCK_PORT\n' > /home/vsock-proxy.sh

####################################################### Create health-check.sh with PROPER newlines
RUN printf '#!/bin/bash\n\nENCLAVE_CID=$1\nHEALTH_PORT=5001\n\necho "Starting health check for enclave CID: $ENCLAVE_CID"\n\nwhile true; do\n    if echo "health" | socat -t 1 - VSOCK-CONNECT:$ENCLAVE_CID:$HEALTH_PORT 2>/dev/null; then\n        echo "$(date): Enclave health check PASSED"\n    else\n        echo "$(date): Enclave health check FAILED"\n    fi\n    sleep 30\ndone\n' > /home/health-check.sh

###################################################### Change permissions
RUN chmod +x /home/run.sh /home/vsock-proxy.sh /home/health-check.sh

###################################################### Debug: Verify all scripts are in place and executable
RUN ls -la /home/ && echo "=== Script contents ===" && \
    head -5 /home/run.sh /home/vsock-proxy.sh /home/health-check.sh && \
    echo "=== All scripts verified ==="

CMD ["/home/run.sh"]





######Enclave Manifest file 


{
    "name": "coconginx",
    "repository": "https://github.com/nerdysrisha/nitroenclave-nginx.git",
    "tag": "main",
    "eif": {
        "name": "nginx.eif",
        "docker": {
            "image_name": "ne-build-nginx-eif",
            "image_tag": "1.0",
            "target": "",
            "x86_64": {
                "file_path": "dockerfiles/v2",
                "file_name": "Dockerfile",
                "build_path": "dockerfiles/v2"
            },
            "aarch64": {
                "file_path": "dockerfiles/v2",
                "file_name": "Dockerfile",
                "build_path": "dockerfiles/v2"
            }
        }
    }
}




#######Run.sh file 


#!/bin/bash -e
# Copyright 2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.

readonly EIF_PATH="/home/nginx.eif"
readonly ENCLAVE_CPU_COUNT=2
readonly ENCLAVE_MEMORY_SIZE=2048

# Function to get enclave VSOCK CID
get_enclave_cid() {
    nitro-cli describe-enclaves | jq -r ".[0].EnclaveCID"
}

# Function to start vsock proxy
# Function to start vsock proxy
start_vsock_proxy() {
    local enclave_cid=$1
    echo "Starting VSOCK proxy for enclave CID: $enclave_cid"
    # Bridge TCP port 80 (external) to VSOCK port 5000 (enclave internal)
    # External clients connect to TCP:80 → Proxy forwards to VSOCK:5000 → Enclave forwards to TCP:8080 → Nginx
    socat TCP-LISTEN:80,fork,reuseaddr VSOCK-CONNECT:$enclave_cid:5000 &
    echo $! > /var/run/vsock-proxy.pid
    echo "VSOCK proxy started: TCP:80 -> VSOCK:$enclave_cid:5000"
}

main() {
    # Start the enclave
    nitro-cli run-enclave --cpu-count $ENCLAVE_CPU_COUNT --memory $ENCLAVE_MEMORY_SIZE \
        --eif-path $EIF_PATH --debug-mode

    local enclave_id=$(nitro-cli describe-enclaves | jq -r ".[0].EnclaveID")
    echo "-------------------------------"
    echo "Enclave ID is $enclave_id"
    echo "-------------------------------"

    # Wait for enclave to be ready and get its CID
    local enclave_cid=""
    while [ -z "$enclave_cid" ]; do
        enclave_cid=$(get_enclave_cid)
        if [ -z "$enclave_cid" ]; then
            echo "Waiting for enclave CID..."
            sleep 2
        fi
    done

    echo "Enclave CID: $enclave_cid"
    
    # Start the vsock proxy
    start_vsock_proxy $enclave_cid
    
    #Waiting for nginx inside enclave to fully start
    echo "Waiting for nginx inside enclave to start. 30 Seconds Wait..."
    sleep 30
    
    # Start health check in background
    /home/health-check.sh $enclave_cid &
    
    echo "Nginx enclave with VSOCK proxy is ready!"
    echo "Access via: curl http://localhost:80"
    
    # Keep the container running
    wait
}

main


#Deployment.yaml 


apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-enclave-deployment
  namespace: integrations
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-enclave
  template:
    metadata:
      labels:
        app: nginx-enclave
    spec:
      containers:
      - name: nginx-container
        image: nerdysrisha/nginx-aws-nitro:latest
        imagePullPolicy: Always
        ports:
          - containerPort: 80
        resources:
          limits:
            aws.ec2.nitro/nitro_enclaves: 1
            hugepages-2Mi: 2048Mi
            cpu: 1000m
            memory: 2Gi
          requests:
            aws.ec2.nitro/nitro_enclaves: 1
            hugepages-2Mi: 2048Mi
            cpu: 1000m
            memory: 2Gi
        volumeMounts:
        - mountPath: /dev/hugepages
          name: hugepage
          readOnly: false
        - mountPath: /dev/vsock
          name: vsock-device
        securityContext:
          privileged: true
          capabilities:
            add:
              - SYS_ADMIN
              - NET_ADMIN
      volumes:
      - name: hugepage
        emptyDir:
          medium: HugePages-2Mi
      - name: vsock-device
        hostPath:
          path: /dev/vsock
      tolerations:
      - effect: NoSchedule
        operator: Exists
      - effect: NoExecute
        operator: Exists
      - key: aws.ec2.nitro/nitro_enclaves
        operator: Exists
        effect: NoSchedule
