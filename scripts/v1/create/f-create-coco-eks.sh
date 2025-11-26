#!/bin/bash


echo "Confidential Containers."
echo "==================================================="



VPC_NAME="coco-eks-vpc"
CLUSTER_NAME="eks-coco"
REGION="eu-west-1"
ROLE_ARN="arn:aws:iam::908774804544:role/eks-coco-cluster-role"
K8S_VERSION="1.29"  # Use a valid version. I am using 29 due to appropriate compatability issues with Nitro Enclaves 




 

printf "\n 1. Getting VPC ID & Subnet IDs: "

VPC_ID=$(aws ec2 describe-vpcs \
  --filters "Name=tag:Name,Values=${VPC_NAME}" \
  --query 'Vpcs[0].VpcId' --output text --region ${REGION})
 
SUBNET_IDS=$(aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=${VPC_ID}" "Name=tag:Name,Values=coco-eks-private-subnet-1,coco-eks-private-subnet-2" \
  --query 'Subnets[].SubnetId' --output text --region ${REGION} | tr '\t' ',')
 
echo " Done. ID:$VPC_ID and $SUBNET_IDS"






printf "\n 2. Creating EKS Cluster and waiting for activation..."
aws eks create-cluster \
  --name ${CLUSTER_NAME} \
  --role-arn ${ROLE_ARN} \
  --resources-vpc-config "subnetIds=${SUBNET_IDS}" \
  --kubernetes-version ${K8S_VERSION} \
  --tags "Env=dev,Project=coco,Owner=sri" \
  --region ${REGION} \
  --no-cli-pager > /dev/null

echo "Waiting for cluster '${CLUSTER_NAME}' to become active..."


aws eks wait cluster-active --name ${CLUSTER_NAME} --region ${REGION}
echo " Done."





printf "\n 3. Installing Add-on components 'vpc-cni, kube-proxy, coredns'..."
aws eks create-addon --cluster-name ${CLUSTER_NAME} --addon-name vpc-cni --region ${REGION} > /dev/null 2>&1
aws eks create-addon --cluster-name ${CLUSTER_NAME} --addon-name kube-proxy --region ${REGION} > /dev/null 2>&1
aws eks create-addon --cluster-name ${CLUSTER_NAME} --addon-name coredns --region ${REGION} > /dev/null 2>&1
echo " Done."



printf "\n 4. Updating the kubeconfig..."
aws eks update-kubeconfig --name ${CLUSTER_NAME} --region ${REGION} > /dev/null 2>&1
echo " Done."


echo "✅ EKS cluster created and ready."
