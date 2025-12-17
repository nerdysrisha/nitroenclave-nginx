Complete EKS Confidential Containers Implementation Guide

######### :#Phase 1: Local Environment Setup		####################################

#Step 1: Setup Local Prerequisites
	# Install AWS CLI
		curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
		unzip awscliv2.zip
		sudo ./aws/install

	# Configure AWS credentials
		aws configure sso

	# Install kubectl
		curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
		sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

	# Install eksctl
		curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
		sudo mv /tmp/eksctl /usr/local/bin

	# Install nitro-cli (for local EIF building)
	# For Ubuntu/Debian
		sudo apt update && sudo apt install -y nitro-cli
	# For Amazon Linux 2
	# sudo amazon-linux-extras install aws-nitro-enclaves-cli -y


#Step 2: Create Cluster Configuration YAML

cat > cluster-config.yaml <<EOF
# [Previous cluster config content]
EOF
 
#Step 3: Create EKS Cluster
	eksctl create cluster -f cluster-config.yaml
	
	
	
	

######### :#Phase 2: Cluster Verification				####################################

#Step 4: Verify Cluster Status
	# Check cluster status
	kubectl get nodes
	kubectl get pods -A

	# Verify enclave nodes specifically
	kubectl get nodes -l node.kubernetes.io/instance-type=m5n.xlarge






######### :#Phase 3: Configure TEE Support				####################################

#Step 5: Install Nitro Enclaves on Worker Nodes

	# SSH to enclave nodes (repeat for each node)
	NODE_IP=$(kubectl get nodes -l node.kubernetes.io/instance-type=m5n.xlarge -o jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}')
	ssh -i ~/.ssh/your-key.pem ec2-user@$NODE_IP

	# Verify Nitro Enclaves installation
	nitro-cli --version
	systemctl status nitro-enclaves-allocator

	# Check allocator config
	cat /etc/nitro_enclaves/allocator.yaml
	nitro-cli describe-enclaves

	# Exit SSH
	exit

#Step 6: Install Container Runtime with Enclave Support

	# Create DaemonSet YAML file for enclave runtime setup
cat > enclave-runtime-setup.yaml <<EOF
# [Previous DaemonSet content]
EOF

	# Apply DaemonSet
	kubectl apply -f enclave-runtime-setup.yaml
 
#Step 7: Create RuntimeClass for Confidential Containers
# Create RuntimeClass YAML file
cat > runtime-class.yaml <<EOF
# [Previous RuntimeClass content]
EOF

	# Apply RuntimeClass YAML
	kubectl apply -f runtime-class.yaml

	# Verify runtime class
	kubectl get runtimeclass


######### :#Phase 4: Install Confidential Container Operator ####################################

#Step 8: Install Enclave Operator
	# Create namespace for enclave-system
	kubectl create namespace enclave-system

	# Create Enclave operator YAML (custom CRD)
cat > enclave-operator.yaml <<EOF
# [Previous operator content]
EOF

	# Apply the YAML
	kubectl apply -f enclave-operator.yaml

 
#Step 9: Verify Operator Installation
	# Check CRD
	kubectl get crd enclaveapps.enclave.aws

	# Check operator pod
	kubectl get pods -n enclave-system

	# Check logs
	kubectl logs -n enclave-system deployment/enclave-operator

	# Verify operator is ready
	kubectl get deployment -n enclave-system enclave-operator


######### :#Phase 5: Key Management Setup				 ####################################




#Step 10: Create KMS Key for Attestation
	# Create KMS key (saves to JSON file)
	aws kms create-key \
	  --description "Enclave attestation key" \
	  --key-usage ENCRYPT_DECRYPT \
	  --key-spec SYMMETRIC_DEFAULT > kms-key.json

	# Echo the key ID
	KMS_KEY_ID=$(cat kms-key.json | jq -r '.KeyMetadata.KeyId')
	echo "KMS Key ID: $KMS_KEY_ID"

	# Create key policy for attestation using the JSON file created previously
	
cat > key-policy.json <<EOF
# [Previous key policy content]
EOF

	aws kms put-key-policy \
	  --key-id $KMS_KEY_ID \
	  --policy-name default \
	  --policy file://key-policy.json


#Step 11: Setup Secrets Management
	# Create secret in AWS Secrets Manager
		aws secretsmanager create-secret \
		  --name "enclave-app-secret" \
		  --description "Secret for confidential Java application" \
		  --secret-string '{"api_key":"super-secret-key","db_password":"secure-password"}'

	#Create Kubernetes secret for KMS key
	kubectl create secret generic kms-key \
	  --from-literal=key-id=$KMS_KEY_ID \
	  -n default

 
 

