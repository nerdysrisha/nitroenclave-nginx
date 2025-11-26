#!/bin/bash


echo "Confidential Containers."
echo "==================================================="



echo "Creating VPC, IGW, PUB_SUBNETS, PVT_SUBNETS, ROUTE TABLE, ELASTIC IP, NATGW, "
echo "============================================================================="




# Configuration variables
AWS_PROFILE="default"
VPC_CIDR="10.1.0.0/16"
PUBLIC_SUBNET_CIDR="10.1.0.0/24"
PRIVATE_SUBNET_CIDR_1="10.1.1.0/24"
PRIVATE_SUBNET_CIDR_2="10.1.2.0/24"
AWS_REGION=$(aws configure get region --profile $AWS_PROFILE)
VPC_NAME="coco-eks-vpc"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
REGION="eu-west-1"


# Tag specifications
VPC_TAGS='ResourceType=vpc,Tags=[{Key=Name,Value=coco-eks-vpc},{Key=Env,Value=dev},{Key=Project,Value=coco},{Key=Owner,Value=sri}]'
SUBNET_TAGS_PRIVATE='ResourceType=subnet,Tags=[{Key=Name,Value=coco-eks-private-subnet},{Key=Env,Value=dev},{Key=Project,Value=coco},{Key=Owner,Value=sri}]'
RT_TAGS_PRIVATE='ResourceType=route-table,Tags=[{Key=Name,Value=coco-eks-private-rt},{Key=Env,Value=dev},{Key=Project,Value=coco},{Key=Owner,Value=sri}]'
RT_TAGS_PUBLIC='ResourceType=route-table,Tags=[{Key=Name,Value=coco-eks-public-rt},{Key=Env,Value=dev},{Key=Project,Value=coco},{Key=Owner,Value=sri}]'

 
printf "\n 1. Creating VPC: "
VPC_ID=$(aws ec2 create-vpc \
  --profile $AWS_PROFILE \
  --cidr-block $VPC_CIDR \
  --tag-specifications "$VPC_TAGS" \
  --query 'Vpc.VpcId' --output text)
echo " Done. ID:$VPC_ID"



printf "\n 2. Enabling DNS Support and hostnames for VPC created: "
aws ec2 modify-vpc-attribute --profile $AWS_PROFILE --vpc-id $VPC_ID --enable-dns-support
aws ec2 modify-vpc-attribute --profile $AWS_PROFILE --vpc-id $VPC_ID --enable-dns-hostnames
echo " Done"


printf "\n 3. Creating IGW: "
IGW_ID=$(aws ec2 create-internet-gateway \
  --profile $AWS_PROFILE \
  --tag-specifications "ResourceType=internet-gateway,Tags=[{Key=Name,Value=coco-eks-igw},{Key=Env,Value=dev},{Key=Project,Value=coco},{Key=Owner,Value=sri}]" \
  --query 'InternetGateway.InternetGatewayId' --output text)
echo " Done. ID: $IGW_ID"


printf "\n 4. Attaching IGW to VPC: "
aws ec2 attach-internet-gateway \
  --profile $AWS_PROFILE \
  --internet-gateway-id $IGW_ID \
  --vpc-id $VPC_ID
echo " Done"

 
# 4. Create Subnets
AZ_1="${AWS_REGION}a"
AZ_2="${AWS_REGION}b"
printf "\n 5. Using two Regions for subnets $AZ_1 & $AZ_2 \n "

printf "\n 6. Creating public Subnet for NAT GW: "
PUBLIC_SUBNET_ID=$(aws ec2 create-subnet \
  --profile $AWS_PROFILE \
  --vpc-id $VPC_ID \
  --cidr-block $PUBLIC_SUBNET_CIDR \
  --availability-zone $AZ_1 \
  --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=coco-eks-public-subnet},{Key=Env,Value=dev},{Key=Project,Value=coco},{Key=Owner,Value=sri}]" \
  --query 'Subnet.SubnetId' --output text)
echo " Done. ID: $PUBLIC_SUBNET_ID"



printf "\n 7. Creating private Subnet1 for workernode: "
PRIVATE_SUBNET_ID_1=$(aws ec2 create-subnet \
  --profile $AWS_PROFILE \
  --vpc-id $VPC_ID \
  --cidr-block $PRIVATE_SUBNET_CIDR_1 \
  --availability-zone $AZ_1 \
  --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=coco-eks-private-subnet-1},{Key=Env,Value=dev},{Key=Project,Value=coco},{Key=Owner,Value=sri}]" \
  --query 'Subnet.SubnetId' --output text)
echo " Done. ID: $PRIVATE_SUBNET_ID_1"


printf "\n 8. Creating private Subnet1 for workernode: "
PRIVATE_SUBNET_ID_2=$(aws ec2 create-subnet \
  --profile $AWS_PROFILE \
  --vpc-id $VPC_ID \
  --cidr-block $PRIVATE_SUBNET_CIDR_2 \
  --availability-zone $AZ_2 \
  --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=coco-eks-private-subnet-2},{Key=Env,Value=dev},{Key=Project,Value=coco},{Key=Owner,Value=sri}]" \
  --query 'Subnet.SubnetId' --output text)
 
