#HIGH LEVEL STEPS 


0. Login

Authenticate to AWS using SSO / CLI profile to ensure credentials are in place.

1. Create Key Pair

	Generate an EC2 key pair to allow SSH access into worker nodes if needed for debugging.

2. Create VPC (Private Only)

	Provision a VPC with private subnets only, and configure NAT Gateway / VPC endpoints for EKS and container registry access.

3. Create IAM Roles

	EKS Cluster Role → for the control plane.

	EKS Node Role → must also include permissions for Nitro Enclaves, KMS, and CoCo attestation APIs.

4. Create EKS Cluster

	Spin up the EKS control plane (private API endpoint if you want end-to-end private).

5. Create Node Group with Confidential Compute Instances

	Provision EKS worker nodes on Nitro-based confidential instance types (e.g., m6i, c6i, c7i).

	Use AMI/runtime that supports Kata Containers / CoCo runtime.

6. Configure Security Groups

	Restrict traffic tightly (no 0.0.0.0/0) and allow only:

	Cluster control plane ↔ nodes.

	Node ↔ VPC endpoints (ECR, S3, KMS, Attestation).

7. Install Confidential Containers Runtime on Cluster

	Deploy the Confidential Containers Operator and related CRDs (Kata runtime classes, attestation services).

8. Verify Worker Node Access (Optional)

	SSH into a worker node (if key pair added) to validate Nitro support and runtime installation.

9. Deploy Payments App with CoCo Annotations

	Modify your Kubernetes Deployment manifest to:

	Use the kata runtime class.

	Optionally configure enclave resources (memory/CPU).

10. Test Payments API

	Run the same functional test flow against your service, verifying it runs inside a Confidential Pod.

11. Validate Attestation (Optional but Recommended)

	Use AWS Nitro Enclaves + CoCo attestation flow to prove your workload is running confidentially.
	
	
	
#COMMANDS FOR EACH STEP 