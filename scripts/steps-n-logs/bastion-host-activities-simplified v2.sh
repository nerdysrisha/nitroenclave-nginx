#Follow these after running the j3-copy-bastion-files-tobastion-host.sh
#which copies four files to bastion host. 

#ON BASTIONHOST: Get Security Group ID 'OF' bastion host itself, using IMDS endpoint. 

	ls -l
	# Fix line endings for ALL files in current directory
	sed -i 's/\r$//' *

	# Make all shell scripts executable
	chmod +x *.sh
	chmod 600 coco-eks-key.pem


	#Configure AWS Crendeitlas 
	./file-bastion-configure-aws-on-bastion.sh
	 
	
	
	#Just to connect without any transfers 
	./file-bastion-just-ssh-no-transfer.sh


	 #Connect and transfer files
	./file-bastion-allow-ssh-and-connect-to-workernode.sh
	 
	 
	 
	 
 
 
#NOW WE ARE INSIDE THE WORKER NODE --- REMEMBER 


#Install Nitro Enclaves on this node, or
#Use a custom AMI with Nitro Enclaves pre-installed

sed -i 's/\r$//' *
chmod +x *.sh
./file-nitro-file-install-tools-build-nginx-enclave.sh

   

#ON WORKERNODE: Create a docker file 

# Create new Dockerfile with Java 17

#Attempt 1 - did not work 

{

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


}



#Attempt 2 - did not work


{
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
	
	
	
	
	
}
	
	
#Attempt 3 ??


