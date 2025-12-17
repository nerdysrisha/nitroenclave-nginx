#!/bin/bash



echo "========================================================================================================================="
echo "================================CLEANING UP NODEGROUP===================================================================="



CLUSTER_NAME="eks-coco"
NODEGROUP_NAME="eks-coco-nodegroup"
REGION="eu-west-1"
ROLE_NAME="eks-coco-node-role"


#NODE_ROLE_NAME="eks-coco-node-role"   
#LAUNCH_TEMPLATE_NAME="eks-coco-nitro-template"


# Disable pagination
export AWS_PAGER=""


echo "Deleting nodegroup..."
aws eks delete-nodegroup \
  --cluster-name ${CLUSTER_NAME} \
  --nodegroup-name ${NODEGROUP_NAME} \
  --region ${REGION} 2>/dev/null || echo "Nodegroup already deleted or doesn't exist"

echo "Waiting for nodegroup deletion..."
aws eks wait nodegroup-deleted \
  --cluster-name ${CLUSTER_NAME} \
  --nodegroup-name ${NODEGROUP_NAME} \
  --region ${REGION} 2>/dev/null || echo "Nodegroup deletion wait completed or nodegroup doesn't exist"

 


#BElow moved to IAM Roles / policies deletion 

#echo "Detaching IAM policies from ${ROLE_NAME}..."
#aws iam detach-role-policy \
#  --role-name ${ROLE_NAME} \
#  --policy-arn arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy 2>/dev/null || echo "Policy already detached"

#aws iam detach-role-policy \
#  --role-name ${ROLE_NAME} \
#  --policy-arn arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy 2>/dev/null || echo "Policy already detached"

#aws iam detach-role-policy \
#  --role-name ${ROLE_NAME} \
#  --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly 2>/dev/null || echo "Policy already detached"

#echo "Deleting IAM role ${ROLE_NAME}..."
#aws iam delete-role --role-name ${ROLE_NAME} 2>/dev/null || echo "Role already deleted or doesn't exist"#

#echo "Cleaning up NodeInstanceRole and NodeInstanceProfile..."
#aws iam remove-role-from-instance-profile --instance-profile-name NodeInstanceProfile --role-name NodeInstanceRole 2>/dev/null || echo "Role already removed from instance profile"
#aws iam delete-instance-profile --instance-profile-name NodeInstanceProfile 2>/dev/null || echo "Instance profile already deleted"

#aws iam detach-role-policy --role-name NodeInstanceRole --policy-arn arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy 2>/dev/null || echo "Policy already detached"
#aws iam detach-role-policy --role-name NodeInstanceRole --policy-arn arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy 2>/dev/null || echo "Policy already detached"
#aws iam detach-role-policy --role-name NodeInstanceRole --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly 2>/dev/null || echo "Policy already detached"
#aws iam delete-role --role-name NodeInstanceRole 2>/dev/null || echo "NodeInstanceRole already deleted"
#
#echo "Nodegroup cleanup completed!"
