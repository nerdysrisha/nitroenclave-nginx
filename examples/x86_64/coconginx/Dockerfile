FROM public.ecr.aws/amazonlinux/amazonlinux:2

# Install nginx
RUN yum update -y && yum install -y nginx

# Create nginx configuration using a proper multi-line approach
RUN cat > /etc/nginx/conf.d/default.conf << 'NGINX_CONFIG'
server {
    listen 80;
    server_name _;
    location / {
        return 200 "Hello from NGINX in Enclave!\n";
        add_header Content-Type text/plain;
    }
}
NGINX_CONFIG

# Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
