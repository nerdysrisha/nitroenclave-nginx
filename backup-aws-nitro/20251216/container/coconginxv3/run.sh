#!/bin/bash -e

readonly EIF_PATH="/home/nginx.eif"
readonly ENCLAVE_CPU_COUNT=2
readonly ENCLAVE_MEMORY_SIZE=2048

# Function to get enclave VSOCK CID
get_enclave_cid() {
    nitro-cli describe-enclaves | jq -r ".[0].EnclaveCID"
}

# Function to start vsock proxy
start_vsock_proxy() {
    local enclave_cid=$1
    echo "Starting VSOCK proxy for enclave CID: $enclave_cid"
    socat TCP-LISTEN:80,fork,reuseaddr VSOCK-CONNECT:$enclave_cid:5000 &
    echo $! > /var/run/vsock-proxy.pid
    echo "VSOCK proxy started: TCP:80 -> VSOCK:$enclave_cid:5000"
}

main() {
    # Start the enclave
    nitro-cli run-enclave --cpu-count $ENCLAVE_CPU_COUNT --memory $ENCLAVE_MEMORY_SIZE --eif-path $EIF_PATH  
    
    local enclave_id=$(nitro-cli describe-enclaves | jq -r ".[0].EnclaveID")
    echo "-------------------------------"
    echo "Enclave ID is $enclave_id"
    echo "-------------------------------"
    
    # Wait for enclave to be ready and get its CID
    local enclave_cid=""
    while [ -z "$enclave_cid" ]; do
        enclave_cid=$(get_enclave_cid)
        if [ -z "$enclave_cid" ]; then
            echo "Waiting for enclave CID..."
            sleep 2
        fi
    done
    
    echo "Enclave CID: $enclave_cid"
    
    # Wait for enclave to initialize
    echo "Waiting for enclave to initialize..."
    sleep 10
    
    # Start the vsock proxy for nginx traffic
    start_vsock_proxy $enclave_cid
    
    echo "Nginx enclave with VSOCK proxy is ready!"
    echo "Port 5000: NGINX traffic (proxied to TCP:80)"
    echo "Port 5001: Attestation service (direct VSOCK access)"
    echo "Access nginx via: curl http://localhost:80"
    echo "Get attestation via: echo 'nonce' | socat - VSOCK-CONNECT:$enclave_cid:5001"
    
    # Keep the container running
    wait
}

main
