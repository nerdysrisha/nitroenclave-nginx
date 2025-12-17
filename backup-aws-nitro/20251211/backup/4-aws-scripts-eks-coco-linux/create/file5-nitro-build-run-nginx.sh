#!/bin/bash
set -euo pipefail

echo "=== Building Nginx Enclave ==="
sudo nitro-cli build-enclave --docker-uri nginx --output-file nginx.eif

echo "=== Checking Allocator Configuration ==="
cat /etc/nitro_enclaves/allocator.yaml

echo "=== Running Nginx Enclave ==="
sudo nitro-cli run-enclave --cpu-count 2 --memory 1024 --eif-path nginx.eif --debug-mode

echo "=== Waiting for enclave to start ==="
sleep 5

echo "=== Describing Enclaves ==="
sudo nitro-cli describe-enclaves

echo "=== Getting Enclave ID dynamically ==="
ENCLAVE_ID=$(sudo nitro-cli describe-enclaves | awk -F'"' '/"EnclaveID":/ {print $4; exit}')

if [ -z "$ENCLAVE_ID" ]; then
    echo "ERROR: No enclave found or failed to get enclave ID"
    exit 1
fi

echo "Found Enclave ID: $ENCLAVE_ID"

echo "=== Connecting to Enclave Console (Press Ctrl+C to exit) ==="
echo "Note: This will show enclave logs. Press Ctrl+C when done viewing."
sudo nitro-cli console --enclave-id "$ENCLAVE_ID" || true

echo "=== Current Directory Contents ==="
ls -l

echo "=== Terminating Enclave ==="
sudo nitro-cli terminate-enclave --enclave-id "$ENCLAVE_ID"

echo "=== Verifying Enclave Termination ==="
sudo nitro-cli describe-enclaves

echo "=== Test Complete ==="