######### :#Phase 6: Build and Deploy Confidential Application	 ####################################


#Step 12: Build Enclave Image
	# Create sample application directory
	mkdir -p java-enclave-app
	cd java-enclave-app

	# Create Dockerfile for your Java JAR
	
cat > Dockerfile <<EOF
FROM openjdk:11-jre-slim
COPY your-app.jar /app/app.jar
WORKDIR /app
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
EOF

	# Build Docker image (using your Java JAR)
	docker build -t java-enclave-app:latest .

	# Build enclave image file (using your Docker build details)
	nitro-cli build-enclave \
	  --docker-uri java-enclave-app:latest \
	  --output-file java-enclave-app.eif

	# Note the PCR values from output
	# PCR (Platform Configuration Register) values are cryptographic measurements that uniquely identify your enclave:
	# - PCR0: Hash of the enclave image file itself
	# - PCR1: Hash of the Linux kernel and bootstrap data  
	# - PCR2: Hash of the user application code (your Java app)
	echo "Save these PCR values for KMS policy update - they prove your enclave's identity"

 
#Step 13: Update KMS Policy with PCR Values
	# Get PCR0 from enclave build output (replace with actual value from above)
	PCR0_VALUE="your-actual-pcr0-value-from-build-output"

	# Update KMS key policy with real PCR0
	sed -i "s/PLACEHOLDER_PCR0_VALUE/$PCR0_VALUE/g" key-policy.json
	aws kms put-key-policy \
	  --key-id $KMS_KEY_ID \
	  --policy-name default \
	  --policy file://key-policy.json


#Step 14: Push Images to ECR
# Create ECR repository
	aws ecr create-repository --repository-name java-enclave-app

	# Get login token
	aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-west-2.amazonaws.com

	# Tag and push to ECR
	docker tag java-enclave-app:latest 123456789012.dkr.ecr.us-west-2.amazonaws.com/java-enclave-app:latest
	docker push 123456789012.dkr.ecr.us-west-2.amazonaws.com/java-enclave-app:latest

	# Upload EIF to S3
	aws s3 cp java-enclave-app.eif s3://your-bucket/java-enclave-app.eif




######### :#Phase 7: Deploy Confidential Application	 ####################################

#Step 15: Create Confidential Application Deployment
# Create YAML file containing two objects (EnclaveApp CRD + Deployment)

cat > confidential-java-app.yaml <<EOF
apiVersion: enclave.aws/v1
kind: EnclaveApp
metadata:
  name: java-confidential-app
  namespace: default
spec:
  image: "123456789012.dkr.ecr.us-west-2.amazonaws.com/java-enclave-app:latest"
  memory: "1024Mi"
  cpu: 2
  attestation:
    enabled: true
    kmsKeyId: "$KMS_KEY_ID"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: java-confidential-app
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: java-confidential-app
  template:
    metadata:
      labels:
        app: java-confidential-app
      annotations:
        enclave.aws/enabled: "true"
        enclave.aws/memory: "1024"
        enclave.aws/cpu-count: "2"
    spec:
      runtimeClassName: nitro-enclaves
      nodeSelector:
        node.kubernetes.io/instance-type: m5n.xlarge
      containers:
      - name: java-app
        image: 123456789012.dkr.ecr.us-west-2.amazonaws.com/java-enclave-app:latest
        ports:
        - containerPort: 8080
        resources:
          requests:
            memory: "1Gi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "1000m"
        env:
        - name: KMS_KEY_ID
          valueFrom:
            secretKeyRef:
              name: kms-key
              key: key-id
EOF

	# Apply the YAML file
	kubectl apply -f confidential-java-app.yaml

 
######### :#Phase 8: Validation and Testing			 ####################################


#Step 16: Verify Deployment
	# Check EnclaveApp CRD by getting it and describing it
	kubectl get enclaveapp
	kubectl describe enclaveapp java-confidential-app

	# Check deployment
	kubectl get deployment java-confidential-app
	kubectl get pods -l app=java-confidential-app

	# Get pod details
	POD_NAME=$(kubectl get pods -l app=java-confidential-app -o jsonpath='{.items[0].metadata.name}')
	kubectl describe pod $POD_NAME

	 
#Step 17: Verify Enclave is Running
	# SSH to the node where pod is running
	NODE_NAME=$(kubectl get pod $POD_NAME -o jsonpath='{.spec.nodeName}')
	NODE_IP=$(kubectl get node $NODE_NAME -o jsonpath='{.status.addresses[?(@.type=="ExternalIP")].address}')
	ssh -i ~/.ssh/your-key.pem ec2-user@$NODE_IP

	# Install nitro-cli on the node (if not already installed)
	sudo amazon-linux-extras install aws-nitro-enclaves-cli -y

	# Check running enclaves
	nitro-cli describe-enclaves

	# Check enclave console output
	ENCLAVE_ID=$(nitro-cli describe-enclaves | jq -r '.[0].EnclaveID')
	nitro-cli console --enclave-id $ENCLAVE_ID

	# Exit SSH
	exit

 
