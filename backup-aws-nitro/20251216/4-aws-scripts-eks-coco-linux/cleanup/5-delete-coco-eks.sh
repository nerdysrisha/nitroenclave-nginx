#!/bin/bash



echo "========================================================================================================================="
echo "================================CLEANING UP EKS  ========================================================================"


# Configuration variables
AWS_PROFILE="default"
AWS_REGION="eu-west-1"
CLUSTER_NAME="eks-coco"


# Disable pagination
export AWS_PAGER=""


echo "Starting EKS cluster deletion process..."

 

# 1. Delete the EKS cluster
echo "Deleting EKS cluster..."
#CMD="aws eks delete-cluster --profile $AWS_PROFILE --name $CLUSTER_NAME --region $AWS_REGION --output json"
CMD="aws eks delete-cluster --profile $AWS_PROFILE --name $CLUSTER_NAME --region $AWS_REGION --output json --no-cli-pager"

echo "Command: $CMD"
eval $CMD

# 2. Wait for cluster to be deleted
echo "Waiting for cluster to be deleted..."
aws eks wait cluster-deleted --profile $AWS_PROFILE --name $CLUSTER_NAME --region $AWS_REGION
echo "Cluster deleted successfully!"

# 3. Remove cluster from kubeconfig (optional)
echo "Removing cluster from kubeconfig..."
kubectl config delete-context arn:aws:eks:$AWS_REGION:$(aws sts get-caller-identity --profile $AWS_PROFILE --query Account --output text):cluster/$CLUSTER_NAME 2>/dev/null || true
kubectl config delete-cluster arn:aws:eks:$AWS_REGION:$(aws sts get-caller-identity --profile $AWS_PROFILE --query Account --output text):cluster/$CLUSTER_NAME 2>/dev/null || true

echo "EKS cluster deletion completed!"
echo "Note: VPC, subnets, IAM roles, and key pair are preserved for reuse."

