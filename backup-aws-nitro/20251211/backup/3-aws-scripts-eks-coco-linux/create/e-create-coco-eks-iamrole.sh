#!/bin/bash


echo "Confidential Containers."
echo "==================================================="


# Disable AWS CLI pager for this script only
export AWS_PAGER=""
export AWS_CLI_PAGER=""

#Variables
AWS_PROFILE="default"
REGION="eu-west-1"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text --profile $AWS_PROFILE)
TAGS="Key=Env,Value=dev Key=Project,Value=coco Key=Owner,Value=sri"



 

printf "\n 1. Creating Cluster Trust Policy (json) in current directory, for Cluster Role: "
cat > eks-cluster-trust-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
echo " Done."

printf "\n 2. Creating Cluster Cluster Role(eks-coco-cluster-role) using json file: "
aws iam create-role \
  --profile $AWS_PROFILE \
  --role-name eks-coco-cluster-role \
  --assume-role-policy-document file://eks-cluster-trust-policy.json \
  --description "EKS Cluster Role for Confidential Containers" \
  --tags $TAGS  
  
   

printf "\n 3. Attaching Policy (AmazonEKSClusterPolicy) to role (eks-coco-cluster-role): "
#NOTE: CHECK THE PURPOSE AND IMPACT OF THE SAME. 
aws iam attach-role-policy --profile $AWS_PROFILE --role-name eks-coco-cluster-role \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy > /dev/null 2>&1 && echo " Done." || echo " Failed."


printf "\n 4. Creating Nodegroup Trust Policy (json) in current directory, for Cluster Role: "
cat > eks-nodegroup-trust-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
echo " Done."



printf "\n 5. Creating Nodegroup Role (eks-coco-nodegroup-role) using the json file. : "
aws iam create-role \
  --profile $AWS_PROFILE \
  --role-name eks-coco-nodegroup-role \
  --assume-role-policy-document file://eks-nodegroup-trust-policy.json \
  --description "EKS Nodegroup Role for Confidential Containers" \
  --tags $TAGS  
 


printf "\n 6. Attaching Policy (AmazonEKSWorkerNodePolicy) to Role (eks-coco-nodegroup-role). : "
aws iam attach-role-policy --profile $AWS_PROFILE --role-name eks-coco-nodegroup-role \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy > /dev/null 2>&1 && echo " Done." || echo " Failed."


printf "\n 7. Attaching Policy (AmazonEKS_CNI_Policy) to Role (eks-coco-nodegroup-role). : "

aws iam attach-role-policy --profile $AWS_PROFILE --role-name eks-coco-nodegroup-role \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy > /dev/null 2>&1 && echo " Done." || echo " Failed."



printf "\n 8. Attaching Policy (AmazonEC2ContainerRegistryReadOnly) to Role (eks-coco-nodegroup-role).: "

aws iam attach-role-policy --profile $AWS_PROFILE --role-name eks-coco-nodegroup-role \
  --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly > /dev/null 2>&1 && echo " Done." || echo " Failed."








printf "\n 9. Creating Nitro Enclave Policy (json file) in current directory: "
cat > nitro-enclaves-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:ModifyInstanceAttribute",
        "ec2:DescribeInstances",
        "ec2:StartInstances",
        "ec2:StopInstances",
        "ec2:TerminateInstances"
      ],
      "Resource": "*"
    }
  ]
}
EOF

echo " Done."




printf "\n 10. Creating and Attaching Policies using json file: "

aws iam create-policy \
  --profile $AWS_PROFILE \
  --policy-name CustomNitroEnclavesAccess \
  --policy-document file://nitro-enclaves-policy.json  



printf "\n 11. Attaching Policy (CustomNitroEnclavesAccess) to Role (eks-coco-nodegroup-role): "

aws iam attach-role-policy \
  --profile $AWS_PROFILE \
  --role-name eks-coco-nodegroup-role \
  --policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/CustomNitroEnclavesAccess > /dev/null 2>&1 && echo " Done." || echo " Failed."
 




printf "\n 12. Creating NodeInstance Trust Policy (json) in current directory, for NodeInstance Role: "
cat > NodeInstanceTrustPolicy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
printf " Done.\n"

 

printf "\n 13. Creating NodeInstance Role using the json file (NodeInstanceTrustPolicy.json): "
aws iam create-role \
  --profile $AWS_PROFILE \
  --role-name NodeInstanceRole \
  --assume-role-policy-document file://NodeInstanceTrustPolicy.json  





printf "\n 14. Attaching Policy (AmazonEKSWorkerNodePolicy) to Role (NodeInstanceRole): "
aws iam attach-role-policy \
  --profile $AWS_PROFILE \
  --role-name NodeInstanceRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy > /dev/null 2>&1 && echo " Done." || echo " Failed."

printf "\n 15. Attaching Policy (AmazonEKS_CNI_Policy) to Role (NodeInstanceRole): "
aws iam attach-role-policy \
  --profile $AWS_PROFILE \
  --role-name NodeInstanceRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy > /dev/null 2>&1 && echo " Done." || echo " Failed."

printf "\n 16. Attaching Policy (AmazonEC2ContainerRegistryReadOnly) to Role (NodeInstanceRole): "
aws iam attach-role-policy \
  --profile $AWS_PROFILE \
  --role-name NodeInstanceRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly > /dev/null 2>&1 && echo " Done." || echo " Failed."


printf "\n 17. Attaching Policy (AmazonSSMManagedInstanceCore) to Role (NodeInstanceRole): "
aws iam attach-role-policy \
  --profile $AWS_PROFILE \
  --role-name NodeInstanceRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore > /dev/null 2>&1 && echo " Done." || echo " Failed."
 

printf "\n 18. Creating Instance Profile (NodeInstanceProfile): "
aws iam create-instance-profile \
  --profile $AWS_PROFILE \
  --instance-profile-name NodeInstanceProfile  


printf "\n 19. Adding Role (NodeInstanceRole) to Instance Profile (NodeInstanceProfile): "
aws iam add-role-to-instance-profile \
  --profile $AWS_PROFILE \
  --instance-profile-name NodeInstanceProfile \
  --role-name NodeInstanceRole > /dev/null  







printf "\n 20. Removing the JSON Policy files from current directory: "

rm -f eks-cluster-trust-policy.json eks-nodegroup-trust-policy.json nitro-enclaves-policy.json NodeInstanceTrustPolicy.json > /dev/null 2>&1 && echo " Done." || echo " Failed."
 


printf "\n All IAM roles and policies created successfully!"
 