#Step 18: Test Attestation

	# Create test pod YAML file to verify attestation
cat > attestation-test.yaml <<EOF
# [Previous attestation test content]
EOF

	# Apply the attestation YAML file
	kubectl apply -f attestation-test.yaml

	# Get logs of attestation pod that we created
	kubectl logs attestation-test


#Step 19: Monitor and Validate
	# Check application logs (Java application)
	kubectl logs -f deployment/java-confidential-app

	# Check enclave operator logs
	kubectl logs -f -n enclave-system deployment/enclave-operator

	# Verify resource usage using top command for pods and nodes
	kubectl top pods
	kubectl top nodes

	# Check events
	kubectl get events --sort-by=.metadata.creationTimestamp

	# Validate security by getting pods and describing the runtime class
	kubectl get pods -o wide
	kubectl describe runtimeclass nitro-enclaves




 
######### :#Phase 9: Memory Dump Security Testing						 ####################################
 
  
#Step 20: Send Sensitive Payment Data to Java API

	# Get Java app pod IP
	JAVA_APP_IP=$(kubectl get pod $POD_NAME -o jsonpath='{.status.podIP}')

	# Fire POST request with sensitive data (update with your actual API details)
	curl -X POST http://$JAVA_APP_IP:8080/your-api-endpoint \
	  -H "Content-Type: application/json" \
	  -d '{"key": "value"}'

	# Send multiple requests to ensure data stays in memory
	for i in {1..5}; do
	  curl -X POST http://$JAVA_APP_IP:8080/your-api-endpoint \
		-H "Content-Type: application/json" \
		-d "{\"messageId\":\"MSG-00000$i\",\"sensitiveData\":\"test-data-$i\"}"
	done

 
#Step 21: Attempt Memory Dump from Host Node

	# SSH to the worker node where Java app is running
	ssh -i ~/.ssh/your-key.pem ec2-user@$NODE_IP

	# Find Java process inside enclave
	JAVA_PID=$(ps aux | grep java | grep -v grep | awk '{print $2}')
	echo "Java Process PID: $JAVA_PID"

	# Attempt memory dump of Java process
	sudo gcore $JAVA_PID 2>/dev/null || echo "Memory dump blocked (GOOD!)"

	# If dump succeeds, search for sensitive data
	if [ -f core.$JAVA_PID ]; then
	  echo "Searching for sensitive data in memory dump..."
	  sudo strings core.$JAVA_PID | grep -E "(MSG-00000|sensitiveData|test-data)"
	  echo "Above should show NO results if enclave protection works"
	fi

	# Try direct memory access
	sudo cat /proc/$JAVA_PID/environ | grep -E "(MSG-|sensitive)" || echo "Direct memory access blocked (GOOD!)"

 
#Step 22 Test Container Runtime Memory Access

	# Get container ID of Java app
	CONTAINER_ID=$(sudo crictl ps | grep java-confidential-app | awk '{print $1}')

	# Try to access container memory
	sudo crictl exec $CONTAINER_ID ps aux
	sudo crictl exec $CONTAINER_ID cat /proc/1/environ | grep -E "(MSG-|sensitive)" || echo "Container memory protected (GOOD!)"

	exit

 
#Step 23: Verify Application Logs vs Memory Protection

	# Check if sensitive data appears in application logs (expected)
	kubectl logs $POD_NAME | grep -E "(MSG-00000|sensitiveData)"
	echo "↑ Logs should show processed data (this is normal)"

	 

 
######### :#Phase 10: Cleanup							 ####################################
 
#Step 24: Cleanup Resources
	# Delete applications (both Java app and attestation pod)
	kubectl delete -f confidential-java-app.yaml
	kubectl delete -f attestation-test.yaml

	# Delete operator and namespace
	kubectl delete -f enclave-operator.yaml
	kubectl delete namespace enclave-system

	# Delete runtime class
	kubectl delete -f runtime-class.yaml

	# Delete cluster
	eksctl delete cluster confidential-cluster

	# Clean up AWS resources (key, secret, repository)
	aws kms schedule-key-deletion --key-id $KMS_KEY_ID --pending-window-in-days 7
	aws secretsmanager delete-secret --secret-id enclave-app-secret
	aws ecr delete-repository --repository-name java-enclave-app --force
	aws s3 rm s3://your-bucket/java-enclave-app.eif

 