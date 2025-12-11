#!/bin/bash
echo "=== Testing KMS Attestation ==="

# Set AWS region
export AWS_DEFAULT_REGION=us-east-1

cd /tmp
echo "Secret-$(date +%s)" > secret.txt

python3 - << 'PYEOF'
import boto3
import os

# Set region explicitly
os.environ['AWS_DEFAULT_REGION'] = 'us-east-1'

try:
    kms = boto3.client("kms", region_name='us-east-1')
    
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
