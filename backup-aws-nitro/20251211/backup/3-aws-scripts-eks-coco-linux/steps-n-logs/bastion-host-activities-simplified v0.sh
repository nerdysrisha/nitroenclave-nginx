
###################################IGNORE ALL ABOVE 
 
#ON BASTIONHOST: Download kubectl 
	curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.3/2023-11-14/bin/linux/amd64/kubectl

#ON BASTIONHOST: Make the kubectl executatble and also move it to proper location like /bin

	chmod +x ./kubectl && sudo mv ./kubectl /usr/local/bin
 
##ON BASTIONHOST: Configure AWS Credentials in Bastion. Obtain below values from Initial AWS access
#Obtain Credentials (Keys) of AWS 

	AWS_ACCESS_KEY_ID="ASIA5HFZTBRAOEMKNI66"
	AWS_SECRET_ACCESS_KEY="sOH4BT4iSphoBuCWYJq14d5zXPoJP5rBU8s9Ezul"
	AWS_SESSION_TOKEN="Ixxxxxxxxxxxxxxxthis gets expiredxxxxxxxxxxx need to fetch again after expiry "


#ON BASTIONHOST: Run below command and provide the details like id and secret along with region and format

	aws configure

#ON BASTIONHOST: Add the token to the session 

	aws configure set aws_session_token "Ixxxxxxxxxxxxxxxthis gets expiredxxxxxxxxxxx need to fetch again after expiry "

#ON BASTIONHOST: Test the access 

	aws sts get-caller-identity

#ON BASTIONHOST: Configure cluster 


	aws eks update-kubeconfig --region eu-west-1 --name eks-coco
 


#ON BASTIONHOST: Fetch nodes. This may result in failure. Like below. Cat the config to see the version 

	kubectl get nodes

	#This was NOT working on bastion so ignored this step.
	#Instead used the SSH option from BASTION to WORKER NODE

 
#From your local (OR HOST) machine, COPY the .pem file to Bastion.
#Note we have applied same key for bastion ec2 and also workernode ec2 in configuration. Hence same key works for both while accessing / copying etc. 

#ON WINDOWS HOST: Syntax:  scp -i <your-bastion-key.pem> <your-worker-key.pem> ec2-user@<bastion-public-ip>:~/
	
	scp -i coco-eks-key.pem   coco-eks-key.pem ec2-user@3.249.239.65:~/
 
 
###################################IGNORE ALL ABOVE 
 
 
 
 
 
 

 
#Activities on the Bastion Host   ------ start from here 
 
 
 
 
 
 
 
#ON BASTIONHOST:
#Check if it is copied to bastion 

	ls -l
 

#Change the permissions 

	chmod 400 coco-eks-key.pem
 

#ON HOST MACHINE (WINDOWS) : Get private IP of worker node. From Host machine. Important 
 	
	kubectl get nodes -o wide

#ON HOST MACHINE (WINDOWS) : Get Security Group ID using the private IP of worker node. 

 	aws ec2 describe-instances --filters "Name=private-ip-address,Values=10.1.1.19" --query 'Reservations[*].Instances[*].SecurityGroups[*].GroupId' --output table --region eu-west-1
	 

#ON HOST MACHINE (WINDOWS) :  Check SSH Port is allowed in the security group of worker node. 

#Usually it is not allowed by default and will not have the rule. 

	aws ec2 describe-security-groups --group-ids sg-0be89234f52456550 --region eu-west-1 --query 'SecurityGroups[*].IpPermissions[?FromPort==`22`]'


#ON BASTIONHOST: Get Security Group ID 'OF' bastion host itself, using IMDS endpoint. 

#Note: 169.254.169.254 is an internal/private IP address! 🎯
#It's the AWS Instance Metadata Service (IMDS) endpoint - a special link-local address that's only accessible from WITHIN any EC2 instance.
#When you run that command on the bastion terminal, you're querying the bastion's own metadata, not reaching out to any external/public IP.
#That's why it returned the bastion's security group - because you're asking "what's MY security group?" from the bastion's perspective! 

	curl -s http://169.254.169.254/latest/meta-data/instance-id | xargs -I {} aws ec2 describe-instances --instance-ids {} --region eu-west-1 --query 'Reservations[*].Instances[*].SecurityGroups[*].GroupId' --output text
 

#ON BASTIONHOST: Add ssh configuration to Security Group. 

	aws ec2 authorize-security-group-ingress --group-id sg-0be89234f52456550 --protocol tcp --port 22 --source-group sg-03843ec28e98e7300 --region eu-west-1


#ON BASTIONHOST: Verify the configuration  

	aws ec2 describe-security-groups --group-ids sg-0be89234f52456550 --region eu-west-1 --query 'SecurityGroups[*].IpPermissions[?FromPort==`22`]'
	

