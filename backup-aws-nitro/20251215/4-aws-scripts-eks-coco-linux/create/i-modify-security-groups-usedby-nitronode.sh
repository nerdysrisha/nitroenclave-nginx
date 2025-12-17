#!/bin/bash

 
echo "========================================================================================================================="
echo "================================MODIFY SECURITY GROUP  =================================================================="


#this need to be revisited as do we need all security groups to be enabled with the port in question????

#This is required for apis to be invoked directly from internet.
#Basically we are exposint via node port
PORT=30080
REGION="eu-west-1"

NODE_DNS=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')
SG_IDS=$(aws ec2 describe-instances --filters "Name=private-dns-name,Values=${NODE_DNS}" --query "Reservations[0].Instances[0].SecurityGroups[*].GroupId" --output text --region ${REGION})

for SG_ID in $SG_IDS; do
    echo "Adding port ${PORT} rule to security group ${SG_ID}..."
    aws ec2 authorize-security-group-ingress \
        --group-id ${SG_ID} \
        --protocol tcp \
        --port ${PORT} \
        --cidr 0.0.0.0/0 \
        --region ${REGION} 2>/dev/null || echo "Rule may already exist"
    
    RULE_EXISTS=$(aws ec2 describe-security-groups \
        --group-ids ${SG_ID} \
        --query "SecurityGroups[0].IpPermissions[?FromPort==\`${PORT}\` && ToPort==\`${PORT}\`]" \
        --output text --region ${REGION})
    
    if [ -n "$RULE_EXISTS" ]; then
        echo "✓ Validated: Port ${PORT} rule exists in ${SG_ID}"
    else
        echo "✗ Failed: Port ${PORT} rule not found in ${SG_ID}"
    fi
done


