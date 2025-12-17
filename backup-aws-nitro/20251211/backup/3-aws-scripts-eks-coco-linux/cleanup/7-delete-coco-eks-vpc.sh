#!/bin/bash

# VPC Deletion Script with Security Group deletion as well 
# Deletes all resources created by the VPC creation script

set -e  # Exit on any error

# Disable pagination
export AWS_PAGER=""


# Configuration variables
AWS_PROFILE="default"
VPC_NAME_TAG="coco-eks-vpc"

echo "Starting VPC creation automation with profile: $AWS_PROFILE..."

# Check credentials
echo "Checking AWS credentials..."
if ! aws sts get-caller-identity --profile $AWS_PROFILE >/dev/null 2>&1; then
	echo "ERROR: AWS credentials are invalid or expired."
	echo "Please run: aws sso login --profile $AWS_PROFILE"
	exit 1
fi
echo "Credentials are valid. Proceeding with VPC creation..."


echo "Starting VPC deletion process with profile: $AWS_PROFILE..."
echo "WARNING: This will delete all resources associated with VPC tagged as '$VPC_NAME_TAG'"
 

# 1. Find VPC ID by Name tag
echo "Finding VPC by Name tag: $VPC_NAME_TAG..."
VPC_ID=$(aws ec2 describe-vpcs \
	--profile $AWS_PROFILE \
	--filters "Name=tag:Name,Values=$VPC_NAME_TAG" \
	--query 'Vpcs[0].VpcId' \
	--output text)

if [ "$VPC_ID" = "None" ] || [ -z "$VPC_ID" ]; then
	echo "VPC with Name tag '$VPC_NAME_TAG' not found. Exiting."
	exit 1
fi

echo "Found VPC ID: $VPC_ID"

# 2. Get all subnets in the VPC
echo "Finding subnets in VPC..."
SUBNET_IDS=$(aws ec2 describe-subnets \
	--profile $AWS_PROFILE \
	--filters "Name=vpc-id,Values=$VPC_ID" \
	--query 'Subnets[].SubnetId' \
	--output text)

# 3. Get all route tables in the VPC (excluding main route table)
echo "Finding custom route tables in VPC..."
ROUTE_TABLE_IDS=$(aws ec2 describe-route-tables \
	--profile $AWS_PROFILE \
	--filters "Name=vpc-id,Values=$VPC_ID" \
	--query 'RouteTables[?Associations[0].Main!=`true`].RouteTableId' \
	--output text)

# 4. Get Internet Gateway attached to VPC
echo "Finding Internet Gateway attached to VPC..."
IGW_ID=$(aws ec2 describe-internet-gateways \
	--profile $AWS_PROFILE \
	--filters "Name=attachment.vpc-id,Values=$VPC_ID" \
	--query 'InternetGateways[0].InternetGatewayId' \
	--output text)

# 5. Delete route table associations (except main route table)
if [ ! -z "$ROUTE_TABLE_IDS" ] && [ "$ROUTE_TABLE_IDS" != "None" ]; then
	for RT_ID in $ROUTE_TABLE_IDS; do
		echo "Processing route table: $RT_ID"
		
		# Get association IDs for this route table (excluding main associations)
		ASSOC_IDS=$(aws ec2 describe-route-tables \
			--profile $AWS_PROFILE \
			--route-table-ids $RT_ID \
			--query 'RouteTables[0].Associations[?Main!=`true`].RouteTableAssociationId' \
			--output text)
		
		if [ ! -z "$ASSOC_IDS" ] && [ "$ASSOC_IDS" != "None" ]; then
			for ASSOC_ID in $ASSOC_IDS; do
				echo "Disassociating route table association: $ASSOC_ID"
				aws ec2 disassociate-route-table \
					--profile $AWS_PROFILE \
					--association-id $ASSOC_ID
			done
		fi
	done
fi

# 6. Delete custom routes in route tables (routes to IGW)
if [ ! -z "$ROUTE_TABLE_IDS" ] && [ "$ROUTE_TABLE_IDS" != "None" ]; then
	for RT_ID in $ROUTE_TABLE_IDS; do
		echo "Deleting custom routes in route table: $RT_ID"
		
		# Delete route to Internet Gateway if exists
		aws ec2 delete-route \
			--profile $AWS_PROFILE \
			--route-table-id $RT_ID \
			--destination-cidr-block 0.0.0.0/0 2>/dev/null || echo "No route to 0.0.0.0/0 found in $RT_ID"
	done
fi

