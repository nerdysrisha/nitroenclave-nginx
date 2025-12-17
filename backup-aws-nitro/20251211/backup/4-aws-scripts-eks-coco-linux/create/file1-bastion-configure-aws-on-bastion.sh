#!/bin/bash
echo "Configuring AWS CLI on bastion using temporary credentials..."
echo "============================================================="

FILE1="file0-bastion-aws-temporary-creds"

# Check if credentials file exists
if [ ! -f ${FILE1} ]; then
    echo "Error: ${FILE1} file not found!"
    exit 1
fi

echo "Found credentials file, loading..."

# Source the credentials
source ${FILE1}

# Validate credentials were loaded
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ] || [ -z "$AWS_SESSION_TOKEN" ]; then
    echo "Error: Missing required credentials in file!"
    echo "AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID:+SET}"
    echo "AWS_SECRET_ACCESS_KEY: ${AWS_SECRET_ACCESS_KEY:+SET}"
    echo "AWS_SESSION_TOKEN: ${AWS_SESSION_TOKEN:+SET}"
    exit 1
fi

echo "Credentials loaded successfully"

# Configure AWS CLI
echo "Configuring AWS CLI..."
aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
aws configure set aws_session_token "$AWS_SESSION_TOKEN"
aws configure set region "$AWS_DEFAULT_REGION"

echo "AWS CLI configured successfully!"
echo "Testing connection..."
aws sts get-caller-identity

if [ $? -eq 0 ]; then
    echo "✅ AWS configuration successful!"
else
    echo "❌ AWS configuration failed!"
    exit 1
fi

echo "Done."
