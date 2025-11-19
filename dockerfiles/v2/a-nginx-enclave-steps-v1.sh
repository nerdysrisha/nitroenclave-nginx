

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
			
#Copy file from Host to Linux. One time excercise. If already copied no need to run this 

ls -l 
#Commented intentionaly. This is already copied, no need to copy again
#cp -r /media/sf_ws/cocopoc/3-aws-scripts-eks-coco ~/Downloads/

sed -i 's/\r$//' *
chmod +x *.sh
sudo apt install dos2unix
dos2unix *.sh

}
##############ONE TIME ACTIVITY ############# ONE TIME ACTIVITY  ONE TIME ACTIVITY  ONE TIME ACTIVITY  END


 
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



#Docker login if not logged in, as we will need to push to dockerhub. 
docker login
 

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
	./enclavectl build --image coconginx  


	docker images
	docker ps -a

#Dynamically tagging the coconginx-xxxxxx:xxxx to appropriate one as in the command. 
	docker images --format '{{.Repository}}:{{.Tag}}' | grep '^coconginx-' | while read image; do
	  docker tag "$image" nerdysrisha/nginx-aws-nitro:latest
	done

	docker images
 
#Push the image to docker hub. 
docker push nerdysrisha/nginx-aws-nitro:latest



#Below LOGIN step will be required to be executed every one hour as the token expires after one hour. 
#First time: sridhara_shastry / password / google authenticator mfa

#For clean up 
cd /home/sridhara/Downloads/3-aws-scripts-eks-coco-linux/cleanup


cd /home/sridhara/Downloads/3-aws-scripts-eks-coco-linux/create
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
 

#Install Nitro Enclaves Device Plugin on aws kubernetes 
	kubectl apply -f https://raw.githubusercontent.com/aws/aws-nitro-enclaves-k8s-device-plugin/main/aws-nitro-enclaves-k8s-ds.yaml
	kubectl get ns

#Label the node 
	kubectl get nodes
 
#Label the node by fetching name dynamically. 
	kubectl label node $(kubectl get nodes -o jsonpath='{.items[0].metadata.name}') aws-nitro-enclaves-k8s-dp=enabled

#Validate once labelled
	kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{" "}{.metadata.labels.aws-nitro-enclaves-k8s-dp}{"\n"}{end}'

#Switch to create directory 
	cd /home/sridhara/Downloads/3-aws-scripts-eks-coco-linux/create
	ls -l file*.*




#Create namespace and switch
	kubectl create namespace integrations
	kubectl config set-context --current --namespace=integrations

 

#For simple nginx 
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
	cd /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s/container/versionednginx/v2/
	kubectl delete -f vsock-nginx-deployment.yaml
	kubectl get pods
	
	
	#Create Deployment 
	cd /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s/container/versionednginx/v2/
	dos2unix *.yaml
	kubectl apply -f vsock-nginx-deployment.yaml 
	kubectl get pods
	 
}


#Get logs 
kubectl get pods
kubectl logs $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | head -n 1)


#Describe pod 
kubectl describe pod $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | head -n 1)

 
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
			yum install -y procps-ng util-linux

##############################################################
	#Open this in a diffrent terminal 
	nitro-cli console --enclave-name nginx


