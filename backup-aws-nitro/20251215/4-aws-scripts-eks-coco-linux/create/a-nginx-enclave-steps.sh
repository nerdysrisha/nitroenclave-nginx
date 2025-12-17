
{
added flask server  to nginx file
added some set endpoint invocation in run.sh 

however, the flask is not starting or not working 
need to double check 



}


#Step 0 ##############ONE TIME ACTIVITY ############CONFIGURE SSO############  

{
	
#On ubuntu host
aws --version

#If not configured, execute below. ONLY ONCE. 

cd /home/sridhara/Downloads/ 
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version


#Configure SSO. This is also one time excercise. 
aws configure sso
	#Enter below values 
	sri-poc-coco-ubuntu
	https://d-93671b9731.awsapps.com/start/#
	eu-west-1
	AWSAdministratorAccess
	eu-west-1
	default
			
aws sts get-caller-identity
			
sed -i 's/\r$//' *
chmod +x *.sh
sudo apt install dos2unix
dos2unix *.sh

}



#STEP 1 #############LOGIN TO AWS 

{
	
	
cd /home/sridhara/Downloads/4-aws-scripts-eks-coco-linux/create
ls -l file*.*
./b-login.sh
	
}



#STEP 2 ##############BUILD DOCKER IMAGE WITH EIF INSIDE IT #################   

{
#Check docker login status 
docker info | grep Username

#Docker login if not logged in, as we will need to push to dockerhub. 
#docker login


LOG_FILE="/home/sridhara/Downloads/4-aws-scripts-eks-coco-linux/logs/build_output_$(date '+%Y-%m-%d_%H-%M').txt"
export LOG_FILE
cd /home/sridhara/Downloads/4-aws-scripts-eks-coco-linux/create
chmod +x *.sh
./a0-build-enclave-image.sh  2>&1 | tee -a "$LOG_FILE"

  
  

}
	 
 
 
 
#STEP 3 ##############ONE TIME ACTIVITY TO CREATE THE KEY ON AWS. ONE PENDING PENDING PENDING PENDING ACTIVITY. 
{

	#List the keys
	aws kms list-keys

	#Create KMS Key. Below command creates a key and gets us key id. 
	aws kms create-key --description "For Nitro enclave attestation" 

	#Create alias PERMISSION DENIED
	#aws kms create-alias --alias-name alias/coco-attestation-key --target-key-id $(aws kms list-keys --query 'Keys[-1].KeyId' --output text)

	#Get the description of the existing key
	aws kms list-keys | jq -r '.Keys[].KeyId' | xargs -I {} aws kms describe-key --key-id {} | grep -i "enclave\|nitro\|attest"
	 
	#Get the ARN assosciated with the Key
	aws kms describe-key --key-id 4bae92be-4b6c-4380-abb3-504dcb330b5a | jq -r '.KeyMetadata.Arn'
	

}

#STEP 4 ##############Update KMS Policy with EIF PCR Values

{


 
cd /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s/container/coconginxv3
dos2unix *.sh
chmod +x *.sh
./update-kms-policy-with-pcrvalues.sh    2>&1 | tee -a "$LOG_FILE"


}

#STEP 5 ##############CREATE ROLE & KMS-POLICIES 

{
	
	
#ONE TIME ACTIVITY
#NOTE: WHENVVER THE KEY IS CHANGED (OR NEW ONECREATED) CHANGE IN BELOW ROLE AS WELL 


	# CREATE TRUST-POLICY
	# CREATE AWS-ROLE 
	# ATTACH TRUST-POLICY TO AWS-ROLE
	# CREATE KMS-POLICY
	# ATTACH KMS-POLICY TO AWS-ROLE 

#Obtain oidc provider to be used in the trust policy 
aws eks describe-cluster --name eks-coco --region eu-west-1 --query "cluster.identity.oidc.issuer" --output text
https://oidc.eks.eu-west-1.amazonaws.com/id/FB71067963F46D29829205FF9AC54700
 
aws iam list-roles --query 'Roles[*].RoleName' --output json


#Create trust policy 

# Save the trust policy
cat > trust-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::908774804544:oidc-provider/oidc.eks.eu-west-1.amazonaws.com/id/FB71067963F46D29829205FF9AC54700"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.eu-west-1.amazonaws.com/id/FB71067963F46D29829205FF9AC54700:sub": "system:serviceaccount:default:nitro-enclave-sa"
        }
      }
    }
  ]
}
EOF


# Create the role and attach the policy 
aws iam create-role --role-name NitroEnclaveKMSRole --assume-role-policy-document file://trust-policy.json

 

