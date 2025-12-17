#!/bin/bash


 
echo "========================================================================================================================="
echo "================================CREATING BASTION HOST  =================================================================="


# Configuration
CLUSTER_NAME="eks-coco"
REGION="eu-west-1"
KEY_NAME="coco-eks-key"
AMI_ID="ami-07e9032b01a41341a"
VPC_NAME="coco-eks-vpc"
REGION="eu-west-1"

# Disable pagination
export AWS_PAGER=""





printf "\n 1. Getting VPC ID: "
# Get VPC ID

VPC_ID=$(aws ec2 describe-vpcs \
  --filters "Name=tag:Name,Values=${VPC_NAME}" \
  --query 'Vpcs[0].VpcId' \
  --output text \
  --region ${REGION})
echo " Done. ID: $VPC_ID"
 
 

printf "\n 2. Getting First Public Subnet: "

# Get first public subnet ID
PUBLIC_SUBNET=$(aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=${VPC_ID}" "Name=map-public-ip-on-launch,Values=true" \
  --query 'Subnets[0].SubnetId' \
  --output text \
  --region ${REGION})
echo " Done. ID: $PUBLIC_SUBNET"
 

printf "\n 3. Getting default security group: "
# Get default security group ID for the VPC
SG_ID=$(aws ec2 describe-security-groups \
  --filters "Name=vpc-id,Values=${VPC_ID}" "Name=group-name,Values=default" \
  --query 'SecurityGroups[0].GroupId' \
  --output text \
  --region ${REGION})
echo " Done. ID: $SG_ID"
 
  
  
  
  
  

printf "\n 4. Creating a bastion host: "
 
printf "\n Creating bastion host..."
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id ${AMI_ID} \
  --instance-type t3.micro \
  --key-name ${KEY_NAME} \
  --security-group-ids ${SG_ID} \
  --subnet-id ${PUBLIC_SUBNET} \
  --associate-public-ip-address \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=bastion-host}]' \
  --region ${REGION} \
  --query 'Instances[0].InstanceId' \
  --output text 2>/dev/null)
echo " Done. ID:${INSTANCE_ID}"



echo "Waiting for instance to be running..."

# Wait for instance to be running
aws ec2 wait instance-running --instance-ids ${INSTANCE_ID} --region ${REGION}




printf "\n 5. Fetching public ip of machine: "
MY_IP=$(curl -s https://checkip.amazonaws.com)
echo " Done. PIP: ${MY_IP}"


# Add SSH rule to security group


printf "\n 6. Adding SSH access rule to security group: "
aws ec2 authorize-security-group-ingress \
  --group-id ${SG_ID} \
  --protocol tcp \
  --port 22 \
  --cidr ${MY_IP}/32 \
  --region ${REGION}

echo " Done"



printf "\n 7. Obtain Bastion Public IP: "
# Get bastion public IP
BASTION_IP=$(aws ec2 describe-instances \
  --instance-ids ${INSTANCE_ID} \
  --region ${REGION} \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)
echo " Done. ID: $BASTION_IP"

echo "Bastion host is ready!"
echo "Instance ID: ${INSTANCE_ID}"
echo "Public IP: ${BASTION_IP}"
echo "You can now SSH with: ssh -i ${KEY_NAME}.pem ec2-user@${BASTION_IP}"




echo "Instance ${INSTANCE_ID} is now running!"
