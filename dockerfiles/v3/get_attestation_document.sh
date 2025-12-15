#!/bin/bash

# Read base64-encoded nonce from stdin (sent by parent)
read -r NONCE_B64

# Call the attestation binary with the nonce
# The binary should generate the attestation document including this nonce
ATTESTATION_JSON=$(/opt/attest/attest_c "$NONCE_B64")

# Output the attestation document to stdout
echo "$ATTESTATION_JSON"