#ON BASTIONHOST: Connect to the worker node using the PRIVATE ip. 

	ssh -i coco-eks-key.pem ec2-user@10.1.1.19
	
	
 




#NOW WE ARE INSIDE THE WORKER NODE --- REMEMBER 


#Install Nitro Enclaves on this node, or
#Use a custom AMI with Nitro Enclaves pre-installed


#ON WORKERNODE: Check the linux version 

	cat /etc/os-release
		 
 
#ON WORKERNODE: Install docker 

	sudo yum install -y docker
		 


#ON WORKERNODE: Check docker commands 

	docker ps
	docker images
	docker container ls
 	 

#ON WORKERNODE: INSTALL THE NITRO-ENCLAVES-CLI  

	sudo yum install -y aws-nitro-enclaves-cli 
	#There are important instructions in the output. Refer the detailed sheet for the same. 
	#nitro-cli - The command line tool
	#nitro-enclaves-allocator - Service that manages CPU/memory allocation
	#nitro-enclaves-vsock-proxy - Handles communication between parent and enclave
	#Kernel drivers - For enclave and vsock devices

#ON WORKERNODE: Start allocator 
	sudo systemctl start nitro-enclaves-allocator

#ON WORKERNODE: enable nitro enclaves allocator  

	sudo systemctl enable nitro-enclaves-allocator
 

#ON WORKERNODE:  Install 

	# First, add your user to the 'ne' group
	sudo usermod -a -G ne ec2-user

	# Check the allocator configuration. notice the memory and cpu information in response. 
	cat /etc/nitro_enclaves/allocator.yaml

	# Start and enable the allocator service (as you mentioned you'll run)
	sudo systemctl start nitro-enclaves-allocator.service
	sudo systemctl enable nitro-enclaves-allocator.service

	# After starting the services, you'll need to log out and back in 
	# for the group membership to take effect, OR run:
	newgrp ne

 	# Check if the allocator service is running properly
	sudo systemctl status nitro-enclaves-allocator

  	# Install the devel package which should contain the kernel blobs
	sudo yum install -y aws-nitro-enclaves-cli-devel

	# Check if blobs directory exists now. we should the few folders and files. If they are missing, then installation did not go well. 
	ls -la /usr/share/nitro_enclaves/blobs/
 
 
#ON WORKERNODE:  Build and Run Hello World App  

	# Now let's try building a simple enclave again. This command will give few details about image. 
	nitro-cli build-enclave --docker-uri hello-world --output-file hello.eif
	
	#Check local directory 
	ls -l

	# If that works, let's also check our allocated resources are working. This will not give anything or empty response as nitro-app is not started. 
	nitro-cli describe-enclaves
			#The empty [] from describe-enclaves is correct - it means no enclaves are currently running (which is expected since we just built the image but haven't launched it yet).

 
	# Launch the enclave with the image we just built
	nitro-cli run-enclave --cpu-count 2 --memory 512 --eif-path hello.eif --debug-mode

	# Check if it's running. Note that this still gives an empty response. 
	nitro-cli describe-enclaves
		#The [] from describe-enclaves is actually expected behavior here. The hello-world container runs, prints its message, and then exits immediately - so by the time you run describe-enclaves, it's already finished!




#ON WORKERNODE:  Build and Run Long Running Process or app (Eg. nginx)   



	nitro-cli build-enclave --docker-uri nginx --output-file nginx.eif
	ls -l

	# Change memory from 512 to 1024 using sed so that nginx app could be run easily. 
	sudo sed -i 's/memory_mib: 512/memory_mib: 1024/' /etc/nitro_enclaves/allocator.yaml

	# Verify the change
	cat /etc/nitro_enclaves/allocator.yaml

	# Restart the allocator service
	sudo systemctl restart nitro-enclaves-allocator

	# Now run nginx with 756 MB (minimum required)
	nitro-cli run-enclave --cpu-count 2 --memory 756 --eif-path nginx.eif --debug-mode

	# Now check if it's running. Now this should give some response with Enclave ID. 
	nitro-cli describe-enclaves

	# Try console connection to the running nginx enclave
	nitro-cli console --enclave-name nginx


	 
 
#ON HOST MACHINE (WINDOWS) : Build Java Application. 

 	# Run this in powershell 
	cd C:\ws\sboot\lab053b
	mvn clean package

	#Run this in bash shell 
	cd /c/ws/sboot/lab053b/target 
	ls -l

	#SCP the jar file from Host to Bastion 
	scp -i "C:/ws/cocopoc/3-aws-scripts-eks-coco/create/coco-eks-key.pem" payments-0.0.1-SNAPSHOT.jar ec2-user@3.249.239.65:/home/ec2-user/
		 
#ON WORKERNODE: Exit from worker node and come back to bastion ec2

	exit

