Phase 1: Infrastructure Setup
Step 1: Create EKS Cluster


# Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# Create cluster config
cat > cluster-config.yaml <<EOF
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: confidential-cluster
  region: us-west-2
  version: "1.28"

managedNodeGroups:
  - name: regular-nodes
    instanceType: m5.large
    desiredCapacity: 2
    minSize: 1
    maxSize: 3

nodeGroups:
  - name: enclave-nodes
    instanceType: m5n.xlarge  # Nitro Enclaves supported
    desiredCapacity: 2
    minSize: 1
    maxSize: 3
    ami: ami-0c02fb55956c7d316  # Amazon Linux 2
    userData: |
      #!/bin/bash
      /etc/eks/bootstrap.sh confidential-cluster
      # Enable Nitro Enclaves
      amazon-linux-extras install aws-nitro-enclaves-cli -y
      usermod -aG ne ec2-user
      usermod -aG docker ec2-user
      # Configure enclave allocator
      echo 'memory_mib: 1024' > /etc/nitro_enclaves/allocator.yaml
      echo 'cpu_count: 2' >> /etc/nitro_enclaves/allocator.yaml
      systemctl start nitro-enclaves-allocator.service
      systemctl enable nitro-enclaves-allocator.service
EOF

# Create cluster
eksctl create cluster -f cluster-config.yaml

Run in CloudShell
Step 2: Verify Cluster
# Check cluster status
kubectl get nodes
kubectl get pods -A

# Verify enclave nodes
kubectl get nodes -l node.kubernetes.io/instance-type=m5n.xlarge

Run in CloudShell
Phase 2: Configure TEE Support
Step 3: Install Nitro Enclaves on Worker Nodes
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

Run in CloudShell
Step 4: Install Container Runtime with Enclave Support
# Create DaemonSet for enclave runtime setup
cat > enclave-runtime-setup.yaml <<EOF
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: enclave-runtime-setup
  namespace: kube-system
spec:
  selector:
    matchLabels:
      name: enclave-runtime-setup
  template:
    metadata:
      labels:
        name: enclave-runtime-setup
    spec:
      nodeSelector:
        node.kubernetes.io/instance-type: m5n.xlarge
      hostPID: true
      hostNetwork: true
      containers:
      - name: setup
        image: amazonlinux:2
        command: ["/bin/bash"]
        args:
        - -c
        - |
          # Install containerd with enclave support
          yum update -y
          yum install -y containerd
          # Configure containerd for enclaves
          mkdir -p /etc/containerd
          cat > /etc/containerd/config.toml <<EOL
          version = 2
          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
            runtime_type = "io.containerd.runc.v2"
          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nitro-enclaves]
            runtime_type = "io.containerd.runc.v2"
            pod_annotations = ["enclave.aws/enabled"]
          EOL
          systemctl restart containerd
          sleep infinity
        securityContext:
          privileged: true
        volumeMounts:
        - name: host-root
          mountPath: /host
      volumes:
      - name: host-root
        hostPath:
          path: /
      tolerations:
      - operator: Exists
EOF

kubectl apply -f enclave-runtime-setup.yaml

Run in CloudShell
Step 5: Create RuntimeClass for Confidential Containers
cat > runtime-class.yaml <<EOF
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
  name: nitro-enclaves
handler: nitro-enclaves
scheduling:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: node.kubernetes.io/instance-type
          operator: In
          values: ["m5n.xlarge", "m5n.large", "m5n.2xlarge"]
EOF

kubectl apply -f runtime-class.yaml
kubectl get runtimeclass

Run in CloudShell
Phase 3: Install Confidential Container Operator
Step 6: Install Enclave Operator
# Create namespace
kubectl create namespace enclave-system

# Install enclave operator (custom CRD)
cat > enclave-operator.yaml <<EOF
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: enclaveapps.enclave.aws
spec:
  group: enclave.aws
  versions:
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            properties:
              image:
                type: string
              memory:
                type: string
              cpu:
                type: integer
              attestation:
                type: object
                properties:
                  enabled:
                    type: boolean
                  kmsKeyId:
                    type: string
          status:
            type: object
  scope: Namespaced
  names:
    plural: enclaveapps
    singular: enclaveapp
    kind: EnclaveApp
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: enclave-operator
  namespace: enclave-system
