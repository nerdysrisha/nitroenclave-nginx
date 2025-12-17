#!/bin/bash
set -e


echo "========================================================================================================================="
echo "================================BUILDING ENCLAVE IMAGE =================================================================="

echo "Navigating to project directory..."
cd /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s

echo "Adding enclavectl to the path..."
source env.sh

echo "Cleaning up enclavectl environment..."
./enclavectl cleanup

echo "Applying configuration settings from settings.json..."
./enclavectl configure --file settings.json

echo "Initial setup completed."

echo "Step 1: Cleaning up Docker containers and images..."

docker ps -a --format '{{.ID}} {{.Image}}' | grep -v 'kindest/node' | awk '{print $1}' | xargs -r docker rm -f
docker images --format '{{.Repository}}:{{.Tag}} {{.ID}}' | grep -v '^kindest/node' | awk '{print $2}' | xargs -r docker rmi -f

docker image prune -f
docker builder prune --all --force
docker volume prune -f
docker network prune -f

echo "Docker cleanup completed."

echo "Step 2: Cleaning up existing .eif files..."

EIF_DIR="/home/sridhara/Downloads/aws-nitro-enclaves-with-k8s/container/bin"

ls -lrt "$EIF_DIR"
rm -f "$EIF_DIR"/*.*
ls -lrt "$EIF_DIR"

echo "Step 3: Building Nitro Enclaves..."

cd /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s

echo "Confirmed directory: $(pwd)"
echo "Starting enclavectl build process..."
./enclavectl build --image coconginxv3

docker images
docker ps -a

echo "Step 4: Tagging coconginx images..."

docker images --format '{{.Repository}}:{{.Tag}}' \
  | grep '^coconginx' \
  | while read image; do
    docker tag "$image" nerdysrisha/nginx-aws-nitro:latest
done

echo "Step 5: Pushing image to Docker Hub..."
docker push nerdysrisha/nginx-aws-nitro:latest

echo "Step 6: Cleaning up Docker containers and images..."

docker ps -a --format '{{.ID}} {{.Image}}' | grep -v 'kindest/node' | awk '{print $1}' | xargs -r docker rm -f
docker images --format '{{.Repository}}:{{.Tag}} {{.ID}}' | grep -v '^kindest/node' | awk '{print $2}' | xargs -r docker rmi -f

docker image prune -f
docker builder prune --all --force
docker volume prune -f
docker network prune -f

echo "=========================================="
echo "Script execution completed successfully!"
echo "=========================================="
