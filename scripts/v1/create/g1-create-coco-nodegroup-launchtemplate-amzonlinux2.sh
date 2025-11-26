#!/usr/bin/env bash
set -euo pipefail

AWS_PROFILE="default"
AWS_REGION="eu-west-1"
CLUSTER_NAME="eks-coco"
LAUNCH_TEMPLATE_NAME="eks-coco-nitro-template"
AMI_ID="ami-0f608183105f43978"
INSTANCE_TYPE="m5d.2xlarge"
KEY_NAME="coco-eks-key"
INSTANCE_PROFILE_NAME="NodeInstanceProfile"
CPU_COUNT=6
MEMORY_MIB=6144

# Create user data
USER_DATA=$(base64 -w0 <<EOF
#!/bin/bash -xe
/etc/eks/bootstrap.sh ${CLUSTER_NAME}

readonly NE_ALLOCATOR_SPEC_PATH="/etc/nitro_enclaves/allocator.yaml"

amazon-linux-extras install aws-nitro-enclaves-cli -y
yum install -y aws-nitro-enclaves-cli-devel

sed -i "s/cpu_count:.*/cpu_count: ${CPU_COUNT}/g" \$NE_ALLOCATOR_SPEC_PATH
sed -i "s/memory_mib:.*/memory_mib: ${MEMORY_MIB}/g" \$NE_ALLOCATOR_SPEC_PATH

systemctl enable nitro-enclaves-allocator.service
systemctl restart nitro-enclaves-allocator.service

echo 'vm.nr_hugepages=3072' >> /etc/sysctl.conf
sysctl -p

# CRITICAL: Restart kubelet to detect hugepages
systemctl restart kubelet


echo "EKS node with Nitro Enclaves setup completed successfully on \$(hostname)"
EOF
)
echo "Creating template ${LAUNCH_TEMPLATE_NAME}"

aws ec2 create-launch-template \
  --region "${AWS_REGION}" \
  --profile "${AWS_PROFILE}" \
  --launch-template-name "${LAUNCH_TEMPLATE_NAME}" \
  --version-description "EKS node with Nitro Enclaves for Amazon Linux 2" \
  --launch-template-data '{
    "ImageId": "'${AMI_ID}'",
    "InstanceType": "'${INSTANCE_TYPE}'",
    "KeyName": "'${KEY_NAME}'",
    "UserData": "'${USER_DATA}'",
    "EnclaveOptions": {"Enabled": true},
    "MetadataOptions": {
      "HttpEndpoint": "enabled",
      "HttpTokens": "optional",
      "HttpPutResponseHopLimit": 2
    },
    "NetworkInterfaces": [
      {"DeviceIndex": 0, "AssociatePublicIpAddress": true}
    ]
  }'

echo "Template created and listing as below"
aws ec2 describe-launch-templates --region "${AWS_REGION}" --profile "${AWS_PROFILE}" --output table
