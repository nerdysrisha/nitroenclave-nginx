FROM public.ecr.aws/amazonlinux/amazonlinux:2

# Install nginx
RUN yum update -y && yum install -y nginx

# Create a simple nginx configuration file
RUN printf 'server {\n    listen 80;\n    server_name _;\n    location / {\n        return 200 "Hello from NGINX in Enclave!\\n";\n        add_header Content-Type text/plain;\n    }\n}' > /etc/nginx/conf.d/default.conf

# Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