echo " Done. ID:$PRIVATE_SUBNET_ID_2"




printf "\n 9. Creating Public Route Table: "
PUBLIC_RT_ID=$(aws ec2 create-route-table \
  --profile $AWS_PROFILE \
  --vpc-id $VPC_ID \
  --tag-specifications "$RT_TAGS_PUBLIC" \
  --query 'RouteTable.RouteTableId' --output text)
echo " Done. ID: $PUBLIC_RT_ID"


printf "\n 10. Adding route to IGW in public route table: "
aws ec2 create-route \
  --profile $AWS_PROFILE \
  --route-table-id $PUBLIC_RT_ID \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id $IGW_ID \
  --output text
printf " Done.\n"

printf "\n 11. Associate public subnet with public RT: "
aws ec2 associate-route-table \
  --profile $AWS_PROFILE \
  --route-table-id $PUBLIC_RT_ID \
  --subnet-id $PUBLIC_SUBNET_ID \
  --output text
printf " Done.\n"



printf "\n 12. Allocating Elastic IP for NAT GW: " 
EIP_ALLOC_ID=$(aws ec2 allocate-address \
  --profile $AWS_PROFILE \
  --domain vpc \
  --tag-specifications "ResourceType=elastic-ip,Tags=[{Key=Name,Value=coco-eks-eip},{Key=Env,Value=dev},{Key=Project,Value=coco},{Key=Owner,Value=sri}]" \
  --query 'AllocationId' --output text)
echo " Done. ID: $EIP_ALLOC_ID"



printf "\n 13. Creating NAT GW in Public Subnet: " 
NAT_GW_ID=$(aws ec2 create-nat-gateway \
  --profile $AWS_PROFILE \
  --subnet-id $PUBLIC_SUBNET_ID \
  --allocation-id $EIP_ALLOC_ID \
  --tag-specifications "ResourceType=natgateway,Tags=[{Key=Name,Value=coco-eks-natgw-${TIMESTAMP}},{Key=Env,Value=dev},{Key=Project,Value=coco},{Key=Owner,Value=sri}]" \
  --query 'NatGateway.NatGatewayId' --output text)
echo " Done. ID:$NAT_GW_ID"

 
printf "\n 14. Waiting for NAT GW to become available: " 
# This will pause your script until NAT Gateway is ready
aws ec2 wait nat-gateway-available --nat-gateway-ids $NAT_GW_ID --region eu-west-1
echo " NAT GW Ready"



printf "\n 15. Configuring Internet routing and public IP assignments. Important Step." 

# Note: Configure internet routing and public IP assignment for EKS. super important steps so that worker node can communicate with control plane over internet. 
echo "Configuring internet route and auto-assign public IP for EKS compatibility: "
aws ec2 create-route --route-table-id $(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" "Name=association.main,Values=true" --region $REGION --query "RouteTables[0].RouteTableId" --output text) --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID --region $REGION
echo " Done"


#printf "\n 16. Modifying subnet attribute to auto-assign public IPs: "
#aws ec2 modify-subnet-attribute --subnet-id $PUBLIC_SUBNET_ID --map-public-ip-on-launch --region $REGION
 
 
 
# Fetch subnet IDs from the VPC
#PUBLIC_SUBNET_ID=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" "Name=tag:Name,Values=coco-eks-public-subnet" --region $REGION --query "Subnets[0].SubnetId" --output text)

#PRIVATE_SUBNET_1_ID=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" "Name=tag:Name,Values=coco-eks-private-subnet-1" --region $REGION --query "Subnets[0].SubnetId" --output text)

#PRIVATE_SUBNET_2_ID=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" "Name=tag:Name,Values=coco-eks-private-subnet-2" --region $REGION --query "Subnets[0].SubnetId" --output text)

 
 
 
 
# Enable auto-assign public IP for all subnets
printf "\n 16. Modifying subnet attributes to auto-assign public IPs: "
aws ec2 modify-subnet-attribute --subnet-id $PUBLIC_SUBNET_ID --map-public-ip-on-launch --region $REGION
aws ec2 modify-subnet-attribute --subnet-id $PRIVATE_SUBNET_ID_1 --map-public-ip-on-launch --region $REGION  
aws ec2 modify-subnet-attribute --subnet-id $PRIVATE_SUBNET_ID_2 --map-public-ip-on-launch --region $REGION
echo " Done"


printf "\n 17. Checking private subnets are in different zones..: "
aws ec2 describe-subnets \
  --subnet-ids $PRIVATE_SUBNET_ID_1  $PRIVATE_SUBNET_ID_2 \
  --query 'Subnets[*].[SubnetId,AvailabilityZone]' \
  --output table


echo "EKS networking configuration completed successfully!"
 