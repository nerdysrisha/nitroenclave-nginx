#!/bin/bash
echo "=== Testing KMS Attestation ==="

cd /tmp
echo "Secret-$(date +%s)" > secret.txt

python3 - << 'PYEOF'
import boto3
kms = boto3.client("kms")
with open("secret.txt", "rb") as f:
    ciphertext = kms.encrypt(KeyId="4bae92be-4b6c-4380-abb3-504dcb330b5a", Plaintext=f.read())["CiphertextBlob"]
try:
    kms.decrypt(CiphertextBlob=ciphertext)
    print("✔ ATTESTATION SUCCESS - Enclave verified!")
except Exception as e:
    print("✘ ATTESTATION FAILED:", str(e))
PYEOF

echo "=== Attestation test complete ==="
