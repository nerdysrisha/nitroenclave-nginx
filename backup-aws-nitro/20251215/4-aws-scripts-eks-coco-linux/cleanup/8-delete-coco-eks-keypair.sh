#!/bin/bash


echo "========================================================================================================================="
echo "================================CLEANING UP KEYPAIR  ===================================================================="

# EKS Keypair Deletion Script
echo "=== Deleting EKS Keypair. Your local .pem (private key) becomes useless ==="

# Set keypair name as variable
KEYPAIR_NAME="coco-eks-key"

# Delete keypair from AWS
echo "Deleting keypair from AWS..."
DELETE_COMMAND="aws ec2 delete-key-pair --key-name $KEYPAIR_NAME"
echo "Executing: $DELETE_COMMAND"
eval $DELETE_COMMAND

# Verify deletion
echo "Verifying keypair deletion..."
VERIFY_COMMAND="aws ec2 describe-key-pairs --key-names $KEYPAIR_NAME 2>/dev/null || echo 'Keypair not found'"
echo "Executing: $VERIFY_COMMAND"
RESULT=$(eval $VERIFY_COMMAND)

echo "Removing the private key stored..."
rm -f C:/ws/cocopoc/3-aws-scripts-eks-coco/create/coco-eks-key.pem
rm -f /home/sridhara/Downloads/3-aws-scripts-eks-coco/create/coco-eks-key.pem



echo "Removing images and containers..."
docker ps -a --format '{{.ID}} {{.Image}}' | grep -v 'kindest/node' | awk '{print $1}' | xargs -r docker rm -f
docker images --format '{{.Repository}}:{{.Tag}} {{.ID}}' | grep -v '^kindest/node' | awk '{print $2}' | xargs -r docker rmi -f


echo "=== Keypair Deletion Complete ==="
echo "Keypair Name: $KEYPAIR_NAME"
echo "Status: $RESULT"
