#!/bin/bash


echo "========================================================================================================================="
echo "================================CLEANING UP IAM ROLES===================================================================="



export AWS_PAGER=""



AWS_PROFILE="default"

echo "=== DEBUGGING CLEANUP ==="

echo "Step 1: Checking attached policies..."
echo "eks-coco-cluster-role policies:"
aws iam list-attached-role-policies --profile $AWS_PROFILE --role-name eks-coco-cluster-role

echo "eks-coco-nodegroup-role policies:"
aws iam list-attached-role-policies --profile $AWS_PROFILE --role-name eks-coco-nodegroup-role

echo "NodeInstanceRole policies:"
aws iam list-attached-role-policies --profile $AWS_PROFILE --role-name NodeInstanceRole

echo "Step 2: Checking instance profile:"
aws iam get-instance-profile --profile $AWS_PROFILE --instance-profile-name NodeInstanceProfile 2>/dev/null

echo "Step 3: FORCE detach and delete..."
# Force detach ALL policies
aws iam detach-role-policy --profile $AWS_PROFILE --role-name eks-coco-cluster-role --policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy
aws iam detach-role-policy --profile $AWS_PROFILE --role-name eks-coco-nodegroup-role --policy-arn arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy
aws iam detach-role-policy --profile $AWS_PROFILE --role-name eks-coco-nodegroup-role --policy-arn arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy
aws iam detach-role-policy --profile $AWS_PROFILE --role-name eks-coco-nodegroup-role --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly
aws iam detach-role-policy --profile $AWS_PROFILE --role-name eks-coco-nodegroup-role --policy-arn arn:aws:iam::908774804544:policy/CustomNitroEnclavesAccess
aws iam detach-role-policy --profile $AWS_PROFILE --role-name NodeInstanceRole --policy-arn arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy
aws iam detach-role-policy --profile $AWS_PROFILE --role-name NodeInstanceRole --policy-arn arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy
aws iam detach-role-policy --profile $AWS_PROFILE --role-name NodeInstanceRole --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly
aws iam detach-role-policy --profile $AWS_PROFILE --role-name NodeInstanceRole --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore

# Remove from instance profile
aws iam remove-role-from-instance-profile --profile $AWS_PROFILE --instance-profile-name NodeInstanceProfile --role-name NodeInstanceRole

# Delete instance profile
aws iam delete-instance-profile --profile $AWS_PROFILE --instance-profile-name NodeInstanceProfile

# Delete roles
aws iam delete-role --profile $AWS_PROFILE --role-name eks-coco-cluster-role
aws iam delete-role --profile $AWS_PROFILE --role-name eks-coco-nodegroup-role
aws iam delete-role --profile $AWS_PROFILE --role-name NodeInstanceRole

# Delete policy
aws iam delete-policy --profile $AWS_PROFILE --policy-arn arn:aws:iam::908774804544:policy/CustomNitroEnclavesAccess

echo "=== CLEANUP COMPLETE ==="