spec:
  replicas: 1
  selector:
    matchLabels:
      app: enclave-operator
  template:
    metadata:
      labels:
        app: enclave-operator
    spec:
      containers:
      - name: operator
        image: public.ecr.aws/aws-samples/nitro-enclave-operator:latest
        env:
        - name: WATCH_NAMESPACE
          value: ""
        ports:
        - containerPort: 8080
EOF

kubectl apply -f enclave-operator.yaml

Run in CloudShell
Step 7: Verify Operator Installation
# Check CRD
kubectl get crd enclaveapps.enclave.aws

# Check operator pod
kubectl get pods -n enclave-system
kubectl logs -n enclave-system deployment/enclave-operator

# Verify operator is ready
kubectl get deployment -n enclave-system enclave-operator

Run in CloudShell
Phase 4: Key Management Setup
Step 8: Create KMS Key for Attestation
# Create KMS key
aws kms create-key \
  --description "Enclave attestation key" \
  --key-usage ENCRYPT_DECRYPT \
  --key-spec SYMMETRIC_DEFAULT > kms-key.json

KMS_KEY_ID=$(cat kms-key.json | jq -r '.KeyMetadata.KeyId')
echo "KMS Key ID: $KMS_KEY_ID"

# Create key policy for attestation
cat > key-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable attestation-based access",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "kms:Decrypt",
        "kms:GenerateDataKey"
      ],
      "Resource": "*",
      "Condition": {
        "StringEqualsIgnoreCase": {
          "kms:RecipientAttestation:ImageSha384": "PLACEHOLDER_PCR0_VALUE"
        }
      }
    }
  ]
}
EOF

aws kms put-key-policy \
  --key-id $KMS_KEY_ID \
  --policy-name default \
  --policy file://key-policy.json

Run in CloudShell
Step 9: Setup Secrets Management
# Create secret in AWS Secrets Manager
aws secretsmanager create-secret \
  --name "enclave-app-secret" \
  --description "Secret for confidential application" \
  --secret-string '{"api_key":"super-secret-key","db_password":"secure-password"}'

# Create Kubernetes secret for KMS key
kubectl create secret generic kms-key \
  --from-literal=key-id=$KMS_KEY_ID \
  -n default

Run in CloudShell
Phase 5: Build and Deploy Confidential Application
Step 10: Build Enclave Image
# Create sample application
mkdir -p enclave-app
cd enclave-app

cat > Dockerfile <<EOF
FROM amazonlinux:2
RUN yum update -y && yum install -y python3 python3-pip
COPY app.py /app/
WORKDIR /app
CMD ["python3", "app.py"]
EOF

cat > app.py <<EOF
#!/usr/bin/env python3
import json
import socket
import time

def main():
    print("Confidential application starting...")
    
    # Simulate processing sensitive data
    while True:
        print("Processing confidential data in enclave...")
        time.sleep(30)

if __name__ == "__main__":
    main()
EOF

# Build Docker image
docker build -t enclave-app:latest .

# Build enclave image file
nitro-cli build-enclave \
  --docker-uri enclave-app:latest \
  --output-file enclave-app.eif

# Note the PCR values from output
echo "Save PCR0 value for KMS policy update"

Run in CloudShell
Step 11: Update KMS Policy with PCR Values
# Get PCR0 from enclave build output (replace with actual value)
PCR0_VALUE="your-actual-pcr0-value-from-build-output"

# Update KMS key policy with real PCR0
sed -i "s/PLACEHOLDER_PCR0_VALUE/$PCR0_VALUE/g" key-policy.json

aws kms put-key-policy \
  --key-id $KMS_KEY_ID \
  --policy-name default \
  --policy file://key-policy.json

Run in CloudShell
Step 12: Push Images to ECR
# Create ECR repository
aws ecr create-repository --repository-name enclave-app

# Get login token
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-west-2.amazonaws.com

# Tag and push
docker tag enclave-app:latest 123456789012.dkr.ecr.us-west-2.amazonaws.com/enclave-app:latest
docker push 123456789012.dkr.ecr.us-west-2.amazonaws.com/enclave-app:latest

# Upload EIF to S3
aws s3 cp enclave-app.eif s3://your-bucket/enclave-app.eif

Run in CloudShell
Phase 6: Deploy Confidential Application
Step 13: Create Confidential Application Deployment
cat > confidential-app.yaml <<EOF
apiVersion: enclave.aws/v1
kind: EnclaveApp
metadata:
  name: confidential-app
  namespace: default
