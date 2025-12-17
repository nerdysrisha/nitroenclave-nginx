#!/bin/bash -e
# Copyright 2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.

readonly EIF_PATH="/home/nginx.eif"
readonly ENCLAVE_CPU_COUNT=2
readonly ENCLAVE_MEMORY_SIZE=2048

# Function to get enclave VSOCK CID
get_enclave_cid() {
    nitro-cli describe-enclaves | jq -r ".[0].EnclaveCID"
}

# Function to start vsock proxy
# Function to start vsock proxy
start_vsock_proxy() {
    local enclave_cid=$1
    echo "Starting VSOCK proxy for enclave CID: $enclave_cid"
    # Bridge TCP port 80 (external) to VSOCK port 5000 (enclave internal)
    # External clients connect to TCP:80 → Proxy forwards to VSOCK:5000 → Enclave forwards to TCP:8080 → Nginx
    socat TCP-LISTEN:80,fork,reuseaddr VSOCK-CONNECT:$enclave_cid:5000 &
    echo $! > /var/run/vsock-proxy.pid
    echo "VSOCK proxy started: TCP:80 -> VSOCK:$enclave_cid:5000"
}

main() {
    # Start the enclave
    # SUPER IMPORTANT, IF THE ENCLAVE IS RUNNING IN DEBUG MODE, ATTESTATION WILL NOT HAPPEN. 
    # IF WE WANT ATTESTATION, WE NEED TO REMOVE DEBUG MODE
    nitro-cli run-enclave --cpu-count $ENCLAVE_CPU_COUNT --memory $ENCLAVE_MEMORY_SIZE \
        --eif-path $EIF_PATH --debug-mode

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
    
    # Start the vsock proxy
    start_vsock_proxy $enclave_cid
    
    #Waiting for nginx inside enclave to fully start
    echo "Waiting for nginx inside enclave to start. 30 Seconds Wait..."
    sleep 30
    
    # Start health check in background
    /home/health-check.sh $enclave_cid &
    
    echo "Nginx enclave with VSOCK proxy is ready!"
    echo "Access via: curl http://localhost:80"
    
    # Keep the container running
    wait
}

main
