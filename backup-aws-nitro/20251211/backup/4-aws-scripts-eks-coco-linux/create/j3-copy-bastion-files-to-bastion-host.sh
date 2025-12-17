#!/bin/bash

REGION="eu-west-1"
KEY_FILE="coco-eks-key.pem"

printf "\n 1. Getting the current IP of accessing device: "
MY_IP=$(curl -s ifconfig.me 2>/dev/null)
echo "${MY_IP}"
echo " Done."

printf "\n 1.5. Getting bastion host security group and instance ID..."
BASTION_INFO=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=bastion-host" "Name=instance-state-name,Values=running" \
  --query 'Reservations[0].Instances[0].[SecurityGroups[0].GroupId,InstanceId]' \
  --output text \
  --region ${REGION} 2>/dev/null)

SG_ID=$(echo $BASTION_INFO | cut -d' ' -f1)
INSTANCE_ID=$(echo $BASTION_INFO | cut -d' ' -f2)

echo " SG_ID: ${SG_ID}"
echo " INSTANCE_ID: ${INSTANCE_ID}"
echo " Done."

printf "\n 2. Adding current IP to security group for SSH access..."
aws ec2 authorize-security-group-ingress \
  --group-id ${SG_ID} \
  --protocol tcp \
  --port 22 \
  --cidr ${MY_IP}/32 \
  --region ${REGION} > /dev/null 2>&1
echo " Done."

printf "\n 3. Getting bastion host details..."
BASTION_PUBLIC_IP=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=bastion-host" "Name=instance-state-name,Values=running" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text \
  --region ${REGION} 2>/dev/null)

BASTION_PRIVATE_IP=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=bastion-host" "Name=instance-state-name,Values=running" \
  --query 'Reservations[0].Instances[0].PrivateIpAddress' \
  --output text \
  --region ${REGION} 2>/dev/null)
echo " Done."

printf "\n   Bastion Public IP: ${BASTION_PUBLIC_IP}"
printf "\n   Bastion Private IP: ${BASTION_PRIVATE_IP}"
printf "\n   Target directory: /home/ec2-user/"

printf "\n 5. Changing file permissions of pem file."
chmod 400 coco-eks-key.pem

printf "\n 7. Waiting for bastion host to be ready..."
aws ec2 wait instance-running --instance-ids ${INSTANCE_ID} --region ${REGION} && echo "running"

printf "\n 8. Copying files to bastion host..."
cd "/home/sridhara/Downloads/3-aws-scripts-eks-coco-linux/create"

FILE0="file0-bastion-aws-temporary-creds"
FILE1="file1-bastion-configure-aws-on-bastion.sh"
FILE2="file2-bastion-just-ssh-to-workernode.sh"
FILE6="coco-eks-key.pem"

scp -o StrictHostKeyChecking=no -i $KEY_FILE $FILE0 ec2-user@${BASTION_PUBLIC_IP}:/home/ec2-user/  && echo " $FILE0 copied."
scp -o StrictHostKeyChecking=no -i $KEY_FILE $FILE1 ec2-user@${BASTION_PUBLIC_IP}:/home/ec2-user/  && echo " $FILE1 copied."
scp -o StrictHostKeyChecking=no -i $KEY_FILE $FILE2 ec2-user@${BASTION_PUBLIC_IP}:/home/ec2-user/  && echo " $FILE2 copied."
scp -o StrictHostKeyChecking=no -i $KEY_FILE $FILE6 ec2-user@${BASTION_PUBLIC_IP}:/home/ec2-user/  && echo " $FILE6 copied."

echo " All files copied successfully!"
