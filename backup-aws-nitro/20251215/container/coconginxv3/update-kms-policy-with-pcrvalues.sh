#!/bin/bash
set -e

echo "========================================================================================================================="
echo "================================UPDATE KMS POLICY WITH PCR VALUES. PULLING INFO FROM LOG FILE============================"



: "${LOG_FILE:?LOG_FILE not set}"

PCR0=$(grep -A 10 "Measurements" "$LOG_FILE" | grep '"PCR0"' | cut -d'"' -f4)
PCR1=$(grep -A 10 "Measurements" "$LOG_FILE" | grep '"PCR1"' | cut -d'"' -f4)
PCR2=$(grep -A 10 "Measurements" "$LOG_FILE" | grep '"PCR2"' | cut -d'"' -f4)

KEY_ID=$(aws kms list-keys --query 'Keys[0].KeyId' --output text)
KEY_ARN=$(aws kms list-keys --query 'Keys[0].KeyArn' --output text)
ACCOUNT_ID=$(echo "$KEY_ARN" | cut -d':' -f5)

echo "KEY_ID=$KEY_ID | KEY_ARN=$KEY_ARN | ACCOUNT_ID=$ACCOUNT_ID"

cat > enclave-kms-policy.json << EOF
{
  "Version": "2012-10-17",
  "Id": "key-configured-for-enclave",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${ACCOUNT_ID}:root"
      },
      "Action": [
        "kms:Decrypt",
        "kms:PutKeyPolicy",
        "kms:GetKeyPolicy"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Enable enclave decrypt",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${ACCOUNT_ID}:root"
      },
      "Action": "kms:Decrypt",
      "Resource": "*",
      "Condition": {
        "StringEqualsIgnoreCase": {
          "kms:RecipientAttestation:PCR0": "$PCR0",
          "kms:RecipientAttestation:PCR1": "$PCR1",
          "kms:RecipientAttestation:PCR2": "$PCR2"
        }
      }
    }
  ]
}
EOF

aws kms put-key-policy \
  --key-id "$KEY_ID" \
  --policy-name default \
  --policy file://enclave-kms-policy.json

echo "KMS policy updated"

#Verify 
aws kms get-key-policy --key-id $KEY_ID --policy-name default --output json | jq .