{


		bash-4.2# nitro-cli console --enclave-name nginx
		Connecting to the console for enclave 18...
		Successfully connected to the console.
		0 Nov 19 20:21 conf.d
		drwxr-xr-x  2 root root    40 Aug 12 21:19 default.d
		-rw-r--r--  1 root root  1077 Aug 12 21:19 fastcgi.conf
		-rw-r--r--  1 root root  1077 Aug 12 21:19 fastcgi.conf.default
		-rw-r--r--  1 root root  1007 Aug 12 21:19 fastcgi_params
		-rw-r--r--  1 root root  1007 Aug 12 21:19 fastcgi_params.default
		-rw-r--r--  1 root root  2837 Aug 12 21:19 koi-utf
		-rw-r--r--  1 root root  2223 Aug 12 21:19 koi-win
		-rw-r--r--  1 root root 35272 Feb  1  2023 mime.types
		-rw-r--r--  1 root root  5349 Aug 12 21:19 mime.types.default
		-rw-r--r--  1 root root  2262 Nov 19 20:21 nginx.conf
		-rw-r--r--  1 root root  2656 Aug 12 21:19 nginx.conf.default
		-rw-r--r--  1 root root   636 Aug 12 21:19 scgi_params
		-rw-r--r--  1 root root   636 Aug 12 21:19 scgi_params.default
		-rw-r--r--  1 root root   664 Aug 12 21:19 uwsgi_params
		-rw-r--r--  1 root root   664 Aug 12 21:19 uwsgi_params.default
		-rw-r--r--  1 root root  3611 Aug 12 21:19 win-utf
		+ ls -la /etc/nginx/conf.d/
		total 4
		drwxr-xr-x 2 root root  60 Nov 19 20:21 .
		drwxr-xr-x 4 root root 380 Nov 19 20:21 ..
		-rw-r--r-- 1 root root  66 Nov 19 20:21 default.conf
		+ echo 'Default config content:'
		Default config content:
		+ cat /etc/nginx/conf.d/default.conf
		server { listen 8080; location / { root /usr/share/nginx/html; }}
		+ echo 'Main nginx.conf relevant lines:'
		Main nginx.conf relevant lines:
		+ grep -v '^#' /etc/nginx/nginx.conf
		+ grep -v '^$'
		user nginx;
		worker_processes auto;
		error_log /var/log/nginx/error.log notice;
		pid /run/nginx.pid;
		include /usr/share/nginx/modules/*.conf;
		events {
			worker_connections 1024;
		}
		http {
			log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
							  '$status $body_bytes_sent "$http_referer" '
							  '"$http_user_agent" "$http_x_forwarded_for"';
			access_log  /var/log/nginx/access.log  main;
			sendfile            on;
			tcp_nopush          on;
			keepalive_timeout   65;
			types_hash_max_size 4096;
			include             /etc/nginx/mime.types;
			default_type        application/octet-stream;
			# Load modular configuration files from the /etc/nginx/conf.d directory.
			# See http://nginx.org/en/docs/ngx_core_module.html#include
			# for more information.
			include /etc/nginx/conf.d/*.conf;
			server {
				server_name  _;
				root         /usr/share/nginx/html;
				# Load configuration files for the default server block.
				include /etc/nginx/default.d/*.conf;
				error_page 404 /404.html;
				location = /404.html {
				}
				error_page 500 502 503 504 /50x.html;
				location = /50x.html {
				}
			}
		}
		+ echo '=== Starting nginx ==='
		=== Starting nginx ===
		+ NGINX_PID=607
		+ echo 'Nginx PID: 607'
		+ nginx -g 'daemon off;'
		Nginx PID: 607
		+ echo 'Nginx started on port 8080'
		Nginx started on port 8080
		+ echo '=== Waiting for nginx to initialize ==='
		=== Waiting for nginx to initialize ===
		+ sleep 3
		+ echo '=== Post-nginx start debugging ==='
		=== Post-nginx start debugging ===
		+ echo 'Process list:'
		Process list:
		+ ps aux
		USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
		root         1 28.0  0.0   1024     4 ?        S    20:26   0:00 /init nomodules
		root         2  0.0  0.0      0     0 ?        S    20:26   0:00 [kthreadd]
		root         3  0.0  0.0      0     0 ?        I    20:26   0:00 [kworker/0:0]
		root         4  0.0  0.0      0     0 ?        I<   20:26   0:00 [kworker/0:0H]
		root         5  0.3  0.0      0     0 ?        I    20:26   0:00 [kworker/u4:0]
		root         6  0.0  0.0      0     0 ?        I<   20:26   0:00 [mm_percpu_wq]
		root         7  0.0  0.0      0     0 ?        S    20:26   0:00 [ksoftirqd/0]
		root         8  0.0  0.0      0     0 ?        I    20:26   0:00 [rcu_sched]
		root         9  0.0  0.0      0     0 ?        I    20:26   0:00 [rcu_bh]
		root        10  0.0  0.0      0     0 ?        S    20:26   0:00 [migration/0]
		root        11  0.0  0.0      0     0 ?        S    20:26   0:00 [watchdog/0]
		root        12  0.0  0.0      0     0 ?        S    20:26   0:00 [cpuhp/0]
		root        13  0.0  0.0      0     0 ?        S    20:26   0:00 [cpuhp/1]
		root        14  0.0  0.0      0     0 ?        S    20:26   0:00 [watchdog/1]
		root        15  1.0  0.0      0     0 ?        S    20:26   0:00 [migration/1]
		root        16  0.0  0.0      0     0 ?        S    20:26   0:00 [ksoftirqd/1]
		root        17  0.0  0.0      0     0 ?        I    20:26   0:00 [kworker/1:0]
		root        18  0.0  0.0      0     0 ?        I<   20:26   0:00 [kworker/1:0H]
		root        19  0.0  0.0      0     0 ?        S    20:26   0:00 [kdevtmpfs]
		root        20  0.0  0.0      0     0 ?        I<   20:26   0:00 [netns]
		root        21  0.0  0.0      0     0 ?        I    20:26   0:00 [kworker/u4:1]
		root        32  0.0  0.0      0     0 ?        I    20:26   0:00 [kworker/0:1]
		root        33  0.0  0.0      0     0 ?        I    20:26   0:00 [kworker/0:2]
		root       118  0.0  0.0      0     0 ?        I    20:26   0:00 [kworker/u4:2]
		root       122  0.0  0.0      0     0 ?        S    20:26   0:00 [khungtaskd]
		root       221  0.0  0.0      0     0 ?        I    20:26   0:00 [kworker/1:1]
		root       222  0.0  0.0      0     0 ?        S    20:26   0:00 [oom_reaper]
		root       223  0.0  0.0      0     0 ?        I<   20:26   0:00 [writeback]
		root       225  0.0  0.0      0     0 ?        S    20:26   0:00 [kcompactd0]
		root       226  0.0  0.0      0     0 ?        SN   20:26   0:00 [ksmd]
		root       227  0.0  0.0      0     0 ?        SN   20:26   0:00 [khugepaged]
		root       228  0.0  0.0      0     0 ?        I<   20:26   0:00 [crypto]
		root       229  0.0  0.0      0     0 ?        I<   20:26   0:00 [kintegrityd]
		root       231  0.0  0.0      0     0 ?        I<   20:26   0:00 [kblockd]
		root       328  0.0  0.0      0     0 ?        I<   20:26   0:00 [rpciod]
		root       329  0.0  0.0      0     0 ?        I<   20:26   0:00 [xprtiod]
		root       352  0.0  0.0      0     0 ?        S    20:26   0:00 [kauditd]
		root       358  0.0  0.0      0     0 ?        S    20:26   0:00 [kswapd0]
		root       436  0.0  0.0      0     0 ?        I<   20:26   0:00 [kworker/u5:0]
		root       447  0.0  0.0      0     0 ?        I<   20:26   0:00 [nfsiod]
		root       496  0.0  0.0      0     0 ?        I<   20:26   0:00 [kthrotld]
		root       549  0.0  0.0      0     0 ?        I<   20:26   0:00 [iscsi_eh]
		root       563  0.0  0.0      0     0 ?        I<   20:26   0:00 [ipv6_addrconf]
		root       572  0.0  0.0      0     0 ?        I<   20:26   0:00 [kstrp]
		root       592  0.0  0.0      0     0 ?        S    20:26   0:00 [hwrng]
		root       594  0.6  0.1   4244  3340 ?        Ss   20:26   0:00 /bin/bash /star
		root       607  0.6  0.5  16624 10260 ?        S    20:26   0:00 nginx: master p
		nginx      609  0.0  0.1  17056  3264 ?        S    20:26   0:00 nginx: worker p
		nginx      610  0.0  0.1  17056  3264 ?        S    20:26   0:00 nginx: worker p
		root       612  0.0  0.0      0     0 ?        I    20:26   0:00 [kworker/1:2]
		root       613  0.0  0.1   4816  2664 ?        R    20:26   0:00 ps aux
		+ echo 'Listening ports after nginx start:'
		Listening ports after nginx start:
		+ ss -tlnp
		State  Recv-Q Send-Q Local Address:Port Peer Address:PortProcess                                                                      
		LISTEN 0      128          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=610,fd=9),("nginx",pid=609,fd=9),("nginx",pid=607,fd=9))
		LISTEN 0      128          0.0.0.0:8080      0.0.0.0:*    users:(("nginx",pid=610,fd=8),("nginx",pid=609,fd=8),("nginx",pid=607,fd=8))
		+ echo 'Nginx process check:'
		Nginx process check:
		+ ps aux
		+ grep nginx
		root       607  0.5  0.5  16624 10260 ?        S    20:26   0:00 nginx: master process nginx -g daemon off;
		nginx      609  0.0  0.1  17056  3264 ?        S    20:26   0:00 nginx: worker process
		nginx      610  0.0  0.1  17056  3264 ?        S    20:26   0:00 nginx: worker process
		root       616  0.0  0.0   3476  1472 ?        S    20:26   0:00 grep nginx
		+ echo '=== Testing local nginx connectivity ==='
		=== Testing local nginx connectivity ===
		+ echo 'Testing 127.0.0.1:8080:'
		Testing 127.0.0.1:8080:
		+ curl -v --connect-timeout 5 http://127.0.0.1:8080/
		*   Trying 127.0.0.1:8080...
		* Connected to 127.0.0.1 (127.0.0.1) port 8080
		* using HTTP/1.x
		> GET / HTTP/1.1
		> Host: 127.0.0.1:8080
		> User-Agent: curl/8.11.1
		> Accept: */*
		> 
		* Request completely sent off
		< HTTP/1.1 200 OK
		< Server: nginx/1.28.0
		< Date: Wed, 19 Nov 2025 20:26:14 GMT
		< Content-Type: text/html
		< Content-Length: 76
		< Last-Modified: Wed, 19 Nov 2025 20:21:39 GMT
		< Connection: keep-alive
		< ETag: "691e26d3-4c"
		< Accept-Ranges: bytes
		< 
		Hello from NGINX in Enclave via VSOCK proxy! PoC on Confidential Containers
		* Connection #0 to host 127.0.0.1 left intact
		+ echo 'Testing localhost:8080:'
		Testing localhost:8080:
		+ curl -v --connect-timeout 5 http://localhost:8080/
		* Host localhost:8080 was resolved.
		* IPv6: ::1
		* IPv4: 127.0.0.1
		*   Trying [::1]:8080...
		* connect to ::1 port 8080 from ::1 port 34736 failed: Connection refused
		*   Trying 127.0.0.1:8080...
		* Connected to localhost (127.0.0.1) port 8080
		* using HTTP/1.x
		> GET / HTTP/1.1
		> Host: localhost:8080
		> User-Agent: curl/8.11.1
		> Accept: */*
		> 
		* Request completely sent off
		< HTTP/1.1 200 OK
		< Server: nginx/1.28.0
		< Date: Wed, 19 Nov 2025 20:26:14 GMT
		< Content-Type: text/html
		< Content-Length: 76
		< Last-Modified: Wed, 19 Nov 2025 20:21:39 GMT
		< Connection: keep-alive
		< ETag: "691e26d3-4c"
		< Accept-Ranges: bytes
		< 
		Hello from NGINX in Enclave via VSOCK proxy! PoC on Confidential Containers
		* Connection #0 to host localhost left intact
		+ echo 'Testing 0.0.0.0:8080:'
		Testing 0.0.0.0:8080:
		+ curl -v --connect-timeout 5 http://0.0.0.0:8080/
		*   Trying 0.0.0.0:8080...
		* Connected to 0.0.0.0 (0.0.0.0) port 8080
		* using HTTP/1.x
		> GET / HTTP/1.1
		> Host: 0.0.0.0:8080
		> User-Agent: curl/8.11.1
		> Accept: */*
		> 
		< HTTP/1.1 200 OK
		< Server: nginx/1.28.0
		< Date: Wed, 19 Nov 2025 20:26:14 GMT
		< Content-Type: text/html
		< Content-Length: 76
		< Last-Modified: Wed, 19 Nov 2025 20:21:39 GMT
		< Connection: keep-alive
		< ETag: "691e26d3-4c"
		< Accept-Ranges: bytes
		< 
		Hello from NGINX in Enclave via VSOCK proxy! PoC on Confidential Containers
		* Connection #0 to host 0.0.0.0 left intact
		+ echo '=== Network interface details ==='
		=== Network interface details ===
		+ echo '/etc/hosts content:'
		/etc/hosts content:
		+ cat /etc/hosts
		127.0.0.1       localhost
		::1     localhost ip6-localhost ip6-loopback
		fe00::0 ip6-localnet
		ff00::0 ip6-mcastprefix
		ff02::1 ip6-allnodes
		ff02::2 ip6-allrouters
		+ echo '=== Starting VSOCK proxy ==='
		=== Starting VSOCK proxy ===
		+ echo 'VSOCK proxy command: socat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080'
		VSOCK proxy command: socat VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080
		+ VSOCK_PID=621
		+ echo 'VSOCK proxy PID: 621'
		VSOCK proxy PID: 621
		+ echo 'VSOCK proxy started on port 5000'
		VSOCK proxy started on port 5000
		+ echo '=== Final system state ==='
		=== Final system state ===
		+ socat -d -d VSOCK-LISTEN:5000,fork TCP:0.0.0.0:8080
		+ echo 'All processes:'
		All processes:
		+ ps aux
		USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
		root         1 21.0  0.0   1024     4 ?        S    20:26   0:00 /init nomodules
		root         2  0.0  0.0      0     0 ?        S    20:26   0:00 [kthreadd]
		2025/11/19 20:26:14 socat[621] W ioctl(-1, IOCTL_VM_SOCKETS_GET_LOCAL_CID, ...): Bad file descriptor
		root         3  0.0  0.0      0     0 ?        I    20:26   0:00 [kworker/0:0]
		2025/11/19 20:26:14 socat[621] N listening on AF=40 cid:4294967295 port:5000
		root         4  0.0  0.0      0     0 ?        I<   20:26   0:00 [kworker/0:0H]
		root         5  0.2  0.0      0     0 ?        I    20:26   0:00 [kworker/u4:0]
		root         6  0.0  0.0      0     0 ?        I<   20:26   0:00 [mm_percpu_wq]
		root         7  0.0  0.0      0     0 ?        S    20:26   0:00 [ksoftirqd/0]
		root         8  0.0  0.0      0     0 ?        I    20:26   0:00 [rcu_sched]
		root         9  0.0  0.0      0     0 ?        I    20:26   0:00 [rcu_bh]
		root        10  0.0  0.0      0     0 ?        S    20:26   0:00 [migration/0]
		root        11  0.0  0.0      0     0 ?        S    20:26   0:00 [watchdog/0]
		root        12  0.0  0.0      0     0 ?        S    20:26   0:00 [cpuhp/0]
		root        13  0.0  0.0      0     0 ?        S    20:26   0:00 [cpuhp/1]
		root        14  0.0  0.0      0     0 ?        S    20:26   0:00 [watchdog/1]
		root        15  0.7  0.0      0     0 ?        S    20:26   0:00 [migration/1]
		root        16  0.0  0.0      0     0 ?        S    20:26   0:00 [ksoftirqd/1]
		root        17  0.0  0.0      0     0 ?        I    20:26   0:00 [kworker/1:0]
		root        18  0.0  0.0      0     0 ?        I<   20:26   0:00 [kworker/1:0H]
		root        19  0.0  0.0      0     0 ?        S    20:26   0:00 [kdevtmpfs]
		root        20  0.0  0.0      0     0 ?        I<   20:26   0:00 [netns]
		root        21  0.0  0.0      0     0 ?        I    20:26   0:00 [kworker/u4:1]
		root        32  0.0  0.0      0     0 ?        I    20:26   0:00 [kworker/0:1]
		root        33  0.0  0.0      0     0 ?        I    20:26   0:00 [kworker/0:2]
		root       118  0.0  0.0      0     0 ?        I    20:26   0:00 [kworker/u4:2]
		root       122  0.0  0.0      0     0 ?        S    20:26   0:00 [khungtaskd]
		root       221  0.0  0.0      0     0 ?        I    20:26   0:00 [kworker/1:1]
		root       222  0.0  0.0      0     0 ?        S    20:26   0:00 [oom_reaper]
		root       223  0.0  0.0      0     0 ?        I<   20:26   0:00 [writeback]
		root       225  0.0  0.0      0     0 ?        S    20:26   0:00 [kcompactd0]
		root       226  0.0  0.0      0     0 ?        SN   20:26   0:00 [ksmd]
		root       227  0.0  0.0      0     0 ?        SN   20:26   0:00 [khugepaged]
		root       228  0.0  0.0      0     0 ?        I<   20:26   0:00 [crypto]
		root       229  0.0  0.0      0     0 ?        I<   20:26   0:00 [kintegrityd]
		root       231  0.0  0.0      0     0 ?        I<   20:26   0:00 [kblockd]
		root       328  0.0  0.0      0     0 ?        I<   20:26   0:00 [rpciod]
		root       329  0.0  0.0      0     0 ?        I<   20:26   0:00 [xprtiod]
		root       352  0.0  0.0      0     0 ?        S    20:26   0:00 [kauditd]
		root       358  0.0  0.0      0     0 ?        S    20:26   0:00 [kswapd0]
		root       436  0.0  0.0      0     0 ?        I<   20:26   0:00 [kworker/u5:0]
		root       447  0.0  0.0      0     0 ?        I<   20:26   0:00 [nfsiod]
		root       496  0.0  0.0      0     0 ?        I<   20:26   0:00 [kthrotld]
		root       549  0.0  0.0      0     0 ?        I<   20:26   0:00 [iscsi_eh]
		root       563  0.0  0.0      0     0 ?        I<   20:26   0:00 [ipv6_addrconf]
		root       572  0.0  0.0      0     0 ?        I<   20:26   0:00 [kstrp]
		root       592  0.0  0.0      0     0 ?        S    20:26   0:00 [hwrng]
		root       594  0.7  0.1   4244  3344 ?        Ss   20:26   0:00 /bin/bash /star
		root       607  0.5  0.5  16624 10260 ?        S    20:26   0:00 nginx: master p
		nginx      609  0.0  0.1  17056  3264 ?        S    20:26   0:00 nginx: worker p
		nginx      610  0.0  0.1  17056  3264 ?        S    20:26   0:00 nginx: worker p
		root       612  0.0  0.0      0     0 ?        I    20:26   0:00 [kworker/1:2]
		root       621  0.0  0.1  10092  2820 ?        S    20:26   0:00 socat -d -d VSO
		root       622  0.0  0.1   4816  2528 ?        R    20:26   0:00 ps aux
		+ echo 'All listening ports:'
		All listening ports:
		+ ss -tlnp
		State  Recv-Q Send-Q Local Address:Port Peer Address:PortProcess                                                                      
		LISTEN 0      128          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=610,fd=9),("nginx",pid=609,fd=9),("nginx",pid=607,fd=9))
		LISTEN 0      128          0.0.0.0:8080      0.0.0.0:*    users:(("nginx",pid=610,fd=8),("nginx",pid=609,fd=8),("nginx",pid=607,fd=8))
		+ echo '=== Startup complete - waiting for connections ==='
		=== Startup complete - waiting for connections ===
		+ echo 'Nginx PID: 607, VSOCK PID: 621'
		Nginx PID: 607, VSOCK PID: 621
		+ wait
		[  416.732470] NSM RNG: returning rand bytes = 64
		2025/11/19 20:35:15 socat[621] N accepting connection from AF=40 cid:3 port:740193739 on AF=40 cid:18 port:5000
		2025/11/19 20:35:15 socat[621] N forked off child process 624
		2025/11/19 20:35:15 socat[621] N listening on AF=40 cid:4294967295 port:5000
		2025/11/19 20:35:15 socat[624] N opening connection to AF=2 0.0.0.0:8080
		2025/11/19 20:35:15 socat[624] N successfully connected from local address AF=2 127.0.0.1:44472
		2025/11/19 20:35:15 socat[624] N starting data transfer loop with FDs [6,6] and [5,5]
		2025/11/19 20:35:15 socat[624] N socket 1 (fd 6) is at EOF
		2025/11/19 20:35:15 socat[624] N socket 2 (fd 5) is at EOF
		2025/11/19 20:35:15 socat[624] N exiting with status 0
		2025/11/19 20:35:15 socat[621] N childdied(): handling signal 17
		2025/11/19 20:36:43 socat[621] N accepting connection from AF=40 cid:3 port:740193743 on AF=40 cid:18 port:5000
		2025/11/19 20:36:43 socat[621] N forked off child process 625
		2025/11/19 20:36:43 socat[621] N listening on AF=40 cid:4294967295 port:5000
		2025/11/19 20:36:43 socat[625] N opening connection to AF=2 0.0.0.0:8080
		2025/11/19 20:36:43 socat[625] N successfully connected from local address AF=2 127.0.0.1:44474
		2025/11/19 20:36:43 socat[625] N starting data transfer loop with FDs [6,6] and [5,5]
		2025/11/19 20:36:43 socat[625] N socket 1 (fd 6) is at EOF
		2025/11/19 20:36:43 socat[625] N socket 2 (fd 5) is at EOF
		2025/11/19 20:36:43 socat[625] N exiting with status 0
		2025/11/19 20:36:43 socat[621] N childdied(): handling signal 17
		[  779.228514] NSM RNG: returning rand bytes = 64

		####After firing curl requests 
		
		[  779.228514] NSM RNG: returning rand bytes = 64
		2025/11/19 20:43:22 socat[621] N accepting connection from AF=40 cid:3 port:740193757 on AF=40 cid:18 port:5000
		2025/11/19 20:43:22 socat[621] N forked off child process 626
		2025/11/19 20:43:22 socat[621] N listening on AF=40 cid:4294967295 port:5000
		2025/11/19 20:43:22 socat[626] N opening connection to AF=2 0.0.0.0:8080
		2025/11/19 20:43:22 socat[626] N successfully connected from local address AF=2 127.0.0.1:44476
		2025/11/19 20:43:22 socat[626] N starting data transfer loop with FDs [6,6] and [5,5]
		2025/11/19 20:43:23 socat[626] N socket 1 (fd 6) is at EOF
		2025/11/19 20:43:23 socat[626] N socket 2 (fd 5) is at EOF
		2025/11/19 20:43:23 socat[626] N exiting with status 0
		2025/11/19 20:43:23 socat[621] N childdied(): handling signal 17
		[ 1145.820473] NSM RNG: returning rand bytes = 64
		2025/11/19 20:45:27 socat[621] N accepting connection from AF=40 cid:3 port:740193762 on AF=40 cid:18 port:5000
		2025/11/19 20:45:27 socat[621] N forked off child process 627
		2025/11/19 20:45:27 socat[621] N listening on AF=40 cid:4294967295 port:5000
		2025/11/19 20:45:27 socat[627] N opening connection to AF=2 0.0.0.0:8080
		2025/11/19 20:45:27 socat[627] N successfully connected from local address AF=2 127.0.0.1:44478
		2025/11/19 20:45:27 socat[627] N starting data transfer loop with FDs [6,6] and [5,5]
		2025/11/19 20:45:28 socat[627] N socket 1 (fd 6) is at EOF
		2025/11/19 20:45:28 socat[627] N socket 2 (fd 5) is at EOF
		2025/11/19 20:45:28 socat[627] N exiting with status 0
		2025/11/19 20:45:28 socat[621] N childdied(): handling signal 17
				
			


}

##############################################################
		#Access the nginx from the pod
		printf "GET / HTTP/1.1\r\nHost: localhost\r\n\r\n" | socat - VSOCK-CONNECT:18:5000

{		
					bash-4.2# printf "GET / HTTP/1.1\r\nHost: localhost\r\n\r\n" | socat - VSOCK-CONNECT:18:5000
					HTTP/1.1 200 OK
					Server: nginx/1.28.0
					Date: Wed, 19 Nov 2025 20:36:43 GMT
					Content-Type: text/html
					Content-Length: 76
					Last-Modified: Wed, 19 Nov 2025 20:21:39 GMT
					Connection: keep-alive
					ETag: "691e26d3-4c"
					Accept-Ranges: bytes

					Hello from NGINX in Enclave via VSOCK proxy! PoC on Confidential Containers
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
