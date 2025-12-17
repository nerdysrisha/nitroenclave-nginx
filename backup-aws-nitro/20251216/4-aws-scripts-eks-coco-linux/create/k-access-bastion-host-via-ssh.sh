#!/bin/bash

# Configuration
REGION="eu-west-1"
KEY_NAME="coco-eks-key.pem"
BASTION_NAME="bastion-host"
REGION="eu-west-1"
#KEY_PATH="~/.ssh/your-key.pem"



# Disable pagination
export AWS_PAGER=""

#this part of dynmic ip may not be needed or j3 and k can be combined together 
#to copy the pem file and also access the shell 

#PENDING PENDING PENDING PENDING 

# === DYNAMIC IP WHITELISTING (ALWAYS ADD) ===   

printf "\n 1. Getting the current IP of accessing device: "
 
MY_IP=$(curl -s ifconfig.me 2>/dev/null)
if [[ -n "$MY_IP" ]]; then
  echo "$MY_IP"
else
  echo "Failed to get IP"
  exit 1
fi

printf "\n 2. Finding Bastion Security Group: "
BASTION_SG=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=${BASTION_NAME}" "Name=instance-state-name,Values=running" \
  --query 'Reservations[0].Instances[0].SecurityGroups[0].GroupId' \
  --output text \
  --region ${REGION} 2>/dev/null)

if [[ -n "$BASTION_SG" && "$BASTION_SG" != "None" ]]; then
  echo "$BASTION_SG"
else
  echo "Failed to find security group"
  exit 1
fi

printf "\n 3. Adding SSH access for your IP: "
aws ec2 authorize-security-group-ingress \
  --group-id $BASTION_SG \
  --protocol tcp \
  --port 22 \
  --cidr ${MY_IP}/32 \
  --region ${REGION} 2>/dev/null && echo "Added" || echo "Already exists (OK)"


printf "\n 4. Finding Bastion Host: "
 
# Get bastion host instance ID
INSTANCE_ID=$(aws ec2 describe-instances \
  --region ${REGION} \
  --filters "Name=tag:Name,Values=bastion-host" "Name=instance-state-name,Values=running" \
  --query 'Reservations[0].Instances[0].InstanceId' \
  --output text)
echo " Done. ID:${INSTANCE_ID}"

if [ "$INSTANCE_ID" = "None" ] || [ -z "$INSTANCE_ID" ]; then
    echo "No running bastion host found!"
    exit 1
fi





printf "\n 5. Getting Public IP of bation host: "
 
# Get public IP
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids ${INSTANCE_ID} \
  --region ${REGION} \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)
echo "Done. Public IP:${PUBLIC_IP}"
echo "Instance ID: ${INSTANCE_ID}"
echo "Public IP: ${PUBLIC_IP}"
echo "Connecting to bastion host..."

# SSH into bastion
ssh -i ${KEY_NAME} ec2-user@${PUBLIC_IP}