# Create KMS policy
cat > kms-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:GenerateDataKey"
      ],
      "Resource": "arn:aws:kms:us-east-1:908774804544:key/4bae92be-4b6c-4380-abb3-504dcb330b5a"
    }
  ]
}
EOF

# Attach policy
aws iam put-role-policy --role-name NitroEnclaveKMSRole --policy-name KMSAccess --policy-document file://kms-policy.json


}

#STEP 6 ##############INFRA CREATION 
{

#Below LOGIN step will be required to be executed every one hour as the token expires after one hour. 
#First time: sridhara_shastry / password / google authenticator mfa

#For clean up 
cd /home/sridhara/Downloads/4-aws-scripts-eks-coco-linux/cleanup
#  ./0-cleanup.sh

#For Creation 
cd /home/sridhara/Downloads/4-aws-scripts-eks-coco-linux/create
./c-create-coco-eks-keypair.sh  							2>&1 | tee -a "$LOG_FILE"
./d-create-coco-eks-vpc.sh  								2>&1 | tee -a "$LOG_FILE"
./e-create-coco-eks-iamrole.sh  							2>&1 | tee -a "$LOG_FILE"
./f-create-coco-eks.sh 										2>&1 | tee -a "$LOG_FILE"
#Wait for 10 mins
./g1-create-coco-nodegroup-launchtemplate-amzonlinux2.sh   	2>&1 | tee -a "$LOG_FILE"
./h-create-coco-eks-nodegroup.sh 							2>&1 | tee -a "$LOG_FILE"
#Wait for 10 mins
./i-modify-security-groups-usedby-nitronode.sh 				2>&1 | tee -a "$LOG_FILE"


kubectl get nodes   

}
 

#STEP 7 ##############ENCLAVE PLUGIN LOADING ONTO K8

./i2-install-nitrol-enclave-device-plugin.sh 				2>&1 | tee -a "$LOG_FILE"
 
 
#STEP 8 ##############APPLICATION DEPLOYMENT (NGINX) 

#Delete Deployment if exists 
	cd /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s/container/coconginxv3
	kubectl delete -f vsock-nginx-deployment.yaml
	kubectl get pods
	
./i3-deploy-nginx-to-eks.sh   2>&1 | tee -a "$LOG_FILE"


{
 
 
#For simple nginx without VSOCK communications
{
	
	#Delete
	cd /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s/container/versionednginx/v1/
	kubectl delete -f simple-nginx-deployment.yaml 
	
	
	#Create
	cd /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s/container/versionednginx/v1/
	kubectl apply -f simple-nginx-deployment.yaml 
	kubectl get pods
	

}
 
#For nginx with vsock etc 
{
	
	#Delete Deployment if exists 
	cd /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s/container/coconginxv3
	kubectl delete -f vsock-nginx-deployment.yaml
	kubectl get pods
	
	#Create Deployment 
	cd /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s/container/coconginxv3
	dos2unix *.yaml
	kubectl apply -f vsock-nginx-deployment.yaml 
	kubectl get pods
	 
}


#Get logs 
kubectl get pods
kubectl logs $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | head -n 1)
#Describe pod 
kubectl describe pod $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | head -n 1)

}

#STEP 9 ##############PORTFORWARD  

{
kubectl port-forward pod/$(kubectl get pods --no-headers -o custom-columns=":metadata.name" | head -n 1) 8080:80
#In another terminal 
curl http://localhost:8080/

}
 
#STEP 10 ##############ACCESS THE POD AND  ATTESTSTION 
 
{
 
#Access the pod and check enclaves
kubectl exec -it  $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | head -n 1) -- /bin/bash

#Describe the nitro enclaves inside the pod 
	#Bash 
	nitro-cli describe-enclaves

			#Install tools - atm not required 
			#install -y procps-ng util-linux
 
 
	#This will fail as the enclave has been started using the DEBUG FLAG OFF. IF DEBUG FLAG IS ON CONSOLE WILL BE SHOWN. 
	nitro-cli console --enclave-name nginx


	# Get the CID dynamically
	CID=$(nitro-cli describe-enclaves | jq -r '.[0].EnclaveCID')

	# Use the dynamic CID in your socat command
	printf "GET / HTTP/1.1\r\nHost: localhost\r\n\r\n" | socat - VSOCK-CONNECT:${CID}:5000

	 
	 
#Attestation testing 

	# Get the CID dynamically
	CID=$(nitro-cli describe-enclaves | jq -r '.[0].EnclaveCID')
	printf "GET /attestation-status.json HTTP/1.1\r\nHost: localhost\r\n\r\n" | socat - VSOCK-CONNECT:${CID}:5000
	  

 
}





























	 
	
	

 #############################################################
	#Open new terminal and get into the pod terminal 
	
	kubectl exec -it  $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | head -n 1) -- /bin/bash
 
	#Run this command
	aws kms encrypt --key-id 4bae92be-4b6c-4380-abb3-504dcb330b5a --plaintext "test data"


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
==============================================================================