spec:
  image: "123456789012.dkr.ecr.us-west-2.amazonaws.com/enclave-app:latest"
  memory: "1024Mi"
  cpu: 2
  attestation:
    enabled: true
    kmsKeyId: "$KMS_KEY_ID"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: confidential-app
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: confidential-app
  template:
    metadata:
      labels:
        app: confidential-app
      annotations:
        enclave.aws/enabled: "true"
        enclave.aws/memory: "1024"
        enclave.aws/cpu-count: "2"
    spec:
      runtimeClassName: nitro-enclaves
      nodeSelector:
        node.kubernetes.io/instance-type: m5n.xlarge
      containers:
      - name: app
        image: 123456789012.dkr.ecr.us-west-2.amazonaws.com/enclave-app:latest
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

kubectl apply -f confidential-app.yaml

Run in CloudShell
Phase 7: Validation and Testing
Step 14: Verify Deployment
# Check EnclaveApp CRD
kubectl get enclaveapp
kubectl describe enclaveapp confidential-app

# Check deployment
kubectl get deployment confidential-app
kubectl get pods -l app=confidential-app

# Get pod details
POD_NAME=$(kubectl get pods -l app=confidential-app -o jsonpath='{.items[0].metadata.name}')
kubectl describe pod $POD_NAME

Run in CloudShell
Step 15: Verify Enclave is Running
# SSH to the node where pod is running
NODE_NAME=$(kubectl get pod $POD_NAME -o jsonpath='{.spec.nodeName}')
NODE_IP=$(kubectl get node $NODE_NAME -o jsonpath='{.status.addresses[?(@.type=="ExternalIP")].address}')

ssh -i ~/.ssh/your-key.pem ec2-user@$NODE_IP

# Check running enclaves
nitro-cli describe-enclaves

# Check enclave console output
ENCLAVE_ID=$(nitro-cli describe-enclaves | jq -r '.[0].EnclaveID')
nitro-cli console --enclave-id $ENCLAVE_ID

# Exit SSH
exit

Run in CloudShell
Step 16: Test Attestation
# Create test pod to verify attestation
cat > attestation-test.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: attestation-test
spec:
  nodeSelector:
    node.kubernetes.io/instance-type: m5n.xlarge
  containers:
  - name: test
    image: amazonlinux:2
    command: ["/bin/bash"]
    args:
    - -c
    - |
      yum update -y
      yum install -y aws-cli
      # Test KMS access with attestation
      aws kms decrypt --key-id $KMS_KEY_ID --ciphertext-blob fileb://test-encrypted-data
      sleep 3600
    env:
    - name: KMS_KEY_ID
      valueFrom:
        secretKeyRef:
          name: kms-key
          key: key-id
EOF

kubectl apply -f attestation-test.yaml
kubectl logs attestation-test

Run in CloudShell
Step 17: Monitor and Validate
# Check application logs
kubectl logs -f deployment/confidential-app

# Check enclave operator logs
kubectl logs -f -n enclave-system deployment/enclave-operator

# Verify resource usage
kubectl top pods
kubectl top nodes

# Check events
kubectl get events --sort-by=.metadata.creationTimestamp

# Validate security
kubectl get pods -o wide
kubectl describe runtimeclass nitro-enclaves

Run in CloudShell
Step 18: Cleanup (Optional)
# Delete applications
kubectl delete -f confidential-app.yaml
kubectl delete -f attestation-test.yaml

# Delete operator
kubectl delete -f enclave-operator.yaml
kubectl delete namespace enclave-system

# Delete runtime class
kubectl delete -f runtime-class.yaml

# Delete cluster
eksctl delete cluster confidential-cluster

# Clean up AWS resources
aws kms schedule-key-deletion --key-id $KMS_KEY_ID --pending-window-in-days 7
aws secretsmanager delete-secret --secret-id enclave-app-secret
aws ecr delete-repository --repository-name enclave-app --force



====doubts 


1. Confidential Container Images - Yes, created regular Docker image (enclave-app:latest) that runs inside the enclave environment.

2. Enclave Image Files - Yes, built .eif file using nitro-cli build-enclave command, which is the actual enclave executable format for Nitro Enclaves.

Missing: Image Registry with Attestation - No, I used standard ECR without attestation metadata/signing. For production, you'd need signed images with attestation data stored in registry.