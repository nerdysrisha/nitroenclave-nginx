# Copyright 2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0
# THIS IS PARENT DOCKER FILE WITH ALL ADDITIONAL TOOLS FOR DEBUGGING

######## full image ########

FROM public.ecr.aws/amazonlinux/amazonlinux:2 as full_image
 
RUN amazon-linux-extras install aws-nitro-enclaves-cli -y && yum install aws-nitro-enclaves-cli-devel jq socat -y && yum clean all
 
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
COPY coconginxv3/run.sh  /home
COPY scripts/vsock-proxy.sh /home/



####################################################### Create vsock-proxy.sh with PROPER newlines
#RUN printf '#!/bin/bash\n\nENCLAVE_CID=$1\nTCP_PORT=${2:-80}\nVSOCK_PORT=${3:-5000}\n\necho "Starting VSOCK proxy: TCP:$TCP_PORT -> VSOCK:$ENCLAVE_CID:$VSOCK_PORT"\n\nexec socat TCP-LISTEN:$TCP_PORT,fork,reuseaddr VSOCK-CONNECT:$ENCLAVE_CID:$VSOCK_PORT\n' > /home/vsock-proxy.sh

####################################################### Create health-check.sh with PROPER newlines
#RUN printf '#!/bin/bash\n\nENCLAVE_CID=$1\nHEALTH_PORT=5001\n\necho "Starting health check for enclave CID: $ENCLAVE_CID"\n\nwhile true; do\n    if echo "health" | socat -t 1 - VSOCK-CONNECT:$ENCLAVE_CID:$HEALTH_PORT 2>/dev/null; then\n        echo "$(date): Enclave health check PASSED"\n    else\n        echo "$(date): Enclave health check FAILED"\n    fi\n    sleep 30\ndone\n' > /home/health-check.sh

###################################################### Change permissions


RUN chmod +x /home/run.sh /home/vsock-proxy.sh  

###################################################### Debug: Verify all scripts are in place and executable
RUN ls -la /home/ && echo "=== Script contents ===" && \
    head -5 /home/run.sh /home/vsock-proxy.sh && \
    echo "=== All scripts verified ==="

CMD ["/home/run.sh"]