poc feedback

graphical representation of steps
does enclave has kernel ?
not all images are compatible to be checked? eg. side car 































######################################################################Additional commands not used extensively ignored hence. start 

# 1. Check VSOCK proxy is running inside the pod
kubectl exec -it $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | head -n 1) -- ps aux | grep socat

# 2. Check the enclave logs from inside the pod
kubectl exec -it $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | head -n 1) -- cat /var/log/nitro_enclaves/*

# 3. (Optional) Use socat inside the pod to test VSOCK connection directly
kubectl exec -it $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | head -n 1) -- socat - TCP-CONNECT:18:5000



#####Below is not done. 
kubectl apply -f file7-nginx-service.yaml 
service/nginx-enclave-service created
	
	
POD IS DEPLOYED NOW IF WE NEED SERVICE OR VSOCK COMMUNICATION ETTC TO BE EXPLORERD PROPERLY 
	
	
		
	
#Exit the terminal 
	bash-4.2# exit

#################################################################Additional commands not used extensively ignored hence. end 










 
#######CREATE BASTION AND ACCESS THE WORKER NODE ##### not tested yet

 
cd /home/sridhara/Downloads/4-aws-scripts-eks-coco-linux/create
./j0-create-coco-eks-bastion-ec2.sh


#Rerun login as we will need extended aws creds
./b-login.sh

./j3-copy-bastion-files-to-bastion-host.sh

./k-access-bastion-host-via-ssh.sh

#ONBASTION 

sed -i 's/\r$//' *
chmod +x *.sh
chmod 600 coco-eks-key.pem


#Configure AWS Crendeitlas 
./file1-bastion-configure-aws-on-bastion.sh
	 
	
	
#Just to connect to WORKERNODE without any transfers 
./file2-bastion-just-ssh-to-workernode.sh




#Inside the nitro-node
#NOT REQUIRED THOUGH
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


#Inside the nitro-node
 
#Check nitro enclaves 
ls -la /dev/nitro_enclaves

#Checking enclave is running 
systemctl status nitro-enclaves-allocator

#We can see the cli installed 
which nitro-cli

#Check version of nitro-cli 
nitro-cli --version


#Check enclaves running. This is resulting in failure as we need to configure few things here to see the enclaves etc
#PENDING PENDING PENDING
nitro-cli describe-enclaves

	Getting E19 error


sudo systemctl status nitro-enclaves-allocator

sudo mkdir -p /var/log/nitro_enclaves
sudo chown ec2-user:ec2-user /var/log/nitro_enclaves
sudo chmod 755 /var/log/nitro_enclaves
sudo systemctl restart nitro-enclaves-allocator
sudo systemctl enable nitro-enclaves-allocator
nitro-cli describe-enclaves
sudo nitro-cli describe-enclaves



RUN THESE ON 03 NOV 





















#List the containers running using the CRI tool (Container Runtime Interface (CRI) Control)
sudo crictl ps


#Fetch logs of 'hello container' 

sudo crictl logs xxxxxxxxxxxx






















####Below not done 
#Connect to WORKERNODE and copy scripts as well 
./file3-bastion-ssh-n-tfr-files-to-workernode.sh
 

	 
#ON NITRO NODE
#Install docker, nitro-cli and nitro-dev tools
./file4-nitro-install-docker-nitrocli.sh
 


#####Commands to test 

# List running enclaves
nitro-cli describe-enclaves

# Check enclave allocator status
systemctl status nitro-enclaves-allocator --no-pager

# View enclave allocation config
cat /etc/nitro_enclaves/allocator.yaml

# Confirm Docker container for enclave is running
docker ps

# Inspect logs (optional, if needed)
journalctl -u nitro-enclaves-allocator


###more commands 

# Test enclave memory isolation
echo "=== Testing enclave memory isolation ==="
sudo nitro-cli describe-enclaves

# Check if enclave memory is isolated from host
echo "=== Checking memory allocation ==="
cat /proc/meminfo | grep -E "(MemTotal|MemAvailable)"

# Verify enclave-allocated memory is not accessible from host
echo "=== Verifying CPU/Memory isolation ==="
cat /sys/devices/system/node/node*/meminfo

# Test that you CANNOT access enclave memory from host
echo "=== Testing memory dump protection ==="
sudo dmesg | grep -i enclave

# Verify enclave processes are isolated
echo "=== Checking process isolation ==="
ps aux | grep -E "(nitro|enclave)"
