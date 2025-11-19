FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install nginx
RUN dnf update -y && dnf install -y nginx

# Create a simple nginx configuration  
RUN echo "Hello from NGINX in Enclave! Super Simple without VSOCK" > /usr/share/nginx/html/index.html

# Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