# 7. Delete custom route tables
if [ ! -z "$ROUTE_TABLE_IDS" ] && [ "$ROUTE_TABLE_IDS" != "None" ]; then
	for RT_ID in $ROUTE_TABLE_IDS; do
		echo "Deleting route table: $RT_ID"
		aws ec2 delete-route-table \
			--profile $AWS_PROFILE \
			--route-table-id $RT_ID
	done
fi




#8a. Get all NAT Gateways in the VPC
echo "Finding NAT Gateways in VPC: $VPC_ID..."
NAT_GW_IDS=$(aws ec2 describe-nat-gateways \
  --profile $AWS_PROFILE \
  --filter "Name=vpc-id,Values=$VPC_ID" "Name=state,Values=available,pending,failed,deleting" \
  --query 'NatGateways[*].NatGatewayId' --output text)

if [ ! -z "$NAT_GW_IDS" ]; then
  for NAT_GW_ID in $NAT_GW_IDS; do
    echo "Deleting NAT Gateway: $NAT_GW_ID..."
    aws ec2 delete-nat-gateway --profile $AWS_PROFILE --nat-gateway-id $NAT_GW_ID
  done
  
  echo "Waiting for NAT Gateways to be deleted..."
  for NAT_GW_ID in $NAT_GW_IDS; do
    aws ec2 wait nat-gateway-deleted --profile $AWS_PROFILE --nat-gateway-ids $NAT_GW_ID
  done
fi







#8b. Detach and delete Internet Gateway
if [ ! -z "$IGW_ID" ] && [ "$IGW_ID" != "None" ]; then
	echo "Detaching Internet Gateway: $IGW_ID from VPC: $VPC_ID"
	aws ec2 detach-internet-gateway \
		--profile $AWS_PROFILE \
		--internet-gateway-id $IGW_ID \
		--vpc-id $VPC_ID
	
	echo "Deleting Internet Gateway: $IGW_ID"
	aws ec2 delete-internet-gateway \
		--profile $AWS_PROFILE \
		--internet-gateway-id $IGW_ID
fi



# 9a. Delete Security Groups (except default)
echo "Getting security groups for VPC: $VPC_ID"
SG_IDS=$(aws ec2 describe-security-groups --profile $AWS_PROFILE --filters "Name=vpc-id,Values=$VPC_ID" --query "SecurityGroups[?GroupName!='default'].GroupId" --output text)

if [ ! -z "$SG_IDS" ] && [ "$SG_IDS" != "None" ]; then
	for SG_ID in $SG_IDS; do
		echo "Deleting security group: $SG_ID"
		aws ec2 delete-security-group \
			--profile $AWS_PROFILE \
			--group-id $SG_ID
	done
fi


# 9b. Get and release all Elastic IPs in the VPC
echo "Finding Elastic IPs in VPC..."
EIP_ALLOC_IDS=$(aws ec2 describe-addresses \
  --profile $AWS_PROFILE \
  --query 'Addresses[?Domain==`vpc`].AllocationId' --output text)

if [ ! -z "$EIP_ALLOC_IDS" ]; then
  for EIP_ALLOC_ID in $EIP_ALLOC_IDS; do
    echo "Releasing Elastic IP: $EIP_ALLOC_ID..."
    aws ec2 release-address --profile $AWS_PROFILE --allocation-id $EIP_ALLOC_ID
  done
fi



# 10. Delete subnets
if [ ! -z "$SUBNET_IDS" ] && [ "$SUBNET_IDS" != "None" ]; then
	for SUBNET_ID in $SUBNET_IDS; do
		echo "Deleting subnet: $SUBNET_ID"
		aws ec2 delete-subnet \
			--profile $AWS_PROFILE \
			--subnet-id $SUBNET_ID
	done
fi

# 11. Delete VPC
echo "Deleting VPC: $VPC_ID"
aws ec2 delete-vpc \
	--profile $AWS_PROFILE \
	--vpc-id $VPC_ID

echo ""
echo "VPC deletion completed successfully!"
echo "================================"
echo "Deleted resources:"
echo "- VPC: $VPC_ID"
if [ ! -z "$SUBNET_IDS" ] && [ "$SUBNET_IDS" != "None" ]; then
	echo "- Subnets: $SUBNET_IDS"
fi
if [ ! -z "$IGW_ID" ] && [ "$IGW_ID" != "None" ]; then
	echo "- Internet Gateway: $IGW_ID"
fi
if [ ! -z "$ROUTE_TABLE_IDS" ] && [ "$ROUTE_TABLE_IDS" != "None" ]; then
	echo "- Route Tables: $ROUTE_TABLE_IDS"
fi
echo "================================"