#!/bin/bash

echo "Confidential Containers."
echo "==================================================="




CLUSTER_NAME="eks-coco"
NODEGROUP_NAME="eks-coco-nodegroup"
REGION="eu-west-1"
NODE_ROLE_NAME="eks-coco-nodegroup-role"
LAUNCH_TEMPLATE_NAME="eks-coco-nitro-template"
VPC_NAME="coco-eks-vpc"




printf "\n 1. Getting VPC ID, Subnet IDs and Node role ARN"
VPC_ID=$(aws ec2 describe-vpcs \
  --filters "Name=tag:Name,Values=${VPC_NAME}" \
  --query 'Vpcs[0].VpcId' --output text --region ${REGION})
SUBNET_IDS=$(aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=${VPC_ID}" "Name=tag:Name,Values=coco-eks-private-subnet-1,coco-eks-private-subnet-2" \
  --query 'Subnets[].SubnetId' --output text --region ${REGION} | tr '\t' ',')
NODE_ROLE_ARN=$(aws iam get-role --role-name ${NODE_ROLE_NAME} --query 'Role.Arn' --output text)
echo " Done. ID:$VPC_ID , $SUBNET_IDS , $NODE_ROLE_ARN"





printf "\n 2. Creating Nodegroup $NODEGROUP_NAME..."
aws eks create-nodegroup \
  --cluster-name ${CLUSTER_NAME} \
  --nodegroup-name ${NODEGROUP_NAME} \
  --node-role ${NODE_ROLE_ARN} \
  --subnets $(echo ${SUBNET_IDS} | tr ',' ' ') \
  --scaling-config minSize=1,maxSize=1,desiredSize=1 \
  --launch-template name=${LAUNCH_TEMPLATE_NAME},version=1 \
  --tags "Name=eks-coco-nitro-node,Env=dev,Project=coco,Owner=sri" \
  --region ${REGION}  > /dev/null 2>&1
echo " Done."


echo "Waiting for nodegroup to become active..."
aws eks wait nodegroup-active --cluster-name ${CLUSTER_NAME} --nodegroup-name ${NODEGROUP_NAME} --region ${REGION}

echo "✅ Nodegroup is active and ready."
