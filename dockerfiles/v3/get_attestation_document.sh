#!/bin/bash
# Read base64 nonce from stdin and call Rust attestation
read -r NONCE_B64
echo "$NONCE_B64" | /opt/attest
