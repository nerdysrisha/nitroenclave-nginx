main() {
    # Get environment variables from the pod
    echo "Getting AWS credentials from environment..."
    echo "AWS_ROLE_ARN: $AWS_ROLE_ARN"
    echo "AWS_WEB_IDENTITY_TOKEN_FILE: $AWS_WEB_IDENTITY_TOKEN_FILE" 
    echo "AWS_REGION: $AWS_REGION"
    
    # Start the enclave WITHOUT environment variables (old nitro-cli)
    nitro-cli run-enclave \
        --cpu-count $ENCLAVE_CPU_COUNT \
        --memory $ENCLAVE_MEMORY_SIZE \
        --eif-path $EIF_PATH

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
    
    # Send credentials to enclave via VSOCK
    echo "Sending AWS credentials to enclave..."
    printf "POST /set-credentials HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"AWS_ROLE_ARN\":\"$AWS_ROLE_ARN\",\"AWS_WEB_IDENTITY_TOKEN_FILE\":\"$AWS_WEB_IDENTITY_TOKEN_FILE\",\"AWS_REGION\":\"$AWS_REGION\"}" | socat - VSOCK-CONNECT:$enclave_cid:5000
    
    # Start the vsock proxy
    start_vsock_proxy $enclave_cid
    
    #Waiting for nginx inside enclave to fully start
    echo "Waiting for nginx inside enclave to start. 30 Seconds Wait..."
    sleep 30
    
    echo "Nginx enclave with VSOCK proxy is ready!"
    echo "Access via: curl http://localhost:80"
    
    # Keep the container running
    wait
}
