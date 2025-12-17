#!/bin/bash
# Install Nitro Enclaves Device Plugin on AWS Kubernetes


echo "========================================================================================================================="
echo "================================INSTALLING NITRO PLUGIN ON AWS K8    ===================================================="



echo "Installing Nitro Enclaves Device Plugin..."
kubectl apply -f https://raw.githubusercontent.com/aws/aws-nitro-enclaves-k8s-device-plugin/main/aws-nitro-enclaves-k8s-ds.yaml

echo "Listing namespaces..."
kubectl get ns

# Label the node by fetching name dynamically
NODE_NAME=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')
echo "Labelling node: $NODE_NAME"
kubectl label node $NODE_NAME aws-nitro-enclaves-k8s-dp=enabled

# Validate once labelled
echo "Validating node labels..."
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{" "}{.metadata.labels.aws-nitro-enclaves-k8s-dp}{"\n"}{end}'

# Create namespace and switch
echo "Creating 'integrations' namespace..."
kubectl create namespace integrations

echo "Switching context to 'integrations' namespace..."
kubectl config set-context --current --namespace=integrations

echo "Setup complete!"
