#!/bin/bash
# Create Deployment for Nitro Enclaves Nginx


echo "========================================================================================================================="
echo "================================DEPLOY NGINX TO EKS     ================================================================="



# Navigate to deployment directory
DEPLOY_DIR="/home/sridhara/Downloads/aws-nitro-enclaves-with-k8s/container/coconginxv3"
echo "Changing directory to $DEPLOY_DIR..."
cd "$DEPLOY_DIR" || { echo "Directory not found: $DEPLOY_DIR"; exit 1; }

# Convert YAML files to Unix format
echo "Converting YAML files to Unix format..."
dos2unix *.yaml

# Apply the deployment
echo "Applying vsock-nginx-deployment.yaml..."
kubectl apply -f vsock-nginx-deployment.yaml

# List pods to verify deployment
echo "Listing pods..."
kubectl get pods

echo "Deployment complete!"
