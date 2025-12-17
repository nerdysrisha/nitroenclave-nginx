#!/bin/bash



echo "========================================================================================================================="
echo "================================CLEANING UP BASTION ====================================================================="



# Configuration
REGION="eu-west-1"

# Disable pagination
export AWS_PAGER=""

echo "Finding bastion host to delete..."

# Get bastion host instance ID
INSTANCE_ID=$(aws ec2 describe-instances \
  --region ${REGION} \
  --filters "Name=tag:Name,Values=bastion-host" "Name=instance-state-name,Values=running,pending,stopping,stopped" \
  --query 'Reservations[0].Instances[0].InstanceId' \
  --output text)

if [ "$INSTANCE_ID" = "None" ] || [ -z "$INSTANCE_ID" ]; then
    echo "No bastion host found!"
    exit 1
fi

echo "Found bastion host: ${INSTANCE_ID}"
echo "Terminating instance..."

# Terminate the instance
aws ec2 terminate-instances \
  --instance-ids ${INSTANCE_ID} \
  --region ${REGION}

echo "Waiting for instance to be terminated..."

# Wait for instance to be terminated
aws ec2 wait instance-terminated \
  --instance-ids ${INSTANCE_ID} \
  --region ${REGION}

echo "Bastion host ${INSTANCE_ID} has been terminated successfully!"
