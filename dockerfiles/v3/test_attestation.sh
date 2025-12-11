#!/bin/bash
echo "=== Testing KMS Attestation ==="

# Debug: Show environment variables
echo "AWS_ROLE_ARN: $AWS_ROLE_ARN"
echo "AWS_WEB_IDENTITY_TOKEN_FILE: $AWS_WEB_IDENTITY_TOKEN_FILE"
echo "AWS_REGION: $AWS_REGION"

cd /tmp
echo "Secret-$(date +%s)" > secret.txt

python3 - << 'PYEOF'
import boto3
import os

# Print environment for debugging
print(f"AWS_ROLE_ARN: {os.environ.get('AWS_ROLE_ARN')}")
print(f"AWS_WEB_IDENTITY_TOKEN_FILE: {os.environ.get('AWS_WEB_IDENTITY_TOKEN_FILE')}")
print(f"AWS_REGION: {os.environ.get('AWS_REGION')}")

try:
    # Let boto3 automatically use the environment variables
    kms = boto3.client("kms", region_name='eu-west-1')  # Use eu-west-1 not us-east-1!
    
    with open("secret.txt", "rb") as f:
        ciphertext = kms.encrypt(
            KeyId="4bae92be-4b6c-4380-abb3-504dcb330b5a", 
            Plaintext=f.read()
        )["CiphertextBlob"]
    
    # Test decrypt
    decrypted = kms.decrypt(CiphertextBlob=ciphertext)
    print("✔ ATTESTATION SUCCESS - Enclave verified!")
    
except Exception as e:
    print("✘ ATTESTATION FAILED:", str(e))
    exit(1)
PYEOF

echo "=== Attestation test complete ==="
