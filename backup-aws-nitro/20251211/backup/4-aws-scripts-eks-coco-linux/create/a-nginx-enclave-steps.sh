
{
Attestation file added all good, 
added new roles etc. 
however, the attestation file is not able to get the environment variables, so it is failing
there are two run.sh where runv0.sh is original that is working without attestation etc. 
then run.sh that has new changes etc, though it is not working 

continue from here by taking the run.sh to other ai



}









##############ONE TIME ACTIVITY ############CONFIGURE SSO############ START


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
			
#Copy file from Host to Linux. One time excercise. If already copied no need to run this 

ls -l 
#Commented intentionaly. This is already copied, no need to copy again
#cp -r /media/sf_ws/cocopoc/3-aws-scripts-eks-coco ~/Downloads/

sed -i 's/\r$//' *
chmod +x *.sh
sudo apt install dos2unix
dos2unix *.sh

}
##############ONE TIME ACTIVITY ############CONFIGURE SSO############ END




##############BUILD DOCKER IMAGE WITH EIF INSIDE IT ################# START 

{
 
#For Linux 


#Build the docker image 
#Navigate to tools directory 

cd /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s
 


#ADD THE enclavectl TOOL TO THE PATH. env.sh adds current directory to your path, makes './enclavectl' available as just enclavectl and sets up environment variables needed by the tool. 
	source env.sh

#Removes all aws resourcces created by any previous etp and deletes local config files build artifacts. 
	./enclavectl cleanup

#Applies config settings from json file to our project. 
	./enclavectl configure --file settings.json

#Check docker login status 
docker info | grep Username

#Docker login if not logged in, as we will need to push to dockerhub. 
#docker login
 

#DELETE CONTAINERS IMAGES DYNAMICALLY 
 
	docker ps -a --format '{{.ID}} {{.Image}}' | grep -v 'kindest/node' | awk '{print $1}' | xargs -r docker rm -f
	docker images --format '{{.Repository}}:{{.Tag}} {{.ID}}' | grep -v '^kindest/node' | awk '{print $2}' | xargs -r docker rmi -f
 	docker image prune -f
	docker builder prune --all --force
	docker volume prune -f
	docker network prune -f



#Removing existing .eif files so that freshly gets built everytime. 
	ls -lrt /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s/container/bin
	rm -f /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s/container/bin/*.*
	ls -lrt /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s/container/bin

#Note for easy deployments, created dedicated directory called 'versionednginx', under which multiple versions are provided
#Eg. v1 folder has super simple nginx without any vsock installations etc. 
#Eg. v2 folder has nginx related but with vsock. Important distinction and diff is the file path of github where for vsock driven setup, we need different enclave app that has additional configurations for vsock

	cd /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s
# Capture all output

	rm build_output.txt 
	./enclavectl build --image coconginxv3 2>&1 | tee build_output.txt					   
 
	docker images
	docker ps -a

#Dynamically tagging the coconginx-xxxxxx:xxxx to appropriate one as in the command. 
	docker images --format '{{.Repository}}:{{.Tag}}' \
	  | grep '^coconginx' \
	  | while read image; do
		  docker tag "$image" nerdysrisha/nginx-aws-nitro:latest
		done
# Fix line endings and permissions
dos2unix run.sh
chmod +x run.sh
	docker images
 
#Push the image to docker hub. 
docker push nerdysrisha/nginx-aws-nitro:latest

}
##############BUILD DOCKER IMAGE WITH EIF INSIDE IT ################# END 



#########################KEY MANAGEMENT ############################ START 

{

######BELOW IS ONE TIME ACTIVITY TO CREATE THE KEY  START

	#List the keys
	aws kms list-keys

	#Create KMS Key 
	aws kms create-key --description "For Nitro enclave attestation" 

	#Create alias PERMISSION DENIED
	#aws kms create-alias --alias-name alias/coco-attestation-key --target-key-id $(aws kms list-keys --query 'Keys[-1].KeyId' --output text)

	#Get the description of the existing key
	aws kms list-keys | jq -r '.Keys[].KeyId' | xargs -I {} aws kms describe-key --key-id {} | grep -i "enclave\|nitro\|attest"
	 
	#Get the ARN assosciated with the Key
	aws kms describe-key --key-id 4bae92be-4b6c-4380-abb3-504dcb330b5a | jq -r '.KeyMetadata.Arn'
 
######BELOW IS ONE TIME ACTIVITY TO CREATE THE KEY  END

 
cd /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s/container/coconginxv3
dos2unix *.sh
chmod +x *.sh
./update-kms-policy-with-pcrvalues.sh

#Verify 
aws kms get-key-policy --key-id 4bae92be-4b6c-4380-abb3-504dcb330b5a --policy-name default --output json | jq .









#Obtain oidc provider 
aws eks describe-cluster --name eks-coco --region eu-west-1 --query "cluster.identity.oidc.issuer" --output text
https://oidc.eks.eu-west-1.amazonaws.com/id/FB71067963F46D29829205FF9AC54700
 
 

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
#########################KEY MANAGEMENT ############################# END 



#########################INFRA CREATION ############################ START 

{

#Below LOGIN step will be required to be executed every one hour as the token expires after one hour. 
#First time: sridhara_shastry / password / google authenticator mfa

#For clean up 
cd /home/sridhara/Downloads/4-aws-scripts-eks-coco-linux/cleanup
#  ./0-cleanup.sh

#For Creation 
cd /home/sridhara/Downloads/4-aws-scripts-eks-coco-linux/create
./b-login.sh


./c-create-coco-eks-keypair.sh

./d-create-coco-eks-vpc.sh

./e-create-coco-eks-iamrole.sh

./f-create-coco-eks.sh
#Wait for 10 mins


./g1-create-coco-nodegroup-launchtemplate-amzonlinux2.sh
./h-create-coco-eks-nodegroup.sh
#Wait for 10 mins


./i-modify-security-groups-usedby-nitronode.sh

kubectl get nodes 

}
#########################INFRA CREATION ############################ END 



#########################ENCLAVE PLUGIN LOADING ONTO K8S ############################ START 

{
####K8 deployments 
 

#Install Nitro Enclaves Device Plugin on aws kubernetes 
	kubectl apply -f https://raw.githubusercontent.com/aws/aws-nitro-enclaves-k8s-device-plugin/main/aws-nitro-enclaves-k8s-ds.yaml
	kubectl get ns

#Label the node 
	kubectl get nodes
 
#Label the node by fetching name dynamically. 
	kubectl label node $(kubectl get nodes -o jsonpath='{.items[0].metadata.name}') aws-nitro-enclaves-k8s-dp=enabled

#Validate once labelled
	kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{" "}{.metadata.labels.aws-nitro-enclaves-k8s-dp}{"\n"}{end}'

#Switch to create ns 
	cd /home/sridhara/Downloads/4-aws-scripts-eks-coco-linux/create
	ls -l file*.*




#Create namespace and switch
	kubectl create namespace integrations
	kubectl config set-context --current --namespace=integrations

 
}
#########################ENCLAVE PLUGIN LOADING ONTO K8S ############################ END 


#########################APPLICATION DEPLOYMENT (NGINX)  ############################ START 
 
 
 
{
 
########----------->>>>>----->>>>>>----->

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
	
# 
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

#########################APPLICATION DEPLOYMENT (NGINX)  ############################ END 
 
 
 
 
 
 
#Access the pod and check enclaves
 
kubectl exec -it  $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | head -n 1) -- /bin/bash

##############################################################

	#Describe the nitro enclaves inside the pod 
	bash-4.2# 
			nitro-cli describe-enclaves

{
				bash-4.2# nitro-cli describe-enclaves
				[
				  {
					"EnclaveName": "nginx",
					"EnclaveID": "i-042fea7bcb28550a1-enc19a9dcbb3a08a0c",
					"ProcessID": 10,
					"EnclaveCID": 18,
					"NumberOfCPUs": 2,
					"CPUIDs": [
					  1,
					  5
					],
					"MemoryMiB": 2048,
					"State": "RUNNING",
					"Flags": "DEBUG_MODE",
					"Measurements": {
					  "HashAlgorithm": "Sha384 { ... }",
					  "PCR0": "0b52b26a4f70fabcfafe4e3d08efed16c4a1e4f94cf4a21b11738fae80b6d36dc250234020bc4f25a91dd5ad8599762c",
					  "PCR1": "0343b056cd8485ca7890ddd833476d78460aed2aa161548e4e26bedf321726696257d623e8805f3f605946b3d8b0c6aa",
					  "PCR2": "85ce5781141e43735b52a32929c9ee14577ac8926383f497d52b1f3de633e575850e5c30ab89966c5b196c43547ba223"
					}
				  }
				]
				bash-4.2#
}

##############################################################
			#Install tools  
			#This may not be required 
			
			#yum install -y procps-ng util-linux




{
	
kubectl exec -it  $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | head -n 1) -- /bin/bash
bash-4.2# nitro-cli describe-enclaves
[
  {
    "EnclaveName": "nginx",
    "EnclaveID": "i-01b6ed4bd7503a92b-enc19afda982ea2ea0",
    "ProcessID": 9,
    "EnclaveCID": 16,
    "NumberOfCPUs": 2,
    "CPUIDs": [
      1,
      5
    ],
    "MemoryMiB": 2048,
    "State": "RUNNING",
    "Flags": "NONE",
    "Measurements": {
      "HashAlgorithm": "Sha384 { ... }",
      "PCR0": "70f8e65fed4f9e05066f095e3923fbe4bd1059a727d5800aabcd80fa20dca4bc2dc6820de412ae2b3ffc5af5b1a30062",
      "PCR1": "0343b056cd8485ca7890ddd833476d78460aed2aa161548e4e26bedf321726696257d623e8805f3f605946b3d8b0c6aa",
      "PCR2": "bf38f600eb8fd76ca9d9d7d928ef43684182a48a1dea5da23c11033927fd5e9606a03f4ab06abbb35b5dd0ccbe517d8e"
    }
  }
]
bash-4.2# yum install -y procps-ng util-linux
Loaded plugins: ovl, priorities
amzn2-core                                                                                                                           | 3.6 kB  00:00:00     
(1/3): amzn2-core/2/x86_64/group_gz                                                                                                  | 2.7 kB  00:00:00     
(2/3): amzn2-core/2/x86_64/updateinfo                                                                                                | 1.2 MB  00:00:00     
(3/3): amzn2-core/2/x86_64/primary_db                                                                                                |  82 MB  00:00:00     
Resolving Dependencies
--> Running transaction check
---> Package procps-ng.x86_64 0:3.3.10-26.amzn2 will be installed
--> Processing Dependency: libsystemd.so.0(LIBSYSTEMD_209)(64bit) for package: procps-ng-3.3.10-26.amzn2.x86_64
--> Processing Dependency: libsystemd.so.0()(64bit) for package: procps-ng-3.3.10-26.amzn2.x86_64
---> Package util-linux.x86_64 0:2.30.2-2.amzn2.0.11 will be installed
--> Processing Dependency: libfdisk = 2.30.2-2.amzn2.0.11 for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libsmartcols = 2.30.2-2.amzn2.0.11 for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: audit-libs >= 1.0.6 for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: pam >= 1.1.3-7 for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: /etc/pam.d/system-auth for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libfdisk.so.1(FDISK_2.26)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libfdisk.so.1(FDISK_2.27)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libfdisk.so.1(FDISK_2.28)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libfdisk.so.1(FDISK_2.29)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libfdisk.so.1(FDISK_2.30)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libpam.so.0(LIBPAM_1.0)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libpam_misc.so.0(LIBPAM_MISC_1.0)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libsmartcols.so.1(SMARTCOLS_2.25)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libsmartcols.so.1(SMARTCOLS_2.27)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libsmartcols.so.1(SMARTCOLS_2.28)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libsmartcols.so.1(SMARTCOLS_2.29)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libsmartcols.so.1(SMARTCOLS_2.30)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libutempter.so.0(UTEMPTER_1.1)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libaudit.so.1()(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libcap-ng.so.0()(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libfdisk.so.1()(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libpam.so.0()(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libpam_misc.so.0()(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libsmartcols.so.1()(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libutempter.so.0()(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Running transaction check
---> Package audit-libs.x86_64 0:2.8.1-3.amzn2.1 will be installed
---> Package libcap-ng.x86_64 0:0.7.5-4.amzn2.0.4 will be installed
---> Package libfdisk.x86_64 0:2.30.2-2.amzn2.0.11 will be installed
---> Package libsmartcols.x86_64 0:2.30.2-2.amzn2.0.11 will be installed
---> Package libutempter.x86_64 0:1.1.6-4.amzn2.0.2 will be installed
--> Processing Dependency: shadow-utils for package: libutempter-1.1.6-4.amzn2.0.2.x86_64
---> Package pam.x86_64 0:1.1.8-23.amzn2.0.5 will be installed
--> Processing Dependency: cracklib-dicts >= 2.8 for package: pam-1.1.8-23.amzn2.0.5.x86_64
--> Processing Dependency: libpwquality >= 0.9.9 for package: pam-1.1.8-23.amzn2.0.5.x86_64
--> Processing Dependency: libcrack.so.2()(64bit) for package: pam-1.1.8-23.amzn2.0.5.x86_64
---> Package systemd-libs.x86_64 0:219-78.amzn2.0.24 will be installed
--> Processing Dependency: libdw.so.1()(64bit) for package: systemd-libs-219-78.amzn2.0.24.x86_64
--> Processing Dependency: liblz4.so.1()(64bit) for package: systemd-libs-219-78.amzn2.0.24.x86_64
--> Running transaction check
---> Package cracklib.x86_64 0:2.9.0-11.amzn2.0.2 will be installed
--> Processing Dependency: gzip for package: cracklib-2.9.0-11.amzn2.0.2.x86_64
---> Package cracklib-dicts.x86_64 0:2.9.0-11.amzn2.0.2 will be installed
---> Package elfutils-libs.x86_64 0:0.176-2.amzn2.0.2 will be installed
--> Processing Dependency: default-yama-scope for package: elfutils-libs-0.176-2.amzn2.0.2.x86_64
---> Package libpwquality.x86_64 0:1.2.3-5.amzn2 will be installed
---> Package lz4.x86_64 0:1.7.5-2.amzn2.0.2 will be installed
---> Package shadow-utils.x86_64 2:4.1.5.1-24.amzn2.0.3 will be installed
--> Processing Dependency: libsemanage.so.1(LIBSEMANAGE_1.0)(64bit) for package: 2:shadow-utils-4.1.5.1-24.amzn2.0.3.x86_64
--> Processing Dependency: libsemanage.so.1()(64bit) for package: 2:shadow-utils-4.1.5.1-24.amzn2.0.3.x86_64
--> Running transaction check
---> Package elfutils-default-yama-scope.noarch 0:0.176-2.amzn2.0.2 will be installed
--> Processing Dependency: systemd for package: elfutils-default-yama-scope-0.176-2.amzn2.0.2.noarch
--> Processing Dependency: systemd for package: elfutils-default-yama-scope-0.176-2.amzn2.0.2.noarch
---> Package gzip.x86_64 0:1.5-10.amzn2.0.1 will be installed
---> Package libsemanage.x86_64 0:2.5-11.amzn2 will be installed
--> Processing Dependency: libustr-1.0.so.1(USTR_1.0)(64bit) for package: libsemanage-2.5-11.amzn2.x86_64
--> Processing Dependency: libustr-1.0.so.1(USTR_1.0.1)(64bit) for package: libsemanage-2.5-11.amzn2.x86_64
--> Processing Dependency: libustr-1.0.so.1()(64bit) for package: libsemanage-2.5-11.amzn2.x86_64
--> Running transaction check
---> Package systemd.x86_64 0:219-78.amzn2.0.24 will be installed
--> Processing Dependency: kmod >= 18-4 for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: acl for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: dbus for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libcryptsetup.so.4(CRYPTSETUP_1.0)(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libkmod.so.2(LIBKMOD_5)(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libcryptsetup.so.4()(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libkmod.so.2()(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libqrencode.so.3()(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
---> Package ustr.x86_64 0:1.0.4-16.amzn2.0.3 will be installed
--> Running transaction check
---> Package acl.x86_64 0:2.2.51-14.amzn2 will be installed
---> Package cryptsetup-libs.x86_64 0:1.7.4-4.amzn2 will be installed
--> Processing Dependency: libdevmapper.so.1.02(Base)(64bit) for package: cryptsetup-libs-1.7.4-4.amzn2.x86_64
--> Processing Dependency: libdevmapper.so.1.02(DM_1_02_97)(64bit) for package: cryptsetup-libs-1.7.4-4.amzn2.x86_64
--> Processing Dependency: libdevmapper.so.1.02()(64bit) for package: cryptsetup-libs-1.7.4-4.amzn2.x86_64
---> Package dbus.x86_64 1:1.10.24-7.amzn2.0.4 will be installed
--> Processing Dependency: dbus-libs(x86-64) = 1:1.10.24-7.amzn2.0.4 for package: 1:dbus-1.10.24-7.amzn2.0.4.x86_64
--> Processing Dependency: libdbus-1.so.3(LIBDBUS_1_3)(64bit) for package: 1:dbus-1.10.24-7.amzn2.0.4.x86_64
--> Processing Dependency: libdbus-1.so.3(LIBDBUS_PRIVATE_1.10.24)(64bit) for package: 1:dbus-1.10.24-7.amzn2.0.4.x86_64
--> Processing Dependency: libdbus-1.so.3()(64bit) for package: 1:dbus-1.10.24-7.amzn2.0.4.x86_64
---> Package kmod.x86_64 0:25-3.amzn2.0.2 will be installed
---> Package kmod-libs.x86_64 0:25-3.amzn2.0.2 will be installed
---> Package qrencode-libs.x86_64 0:3.4.1-3.amzn2.0.2 will be installed
--> Running transaction check
---> Package dbus-libs.x86_64 1:1.10.24-7.amzn2.0.4 will be installed
---> Package device-mapper-libs.x86_64 7:1.02.170-6.amzn2.5 will be installed
--> Processing Dependency: device-mapper = 7:1.02.170-6.amzn2.5 for package: 7:device-mapper-libs-1.02.170-6.amzn2.5.x86_64
--> Running transaction check
---> Package device-mapper.x86_64 7:1.02.170-6.amzn2.5 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

============================================================================================================================================================
 Package                                         Arch                       Version                                    Repository                      Size
============================================================================================================================================================
Installing:
 procps-ng                                       x86_64                     3.3.10-26.amzn2                            amzn2-core                     292 k
 util-linux                                      x86_64                     2.30.2-2.amzn2.0.11                        amzn2-core                     2.3 M
Installing for dependencies:
 acl                                             x86_64                     2.2.51-14.amzn2                            amzn2-core                      82 k
 audit-libs                                      x86_64                     2.8.1-3.amzn2.1                            amzn2-core                      99 k
 cracklib                                        x86_64                     2.9.0-11.amzn2.0.2                         amzn2-core                      80 k
 cracklib-dicts                                  x86_64                     2.9.0-11.amzn2.0.2                         amzn2-core                     3.6 M
 cryptsetup-libs                                 x86_64                     1.7.4-4.amzn2                              amzn2-core                     224 k
 dbus                                            x86_64                     1:1.10.24-7.amzn2.0.4                      amzn2-core                     246 k
 dbus-libs                                       x86_64                     1:1.10.24-7.amzn2.0.4                      amzn2-core                     167 k
 device-mapper                                   x86_64                     7:1.02.170-6.amzn2.5                       amzn2-core                     297 k
 device-mapper-libs                              x86_64                     7:1.02.170-6.amzn2.5                       amzn2-core                     326 k
 elfutils-default-yama-scope                     noarch                     0.176-2.amzn2.0.2                          amzn2-core                      33 k
 elfutils-libs                                   x86_64                     0.176-2.amzn2.0.2                          amzn2-core                     289 k
 gzip                                            x86_64                     1.5-10.amzn2.0.1                           amzn2-core                     129 k
 kmod                                            x86_64                     25-3.amzn2.0.2                             amzn2-core                     111 k
 kmod-libs                                       x86_64                     25-3.amzn2.0.2                             amzn2-core                      59 k
 libcap-ng                                       x86_64                     0.7.5-4.amzn2.0.4                          amzn2-core                      25 k
 libfdisk                                        x86_64                     2.30.2-2.amzn2.0.11                        amzn2-core                     238 k
 libpwquality                                    x86_64                     1.2.3-5.amzn2                              amzn2-core                      84 k
 libsemanage                                     x86_64                     2.5-11.amzn2                               amzn2-core                     152 k
 libsmartcols                                    x86_64                     2.30.2-2.amzn2.0.11                        amzn2-core                     155 k
 libutempter                                     x86_64                     1.1.6-4.amzn2.0.2                          amzn2-core                      25 k
 lz4                                             x86_64                     1.7.5-2.amzn2.0.2                          amzn2-core                      98 k
 pam                                             x86_64                     1.1.8-23.amzn2.0.5                         amzn2-core                     717 k
 qrencode-libs                                   x86_64                     3.4.1-3.amzn2.0.2                          amzn2-core                      50 k
 shadow-utils                                    x86_64                     2:4.1.5.1-24.amzn2.0.3                     amzn2-core                     1.1 M
 systemd                                         x86_64                     219-78.amzn2.0.24                          amzn2-core                     5.0 M
 systemd-libs                                    x86_64                     219-78.amzn2.0.24                          amzn2-core                     409 k
 ustr                                            x86_64                     1.0.4-16.amzn2.0.3                         amzn2-core                      96 k

Transaction Summary
============================================================================================================================================================
Install  2 Packages (+27 Dependent packages)

Total download size: 16 M
Installed size: 56 M
Downloading packages:
(1/29): acl-2.2.51-14.amzn2.x86_64.rpm                                                                                               |  82 kB  00:00:00     
(2/29): audit-libs-2.8.1-3.amzn2.1.x86_64.rpm                                                                                        |  99 kB  00:00:00     
(3/29): cracklib-2.9.0-11.amzn2.0.2.x86_64.rpm                                                                                       |  80 kB  00:00:00     
(4/29): cryptsetup-libs-1.7.4-4.amzn2.x86_64.rpm                                                                                     | 224 kB  00:00:00     
(5/29): dbus-1.10.24-7.amzn2.0.4.x86_64.rpm                                                                                          | 246 kB  00:00:00     
(6/29): cracklib-dicts-2.9.0-11.amzn2.0.2.x86_64.rpm                                                                                 | 3.6 MB  00:00:00     
(7/29): dbus-libs-1.10.24-7.amzn2.0.4.x86_64.rpm                                                                                     | 167 kB  00:00:00     
(8/29): device-mapper-1.02.170-6.amzn2.5.x86_64.rpm                                                                                  | 297 kB  00:00:00     
(9/29): device-mapper-libs-1.02.170-6.amzn2.5.x86_64.rpm                                                                             | 326 kB  00:00:00     
(10/29): elfutils-default-yama-scope-0.176-2.amzn2.0.2.noarch.rpm                                                                    |  33 kB  00:00:00     
(11/29): elfutils-libs-0.176-2.amzn2.0.2.x86_64.rpm                                                                                  | 289 kB  00:00:00     
(12/29): gzip-1.5-10.amzn2.0.1.x86_64.rpm                                                                                            | 129 kB  00:00:00     
(13/29): kmod-25-3.amzn2.0.2.x86_64.rpm                                                                                              | 111 kB  00:00:00     
(14/29): kmod-libs-25-3.amzn2.0.2.x86_64.rpm                                                                                         |  59 kB  00:00:00     
(15/29): libcap-ng-0.7.5-4.amzn2.0.4.x86_64.rpm                                                                                      |  25 kB  00:00:00     
(16/29): libfdisk-2.30.2-2.amzn2.0.11.x86_64.rpm                                                                                     | 238 kB  00:00:00     
(17/29): libpwquality-1.2.3-5.amzn2.x86_64.rpm                                                                                       |  84 kB  00:00:00     
(18/29): libsemanage-2.5-11.amzn2.x86_64.rpm                                                                                         | 152 kB  00:00:00     
(19/29): libsmartcols-2.30.2-2.amzn2.0.11.x86_64.rpm                                                                                 | 155 kB  00:00:00     
(20/29): libutempter-1.1.6-4.amzn2.0.2.x86_64.rpm                                                                                    |  25 kB  00:00:00     
(21/29): lz4-1.7.5-2.amzn2.0.2.x86_64.rpm                                                                                            |  98 kB  00:00:00     
(22/29): pam-1.1.8-23.amzn2.0.5.x86_64.rpm                                                                                           | 717 kB  00:00:00     
(23/29): procps-ng-3.3.10-26.amzn2.x86_64.rpm                                                                                        | 292 kB  00:00:00     
(24/29): qrencode-libs-3.4.1-3.amzn2.0.2.x86_64.rpm                                                                                  |  50 kB  00:00:00     
(25/29): shadow-utils-4.1.5.1-24.amzn2.0.3.x86_64.rpm                                                                                | 1.1 MB  00:00:00     
(26/29): systemd-libs-219-78.amzn2.0.24.x86_64.rpm                                                                                   | 409 kB  00:00:00     
(27/29): systemd-219-78.amzn2.0.24.x86_64.rpm                                                                                        | 5.0 MB  00:00:00     
(28/29): ustr-1.0.4-16.amzn2.0.3.x86_64.rpm                                                                                          |  96 kB  00:00:00     
(29/29): util-linux-2.30.2-2.amzn2.0.11.x86_64.rpm                                                                                   | 2.3 MB  00:00:00     
------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                        54 MB/s |  16 MB  00:00:00     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : libcap-ng-0.7.5-4.amzn2.0.4.x86_64                                                                                                      1/29 
/sbin/ldconfig: /lib64/libz.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libpcre.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5support.so.0 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libkeyutils.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libk5crypto.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libgssapi_krb5.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/libcom_err.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/ld-linux-x86-64.so.2 is not a symbolic link

  Installing : audit-libs-2.8.1-3.amzn2.1.x86_64                                                                                                       2/29 
/sbin/ldconfig: /lib64/libz.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libpcre.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5support.so.0 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libkeyutils.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libk5crypto.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libgssapi_krb5.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/libcom_err.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/ld-linux-x86-64.so.2 is not a symbolic link

  Installing : lz4-1.7.5-2.amzn2.0.2.x86_64                                                                                                            3/29 
/sbin/ldconfig: /lib64/libz.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libpcre.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5support.so.0 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libkeyutils.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libk5crypto.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libgssapi_krb5.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/libcom_err.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/ld-linux-x86-64.so.2 is not a symbolic link

  Installing : kmod-libs-25-3.amzn2.0.2.x86_64                                                                                                         4/29 
/sbin/ldconfig: /lib64/libz.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libpcre.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5support.so.0 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libkeyutils.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libk5crypto.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libgssapi_krb5.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/libcom_err.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/ld-linux-x86-64.so.2 is not a symbolic link

  Installing : acl-2.2.51-14.amzn2.x86_64                                                                                                              5/29 
  Installing : kmod-25-3.amzn2.0.2.x86_64                                                                                                              6/29 
  Installing : ustr-1.0.4-16.amzn2.0.3.x86_64                                                                                                          7/29 
/sbin/ldconfig: /lib64/libz.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libpcre.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5support.so.0 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libkeyutils.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libk5crypto.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libgssapi_krb5.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/libcom_err.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/ld-linux-x86-64.so.2 is not a symbolic link

  Installing : libsemanage-2.5-11.amzn2.x86_64                                                                                                         8/29 
/sbin/ldconfig: /lib64/libz.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libpcre.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5support.so.0 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libkeyutils.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libk5crypto.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libgssapi_krb5.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/libcom_err.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/ld-linux-x86-64.so.2 is not a symbolic link

  Installing : 2:shadow-utils-4.1.5.1-24.amzn2.0.3.x86_64                                                                                              9/29 
  Installing : libutempter-1.1.6-4.amzn2.0.2.x86_64                                                                                                   10/29 
/sbin/ldconfig: /lib64/libz.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libpcre.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5support.so.0 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libkeyutils.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libk5crypto.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libgssapi_krb5.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/libcom_err.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/ld-linux-x86-64.so.2 is not a symbolic link

  Installing : qrencode-libs-3.4.1-3.amzn2.0.2.x86_64                                                                                                 11/29 
/sbin/ldconfig: /lib64/libz.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libpcre.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5support.so.0 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libkeyutils.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libk5crypto.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libgssapi_krb5.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/libcom_err.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/ld-linux-x86-64.so.2 is not a symbolic link

  Installing : libsmartcols-2.30.2-2.amzn2.0.11.x86_64                                                                                                12/29 
/sbin/ldconfig: /lib64/libz.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libpcre.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5support.so.0 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libkeyutils.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libk5crypto.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libgssapi_krb5.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/libcom_err.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/ld-linux-x86-64.so.2 is not a symbolic link

  Installing : libfdisk-2.30.2-2.amzn2.0.11.x86_64                                                                                                    13/29 
/sbin/ldconfig: /lib64/libz.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libpcre.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5support.so.0 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libkeyutils.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libk5crypto.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libgssapi_krb5.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/libcom_err.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/ld-linux-x86-64.so.2 is not a symbolic link

  Installing : gzip-1.5-10.amzn2.0.1.x86_64                                                                                                           14/29 
  Installing : cracklib-2.9.0-11.amzn2.0.2.x86_64                                                                                                     15/29 
/sbin/ldconfig: /lib64/libz.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libpcre.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5support.so.0 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libkeyutils.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libk5crypto.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libgssapi_krb5.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/libcom_err.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/ld-linux-x86-64.so.2 is not a symbolic link

  Installing : cracklib-dicts-2.9.0-11.amzn2.0.2.x86_64                                                                                               16/29 
  Installing : pam-1.1.8-23.amzn2.0.5.x86_64                                                                                                          17/29 
/sbin/ldconfig: /lib64/libz.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libpcre.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5support.so.0 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libkeyutils.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libk5crypto.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libgssapi_krb5.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/libcom_err.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/ld-linux-x86-64.so.2 is not a symbolic link

  Installing : libpwquality-1.2.3-5.amzn2.x86_64                                                                                                      18/29 
/sbin/ldconfig: /lib64/libz.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libpcre.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5support.so.0 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libkeyutils.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libk5crypto.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libgssapi_krb5.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/libcom_err.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/ld-linux-x86-64.so.2 is not a symbolic link

  Installing : util-linux-2.30.2-2.amzn2.0.11.x86_64                                                                                                  19/29 
  Installing : 7:device-mapper-1.02.170-6.amzn2.5.x86_64                                                                                              20/29 
  Installing : 7:device-mapper-libs-1.02.170-6.amzn2.5.x86_64                                                                                         21/29 
/sbin/ldconfig: /lib64/libz.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libpcre.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5support.so.0 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libkeyutils.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libk5crypto.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libgssapi_krb5.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/libcom_err.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/ld-linux-x86-64.so.2 is not a symbolic link

  Installing : cryptsetup-libs-1.7.4-4.amzn2.x86_64                                                                                                   22/29 
/sbin/ldconfig: /lib64/libz.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libpcre.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5support.so.0 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libkeyutils.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libk5crypto.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libgssapi_krb5.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/libcom_err.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/ld-linux-x86-64.so.2 is not a symbolic link

  Installing : elfutils-libs-0.176-2.amzn2.0.2.x86_64                                                                                                 23/29 
/sbin/ldconfig: /lib64/libz.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libpcre.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5support.so.0 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libkeyutils.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libk5crypto.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libgssapi_krb5.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/libcom_err.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/ld-linux-x86-64.so.2 is not a symbolic link

  Installing : systemd-libs-219-78.amzn2.0.24.x86_64                                                                                                  24/29 
/sbin/ldconfig: /lib64/libz.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libpcre.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5support.so.0 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libkeyutils.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libk5crypto.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libgssapi_krb5.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/libcom_err.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/ld-linux-x86-64.so.2 is not a symbolic link

  Installing : 1:dbus-libs-1.10.24-7.amzn2.0.4.x86_64                                                                                                 25/29 
/sbin/ldconfig: /lib64/libz.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libpcre.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5support.so.0 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libkeyutils.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libk5crypto.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libgssapi_krb5.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/libcom_err.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/ld-linux-x86-64.so.2 is not a symbolic link

  Installing : systemd-219-78.amzn2.0.24.x86_64                                                                                                       26/29 
Failed to get D-Bus connection: Operation not permitted
  Installing : 1:dbus-1.10.24-7.amzn2.0.4.x86_64                                                                                                      27/29 
  Installing : elfutils-default-yama-scope-0.176-2.amzn2.0.2.noarch                                                                                   28/29 
  Installing : procps-ng-3.3.10-26.amzn2.x86_64                                                                                                       29/29 
/sbin/ldconfig: /lib64/libz.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libpcre.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5support.so.0 is not a symbolic link

/sbin/ldconfig: /lib64/libkrb5.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libkeyutils.so.1 is not a symbolic link

/sbin/ldconfig: /lib64/libk5crypto.so.3 is not a symbolic link

/sbin/ldconfig: /lib64/libgssapi_krb5.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/libcom_err.so.2 is not a symbolic link

/sbin/ldconfig: /lib64/ld-linux-x86-64.so.2 is not a symbolic link

  Verifying  : 1:dbus-libs-1.10.24-7.amzn2.0.4.x86_64                                                                                                  1/29 
  Verifying  : lz4-1.7.5-2.amzn2.0.2.x86_64                                                                                                            2/29 
  Verifying  : gzip-1.5-10.amzn2.0.1.x86_64                                                                                                            3/29 
  Verifying  : libfdisk-2.30.2-2.amzn2.0.11.x86_64                                                                                                     4/29 
  Verifying  : 1:dbus-1.10.24-7.amzn2.0.4.x86_64                                                                                                       5/29 
  Verifying  : cracklib-2.9.0-11.amzn2.0.2.x86_64                                                                                                      6/29 
  Verifying  : 2:shadow-utils-4.1.5.1-24.amzn2.0.3.x86_64                                                                                              7/29 
  Verifying  : pam-1.1.8-23.amzn2.0.5.x86_64                                                                                                           8/29 
  Verifying  : cryptsetup-libs-1.7.4-4.amzn2.x86_64                                                                                                    9/29 
  Verifying  : 7:device-mapper-1.02.170-6.amzn2.5.x86_64                                                                                              10/29 
  Verifying  : systemd-libs-219-78.amzn2.0.24.x86_64                                                                                                  11/29 
  Verifying  : libutempter-1.1.6-4.amzn2.0.2.x86_64                                                                                                   12/29 
  Verifying  : elfutils-default-yama-scope-0.176-2.amzn2.0.2.noarch                                                                                   13/29 
  Verifying  : libsmartcols-2.30.2-2.amzn2.0.11.x86_64                                                                                                14/29 
  Verifying  : qrencode-libs-3.4.1-3.amzn2.0.2.x86_64                                                                                                 15/29 
  Verifying  : systemd-219-78.amzn2.0.24.x86_64                                                                                                       16/29 
  Verifying  : libpwquality-1.2.3-5.amzn2.x86_64                                                                                                      17/29 
  Verifying  : 7:device-mapper-libs-1.02.170-6.amzn2.5.x86_64                                                                                         18/29 
  Verifying  : util-linux-2.30.2-2.amzn2.0.11.x86_64                                                                                                  19/29 
  Verifying  : cracklib-dicts-2.9.0-11.amzn2.0.2.x86_64                                                                                               20/29 
  Verifying  : procps-ng-3.3.10-26.amzn2.x86_64                                                                                                       21/29 
  Verifying  : libcap-ng-0.7.5-4.amzn2.0.4.x86_64                                                                                                     22/29 
  Verifying  : audit-libs-2.8.1-3.amzn2.1.x86_64                                                                                                      23/29 
  Verifying  : ustr-1.0.4-16.amzn2.0.3.x86_64                                                                                                         24/29 
  Verifying  : kmod-25-3.amzn2.0.2.x86_64                                                                                                             25/29 
  Verifying  : acl-2.2.51-14.amzn2.x86_64                                                                                                             26/29 
  Verifying  : libsemanage-2.5-11.amzn2.x86_64                                                                                                        27/29 
  Verifying  : elfutils-libs-0.176-2.amzn2.0.2.x86_64                                                                                                 28/29 
  Verifying  : kmod-libs-25-3.amzn2.0.2.x86_64                                                                                                        29/29 

Installed:
  procps-ng.x86_64 0:3.3.10-26.amzn2                                         util-linux.x86_64 0:2.30.2-2.amzn2.0.11                                        

Dependency Installed:
  acl.x86_64 0:2.2.51-14.amzn2                              audit-libs.x86_64 0:2.8.1-3.amzn2.1          cracklib.x86_64 0:2.9.0-11.amzn2.0.2             
  cracklib-dicts.x86_64 0:2.9.0-11.amzn2.0.2                cryptsetup-libs.x86_64 0:1.7.4-4.amzn2       dbus.x86_64 1:1.10.24-7.amzn2.0.4                
  dbus-libs.x86_64 1:1.10.24-7.amzn2.0.4                    device-mapper.x86_64 7:1.02.170-6.amzn2.5    device-mapper-libs.x86_64 7:1.02.170-6.amzn2.5   
  elfutils-default-yama-scope.noarch 0:0.176-2.amzn2.0.2    elfutils-libs.x86_64 0:0.176-2.amzn2.0.2     gzip.x86_64 0:1.5-10.amzn2.0.1                   
  kmod.x86_64 0:25-3.amzn2.0.2                              kmod-libs.x86_64 0:25-3.amzn2.0.2            libcap-ng.x86_64 0:0.7.5-4.amzn2.0.4             
  libfdisk.x86_64 0:2.30.2-2.amzn2.0.11                     libpwquality.x86_64 0:1.2.3-5.amzn2          libsemanage.x86_64 0:2.5-11.amzn2                
  libsmartcols.x86_64 0:2.30.2-2.amzn2.0.11                 libutempter.x86_64 0:1.1.6-4.amzn2.0.2       lz4.x86_64 0:1.7.5-2.amzn2.0.2                   
  pam.x86_64 0:1.1.8-23.amzn2.0.5                           qrencode-libs.x86_64 0:3.4.1-3.amzn2.0.2     shadow-utils.x86_64 2:4.1.5.1-24.amzn2.0.3       
  systemd.x86_64 0:219-78.amzn2.0.24                        systemd-libs.x86_64 0:219-78.amzn2.0.24      ustr.x86_64 0:1.0.4-16.amzn2.0.3                 

Complete!

	
}




##############################################################
	#Open new terminal and get into the pod terminal 
	
	kubectl exec -it  $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | head -n 1) -- /bin/bash
 
	#This will fail as the enclave has been started using the DEBUG FLAG OFF
	nitro-cli console --enclave-name nginx

		{
			
		bash-4.2#  nitro-cli console --enclave-name nginx
		[ E44 ] Enclave console connection failure. Such error appears when the Nitro CLI process fails to establish a connection to a running enclaves console.

		For more details, please visit https://docs.aws.amazon.com/enclaves/latest/user/cli-errors.html#E44

		If you open a support ticket, please provide the error log found at "/var/log/nitro_enclaves/err2025-12-08T11:15:24.809590232+00:00.log"
		bash-4.2# 

			
		}
############################################################## 
		

 	kubectl exec -it  $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | head -n 1) -- /bin/bash
 
 
	# Get the CID dynamically
	CID=$(nitro-cli describe-enclaves | jq -r '.[0].EnclaveCID')

	# Use the dynamic CID in your socat command
	printf "GET / HTTP/1.1\r\nHost: localhost\r\n\r\n" | socat - VSOCK-CONNECT:${CID}:5000

	 
	 
#Attestation testing 

	# Get the CID dynamically
		CID=$(nitro-cli describe-enclaves | jq -r '.[0].EnclaveCID')

	# Get the CID dynamically
	CID=$(nitro-cli describe-enclaves | jq -r '.[0].EnclaveCID')

	# Use the dynamic CID in your socat command
	printf "GET / HTTP/1.1\r\nHost: localhost\r\n\r\n" | socat - VSOCK-CONNECT:${CID}:5000

	 



{

bash-4.2# printf "GET /attestation-status.json HTTP/1.1\r\nHost: localhost\r\n\r\n" | socat - VSOCK-CONNECT:${CID}:5000
HTTP/1.1 200 OK
Server: nginx/1.28.0
Date: Thu, 11 Dec 2025 16:05:00 GMT
Content-Type: application/json
Content-Length: 629
Last-Modified: Thu, 11 Dec 2025 16:01:26 GMT
Connection: keep-alive
ETag: "693aead6-275"
Accept-Ranges: bytes

{"status": "SUCCESS", "message": "Attestation passed", "details": "=== Testing KMS Attestation ===
/usr/local/lib/python3.9/site-packages/boto3/compat.py:89: PythonDeprecationWarning: Boto3 will no longer support Python 3.9 starting April 29, 2026. To continue receiving service updates, bug fixes, and security updates please upgrade to Python 3.10 or later. More information can be found here: https://aws.amazon.com/blogs/developer/python-support-policy-updates-for-aws-sdks-and-tools/
  warnings.warn(warning, PythonDeprecationWarning)
✘ ATTESTATION FAILED: Unable to locate credentials
=== Attestation test complete ==="}
bash-4.2# 


#Second attempt  

bash-4.2# printf "GET /attestation-status.json HTTP/1.1\r\nHost: localhost\r\n\r\n" | socat - VSOCK-CONNECT:${CID}:5000
HTTP/1.1 200 OK
Server: nginx/1.28.0
Date: Thu, 11 Dec 2025 16:50:38 GMT
Content-Type: application/json
Content-Length: 629
Last-Modified: Thu, 11 Dec 2025 16:33:05 GMT
Connection: keep-alive
ETag: "693af241-275"
Accept-Ranges: bytes

{"status": "SUCCESS", "message": "Attestation passed", "details": "=== Testing KMS Attestation ===
/usr/local/lib/python3.9/site-packages/boto3/compat.py:89: PythonDeprecationWarning: Boto3 will no longer support Python 3.9 starting April 29, 2026. To continue receiving service updates, bug fixes, and security updates please upgrade to Python 3.10 or later. More information can be found here: https://aws.amazon.com/blogs/developer/python-support-policy-updates-for-aws-sdks-and-tools/
  warnings.warn(warning, PythonDeprecationWarning)
✘ ATTESTATION FAILED: Unable to locate credentials
=== Attestation test complete ==="}
bash-4.2# 
bash-4.2# 




	
	
	
	
}
































	 
	
	 
	 
	 
	 
	{
		
	bash-4.2# # Get the CID dynamically
	bash-4.2# CID=$(nitro-cli describe-enclaves | jq -r '.[0].EnclaveCID')
	bash-4.2# 
	bash-4.2# # Use the dynamic CID in your socat command
	bash-4.2# printf "GET / HTTP/1.1\r\nHost: localhost\r\n\r\n" | socat - VSOCK-CONNECT:${CID}:5000
	HTTP/1.1 200 OK
	Server: nginx/1.28.0
	Date: Mon, 08 Dec 2025 11:16:29 GMT
	Content-Type: text/html
	Content-Length: 76
	Last-Modified: Mon, 08 Dec 2025 10:43:51 GMT
	Connection: keep-alive
	ETag: "6936abe7-4c"
	Accept-Ranges: bytes

	Hello from NGINX in Enclave via VSOCK proxy! PoC on Confidential Containers
	bash-4.2# 
	bash-4.2#  
		
	}	 
	 
			
##############################################################

#Portforward and curl - Open new terminal for portforward
kubectl port-forward pod/$(kubectl get pods --no-headers -o custom-columns=":metadata.name" | head -n 1) 8080:80


	{
			
		sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s/container/versionednginx/v2$ kubectl port-forward pod/$(kubectl get pods --no-headers -o custom-columns=":metadata.name" | head -n 1) 8080:80
		Forwarding from 127.0.0.1:8080 -> 80
		Forwarding from [::1]:8080 -> 80
		Handling connection for 8080

	}


#In another terminal 
curl http://localhost:8080/

	{
		sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s/container/versionednginx/v2$ curl http://localhost:8080/

		 
		Hello from NGINX in Enclave via VSOCK proxy! PoC on Confidential Containers
		sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s/container/versionednginx/v2$ 

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
