#!/bin/bash

# Variables
INSTANCE_NAME="bastion-host"
REGION="eu-west-1"
PROFILE="default"

printf "Stopping bastion instance: "
INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=${INSTANCE_NAME}" "Name=instance-state-name,Values=running" \
  --query 'Reservations[0].Instances[0].InstanceId' \
  --output text \
  --region ${REGION} \
  --profile ${PROFILE} 2>/dev/null)

if [[ -n "$INSTANCE_ID" && "$INSTANCE_ID" != "None" ]]; then
  aws ec2 stop-instances \
    --instance-ids ${INSTANCE_ID} \
    --region ${REGION} \
    --profile ${PROFILE} > /dev/null 2>&1 && echo " Done ($INSTANCE_ID)" || echo " Failed"
else
  echo " No running instance found"
fi
