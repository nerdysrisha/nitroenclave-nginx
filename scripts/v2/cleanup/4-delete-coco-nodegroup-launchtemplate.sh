#!/bin/bash

# Configuration variables
AWS_PROFILE="default"
AWS_REGION="eu-west-1"
CLUSTER_NAME="eks-coco"
LAUNCH_TEMPLATE_NAME="eks-coco-nitro-template"

# Disable pagination
export AWS_PAGER=""


echo "Deleting launch template: ${LAUNCH_TEMPLATE_NAME} in region: ${AWS_REGION}"

aws ec2 delete-launch-template \
  --launch-template-name ${LAUNCH_TEMPLATE_NAME} \
  --region ${AWS_REGION} \
  --profile ${AWS_PROFILE}

if [ $? -eq 0 ]; then
    echo "Launch template ${LAUNCH_TEMPLATE_NAME} deleted successfully"
else
    echo "Failed to delete launch template ${LAUNCH_TEMPLATE_NAME}"
    exit 1
fi

# Verify deletion

echo "Listing templates after deletion...."
aws ec2 describe-launch-templates \
  --region ${AWS_REGION}  \
  --query 'LaunchTemplates[*].[LaunchTemplateName,LaunchTemplateId,CreateTime]' \
  --output table
  
  
 