

##############ONE TIME ACTIVITY ############# ONE TIME ACTIVITY  ONE TIME ACTIVITY  ONE TIME ACTIVITY  START
#On ubuntu host
{
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
			
 
#Commented intentionaly. This is already copied, no need to copy again
 
sed -i 's/\r$//' *
chmod +x *.sh
sudo apt install dos2unix
dos2unix *.sh

}
##############ONE TIME ACTIVITY ############# ONE TIME ACTIVITY  ONE TIME ACTIVITY  ONE TIME ACTIVITY  END


 
#For Linux 
 
cd /home/sridhara/Downloads/3-aws-scripts-eks-coco-linux/create

#Below This step will be required to be executed every one hour as the token expires after one hour. 
#First time: sridhara_shastry / password / google authenticator mfa


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


####K8 deployments 
cd /home/sridhara/Downloads


#Install Nitro Enclaves Device Plugin on aws kubernetes 
kubectl apply -f https://raw.githubusercontent.com/aws/aws-nitro-enclaves-k8s-device-plugin/main/aws-nitro-enclaves-k8s-ds.yaml
kubectl get ns

#Label the node 
kubectl get nodes
#Get if label is already available
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{" "}{.metadata.labels.aws-nitro-enclaves-k8s-dp}{"\n"}{end}'

#Label the node by fetching name dynamically. 
kubectl label node $(kubectl get nodes -o jsonpath='{.items[0].metadata.name}') aws-nitro-enclaves-k8s-dp=enabled

#Validate once labelled
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{" "}{.metadata.labels.aws-nitro-enclaves-k8s-dp}{"\n"}{end}'

#ONE TIME ACTIVITY 
#Setup Enclave Tools. 

 
cd /home/sridhara/Downloads
#Get enclave related utilities and packages. This step may not needed as it is already fetched and ready 
git clone https://github.com/aws/aws-nitro-enclaves-with-k8s.git
ls -l
cd aws-nitro-enclaves-with-k8s
pwd
ls -l

#make the location of env.sh part of executable search path.
source env.sh

#Check docker images. Better cleanup if any existing images exist, by using docker rmi
docker images
docker ps 

#Remove container first followed by all images. #This step is executed, if there are any existing   dangling images / containers etc. 
docker rm 89f81e0f7c93  and others 
docker rmi 13dc1c221a1e  and others



#Clean any previous setups
./enclavectl cleanup
#Configure enclavectl. The enclavectl configure --file settings.json command initializes the enclavectl tool itself, not cluster configuration. Since we have created our cluster manually (not with enclavectl), the settings.json values are completely IGNORED and wont affect existing setup. This is just a mandatory tool initialization step required before we can use other enclavectl commands like enclavectl build. Hence, this step is mandatory as per documentation. 
./enclavectl configure --file settings.json




#Build a simple docker image. The enclavectl build --image hello command builds the Hello Enclaves sample application from the /container/hello directory.It converts the Docker image into a Nitro Enclave image file (.eif) and packages it into a Docker container for Kubernetes deployment. This automates the process of creating both the enclave image file and the Kubernetes-ready Docker image in one step.
./enclavectl build --image hello
#Wait for 5 minutes. 



#Check docker images, we should have some base images that get built automatically. Here get the docker image name for necessary tagging ahead. 
docker images	

#Docker login 
docker login

#Check username that has logged in vis-a-vis Docker Hub 
docker info | grep -i usernamee

#Docker tag the image using the name. Use the correct image name. 
docker tag hello-xxxxx:latest nerdysrisha/hello-aws-nitro:latest

#Docker push the tagged image to docker hub 
docker push nerdysrisha/hello-aws-nitro:latest





#Switch to create directory 
cd /home/sridhara/Downloads/3-aws-scripts-eks-coco-linux/create
ls -l file*.*

#Convert to unix
dos2unix file6-hello-deployment.yaml



#Create namespace and switch
kubectl create namespace integrations
kubectl config set-context --current --namespace=integrations




#apply the deployment yaml and get pods
kubectl apply -f file6-hello-deployment.yaml

kubectl get pods
#Access the pod and check enclaves
kubectl exec -it xxxxx -n integrations -- /bin/bash

	#Describe the nitro enclaves inside the pod 
	bash-4.2# nitro-cli describe-enclaves
#Exit the terminal 
	bash-4.2# exit
 
 
#######CREATE BASTION AND ACCESS THE WORKER NODE ##### not tested yet

 
cd /home/sridhara/Downloads/3-aws-scripts-eks-coco-linux/create
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