#ON BASTIONHOST: Check the copied files

	pwd
	ls -l
	
	
#ON HOST MACHINE (WINDOWS) : Get private IP of worker node. From Host machine. Important 
 	
	kubectl get nodes -o wide

	
#ON BASTIONHOST: Move the jar file from bastion to worker node using the private ip fetched in above step. 

	scp -i coco-eks-key.pem payments-0.0.1-SNAPSHOT.jar ec2-user@10.1.1.19:/home/ec2-user/
 

#ON BASTIONHOST: SSH back to worker node using the private IP of workernode. 
	ls -l
	ssh -i coco-eks-key.pem ec2-user@10.1.1.19
 
#ON WORKERNODE: Check the jar file is copied or not

	ls -l
 

#ON WORKERNODE: Create a docker file 

# Create new Dockerfile with Java 17

#Attempt 1 - did not work 

cat > Dockerfile << 'EOF'
# Single stage - much simpler
FROM eclipse-temurin:22-jre-alpine
WORKDIR /app
COPY payments-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
EXPOSE 8080
EOF




#ON WORKERNODE: Check its creation and execute a cat of the same. 

	ls -l
	cat Dockerfile
	 



#ON WORKERNODE: Build docker and list the images. 

	docker build -t payments-app . 
	docker images
 
		

	 

#ON WORKERNODE: Run docker image as Deamon, so that we can run other commands easily. 

	# Run with port mapping
	docker run -d --name payments-app-test -p 8080:8080 payments-app:latest
	docker ps

#ON WORKERNODE: Test the curl. Single line curl 


	curl -X POST http://localhost:8080/payment/process -H "Content-Type: application/json" -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.fake.payload" -H "X-Message-Id: MSG-12345" -d '{"accountNumber": "123456789","creditCardNumber": "4111111111111111","expiryDate": "12/28","cvv": "123","amount": 500.00,"destinationAccount": "987654321","senderName": "John Doe","receiverName": "Jane Smith"}'

 

#ON WORKERNODE: Stop the container and remove 

	docker stop payments-app-test
	docker rm payments-app-test
 

#ON WORKERNODE: Build Nitro Enclave Image File (EIF) from Docker Image

#What happens during EIF build process:
#• Extracts Docker layers - Unpacks the container filesystem • Creates bootable kernel - Adds minimal Linux kernel for enclave • Packages application code - Bundles your app into the EIF format • Generates cryptographic measurements - Creates PCR0, PCR1, PCR2 hashes • Optimizes for enclave runtime - Removes unnecessary components • Creates single .eif file - Self-contained enclave image ready to run
#Key outputs: • PCR0 - Hash of the enclave image file itself • PCR1 - Hash of Linux kernel and bootstrap • PCR2 - Hash of your application code • Ready-to-run .eif file - Can be launched with nitro-cli run-enclave
#Think of it as: Docker image → Specialized enclave-ready bootable image! 

	ls -l
	nitro-cli build-enclave --docker-uri payments-app:latest --output-file payments-app.eif 
	ls -l
 
	#Note that at this stage we still have not LAUNCHED THE NITRO ENCLAVE. 
	#List all running enclaves, at this stage we should get empty response. 
	nitro-cli describe-enclaves
	
#BELOW ARE OPTIONAL. Termination of enclaves. 

#ON WORKERNODE: List current enclaves
	nitro-cli describe-enclaves
		 

#ON WORKERNODE: Terminate all enclaves (replace ENCLAVE-ID with actual ID)

	nitro-cli terminate-enclave --enclave-id i-085fa5ca0e3bda2cb-enc199a65df9f4c82b
 
#ON WORKERNODE: Run java app in nitro enclave. THIS DID NOT WORK 

	nitro-cli run-enclave --cpu-count 2 --memory 1024 --eif-path payments-app.eif --debug-mode




#Attempt 2 - did not work

# Create new Dockerfile for enclave
cat > Dockerfile << 'EOF'
FROM eclipse-temurin:22-jre-alpine
WORKDIR /app
COPY payments-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-Xmx512m", "-jar", "app.jar", "--server.address=0.0.0.0", "--server.port=8080"]
EXPOSE 8080
EOF



#ON WORKERNODE: Removing existing docker images. REBUILDING 

	ls -l
	docker images
	docker ps
	docker rmi payments-app


#ON WORKERNODE: Buidling the docker images 

	docker build -t payments-app .
 
#ON WORKERNODE:Build Nitro enclave app

	nitro-cli build-enclave --docker-uri payments-app:latest --output-file payments-app.eif
	#List enclaves, we should get empty as we have not run any yet. 
	nitro-cli describe-enclaves
 
	#Run now with more memory 
	nitro-cli run-enclave --cpu-count 2 --memory 1536 --eif-path payments-app.eif --debug-mode
	
	
	
	
	
	
	
	
