#!/bin/bash
read -r NONCE_B64
echo "$NONCE_B64" | /opt/attest_c
