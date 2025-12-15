#!/bin/bash
# Read base64-encoded nonce from stdin
read -r NONCE_B64

# Generate attestation document via the Python script
python3 /opt/attest.py <<< "$NONCE_B64"
