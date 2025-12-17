#!/bin/bash



echo "========================================================================================================================="
echo "================================FORCE STOPPING NODE ====================================================================="


# Variables
CLUSTER_NAME="eks-coco"
NODEGROUP_NAME="eks-coco-nodegroup"
REGION="eu-west-1"
PROFILE="default"

echo "Getting ASG name..."
ASG_NAME=$(aws eks describe-nodegroup \
  --cluster-name $CLUSTER_NAME \
  --nodegroup-name $NODEGROUP_NAME \
  --region $REGION \
  --profile $PROFILE \
  --query 'nodegroup.resources.autoScalingGroups[0].name' \
  --output text)

if [ -z "$ASG_NAME" ] || [ "$ASG_NAME" = "None" ]; then
    echo "Error: Could not get ASG name"
    exit 1
fi

echo "ASG Name: $ASG_NAME"

echo "Getting worker node instance IDs..."
INSTANCE_IDS=$(aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names $ASG_NAME \
  --region $REGION \
  --profile $PROFILE \
  --query 'AutoScalingGroups[0].Instances[*].InstanceId' \
  --output text)

if [ -z "$INSTANCE_IDS" ]; then
    echo "No instances found in ASG"
    exit 1
fi

echo "Instance IDs: $INSTANCE_IDS"

echo "Suspending Auto Scaling processes..."
aws autoscaling suspend-processes \
  --auto-scaling-group-name $ASG_NAME \
  --scaling-processes Launch ReplaceUnhealthy \
  --region $REGION \
  --profile $PROFILE

if [ $? -eq 0 ]; then
    echo "Auto Scaling processes suspended successfully"
else
    echo "Failed to suspend Auto Scaling processes"
    exit 1
fi

echo "Terminating instances..."
aws ec2 terminate-instances \
  --instance-ids $INSTANCE_IDS \
  --region $REGION \
  --profile $PROFILE > /dev/null 2>&1 && echo "Instances terminated: Done" || echo "Instance termination: Failed"

 
echo "Script completed!"