{

[ec2-user@ip-10-1-0-206 ~]$ ls -l
total 212460
-rw-r--r-- 1 root     root     197515395 Oct  5 12:52 nginx.eif
-rwxr-xr-x 1 ec2-user ec2-user       963 Oct  5 12:46 nitro-file-install-tools-build-nginx-enclave.sh
-rw-r--r-- 1 ec2-user ec2-user  20035490 Oct  5 12:46 payments-0.0.1-SNAPSHOT.jar
[ec2-user@ip-10-1-0-206 ~]$ docker images
permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Head "http://%2Fvar%2Frun%2Fdocker.sock/_ping": dial unix /var/run/docker.sock: connect: permission denied
[ec2-user@ip-10-1-0-206 ~]$ sudo docker images
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
nginx        latest    203ad09fc156   7 weeks ago   192MB
[ec2-user@ip-10-1-0-206 ~]$
[ec2-user@ip-10-1-0-206 ~]$ cat > Dockerfile xxxxxx removed the following content for formatting sake 




[ec2-user@ip-10-1-0-206 ~]$ ls -l
total 212464
-rw-rw-r-- 1 ec2-user ec2-user       202 Oct  5 13:09 Dockerfile
-rw-r--r-- 1 root     root     197515395 Oct  5 12:52 nginx.eif
-rwxr-xr-x 1 ec2-user ec2-user       963 Oct  5 12:46 nitro-file-install-tools-build-nginx-enclave.sh
-rw-r--r-- 1 ec2-user ec2-user  20035490 Oct  5 12:46 payments-0.0.1-SNAPSHOT.jar


[ec2-user@ip-10-1-0-206 ~]$ cat Dockerfile
FROM eclipse-temurin:22-jre-alpine
WORKDIR /app
COPY payments-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-Xmx512m", "-jar", "app.jar", "--server.address=0.0.0.0", "--server.port=8080"]
EXPOSE 8080
[ec2-user@ip-10-1-0-206 ~]$



[ec2-user@ip-10-1-0-206 ~]$ sudo docker build -t payments-app .
[+] Building 5.0s (8/8) FINISHED                                                                                                                                                                                            docker:default
 => [internal] load build definition from Dockerfile                                                                                                                                                                                  0.0s
 => => transferring dockerfile: 241B 
 TRUNCATED
 TRUNCATED
 
 f3757a0a4a6523bd125e5f4efedc278f0                                                                                                                                          0.0s
 => => naming to docker.io/library/payments-app                                                                                                                                                                                       0.0s
[ec2-user@ip-10-1-0-206 ~]$







#Build image

[ec2-user@ip-10-1-0-206 ~]$ sudo docker images
REPOSITORY     TAG       IMAGE ID       CREATED              SIZE
payments-app   latest    5d5eab013596   About a minute ago   209MB
nginx          latest    203ad09fc156   7 weeks ago          192MB
[ec2-user@ip-10-1-0-206 ~]$
[ec2-user@ip-10-1-0-206 ~]$ sudo nitro-cli build-enclave --docker-uri payments-app:latest --output-file payments-app.eif
Start building the Enclave Image...
Using the locally available Docker image...
Enclave Image successfully created.
{
  "Measurements": {
    "HashAlgorithm": "Sha384 { ... }",
    "PCR0": "49ac0d9697faa9721bdeedfcf359692b77e1987055d47242cfd731cbce1511bb717127ba3ec7615e0d13fccda20020d5",
    "PCR1": "0343b056cd8485ca7890ddd833476d78460aed2aa161548e4e26bedf321726696257d623e8805f3f605946b3d8b0c6aa",
    "PCR2": "71fe86c32c2f7f6deaae5a096cb50d8ea216461d71b1fa7f5b45ee25b387f95bace57dc2ad02c132e9fc267992194ade"
  }
}
[ec2-user@ip-10-1-0-206 ~]$




#Check Check available resources:


[ec2-user@ip-10-1-0-206 ~]$ sudo nitro-cli describe-eif --eif-path payments-app.eif
{
  "EifVersion": 4,
  "Measurements": {
    "HashAlgorithm": "Sha384 { ... }",
    "PCR0": "49ac0d9697faa9721bdeedfcf359692b77e1987055d47242cfd731cbce1511bb717127ba3ec7615e0d13fccda20020d5",
    "PCR1": "0343b056cd8485ca7890ddd833476d78460aed2aa161548e4e26bedf321726696257d623e8805f3f605946b3d8b0c6aa",
    "PCR2": "71fe86c32c2f7f6deaae5a096cb50d8ea216461d71b1fa7f5b45ee25b387f95bace57dc2ad02c132e9fc267992194ade"
  },
  "IsSigned": false,
  "CheckCRC": true,
  "ImageName": "payments-app",
  "ImageVersion": "5d5eab013596bd8ff495d1dd161b248f3757a0a4a6523bd125e5f4efedc278f0",
  "Metadata": {
    "BuildTime": "2025-10-05T13:12:27.410516995+00:00",
    "BuildTool": "nitro-cli",
    "BuildToolVersion": "1.4.2",
    "OperatingSystem": "Linux",
    "KernelVersion": "4.14.256",
    "DockerInfo": {
      "Architecture": "amd64",
      "Author": "",
      "Comment": "buildkit.dockerfile.v0",
      "Config": {
        "AttachStderr": false,
        "AttachStdin": false,
        "AttachStdout": false,
        "Domainname": "",
        "Entrypoint": [
          "java",
          "-Xmx512m",
          "-jar",
          "app.jar",
          "--server.address=0.0.0.0",
          "--server.port=8080"
        ],
        "Env": [
          "PATH=/opt/java/openjdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
          "JAVA_HOME=/opt/java/openjdk",
          "LANG=en_US.UTF-8",
          "LANGUAGE=en_US:en",
          "LC_ALL=en_US.UTF-8",
          "JAVA_VERSION=jdk-22.0.2+9"
        ],
        "ExposedPorts": {
          "8080/tcp": {}
        },
        "Hostname": "",
        "Image": "",
        "OpenStdin": false,
        "StdinOnce": false,
        "Tty": false,
        "User": "",
        "WorkingDir": "/app"
      },
      "Container": "",
      "ContainerConfig": {
        "AttachStderr": false,
        "AttachStdin": false,
        "AttachStdout": false,
        "Domainname": "",
        "Hostname": "",
        "Image": "",
        "OpenStdin": false,
        "StdinOnce": false,
        "Tty": false,
        "User": "",
        "WorkingDir": ""
      },
      "Created": "2025-10-05T13:10:39.52630426Z",
      "DockerVersion": "",
      "GraphDriver": {
        "Data": {
          "LowerDir": "/var/lib/docker/overlay2/bcyatoknuqu5xlon63atl10b4/diff:/var/lib/docker/overlay2/f5738ba22b0635d05407076bd0497a0a59715b073db32db1737c413f92fb6b7f/diff:/var/lib/docker/overlay2/acb1eed95e14f3657fae5c52ca02fc1a98ad24eb364c114ea9b980691fb392c5/diff:/var/lib/docker/overlay2/a9a363cf8f1071f5a994a5fbc73438a8dfdb747c9db52b7014e29eede9aeb842/diff:/var/lib/docker/overlay2/a73a51c15c52c66729545c4b2ded3cd0cca22238fb1b21541f49beda2679f7ae/diff:/var/lib/docker/overlay2/704b26cd4683571264030697eb3429aa4c12205ee9a4f4ec2abbeb0ec475c38d/diff",
          "MergedDir": "/var/lib/docker/overlay2/4e3p4wk1da3y1bm40pwsc6kxe/merged",
          "UpperDir": "/var/lib/docker/overlay2/4e3p4wk1da3y1bm40pwsc6kxe/diff",
          "WorkDir": "/var/lib/docker/overlay2/4e3p4wk1da3y1bm40pwsc6kxe/work"
        },
        "Name": "overlay2"
      },
      "Id": "sha256:5d5eab013596bd8ff495d1dd161b248f3757a0a4a6523bd125e5f4efedc278f0",
      "Metadata": {
        "LastTagTime": "2025-10-05T13:10:39.664263788Z"
      },
      "Os": "linux",
      "Parent": "",
      "RepoDigests": [],
      "RepoTags": [
        "payments-app:latest"
      ],
      "RootFS": {
        "Layers": [
          "sha256:63ca1fbb43ae5034640e5e6cb3e083e05c290072c5366fcaa9d62435a4cced85",
          "sha256:01d3f5d5a6c9da3fd6eac9064dae0c1bb3e20d25d5df871344931ca2db309c6c",
          "sha256:45902e2f75e61914908800d426593fb17ce6c267c30122ea48ee33c9d680a04b",
          "sha256:0d5f80a7ddd1127c17de3421bdfe9c5ae9a53fbbcbcbbce033063ca20b2e0696",
          "sha256:5dfbb3dccaaa972ed424fccbec18e7da83b43a333311caf18483dcaf84000d0a",
          "sha256:18928442d50ed1eeb2bbe87d3cbabf33446ecc52e11953120b75290566b779c7",
          "sha256:e11049d476c5b0bcd61d66bcda21c8f37e0bbadc5f5ebc4abc21f956fe2fce3e"
        ],
        "Type": "layers"
      },
      "Size": 208650970
    }
  }
}
[ec2-user@ip-10-1-0-206 ~]$



[ec2-user@ip-10-1-0-206 ~]$ sudo nitro-cli run-enclave --cpu-count 1 --memory 512 --enclave-cid 16 --eif-path payments-app.eif
[ E26 ] Insufficient memory requested. User provided `memory` is 512 MB, but based on the EIF file size, the minimum memory should be 820 MB



sudo nitro-cli run-enclave --cpu-count 1 --memory 820 --enclave-cid 16 --eif-path payments-app.eif


[ec2-user@ip-10-1-0-206 ~]$ sudo nitro-cli run-enclave --cpu-count 1 --memory 820 --enclave-cid 16 --eif-path payments-app.eif
[ E29 ] Ioctl failure. Such error is used as a general ioctl error and appears whenever an ioctl fails. In this case, the error backtrace provides detailed information on what specifically failed during the ioctl.

For more details, please visit https://docs.aws.amazon.com/enclaves/latest/user/cli-errors.html#E29

If you open a support ticket, please provide the error log found at "/var/log/nitro_enclaves/err2025-10-05T13:14:56.731022593+00:00.log"
Failed connections: 1
[ E39 ] Enclave process connection failure. Such error appears when the enclave manager fails to connect to at least one enclave process for retrieving the description information.

For more details, please visit https://docs.aws.amazon.com/enclaves/latest/user/cli-errors.html#E39

If you open a support ticket, please provide the error log found at "/var/log/nitro_enclaves/err2025-10-05T13:14:56.731348514+00:00.log"
[ec2-user@ip-10-1-0-206 ~]$






[ec2-user@ip-10-1-0-206 ~]$ free -m
              total        used        free      shared  buff/cache   available
Mem:          15524        1400       10967           2        3156       13837
Swap:             0           0           0
[ec2-user@ip-10-1-0-206 ~]$ nproc
2
[ec2-user@ip-10-1-0-206 ~]$ sudo nitro-cli describe-enclaves
[
  {
    "EnclaveName": "nginx",
    "EnclaveID": "i-078485c44ae5a4c2e-enc199b46fe989c74b",
    "ProcessID": 38507,
    "EnclaveCID": 16,
    "NumberOfCPUs": 2,
    "CPUIDs": [
      1,
      3
    ],
    "MemoryMiB": 1024,
    "State": "RUNNING",
    "Flags": "DEBUG_MODE",
    "Measurements": {
      "HashAlgorithm": "Sha384 { ... }",
      "PCR0": "d5182754070779a5909ce4b83b967f6173dec9a7a679bdd4fc5ecf2627bd8d9761eb7ccf518826bde8bb584ff4f62fae",
      "PCR1": "0343b056cd8485ca7890ddd833476d78460aed2aa161548e4e26bedf321726696257d623e8805f3f605946b3d8b0c6aa",
      "PCR2": "2f8e4a26a68d59d294c3eaf405be652637c62c4ae6ee87c272a9118e933c23f1ccaef2b122b65df838a707caf641ce17"
    }
  }
]
[ec2-user@ip-10-1-0-206 ~]$



#Terminate existing enclave 

[ec2-user@ip-10-1-0-206 ~]$ sudo nitro-cli terminate-enclave --enclave-id i-078485c44ae5a4c2e-enc199b46fe989c74b
Successfully terminated enclave i-078485c44ae5a4c2e-enc199b46fe989c74b.
{
  "EnclaveName": "nginx",
  "EnclaveID": "i-078485c44ae5a4c2e-enc199b46fe989c74b",
  "Terminated": true
}
[ec2-user@ip-10-1-0-206 ~]$





#it did not run despite killing existing enclave 

[ec2-user@ip-10-1-0-206 ~]$ cat /proc/meminfo | grep -i huge
AnonHugePages:         0 kB
ShmemHugePages:        0 kB
FileHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
Hugetlb:         1048576 kB
[ec2-user@ip-10-1-0-206 ~]$


#allocate the hugepages

[ec2-user@ip-10-1-0-206 ~]$ sudo sysctl vm.nr_hugepages=512
vm.nr_hugepages = 512
[ec2-user@ip-10-1-0-206 ~]$ cat /proc/meminfo | grep -i huge
AnonHugePages:         0 kB
ShmemHugePages:        0 kB
FileHugePages:         0 kB
HugePages_Total:     512
HugePages_Free:      512
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
Hugetlb:         2097152 kB
[ec2-user@ip-10-1-0-206 ~]$

[ec2-user@ip-10-1-0-206 ~]$ cat /proc/meminfo | grep HugePages_Total
HugePages_Total:     512
[ec2-user@ip-10-1-0-206 ~]$



#run again 
failed



[ec2-user@ip-10-1-0-206 ~]$ sudo dmesg | grep -i nitro
[ 4353.291286] nitro_enclaves: No CPUs available in CPU pool
[ 4353.296825] nitro_enclaves: Error in setup CPU pool [rc=-22]
[ 4356.761907] nitro_enclaves: No CPUs available in CPU pool
[ 4356.767121] nitro_enclaves: Error in setup CPU pool [rc=-22]
[ 4745.785846] nitro_enclaves: No CPUs available in CPU pool
[ 4745.791015] nitro_enclaves: Error in setup CPU pool [rc=-22]
[ 5880.364021] misc nitro_enclaves: No CPUs available in CPU pool
[ 5999.331666] misc nitro_enclaves: No CPUs available in CPU pool
[ 6128.816143] misc nitro_enclaves: Full CPU cores not used
[ 6242.832846] misc nitro_enclaves: Full CPU cores not used
[ec2-user@ip-10-1-0-206 ~]$




























}