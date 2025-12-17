#!/bin/bash

#variables
KEY_FILE="coco-eks-key.pem"

echo "Finding active EKS worker node..."

# Get bastion security group (current instance)
BASTION_SG=$(curl -s http://169.254.169.254/latest/meta-data/instance-id | xargs -I {} aws ec2 describe-instances --instance-ids {} --region eu-west-1 --query 'Reservations[*].Instances[*].SecurityGroups[*].GroupId' --output text)

# Get worker node info (simple approach)
NITRONODE_IP=$(aws ec2 describe-instances \
  --filters "Name=tag:eks:cluster-name,Values=eks-coco" "Name=instance-state-name,Values=running" \
  --region eu-west-1 \
  --query 'Reservations[*].Instances[*].PrivateIpAddress' \
  --output text)

WORKER_SG=$(aws ec2 describe-instances \
  --filters "Name=tag:eks:cluster-name,Values=eks-coco" "Name=instance-state-name,Values=running" \
  --region eu-west-1 \
  --query 'Reservations[*].Instances[*].SecurityGroups[0].GroupId' \
  --output text)

echo "Bastion SG: $BASTION_SG"
echo "Worker SG: $WORKER_SG"
echo "Worker IP: $NITRONODE_IP"

echo "Adding SSH rule..."
aws ec2 authorize-security-group-ingress --group-id $WORKER_SG --protocol tcp --port 22 --source-group $BASTION_SG --region eu-west-1 2>/dev/null || echo "SSH rule already exists (OK)"

echo "Connecting to worker node at $NITRONODE_IP..."
ssh -i $KEY_FILE ec2-user@$NITRONODE_IP
