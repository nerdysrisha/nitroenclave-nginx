#!/bin/bash

echo "Confidential Containers."
echo "==================================================="


# EKS Keypair Creation Script
echo "Creating EKS Keypair in the current directory with name coco-eks-keypair"
echo "========================================================================"


# Create keypair
echo "Creating keypair for worker node access..."
KEYPAIR_COMMAND="aws ec2 create-key-pair --key-name coco-eks-key --tag-specifications 'ResourceType=key-pair,Tags=[{Key=Env,Value=dev},{Key=Project,Value=coco},{Key=Owner,Value=sri}]' --query 'KeyMaterial' --output text"

echo "Executing: $KEYPAIR_COMMAND"
eval $KEYPAIR_COMMAND > coco-eks-key.pem

# Set proper permissions
echo "Setting keypair permissions..."
CHMOD_COMMAND="chmod 400 coco-eks-key.pem"
echo "Executing: $CHMOD_COMMAND"
eval $CHMOD_COMMAND

# Verify keypair was created
echo "Verifying keypair in AWS..."
VERIFY_COMMAND="aws ec2 describe-key-pairs --key-names coco-eks-key --query 'KeyPairs[0].KeyName' --output text"
echo "Executing: $VERIFY_COMMAND"
KEYPAIR_NAME=$(eval $VERIFY_COMMAND)

echo "=== Keypair Creation Complete ==="
echo "Keypair Name: $KEYPAIR_NAME"
echo "Private Key File: coco-eks-key.pem"
echo "File Permissions: $(ls -la coco-eks-key.pem)"
echo ""
echo "Usage: ssh -i coco-eks-key.pem ec2-user@<worker-node-ip>"
echo "=== Ready for EKS setup ==="

#Save as create-keypair.sh, make executable with chmod +x create-keypair.sh, and run with ./create-keypair.sh

#This will create the keypair and save the private key file in your current directory