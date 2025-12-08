FROM public.ecr.aws/amazonlinux/amazonlinux:2023
RUN dnf update -y && dnf install -y nginx socat python3 python3-pip awscli --allowerasing
RUN pip3 install boto3
RUN mkdir -p /dev /proc /sys /tmp /run /var/run
RUN echo "Hello from NGINX for coco enclaves" > /usr/share/nginx/html/index.html
RUN echo 'server { listen 8080; }' > /etc/nginx/conf.d/default.conf
CMD ["sh", "-c", "ip link set lo up && nginx -g 'daemon off;' & socat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080 & wait"]

 
