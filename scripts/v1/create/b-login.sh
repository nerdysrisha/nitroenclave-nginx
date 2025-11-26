#!/bin/bash
echo "Confidential Containers...Logging into your profile"
echo "==================================================="

CREDS_FILE="file0-bastion-aws-temporary-creds"

aws sso login --profile default

echo ""
echo "Extracting temporary credentials..."

# SSO already provides session credentials, so we get them directly
echo "Getting current caller identity..."
aws sts get-caller-identity

echo "Getting credentials from SSO cache..."
# Use AWS CLI to get credentials in environment format
AWS_CREDS=$(aws configure export-credentials --profile default --format env)
echo "Credentials extracted successfully"

echo "Getting region..."
REGION=$(aws configure get region --profile default)
echo "Region: $REGION"

# Store in file using the exported credentials
echo "Writing to file..."
echo "$AWS_CREDS" > ${CREDS_FILE}
echo "AWS_DEFAULT_REGION=$REGION" >>   ${CREDS_FILE}

echo "Credentials saved to  ${CREDS_FILE}"
echo "File contents:"
cat  ${CREDS_FILE}
echo "Done."
