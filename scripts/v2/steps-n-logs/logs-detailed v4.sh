
#FOR NGINX DEPLOYMENT NOT STARTED 


#./c-create-coco-eks-keypair.sh
 

#./d-create-coco-eks-vpc.sh
 

#./e-create-coco-eks-iamrole.sh

 


#./f-create-coco-eks.sh


 

#./g1-create-coco-nodegroup-launchtemplate-amzonlinux2.sh
 

#./h-create-coco-eks-nodegroup.sh


  

# ./i-modify-security-groups-usedby-nitronode.sh


 
# kubectl get nodes 


 
cd /home/sridhara/Downloads

kubectl apply -f https://raw.githubusercontent.com/aws/aws-nitro-enclaves-k8s-device-plugin/main/aws-nitro-enclaves-k8s-ds.yaml

kubectl get ns
 
kubectl label node $(kubectl get nodes -o jsonpath='{.items[0].metadata.name}') aws-nitro-enclaves-k8s-dp=enabled
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{" "}{.metadata.labels.aws-nitro-enclaves-k8s-dp}{"\n"}{end}'

#One time download, which is already there. so do not download again 
#git clone https://github.com/aws/aws-nitro-enclaves-with-k8s.git

 
cd aws-nitro-enclaves-with-k8s

   
   
CONTINUE FROM THE MAIN SEQUENCE OF STEPS 


###########NGINX BUILDING 


#Navigate  to the folder
 



ls -l


		sridhara@ubuntu:~/Downloads$ ls -l
		total 16
		drwxrwx--- 5 sridhara sridhara 4096 Oct 31 16:10 3-aws-scripts-eks-coco-linux
		drwxrwxr-x 5 sridhara sridhara 4096 Nov  4 11:14 aws-nitro-enclaves-with-k8s
		drwxrwxr-x 2 sridhara sridhara 4096 Oct 21 18:49 helm
		drwxrwxr-x 2 sridhara sridhara 4096 Nov  1 16:12 k8cluster


cd aws-nitro-enclaves-with-k8s/
ls -l


		sridhara@ubuntu:~/Downloads$ cd aws-nitro-enclaves-with-k8s/
		sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ ls -l
		total 64
		-rw-rw-r-- 1 sridhara sridhara   309 Oct 13 12:17 CODE_OF_CONDUCT.md
		drwxrwxr-x 7 sridhara sridhara  4096 Nov 12 13:12 container
		-rw-rw-r-- 1 sridhara sridhara  3160 Oct 13 12:17 CONTRIBUTING.md
		-rwxrwxr-x 1 sridhara sridhara 10007 Oct 13 12:17 enclavectl
		-rw-rw-r-- 1 sridhara sridhara   180 Oct 13 12:17 env.sh
		-rw-rw-r-- 1 sridhara sridhara 10142 Oct 13 12:17 LICENSE
		-rw-rw-r-- 1 sridhara sridhara    67 Oct 13 12:17 NOTICE
		-rw-rw-r-- 1 sridhara sridhara  9938 Oct 13 12:17 README.md
		drwxrwxr-x 2 sridhara sridhara  4096 Oct 13 12:17 scripts
		-rw-rw-r-- 1 sridhara sridhara   286 Oct 13 12:17 settings.json
		sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ 



#Navigate to the container. This is the place where any new application (eg. Nginx) will be hosted.


cd container/
ls -l


		sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ cd container/
		sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s/container$ ls -l
		total 28
		drwxrwxr-x 2 sridhara sridhara 4096 Nov 12 13:15 bin
		drwxrwxr-x 2 sridhara sridhara 4096 Oct 13 12:17 builder
		drwxrwxr-x 2 sridhara sridhara 4096 Nov 12 13:12 coconginx
		drwxrwxr-x 2 sridhara sridhara 4096 Oct 13 12:17 hello
		drwxrwxr-x 2 sridhara sridhara 4096 Oct 13 12:17 kms
		-rw-rw-r-- 1 sridhara sridhara 5767 Oct 13 12:17 README.md


#contents of coconginx folder  where we have put our own customized application (Eg. nginx here)

ls -l coconginx/


		sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s/container$ ls -l coconginx/
		total 12
		-rw-rw-r-- 1 sridhara sridhara 1584 Nov 12 13:12 Dockerfile
		-rw-rw-r-- 1 sridhara sridhara  703 Nov 12 13:12 enclave_manifest.json
		-rw-rw-r-- 1 sridhara sridhara  603 Nov 12 13:12 run.sh
		sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s/container$ 


#Cat of each file 

cat Dockerfile 

		sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s/container/coconginx$ cat Dockerfile 
		# Copyright 2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.
		# SPDX-License-Identifier: Apache-2.0

		######## full image ########

		FROM public.ecr.aws/amazonlinux/amazonlinux:2 as full_image

		RUN amazon-linux-extras install aws-nitro-enclaves-cli && \
			yum install aws-nitro-enclaves-cli-devel jq -y

		WORKDIR /ne-deps

		# Copy only the required binaries to /ne-deps folder.
		#
		RUN BINS="\
			/usr/bin/nitro-cli \
			/usr/bin/nitro-enclaves-allocator \
			/usr/bin/jq \
			" && \
			for bin in $BINS; do \
				{ echo "$bin"; ldd "$bin" | grep -Eo "/.*lib.*/[^ ]+"; } | \
					while read path; do \
						mkdir -p ".$(dirname $path)"; \
						cp -fL "$path" ".$path"; \
					done \
			done

		# Prepare other required files and folders for the final image.
		RUN \
			mkdir -p /ne-deps/etc/nitro_enclaves && \
			mkdir -p /ne-deps/run/nitro_enclaves && \
			mkdir -p /ne-deps/var/log/nitro_enclaves && \
			cp -rf /usr/share/nitro_enclaves/ /ne-deps/usr/share/ && \
			cp -f /etc/nitro_enclaves/allocator.yaml /ne-deps/etc/nitro_enclaves/allocator.yaml

		######## nginx image ########

		FROM public.ecr.aws/amazonlinux/amazonlinux:2 as image

		# Copying dependencies of the enclave apps from the 'full_image'
		# to shrink the final image size.
		#
		COPY --from=full_image /ne-deps/etc /etc
		COPY --from=full_image /ne-deps/lib64 /lib64
		COPY --from=full_image /ne-deps/run /run
		COPY --from=full_image /ne-deps/usr /usr
		COPY --from=full_image /ne-deps/var /var

		COPY bin/nginx.eif /home
		COPY coconginx/run.sh  /home

		CMD ["/home/run.sh"]
		sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s/container/coconginx$ 



cat enclave_manifest.json



		sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s/container/coconginx$ cat enclave_manifest.json 
		{
			"name": "coconginx",
			"repository": "https://github.com/nerdysrisha/nitroenclave-nginx.git",
			"tag": "main",
			"eif": {
				"name": "nginx.eif",
				"docker": {
					"image_name": "ne-build-nginx-eif",
					"image_tag": "1.0",
					"target": "",
					"x86_64": {
						"file_path": "examples/x86_64/coconginx",
						"file_name": "Dockerfile",
						"build_path": "examples/x86_64/coconginx"
					},
					"aarch64": {
						"file_path": "examples/x86_64/coconginx",
						"file_name": "Dockerfile",
						"build_path": "examples/x86_64/coconginx"
					}
				}
			}
		}
		sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s/container/coconginx$ 



cat run.sh 


		sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s/container/coconginx$ cat run.sh 
		#!/bin/bash -e
		# Copyright 2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.

		readonly EIF_PATH="/home/nginx.eif"
		readonly ENCLAVE_CPU_COUNT=2
		readonly ENCLAVE_MEMORY_SIZE=512

		main() {
			nitro-cli run-enclave --cpu-count $ENCLAVE_CPU_COUNT --memory $ENCLAVE_MEMORY_SIZE \
				--eif-path $EIF_PATH --debug-mode

			local enclave_id=$(nitro-cli describe-enclaves | jq -r ".[0].EnclaveID")
			echo "-------------------------------"
			echo "Enclave ID is $enclave_id"
			echo "-------------------------------"

			nitro-cli console --enclave-id $enclave_id # blocking call.
		}

		main
		sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s/container/coconginx$ 



####On the GitHub. There must be a Dockerfile that should exist with below folder structure. 
examples
 x86_64
   coconginx 
      Dockerfile 
       
###For understanding they are cloned on local and shown 


git clone https://github.com/nerdysrisha/nitroenclave-nginx.git
ls -l

	sridhara@ubuntu:~/Downloads/githublocalcopy$ git clone https://github.com/nerdysrisha/nitroenclave-nginx.git
	Cloning into 'nitroenclave-nginx'...
	remote: Enumerating objects: 41, done.
	remote: Counting objects: 100% (41/41), done.
	remote: Compressing objects: 100% (27/27), done.
	remote: Total 41 (delta 5), reused 0 (delta 0), pack-reused 0 (from 0)
	Receiving objects: 100% (41/41), 10.44 KiB | 1.04 MiB/s, done.
	Resolving deltas: 100% (5/5), done.


cd Downloads/githublocalcopy/nitroenclave-nginx/examples/x86_64/coconginx/

	sridhara@ubuntu:~$ cd Downloads/githublocalcopy/nitroenclave-nginx/examples/x86_64/coconginx/
	sridhara@ubuntu:~/Downloads/githublocalcopy/nitroenclave-nginx/examples/x86_64/coconginx$ ls -l
	total 4
	-rw-rw-r-- 1 sridhara sridhara 286 Nov 12 13:50 Dockerfile
	sridhara@ubuntu:~/Downloads/githublocalcopy/nitroenclave-nginx/examples/x86_64/coconginx$ 




#Check the PWD

sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ pwd
/home/sridhara/Downloads/aws-nitro-enclaves-with-k8s


 
#Clean up 

sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ ./enclavectl cleanup

Error when retrieving token from sso: Token has expired and refresh failed
[enclavectl] Attempt to delete launch template: lt_6cd47d6e-1a3d-48e4-85b7-a7d797c72d03
[enclavectl] Deleting cluster_config.yaml...
[enclavectl] Deleting .config.ne.k8s.ctl...
[enclavectl] Deleting .setup.ne.k8s.ctl...
sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ 


#Settings

./enclavectl configure --file settings.json

	sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ ./enclavectl configure --file settings.json
	[enclavectl] Setup UUID doesnt exist. Creating one...
	[enclavectl] Using setup UUID: 36b906d3-ff47-4731-87a4-b7adfe66e8ad
	[enclavectl] Using configuration
	{
	  "region": "eu-central-1",
	  "instance_type": "m5.2xlarge",
	  "eks_cluster_name": "eks-ne-cluster",
	  "eks_worker_node_name": "eks-ne-nodegroup",
	  "eks_worker_node_capacity": "1",
	  "k8s_version": "1.32",
	  "node_enclave_cpu_limit": 2,
	  "node_enclave_memory_limit_mib": 768
	}
	[enclavectl] Configuration finished successfully.
	sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ 




./enclavectl build --image coconginx




{
	
sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ ./enclavectl build --image coconginx

DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  341.3MB
Step 1/5 : FROM public.ecr.aws/amazonlinux/amazonlinux:2
2: Pulling from amazonlinux/amazonlinux
7934f821253e: Pull complete 
Digest: sha256:5ebd84068a008ca31f61b3b8fb58a201b53a31c7dd1123722704a61d853ab05f
Status: Downloaded newer image for public.ecr.aws/amazonlinux/amazonlinux:2
 ---> 44d98a2e35ef
Step 2/5 : RUN amazon-linux-extras install aws-nitro-enclaves-cli &&     yum install wget git aws-nitro-enclaves-cli-devel -y
 ---> Running in a20cb72a4e73
Loaded plugins: ovl, priorities
Cleaning repos: amzn2-core amzn2extra-aws-nitro-enclaves-cli
0 metadata files removed
0 sqlite files removed
0 metadata files removed
Loaded plugins: ovl, priorities
Resolving Dependencies
--> Running transaction check
---> Package aws-nitro-enclaves-cli.x86_64 0:1.4.2-0.amzn2 will be installed
--> Processing Dependency: docker for package: aws-nitro-enclaves-cli-1.4.2-0.amzn2.x86_64
--> Processing Dependency: jq for package: aws-nitro-enclaves-cli-1.4.2-0.amzn2.x86_64
--> Processing Dependency: openssl for package: aws-nitro-enclaves-cli-1.4.2-0.amzn2.x86_64
--> Processing Dependency: systemd for package: aws-nitro-enclaves-cli-1.4.2-0.amzn2.x86_64
--> Processing Dependency: systemd for package: aws-nitro-enclaves-cli-1.4.2-0.amzn2.x86_64
--> Processing Dependency: systemd for package: aws-nitro-enclaves-cli-1.4.2-0.amzn2.x86_64
--> Running transaction check
---> Package docker.x86_64 0:25.0.13-1.amzn2.0.2 will be installed
--> Processing Dependency: containerd >= 1.3.2 for package: docker-25.0.13-1.amzn2.0.2.x86_64
--> Processing Dependency: device-mapper-libs >= 1.02.90-2.24 for package: docker-25.0.13-1.amzn2.0.2.x86_64
--> Processing Dependency: libcgroup >= 0.40.rc1-5.15 for package: docker-25.0.13-1.amzn2.0.2.x86_64
--> Processing Dependency: runc >= 1.0.0 for package: docker-25.0.13-1.amzn2.0.2.x86_64
--> Processing Dependency: iptables for package: docker-25.0.13-1.amzn2.0.2.x86_64
--> Processing Dependency: libsystemd.so.0(LIBSYSTEMD_209)(64bit) for package: docker-25.0.13-1.amzn2.0.2.x86_64
--> Processing Dependency: pigz for package: docker-25.0.13-1.amzn2.0.2.x86_64
--> Processing Dependency: xfsprogs for package: docker-25.0.13-1.amzn2.0.2.x86_64
--> Processing Dependency: xz for package: docker-25.0.13-1.amzn2.0.2.x86_64
--> Processing Dependency: libsystemd.so.0()(64bit) for package: docker-25.0.13-1.amzn2.0.2.x86_64
---> Package jq.x86_64 0:1.5-1.amzn2.0.3 will be installed
--> Processing Dependency: libonig.so.2()(64bit) for package: jq-1.5-1.amzn2.0.3.x86_64
---> Package openssl.x86_64 1:1.0.2k-24.amzn2.0.16 will be installed
--> Processing Dependency: make for package: 1:openssl-1.0.2k-24.amzn2.0.16.x86_64
---> Package systemd.x86_64 0:219-78.amzn2.0.24 will be installed
--> Processing Dependency: kmod >= 18-4 for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: /usr/sbin/groupadd for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: acl for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: dbus for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libcryptsetup.so.4(CRYPTSETUP_1.0)(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libdw.so.1(ELFUTILS_0.122)(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libdw.so.1(ELFUTILS_0.130)(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libdw.so.1(ELFUTILS_0.158)(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libkmod.so.2(LIBKMOD_5)(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libpam.so.0(LIBPAM_1.0)(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libaudit.so.1()(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libcryptsetup.so.4()(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libdw.so.1()(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libkmod.so.2()(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: liblz4.so.1()(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libpam.so.0()(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libqrencode.so.3()(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Running transaction check
---> Package acl.x86_64 0:2.2.51-14.amzn2 will be installed
---> Package audit-libs.x86_64 0:2.8.1-3.amzn2.1 will be installed
--> Processing Dependency: libcap-ng.so.0()(64bit) for package: audit-libs-2.8.1-3.amzn2.1.x86_64
---> Package containerd.x86_64 0:2.1.4-1.amzn2.0.2 will be installed
--> Processing Dependency: libseccomp(x86-64) >= 2.5.2 for package: containerd-2.1.4-1.amzn2.0.2.x86_64
---> Package cryptsetup-libs.x86_64 0:1.7.4-4.amzn2 will be installed
---> Package dbus.x86_64 1:1.10.24-7.amzn2.0.4 will be installed
--> Processing Dependency: dbus-libs(x86-64) = 1:1.10.24-7.amzn2.0.4 for package: 1:dbus-1.10.24-7.amzn2.0.4.x86_64
--> Processing Dependency: libdbus-1.so.3(LIBDBUS_1_3)(64bit) for package: 1:dbus-1.10.24-7.amzn2.0.4.x86_64
--> Processing Dependency: libdbus-1.so.3(LIBDBUS_PRIVATE_1.10.24)(64bit) for package: 1:dbus-1.10.24-7.amzn2.0.4.x86_64
--> Processing Dependency: libdbus-1.so.3()(64bit) for package: 1:dbus-1.10.24-7.amzn2.0.4.x86_64
---> Package device-mapper-libs.x86_64 7:1.02.170-6.amzn2.5 will be installed
--> Processing Dependency: device-mapper = 7:1.02.170-6.amzn2.5 for package: 7:device-mapper-libs-1.02.170-6.amzn2.5.x86_64
---> Package elfutils-libs.x86_64 0:0.176-2.amzn2.0.2 will be installed
--> Processing Dependency: default-yama-scope for package: elfutils-libs-0.176-2.amzn2.0.2.x86_64
---> Package iptables.x86_64 0:1.8.4-10.amzn2.1.2 will be installed
--> Processing Dependency: iptables-libs(x86-64) = 1.8.4-10.amzn2.1.2 for package: iptables-1.8.4-10.amzn2.1.2.x86_64
--> Processing Dependency: libip4tc.so.2()(64bit) for package: iptables-1.8.4-10.amzn2.1.2.x86_64
--> Processing Dependency: libip6tc.so.2()(64bit) for package: iptables-1.8.4-10.amzn2.1.2.x86_64
--> Processing Dependency: libnetfilter_conntrack.so.3()(64bit) for package: iptables-1.8.4-10.amzn2.1.2.x86_64
--> Processing Dependency: libnfnetlink.so.0()(64bit) for package: iptables-1.8.4-10.amzn2.1.2.x86_64
--> Processing Dependency: libpcap.so.1()(64bit) for package: iptables-1.8.4-10.amzn2.1.2.x86_64
--> Processing Dependency: libxtables.so.12()(64bit) for package: iptables-1.8.4-10.amzn2.1.2.x86_64
---> Package kmod.x86_64 0:25-3.amzn2.0.2 will be installed
---> Package kmod-libs.x86_64 0:25-3.amzn2.0.2 will be installed
---> Package libcgroup.x86_64 0:0.41-21.amzn2 will be installed
---> Package lz4.x86_64 0:1.7.5-2.amzn2.0.2 will be installed
---> Package make.x86_64 1:3.82-24.amzn2 will be installed
---> Package oniguruma.x86_64 0:5.9.6-1.amzn2.0.7 will be installed
---> Package pam.x86_64 0:1.1.8-23.amzn2.0.5 will be installed
--> Processing Dependency: cracklib-dicts >= 2.8 for package: pam-1.1.8-23.amzn2.0.5.x86_64
--> Processing Dependency: libpwquality >= 0.9.9 for package: pam-1.1.8-23.amzn2.0.5.x86_64
--> Processing Dependency: libcrack.so.2()(64bit) for package: pam-1.1.8-23.amzn2.0.5.x86_64
---> Package pigz.x86_64 0:2.3.4-1.amzn2.0.1 will be installed
---> Package qrencode-libs.x86_64 0:3.4.1-3.amzn2.0.2 will be installed
---> Package runc.x86_64 0:1.3.3-2.amzn2 will be installed
---> Package shadow-utils.x86_64 2:4.1.5.1-24.amzn2.0.3 will be installed
--> Processing Dependency: libsemanage.so.1(LIBSEMANAGE_1.0)(64bit) for package: 2:shadow-utils-4.1.5.1-24.amzn2.0.3.x86_64
--> Processing Dependency: libsemanage.so.1()(64bit) for package: 2:shadow-utils-4.1.5.1-24.amzn2.0.3.x86_64
---> Package systemd-libs.x86_64 0:219-78.amzn2.0.24 will be installed
---> Package xfsprogs.x86_64 0:5.0.0-10.amzn2.0.1 will be installed
---> Package xz.x86_64 0:5.2.2-1.amzn2.0.3 will be installed
--> Running transaction check
---> Package cracklib.x86_64 0:2.9.0-11.amzn2.0.2 will be installed
--> Processing Dependency: gzip for package: cracklib-2.9.0-11.amzn2.0.2.x86_64
---> Package cracklib-dicts.x86_64 0:2.9.0-11.amzn2.0.2 will be installed
---> Package dbus-libs.x86_64 1:1.10.24-7.amzn2.0.4 will be installed
---> Package device-mapper.x86_64 7:1.02.170-6.amzn2.5 will be installed
--> Processing Dependency: util-linux >= 2.23 for package: 7:device-mapper-1.02.170-6.amzn2.5.x86_64
---> Package elfutils-default-yama-scope.noarch 0:0.176-2.amzn2.0.2 will be installed
---> Package iptables-libs.x86_64 0:1.8.4-10.amzn2.1.2 will be installed
---> Package libcap-ng.x86_64 0:0.7.5-4.amzn2.0.4 will be installed
---> Package libnetfilter_conntrack.x86_64 0:1.0.6-1.amzn2.0.2 will be installed
--> Processing Dependency: libmnl.so.0(LIBMNL_1.0)(64bit) for package: libnetfilter_conntrack-1.0.6-1.amzn2.0.2.x86_64
--> Processing Dependency: libmnl.so.0(LIBMNL_1.1)(64bit) for package: libnetfilter_conntrack-1.0.6-1.amzn2.0.2.x86_64
--> Processing Dependency: libmnl.so.0()(64bit) for package: libnetfilter_conntrack-1.0.6-1.amzn2.0.2.x86_64
---> Package libnfnetlink.x86_64 0:1.0.1-4.amzn2.0.2 will be installed
---> Package libpcap.x86_64 14:1.5.3-11.amzn2 will be installed
---> Package libpwquality.x86_64 0:1.2.3-5.amzn2 will be installed
---> Package libseccomp.x86_64 0:2.5.2-1.amzn2.0.1 will be installed
---> Package libsemanage.x86_64 0:2.5-11.amzn2 will be installed
--> Processing Dependency: libustr-1.0.so.1(USTR_1.0)(64bit) for package: libsemanage-2.5-11.amzn2.x86_64
--> Processing Dependency: libustr-1.0.so.1(USTR_1.0.1)(64bit) for package: libsemanage-2.5-11.amzn2.x86_64
--> Processing Dependency: libustr-1.0.so.1()(64bit) for package: libsemanage-2.5-11.amzn2.x86_64
--> Running transaction check
---> Package gzip.x86_64 0:1.5-10.amzn2.0.1 will be installed
---> Package libmnl.x86_64 0:1.0.3-7.amzn2.0.2 will be installed
---> Package ustr.x86_64 0:1.0.4-16.amzn2.0.3 will be installed
---> Package util-linux.x86_64 0:2.30.2-2.amzn2.0.11 will be installed
--> Processing Dependency: libfdisk = 2.30.2-2.amzn2.0.11 for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libsmartcols = 2.30.2-2.amzn2.0.11 for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libfdisk.so.1(FDISK_2.26)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libfdisk.so.1(FDISK_2.27)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libfdisk.so.1(FDISK_2.28)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libfdisk.so.1(FDISK_2.29)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libfdisk.so.1(FDISK_2.30)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libsmartcols.so.1(SMARTCOLS_2.25)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libsmartcols.so.1(SMARTCOLS_2.27)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libsmartcols.so.1(SMARTCOLS_2.28)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libsmartcols.so.1(SMARTCOLS_2.29)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libsmartcols.so.1(SMARTCOLS_2.30)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libutempter.so.0(UTEMPTER_1.1)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libfdisk.so.1()(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libsmartcols.so.1()(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libutempter.so.0()(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Running transaction check
---> Package libfdisk.x86_64 0:2.30.2-2.amzn2.0.11 will be installed
---> Package libsmartcols.x86_64 0:2.30.2-2.amzn2.0.11 will be installed
---> Package libutempter.x86_64 0:1.1.6-4.amzn2.0.2 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package                     Arch   Version                Repository      Size
================================================================================
Installing:
 aws-nitro-enclaves-cli      x86_64 1.4.2-0.amzn2          amzn2extra-aws-nitro-enclaves-cli
                                                                          6.0 M
Installing for dependencies:
 acl                         x86_64 2.2.51-14.amzn2        amzn2-core      82 k
 audit-libs                  x86_64 2.8.1-3.amzn2.1        amzn2-core      99 k
 containerd                  x86_64 2.1.4-1.amzn2.0.2      amzn2extra-aws-nitro-enclaves-cli
                                                                           20 M
 cracklib                    x86_64 2.9.0-11.amzn2.0.2     amzn2-core      80 k
 cracklib-dicts              x86_64 2.9.0-11.amzn2.0.2     amzn2-core     3.6 M
 cryptsetup-libs             x86_64 1.7.4-4.amzn2          amzn2-core     224 k
 dbus                        x86_64 1:1.10.24-7.amzn2.0.4  amzn2-core     246 k
 dbus-libs                   x86_64 1:1.10.24-7.amzn2.0.4  amzn2-core     167 k
 device-mapper               x86_64 7:1.02.170-6.amzn2.5   amzn2-core     297 k
 device-mapper-libs          x86_64 7:1.02.170-6.amzn2.5   amzn2-core     326 k
 docker                      x86_64 25.0.13-1.amzn2.0.2    amzn2extra-aws-nitro-enclaves-cli
                                                                           46 M
 elfutils-default-yama-scope noarch 0.176-2.amzn2.0.2      amzn2-core      33 k
 elfutils-libs               x86_64 0.176-2.amzn2.0.2      amzn2-core     289 k
 gzip                        x86_64 1.5-10.amzn2.0.1       amzn2-core     129 k
 iptables                    x86_64 1.8.4-10.amzn2.1.2     amzn2-core     476 k
 iptables-libs               x86_64 1.8.4-10.amzn2.1.2     amzn2-core      93 k
 jq                          x86_64 1.5-1.amzn2.0.3        amzn2-core     152 k
 kmod                        x86_64 25-3.amzn2.0.2         amzn2-core     111 k
 kmod-libs                   x86_64 25-3.amzn2.0.2         amzn2-core      59 k
 libcap-ng                   x86_64 0.7.5-4.amzn2.0.4      amzn2-core      25 k
 libcgroup                   x86_64 0.41-21.amzn2          amzn2-core      66 k
 libfdisk                    x86_64 2.30.2-2.amzn2.0.11    amzn2-core     238 k
 libmnl                      x86_64 1.0.3-7.amzn2.0.2      amzn2-core      23 k
 libnetfilter_conntrack      x86_64 1.0.6-1.amzn2.0.2      amzn2-core      58 k
 libnfnetlink                x86_64 1.0.1-4.amzn2.0.2      amzn2-core      26 k
 libpcap                     x86_64 14:1.5.3-11.amzn2      amzn2-core     140 k
 libpwquality                x86_64 1.2.3-5.amzn2          amzn2-core      84 k
 libseccomp                  x86_64 2.5.2-1.amzn2.0.1      amzn2-core      65 k
 libsemanage                 x86_64 2.5-11.amzn2           amzn2-core     152 k
 libsmartcols                x86_64 2.30.2-2.amzn2.0.11    amzn2-core     155 k
 libutempter                 x86_64 1.1.6-4.amzn2.0.2      amzn2-core      25 k
 lz4                         x86_64 1.7.5-2.amzn2.0.2      amzn2-core      98 k
 make                        x86_64 1:3.82-24.amzn2        amzn2-core     420 k
 oniguruma                   x86_64 5.9.6-1.amzn2.0.7      amzn2-core     127 k
 openssl                     x86_64 1:1.0.2k-24.amzn2.0.16 amzn2-core     498 k
 pam                         x86_64 1.1.8-23.amzn2.0.5     amzn2-core     717 k
 pigz                        x86_64 2.3.4-1.amzn2.0.1      amzn2-core      81 k
 qrencode-libs               x86_64 3.4.1-3.amzn2.0.2      amzn2-core      50 k
 runc                        x86_64 1.3.3-2.amzn2          amzn2extra-aws-nitro-enclaves-cli
                                                                          3.9 M
 shadow-utils                x86_64 2:4.1.5.1-24.amzn2.0.3 amzn2-core     1.1 M
 systemd                     x86_64 219-78.amzn2.0.24      amzn2-core     5.0 M
 systemd-libs                x86_64 219-78.amzn2.0.24      amzn2-core     409 k
 ustr                        x86_64 1.0.4-16.amzn2.0.3     amzn2-core      96 k
 util-linux                  x86_64 2.30.2-2.amzn2.0.11    amzn2-core     2.3 M
 xfsprogs                    x86_64 5.0.0-10.amzn2.0.1     amzn2-core     1.0 M
 xz                          x86_64 5.2.2-1.amzn2.0.3      amzn2-core     228 k

Transaction Summary
================================================================================
Install  1 Package (+46 Dependent packages)

Total download size: 96 M
Installed size: 345 M
Downloading packages:
--------------------------------------------------------------------------------
Total                                               13 MB/s |  96 MB  00:07     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : libcap-ng-0.7.5-4.amzn2.0.4.x86_64                          1/47 
  Installing : audit-libs-2.8.1-3.amzn2.1.x86_64                           2/47 
  Installing : libseccomp-2.5.2-1.amzn2.0.1.x86_64                         3/47 
  Installing : runc-1.3.3-2.amzn2.x86_64                                   4/47 
  Installing : libnfnetlink-1.0.1-4.amzn2.0.2.x86_64                       5/47 
  Installing : 14:libpcap-1.5.3-11.amzn2.x86_64                            6/47 
  Installing : lz4-1.7.5-2.amzn2.0.2.x86_64                                7/47 
  Installing : iptables-libs-1.8.4-10.amzn2.1.2.x86_64                     8/47 
  Installing : containerd-2.1.4-1.amzn2.0.2.x86_64                         9/47 
  Installing : kmod-libs-25-3.amzn2.0.2.x86_64                            10/47 
  Installing : 1:make-3.82-24.amzn2.x86_64                                11/47 
  Installing : 1:openssl-1.0.2k-24.amzn2.0.16.x86_64                      12/47 
  Installing : acl-2.2.51-14.amzn2.x86_64                                 13/47 
  Installing : kmod-25-3.amzn2.0.2.x86_64                                 14/47 
  Installing : ustr-1.0.4-16.amzn2.0.3.x86_64                             15/47 
  Installing : libsemanage-2.5-11.amzn2.x86_64                            16/47 
  Installing : 2:shadow-utils-4.1.5.1-24.amzn2.0.3.x86_64                 17/47 
  Installing : libutempter-1.1.6-4.amzn2.0.2.x86_64                       18/47 
  Installing : xz-5.2.2-1.amzn2.0.3.x86_64                                19/47 
  Installing : libfdisk-2.30.2-2.amzn2.0.11.x86_64                        20/47 
  Installing : qrencode-libs-3.4.1-3.amzn2.0.2.x86_64                     21/47 
  Installing : oniguruma-5.9.6-1.amzn2.0.7.x86_64                         22/47 
  Installing : jq-1.5-1.amzn2.0.3.x86_64                                  23/47 
  Installing : pigz-2.3.4-1.amzn2.0.1.x86_64                              24/47 
  Installing : libsmartcols-2.30.2-2.amzn2.0.11.x86_64                    25/47 
  Installing : gzip-1.5-10.amzn2.0.1.x86_64                               26/47 
  Installing : cracklib-2.9.0-11.amzn2.0.2.x86_64                         27/47 
  Installing : cracklib-dicts-2.9.0-11.amzn2.0.2.x86_64                   28/47 
  Installing : pam-1.1.8-23.amzn2.0.5.x86_64                              29/47 
  Installing : libpwquality-1.2.3-5.amzn2.x86_64                          30/47 
  Installing : util-linux-2.30.2-2.amzn2.0.11.x86_64                      31/47 
  Installing : 7:device-mapper-1.02.170-6.amzn2.5.x86_64                  32/47 
  Installing : 7:device-mapper-libs-1.02.170-6.amzn2.5.x86_64             33/47 
  Installing : cryptsetup-libs-1.7.4-4.amzn2.x86_64                       34/47 
  Installing : elfutils-libs-0.176-2.amzn2.0.2.x86_64                     35/47 
  Installing : systemd-libs-219-78.amzn2.0.24.x86_64                      36/47 
  Installing : 1:dbus-libs-1.10.24-7.amzn2.0.4.x86_64                     37/47 
  Installing : systemd-219-78.amzn2.0.24.x86_64                           38/47 
Failed to get D-Bus connection: Operation not permitted
  Installing : elfutils-default-yama-scope-0.176-2.amzn2.0.2.noarch       39/47 
  Installing : 1:dbus-1.10.24-7.amzn2.0.4.x86_64                          40/47 
  Installing : libcgroup-0.41-21.amzn2.x86_64                             41/47 
  Installing : xfsprogs-5.0.0-10.amzn2.0.1.x86_64                         42/47 
  Installing : libmnl-1.0.3-7.amzn2.0.2.x86_64                            43/47 
  Installing : libnetfilter_conntrack-1.0.6-1.amzn2.0.2.x86_64            44/47 
  Installing : iptables-1.8.4-10.amzn2.1.2.x86_64                         45/47 
  Installing : docker-25.0.13-1.amzn2.0.2.x86_64                          46/47 
  Installing : aws-nitro-enclaves-cli-1.4.2-0.amzn2.x86_64                47/47 
chgrp: cannot access '/dev/nitro_enclaves': No such file or directory

    * In order to successfully run Nitro Enclaves, please add your user to group 'ne'

    * Before being able to run enclaves, the system administrator must reserve the required
      resources (i.e. CPUs and memory). Edit the allocator configuration file at
      /etc/nitro_enclaves/allocator.yaml and then start the allocator oneshot service:
      
        sudo systemctl start nitro-enclaves-allocator.service

      Resource allocation can be performed at system boot (recommended), by enabling
      the allocator service:

        sudo systemctl enable nitro-enclaves-allocator.service

  Verifying  : 1:dbus-libs-1.10.24-7.amzn2.0.4.x86_64                      1/47 
  Verifying  : libmnl-1.0.3-7.amzn2.0.2.x86_64                             2/47 
  Verifying  : lz4-1.7.5-2.amzn2.0.2.x86_64                                3/47 
  Verifying  : gzip-1.5-10.amzn2.0.1.x86_64                                4/47 
  Verifying  : jq-1.5-1.amzn2.0.3.x86_64                                   5/47 
  Verifying  : libsmartcols-2.30.2-2.amzn2.0.11.x86_64                     6/47 
  Verifying  : pigz-2.3.4-1.amzn2.0.1.x86_64                               7/47 
  Verifying  : oniguruma-5.9.6-1.amzn2.0.7.x86_64                          8/47 
  Verifying  : cracklib-2.9.0-11.amzn2.0.2.x86_64                          9/47 
  Verifying  : iptables-1.8.4-10.amzn2.1.2.x86_64                         10/47 
  Verifying  : 2:shadow-utils-4.1.5.1-24.amzn2.0.3.x86_64                 11/47 
  Verifying  : pam-1.1.8-23.amzn2.0.5.x86_64                              12/47 
  Verifying  : cryptsetup-libs-1.7.4-4.amzn2.x86_64                       13/47 
  Verifying  : 14:libpcap-1.5.3-11.amzn2.x86_64                           14/47 
  Verifying  : containerd-2.1.4-1.amzn2.0.2.x86_64                        15/47 
  Verifying  : systemd-libs-219-78.amzn2.0.24.x86_64                      16/47 
  Verifying  : libutempter-1.1.6-4.amzn2.0.2.x86_64                       17/47 
  Verifying  : elfutils-default-yama-scope-0.176-2.amzn2.0.2.noarch       18/47 
  Verifying  : 1:dbus-1.10.24-7.amzn2.0.4.x86_64                          19/47 
  Verifying  : qrencode-libs-3.4.1-3.amzn2.0.2.x86_64                     20/47 
  Verifying  : systemd-219-78.amzn2.0.24.x86_64                           21/47 
  Verifying  : libpwquality-1.2.3-5.amzn2.x86_64                          22/47 
  Verifying  : runc-1.3.3-2.amzn2.x86_64                                  23/47 
  Verifying  : aws-nitro-enclaves-cli-1.4.2-0.amzn2.x86_64                24/47 
  Verifying  : 7:device-mapper-libs-1.02.170-6.amzn2.5.x86_64             25/47 
  Verifying  : libcgroup-0.41-21.amzn2.x86_64                             26/47 
  Verifying  : cracklib-dicts-2.9.0-11.amzn2.0.2.x86_64                   27/47 
  Verifying  : util-linux-2.30.2-2.amzn2.0.11.x86_64                      28/47 
  Verifying  : libfdisk-2.30.2-2.amzn2.0.11.x86_64                        29/47 
  Verifying  : xfsprogs-5.0.0-10.amzn2.0.1.x86_64                         30/47 
  Verifying  : libcap-ng-0.7.5-4.amzn2.0.4.x86_64                         31/47 
  Verifying  : audit-libs-2.8.1-3.amzn2.1.x86_64                          32/47 
  Verifying  : xz-5.2.2-1.amzn2.0.3.x86_64                                33/47 
  Verifying  : ustr-1.0.4-16.amzn2.0.3.x86_64                             34/47 
  Verifying  : libnetfilter_conntrack-1.0.6-1.amzn2.0.2.x86_64            35/47 
  Verifying  : kmod-25-3.amzn2.0.2.x86_64                                 36/47 
  Verifying  : acl-2.2.51-14.amzn2.x86_64                                 37/47 
  Verifying  : libsemanage-2.5-11.amzn2.x86_64                            38/47 
  Verifying  : 1:openssl-1.0.2k-24.amzn2.0.16.x86_64                      39/47 
  Verifying  : libnfnetlink-1.0.1-4.amzn2.0.2.x86_64                      40/47 
  Verifying  : 1:make-3.82-24.amzn2.x86_64                                41/47 
  Verifying  : elfutils-libs-0.176-2.amzn2.0.2.x86_64                     42/47 
  Verifying  : iptables-libs-1.8.4-10.amzn2.1.2.x86_64                    43/47 
  Verifying  : libseccomp-2.5.2-1.amzn2.0.1.x86_64                        44/47 
  Verifying  : kmod-libs-25-3.amzn2.0.2.x86_64                            45/47 
  Verifying  : docker-25.0.13-1.amzn2.0.2.x86_64                          46/47 
  Verifying  : 7:device-mapper-1.02.170-6.amzn2.5.x86_64                  47/47 

Installed:
  aws-nitro-enclaves-cli.x86_64 0:1.4.2-0.amzn2                                 

Dependency Installed:
  acl.x86_64 0:2.2.51-14.amzn2                                                  
  audit-libs.x86_64 0:2.8.1-3.amzn2.1                                           
  containerd.x86_64 0:2.1.4-1.amzn2.0.2                                         
  cracklib.x86_64 0:2.9.0-11.amzn2.0.2                                          
  cracklib-dicts.x86_64 0:2.9.0-11.amzn2.0.2                                    
  cryptsetup-libs.x86_64 0:1.7.4-4.amzn2                                        
  dbus.x86_64 1:1.10.24-7.amzn2.0.4                                             
  dbus-libs.x86_64 1:1.10.24-7.amzn2.0.4                                        
  device-mapper.x86_64 7:1.02.170-6.amzn2.5                                     
  device-mapper-libs.x86_64 7:1.02.170-6.amzn2.5                                
  docker.x86_64 0:25.0.13-1.amzn2.0.2                                           
  elfutils-default-yama-scope.noarch 0:0.176-2.amzn2.0.2                        
  elfutils-libs.x86_64 0:0.176-2.amzn2.0.2                                      
  gzip.x86_64 0:1.5-10.amzn2.0.1                                                
  iptables.x86_64 0:1.8.4-10.amzn2.1.2                                          
  iptables-libs.x86_64 0:1.8.4-10.amzn2.1.2                                     
  jq.x86_64 0:1.5-1.amzn2.0.3                                                   
  kmod.x86_64 0:25-3.amzn2.0.2                                                  
  kmod-libs.x86_64 0:25-3.amzn2.0.2                                             
  libcap-ng.x86_64 0:0.7.5-4.amzn2.0.4                                          
  libcgroup.x86_64 0:0.41-21.amzn2                                              
  libfdisk.x86_64 0:2.30.2-2.amzn2.0.11                                         
  libmnl.x86_64 0:1.0.3-7.amzn2.0.2                                             
  libnetfilter_conntrack.x86_64 0:1.0.6-1.amzn2.0.2                             
  libnfnetlink.x86_64 0:1.0.1-4.amzn2.0.2                                       
  libpcap.x86_64 14:1.5.3-11.amzn2                                              
  libpwquality.x86_64 0:1.2.3-5.amzn2                                           
  libseccomp.x86_64 0:2.5.2-1.amzn2.0.1                                         
  libsemanage.x86_64 0:2.5-11.amzn2                                             
  libsmartcols.x86_64 0:2.30.2-2.amzn2.0.11                                     
  libutempter.x86_64 0:1.1.6-4.amzn2.0.2                                        
  lz4.x86_64 0:1.7.5-2.amzn2.0.2                                                
  make.x86_64 1:3.82-24.amzn2                                                   
  oniguruma.x86_64 0:5.9.6-1.amzn2.0.7                                          
  openssl.x86_64 1:1.0.2k-24.amzn2.0.16                                         
  pam.x86_64 0:1.1.8-23.amzn2.0.5                                               
  pigz.x86_64 0:2.3.4-1.amzn2.0.1                                               
  qrencode-libs.x86_64 0:3.4.1-3.amzn2.0.2                                      
  runc.x86_64 0:1.3.3-2.amzn2                                                   
  shadow-utils.x86_64 2:4.1.5.1-24.amzn2.0.3                                    
  systemd.x86_64 0:219-78.amzn2.0.24                                            
  systemd-libs.x86_64 0:219-78.amzn2.0.24                                       
  ustr.x86_64 0:1.0.4-16.amzn2.0.3                                              
  util-linux.x86_64 0:2.30.2-2.amzn2.0.11                                       
  xfsprogs.x86_64 0:5.0.0-10.amzn2.0.1                                          
  xz.x86_64 0:5.2.2-1.amzn2.0.3                                                 

Complete!
Installing aws-nitro-enclaves-cli
  2  httpd_modules                  available    [ =1.0  =stable ]
  3  memcached1.5                   available    \
        [ =1.5.1  =1.5.16  =1.5.17 ]
  9  R3.4                           available    [ =3.4.3  =stable ]
 18  libreoffice                    available    \
        [ =5.0.6.2_15  =5.3.6.1  =stable ]
 19  gimp                           available    [ =2.8.22 ]
 20  docker                         available    \
        [ =17.12.1  =18.03.1  =18.06.1  =18.09.9  =stable ]
 21  mate-desktop1.x                available    \
        [ =1.19.0  =1.20.0  =stable ]
 22  GraphicsMagick1.3              available    \
        [ =1.3.29  =1.3.32  =1.3.34  =stable ]
 25  testing                        available    [ =1.0  =stable ]
 26  ecs                            available    [ =stable ]
 27  corretto8                      available    \
        [ =1.8.0_192  =1.8.0_202  =1.8.0_212  =1.8.0_222  =1.8.0_232
          =1.8.0_242  =stable ]
 32  lustre2.10                     available    \
        [ =2.10.5  =2.10.8  =stable ]
 34  lynis                          available    [ =stable ]
 36  BCC                            available    [ =0.x  =stable ]
 37  mono                           available    [ =5.x  =stable ]
 38  nginx1                         available    [ =stable ]
 40  mock                           available    [ =stable ]
 43  livepatch                      available    [ =stable ]
 45  haproxy2                       available    [ =stable ]
 46  collectd                       available    [ =stable ]
 47  aws-nitro-enclaves-cli=latest  enabled      [ =stable ]
 48  R4                             available    [ =stable ]
 49  kernel-5.4                     available    [ =stable ]
 50  selinux-ng                     available    [ =stable ]
 52  tomcat9                        available    [ =stable ]
 55  kernel-5.10                    available    [ =stable ]
 56  redis6                         available    [ =stable ]
 59 †postgresql13                   available    [ =stable ]
 60  mock2                          available    [ =stable ]
 62  kernel-5.15                    available    [ =stable ]
 63  postgresql14                   available    [ =stable ]
 64  firefox                        available    [ =stable ]
 65  lustre                         available    [ =stable ]
 66 †php8.1                         available    [ =stable ]
 67  awscli1                        available    [ =stable ]
 68  php8.2                         available    [ =stable ]
 69  dnsmasq                        available    [ =stable ]
 70  unbound1.17                    available    [ =stable ]
 72  collectd-python3               available    [ =stable ]
† Note on end-of-support. Use 'info' subcommand.
Loaded plugins: ovl, priorities
Resolving Dependencies
--> Running transaction check
---> Package aws-nitro-enclaves-cli-devel.x86_64 0:1.4.2-0.amzn2 will be installed
---> Package git.x86_64 0:2.47.3-1.amzn2.0.1 will be installed
--> Processing Dependency: git-core = 2.47.3-1.amzn2.0.1 for package: git-2.47.3-1.amzn2.0.1.x86_64
--> Processing Dependency: git-core-doc = 2.47.3-1.amzn2.0.1 for package: git-2.47.3-1.amzn2.0.1.x86_64
--> Processing Dependency: perl-Git = 2.47.3-1.amzn2.0.1 for package: git-2.47.3-1.amzn2.0.1.x86_64
--> Processing Dependency: perl >= 5.008001 for package: git-2.47.3-1.amzn2.0.1.x86_64
--> Processing Dependency: /usr/bin/perl for package: git-2.47.3-1.amzn2.0.1.x86_64
--> Processing Dependency: perl(File::Basename) for package: git-2.47.3-1.amzn2.0.1.x86_64
--> Processing Dependency: perl(File::Find) for package: git-2.47.3-1.amzn2.0.1.x86_64
--> Processing Dependency: perl(File::Spec) for package: git-2.47.3-1.amzn2.0.1.x86_64
--> Processing Dependency: perl(Getopt::Long) for package: git-2.47.3-1.amzn2.0.1.x86_64
--> Processing Dependency: perl(Git) for package: git-2.47.3-1.amzn2.0.1.x86_64
--> Processing Dependency: perl(IPC::Open2) for package: git-2.47.3-1.amzn2.0.1.x86_64
--> Processing Dependency: perl(Term::ReadKey) for package: git-2.47.3-1.amzn2.0.1.x86_64
--> Processing Dependency: perl(lib) for package: git-2.47.3-1.amzn2.0.1.x86_64
--> Processing Dependency: perl(strict) for package: git-2.47.3-1.amzn2.0.1.x86_64
--> Processing Dependency: perl(warnings) for package: git-2.47.3-1.amzn2.0.1.x86_64
---> Package wget.x86_64 0:1.14-18.amzn2.1 will be installed
--> Processing Dependency: libidn.so.11(LIBIDN_1.0)(64bit) for package: wget-1.14-18.amzn2.1.x86_64
--> Processing Dependency: libidn.so.11()(64bit) for package: wget-1.14-18.amzn2.1.x86_64
--> Running transaction check
---> Package git-core.x86_64 0:2.47.3-1.amzn2.0.1 will be installed
--> Processing Dependency: less for package: git-core-2.47.3-1.amzn2.0.1.x86_64
--> Processing Dependency: openssh-clients for package: git-core-2.47.3-1.amzn2.0.1.x86_64
--> Processing Dependency: libpcre2-8.so.0()(64bit) for package: git-core-2.47.3-1.amzn2.0.1.x86_64
---> Package git-core-doc.noarch 0:2.47.3-1.amzn2.0.1 will be installed
---> Package libidn.x86_64 0:1.28-4.amzn2.0.5 will be installed
---> Package perl.x86_64 4:5.16.3-299.amzn2.0.3 will be installed
--> Processing Dependency: perl-libs = 4:5.16.3-299.amzn2.0.3 for package: 4:perl-5.16.3-299.amzn2.0.3.x86_64
--> Processing Dependency: perl(Scalar::Util) >= 1.10 for package: 4:perl-5.16.3-299.amzn2.0.3.x86_64
--> Processing Dependency: perl(Socket) >= 1.3 for package: 4:perl-5.16.3-299.amzn2.0.3.x86_64
--> Processing Dependency: perl(Carp) for package: 4:perl-5.16.3-299.amzn2.0.3.x86_64
--> Processing Dependency: perl(Exporter) for package: 4:perl-5.16.3-299.amzn2.0.3.x86_64
--> Processing Dependency: perl(File::Path) for package: 4:perl-5.16.3-299.amzn2.0.3.x86_64
--> Processing Dependency: perl(File::Temp) for package: 4:perl-5.16.3-299.amzn2.0.3.x86_64
--> Processing Dependency: perl(Filter::Util::Call) for package: 4:perl-5.16.3-299.amzn2.0.3.x86_64
--> Processing Dependency: perl(Pod::Simple::Search) for package: 4:perl-5.16.3-299.amzn2.0.3.x86_64
--> Processing Dependency: perl(Pod::Simple::XHTML) for package: 4:perl-5.16.3-299.amzn2.0.3.x86_64
--> Processing Dependency: perl(Scalar::Util) for package: 4:perl-5.16.3-299.amzn2.0.3.x86_64
--> Processing Dependency: perl(Socket) for package: 4:perl-5.16.3-299.amzn2.0.3.x86_64
--> Processing Dependency: perl(Storable) for package: 4:perl-5.16.3-299.amzn2.0.3.x86_64
--> Processing Dependency: perl(Time::HiRes) for package: 4:perl-5.16.3-299.amzn2.0.3.x86_64
--> Processing Dependency: perl(Time::Local) for package: 4:perl-5.16.3-299.amzn2.0.3.x86_64
--> Processing Dependency: perl(constant) for package: 4:perl-5.16.3-299.amzn2.0.3.x86_64
--> Processing Dependency: perl(threads) for package: 4:perl-5.16.3-299.amzn2.0.3.x86_64
--> Processing Dependency: perl(threads::shared) for package: 4:perl-5.16.3-299.amzn2.0.3.x86_64
--> Processing Dependency: perl-libs for package: 4:perl-5.16.3-299.amzn2.0.3.x86_64
--> Processing Dependency: perl-macros for package: 4:perl-5.16.3-299.amzn2.0.3.x86_64
--> Processing Dependency: libperl.so()(64bit) for package: 4:perl-5.16.3-299.amzn2.0.3.x86_64
---> Package perl-Getopt-Long.noarch 0:2.40-3.amzn2 will be installed
--> Processing Dependency: perl(Pod::Usage) >= 1.14 for package: perl-Getopt-Long-2.40-3.amzn2.noarch
--> Processing Dependency: perl(Text::ParseWords) for package: perl-Getopt-Long-2.40-3.amzn2.noarch
---> Package perl-Git.noarch 0:2.47.3-1.amzn2.0.1 will be installed
--> Processing Dependency: perl(Error) for package: perl-Git-2.47.3-1.amzn2.0.1.noarch
---> Package perl-PathTools.x86_64 0:3.40-5.amzn2.0.2 will be installed
---> Package perl-TermReadKey.x86_64 0:2.30-20.amzn2.0.2 will be installed
--> Running transaction check
---> Package less.x86_64 0:458-9.amzn2.0.4 will be installed
--> Processing Dependency: groff-base for package: less-458-9.amzn2.0.4.x86_64
---> Package openssh-clients.x86_64 0:7.4p1-22.amzn2.0.10 will be installed
--> Processing Dependency: openssh = 7.4p1-22.amzn2.0.10 for package: openssh-clients-7.4p1-22.amzn2.0.10.x86_64
--> Processing Dependency: fipscheck-lib(x86-64) >= 1.3.0 for package: openssh-clients-7.4p1-22.amzn2.0.10.x86_64
--> Processing Dependency: libedit.so.0()(64bit) for package: openssh-clients-7.4p1-22.amzn2.0.10.x86_64
--> Processing Dependency: libfipscheck.so.1()(64bit) for package: openssh-clients-7.4p1-22.amzn2.0.10.x86_64
---> Package pcre2.x86_64 0:10.23-11.amzn2.0.2 will be installed
---> Package perl-Carp.noarch 0:1.26-244.amzn2 will be installed
---> Package perl-Error.noarch 1:0.17020-2.amzn2 will be installed
---> Package perl-Exporter.noarch 0:5.68-3.amzn2 will be installed
---> Package perl-File-Path.noarch 0:2.09-2.amzn2.0.1 will be installed
---> Package perl-File-Temp.noarch 0:0.23.01-3.amzn2 will be installed
---> Package perl-Filter.x86_64 0:1.49-3.amzn2.0.2 will be installed
---> Package perl-Pod-Simple.noarch 1:3.28-4.amzn2 will be installed
--> Processing Dependency: perl(Pod::Escapes) >= 1.04 for package: 1:perl-Pod-Simple-3.28-4.amzn2.noarch
--> Processing Dependency: perl(Encode) for package: 1:perl-Pod-Simple-3.28-4.amzn2.noarch
---> Package perl-Pod-Usage.noarch 0:1.63-3.amzn2 will be installed
--> Processing Dependency: perl(Pod::Text) >= 3.15 for package: perl-Pod-Usage-1.63-3.amzn2.noarch
--> Processing Dependency: perl-Pod-Perldoc for package: perl-Pod-Usage-1.63-3.amzn2.noarch
---> Package perl-Scalar-List-Utils.x86_64 0:1.27-248.amzn2.0.2 will be installed
---> Package perl-Socket.x86_64 0:2.010-4.amzn2.0.2 will be installed
---> Package perl-Storable.x86_64 0:2.45-3.amzn2.0.2 will be installed
---> Package perl-Text-ParseWords.noarch 0:3.29-4.amzn2 will be installed
---> Package perl-Time-HiRes.x86_64 4:1.9725-3.amzn2.0.2 will be installed
---> Package perl-Time-Local.noarch 0:1.2300-2.amzn2 will be installed
---> Package perl-constant.noarch 0:1.27-2.amzn2.0.1 will be installed
---> Package perl-libs.x86_64 4:5.16.3-299.amzn2.0.3 will be installed
---> Package perl-macros.x86_64 4:5.16.3-299.amzn2.0.3 will be installed
---> Package perl-threads.x86_64 0:1.87-4.amzn2.0.2 will be installed
---> Package perl-threads-shared.x86_64 0:1.43-6.amzn2.0.2 will be installed
--> Running transaction check
---> Package fipscheck-lib.x86_64 0:1.4.1-6.amzn2.0.2 will be installed
--> Processing Dependency: /usr/bin/fipscheck for package: fipscheck-lib-1.4.1-6.amzn2.0.2.x86_64
---> Package groff-base.x86_64 0:1.22.2-8.amzn2.0.2 will be installed
---> Package libedit.x86_64 0:3.0-12.20121213cvs.amzn2.0.2 will be installed
---> Package openssh.x86_64 0:7.4p1-22.amzn2.0.10 will be installed
---> Package perl-Encode.x86_64 0:2.51-7.amzn2.0.2 will be installed
---> Package perl-Pod-Escapes.noarch 1:1.04-299.amzn2.0.3 will be installed
---> Package perl-Pod-Perldoc.noarch 0:3.20-4.amzn2.0.1 will be installed
--> Processing Dependency: perl(HTTP::Tiny) for package: perl-Pod-Perldoc-3.20-4.amzn2.0.1.noarch
--> Processing Dependency: perl(parent) for package: perl-Pod-Perldoc-3.20-4.amzn2.0.1.noarch
---> Package perl-podlators.noarch 0:2.5.1-3.amzn2.0.1 will be installed
--> Running transaction check
---> Package fipscheck.x86_64 0:1.4.1-6.amzn2.0.2 will be installed
---> Package perl-HTTP-Tiny.noarch 0:0.033-3.amzn2.0.1 will be installed
---> Package perl-parent.noarch 1:0.225-244.amzn2.0.1 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package                 Arch   Version                       Repository   Size
================================================================================
Installing:
 aws-nitro-enclaves-cli-devel
                         x86_64 1.4.2-0.amzn2                 amzn2extra-aws-nitro-enclaves-cli
                                                                           15 M
 git                     x86_64 2.47.3-1.amzn2.0.1            amzn2-core   57 k
 wget                    x86_64 1.14-18.amzn2.1               amzn2-core  547 k
Installing for dependencies:
 fipscheck               x86_64 1.4.1-6.amzn2.0.2             amzn2-core   21 k
 fipscheck-lib           x86_64 1.4.1-6.amzn2.0.2             amzn2-core   11 k
 git-core                x86_64 2.47.3-1.amzn2.0.1            amzn2-core   11 M
 git-core-doc            noarch 2.47.3-1.amzn2.0.1            amzn2-core  3.2 M
 groff-base              x86_64 1.22.2-8.amzn2.0.2            amzn2-core  948 k
 less                    x86_64 458-9.amzn2.0.4               amzn2-core  119 k
 libedit                 x86_64 3.0-12.20121213cvs.amzn2.0.2  amzn2-core   93 k
 libidn                  x86_64 1.28-4.amzn2.0.5              amzn2-core  209 k
 openssh                 x86_64 7.4p1-22.amzn2.0.10           amzn2-core  484 k
 openssh-clients         x86_64 7.4p1-22.amzn2.0.10           amzn2-core  654 k
 pcre2                   x86_64 10.23-11.amzn2.0.2            amzn2-core  208 k
 perl                    x86_64 4:5.16.3-299.amzn2.0.3        amzn2-core  8.0 M
 perl-Carp               noarch 1.26-244.amzn2                amzn2-core   19 k
 perl-Encode             x86_64 2.51-7.amzn2.0.2              amzn2-core  1.5 M
 perl-Error              noarch 1:0.17020-2.amzn2             amzn2-core   32 k
 perl-Exporter           noarch 5.68-3.amzn2                  amzn2-core   29 k
 perl-File-Path          noarch 2.09-2.amzn2.0.1              amzn2-core   27 k
 perl-File-Temp          noarch 0.23.01-3.amzn2               amzn2-core   56 k
 perl-Filter             x86_64 1.49-3.amzn2.0.2              amzn2-core   76 k
 perl-Getopt-Long        noarch 2.40-3.amzn2                  amzn2-core   56 k
 perl-Git                noarch 2.47.3-1.amzn2.0.1            amzn2-core   44 k
 perl-HTTP-Tiny          noarch 0.033-3.amzn2.0.1             amzn2-core   39 k
 perl-PathTools          x86_64 3.40-5.amzn2.0.2              amzn2-core   83 k
 perl-Pod-Escapes        noarch 1:1.04-299.amzn2.0.3          amzn2-core   52 k
 perl-Pod-Perldoc        noarch 3.20-4.amzn2.0.1              amzn2-core   87 k
 perl-Pod-Simple         noarch 1:3.28-4.amzn2                amzn2-core  216 k
 perl-Pod-Usage          noarch 1.63-3.amzn2                  amzn2-core   27 k
 perl-Scalar-List-Utils  x86_64 1.27-248.amzn2.0.2            amzn2-core   36 k
 perl-Socket             x86_64 2.010-4.amzn2.0.2             amzn2-core   49 k
 perl-Storable           x86_64 2.45-3.amzn2.0.2              amzn2-core   78 k
 perl-TermReadKey        x86_64 2.30-20.amzn2.0.2             amzn2-core   31 k
 perl-Text-ParseWords    noarch 3.29-4.amzn2                  amzn2-core   14 k
 perl-Time-HiRes         x86_64 4:1.9725-3.amzn2.0.2          amzn2-core   45 k
 perl-Time-Local         noarch 1.2300-2.amzn2                amzn2-core   24 k
 perl-constant           noarch 1.27-2.amzn2.0.1              amzn2-core   19 k
 perl-libs               x86_64 4:5.16.3-299.amzn2.0.3        amzn2-core  685 k
 perl-macros             x86_64 4:5.16.3-299.amzn2.0.3        amzn2-core   45 k
 perl-parent             noarch 1:0.225-244.amzn2.0.1         amzn2-core   12 k
 perl-podlators          noarch 2.5.1-3.amzn2.0.1             amzn2-core  112 k
 perl-threads            x86_64 1.87-4.amzn2.0.2              amzn2-core   50 k
 perl-threads-shared     x86_64 1.43-6.amzn2.0.2              amzn2-core   39 k

Transaction Summary
================================================================================
Install  3 Packages (+41 Dependent packages)

Total download size: 44 M
Installed size: 143 M
Downloading packages:
--------------------------------------------------------------------------------
Total                                               12 MB/s |  44 MB  00:03     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : groff-base-1.22.2-8.amzn2.0.2.x86_64                        1/44 
  Installing : less-458-9.amzn2.0.4.x86_64                                 2/44 
  Installing : 1:perl-parent-0.225-244.amzn2.0.1.noarch                    3/44 
  Installing : perl-HTTP-Tiny-0.033-3.amzn2.0.1.noarch                     4/44 
  Installing : perl-podlators-2.5.1-3.amzn2.0.1.noarch                     5/44 
  Installing : perl-Pod-Perldoc-3.20-4.amzn2.0.1.noarch                    6/44 
  Installing : 1:perl-Pod-Escapes-1.04-299.amzn2.0.3.noarch                7/44 
  Installing : perl-Text-ParseWords-3.29-4.amzn2.noarch                    8/44 
  Installing : perl-Encode-2.51-7.amzn2.0.2.x86_64                         9/44 
  Installing : perl-Pod-Usage-1.63-3.amzn2.noarch                         10/44 
  Installing : 4:perl-macros-5.16.3-299.amzn2.0.3.x86_64                  11/44 
  Installing : 4:perl-libs-5.16.3-299.amzn2.0.3.x86_64                    12/44 
  Installing : perl-Filter-1.49-3.amzn2.0.2.x86_64                        13/44 
  Installing : perl-Scalar-List-Utils-1.27-248.amzn2.0.2.x86_64           14/44 
  Installing : perl-PathTools-3.40-5.amzn2.0.2.x86_64                     15/44 
  Installing : perl-Storable-2.45-3.amzn2.0.2.x86_64                      16/44 
  Installing : perl-Socket-2.010-4.amzn2.0.2.x86_64                       17/44 
  Installing : 4:perl-Time-HiRes-1.9725-3.amzn2.0.2.x86_64                18/44 
  Installing : perl-Carp-1.26-244.amzn2.noarch                            19/44 
  Installing : perl-Time-Local-1.2300-2.amzn2.noarch                      20/44 
  Installing : perl-constant-1.27-2.amzn2.0.1.noarch                      21/44 
  Installing : perl-threads-1.87-4.amzn2.0.2.x86_64                       22/44 
  Installing : perl-threads-shared-1.43-6.amzn2.0.2.x86_64                23/44 
  Installing : 1:perl-Pod-Simple-3.28-4.amzn2.noarch                      24/44 
  Installing : perl-Getopt-Long-2.40-3.amzn2.noarch                       25/44 
  Installing : perl-File-Temp-0.23.01-3.amzn2.noarch                      26/44 
  Installing : perl-File-Path-2.09-2.amzn2.0.1.noarch                     27/44 
  Installing : perl-Exporter-5.68-3.amzn2.noarch                          28/44 
  Installing : 4:perl-5.16.3-299.amzn2.0.3.x86_64                         29/44 
  Installing : perl-TermReadKey-2.30-20.amzn2.0.2.x86_64                  30/44 
  Installing : 1:perl-Error-0.17020-2.amzn2.noarch                        31/44 
  Installing : fipscheck-lib-1.4.1-6.amzn2.0.2.x86_64                     32/44 
  Installing : fipscheck-1.4.1-6.amzn2.0.2.x86_64                         33/44 
  Installing : openssh-7.4p1-22.amzn2.0.10.x86_64                         34/44 
  Installing : libedit-3.0-12.20121213cvs.amzn2.0.2.x86_64                35/44 
  Installing : openssh-clients-7.4p1-22.amzn2.0.10.x86_64                 36/44 
  Installing : libidn-1.28-4.amzn2.0.5.x86_64                             37/44 
  Installing : pcre2-10.23-11.amzn2.0.2.x86_64                            38/44 
  Installing : git-core-2.47.3-1.amzn2.0.1.x86_64                         39/44 
  Installing : git-core-doc-2.47.3-1.amzn2.0.1.noarch                     40/44 
  Installing : git-2.47.3-1.amzn2.0.1.x86_64                              41/44 
  Installing : perl-Git-2.47.3-1.amzn2.0.1.noarch                         42/44 
  Installing : wget-1.14-18.amzn2.1.x86_64                                43/44 
  Installing : aws-nitro-enclaves-cli-devel-1.4.2-0.amzn2.x86_64          44/44 
  Verifying  : perl-Exporter-5.68-3.amzn2.noarch                           1/44 
  Verifying  : git-2.47.3-1.amzn2.0.1.x86_64                               2/44 
  Verifying  : perl-Time-Local-1.2300-2.amzn2.noarch                       3/44 
  Verifying  : pcre2-10.23-11.amzn2.0.2.x86_64                             4/44 
  Verifying  : perl-Pod-Usage-1.63-3.amzn2.noarch                          5/44 
  Verifying  : aws-nitro-enclaves-cli-devel-1.4.2-0.amzn2.x86_64           6/44 
  Verifying  : 4:perl-5.16.3-299.amzn2.0.3.x86_64                          7/44 
  Verifying  : 4:perl-macros-5.16.3-299.amzn2.0.3.x86_64                   8/44 
  Verifying  : libidn-1.28-4.amzn2.0.5.x86_64                              9/44 
  Verifying  : openssh-clients-7.4p1-22.amzn2.0.10.x86_64                 10/44 
  Verifying  : openssh-7.4p1-22.amzn2.0.10.x86_64                         11/44 
  Verifying  : perl-Filter-1.49-3.amzn2.0.2.x86_64                        12/44 
  Verifying  : 1:perl-Pod-Simple-3.28-4.amzn2.noarch                      13/44 
  Verifying  : 4:perl-libs-5.16.3-299.amzn2.0.3.x86_64                    14/44 
  Verifying  : perl-Scalar-List-Utils-1.27-248.amzn2.0.2.x86_64           15/44 
  Verifying  : fipscheck-1.4.1-6.amzn2.0.2.x86_64                         16/44 
  Verifying  : perl-File-Temp-0.23.01-3.amzn2.noarch                      17/44 
  Verifying  : less-458-9.amzn2.0.4.x86_64                                18/44 
  Verifying  : perl-podlators-2.5.1-3.amzn2.0.1.noarch                    19/44 
  Verifying  : perl-TermReadKey-2.30-20.amzn2.0.2.x86_64                  20/44 
  Verifying  : perl-Git-2.47.3-1.amzn2.0.1.noarch                         21/44 
  Verifying  : perl-PathTools-3.40-5.amzn2.0.2.x86_64                     22/44 
  Verifying  : perl-HTTP-Tiny-0.033-3.amzn2.0.1.noarch                    23/44 
  Verifying  : wget-1.14-18.amzn2.1.x86_64                                24/44 
  Verifying  : perl-Pod-Perldoc-3.20-4.amzn2.0.1.noarch                   25/44 
  Verifying  : libedit-3.0-12.20121213cvs.amzn2.0.2.x86_64                26/44 
  Verifying  : perl-Storable-2.45-3.amzn2.0.2.x86_64                      27/44 
  Verifying  : 1:perl-Pod-Escapes-1.04-299.amzn2.0.3.noarch               28/44 
  Verifying  : 1:perl-Error-0.17020-2.amzn2.noarch                        29/44 
  Verifying  : perl-Socket-2.010-4.amzn2.0.2.x86_64                       30/44 
  Verifying  : 4:perl-Time-HiRes-1.9725-3.amzn2.0.2.x86_64                31/44 
  Verifying  : perl-Carp-1.26-244.amzn2.noarch                            32/44 
  Verifying  : 1:perl-parent-0.225-244.amzn2.0.1.noarch                   33/44 
  Verifying  : perl-constant-1.27-2.amzn2.0.1.noarch                      34/44 
  Verifying  : perl-Encode-2.51-7.amzn2.0.2.x86_64                        35/44 
  Verifying  : perl-threads-1.87-4.amzn2.0.2.x86_64                       36/44 
  Verifying  : perl-threads-shared-1.43-6.amzn2.0.2.x86_64                37/44 
  Verifying  : git-core-doc-2.47.3-1.amzn2.0.1.noarch                     38/44 
  Verifying  : git-core-2.47.3-1.amzn2.0.1.x86_64                         39/44 
  Verifying  : groff-base-1.22.2-8.amzn2.0.2.x86_64                       40/44 
  Verifying  : perl-Text-ParseWords-3.29-4.amzn2.noarch                   41/44 
  Verifying  : perl-Getopt-Long-2.40-3.amzn2.noarch                       42/44 
  Verifying  : perl-File-Path-2.09-2.amzn2.0.1.noarch                     43/44 
  Verifying  : fipscheck-lib-1.4.1-6.amzn2.0.2.x86_64                     44/44 

Installed:
  aws-nitro-enclaves-cli-devel.x86_64 0:1.4.2-0.amzn2                           
  git.x86_64 0:2.47.3-1.amzn2.0.1                                               
  wget.x86_64 0:1.14-18.amzn2.1                                                 

Dependency Installed:
  fipscheck.x86_64 0:1.4.1-6.amzn2.0.2                                          
  fipscheck-lib.x86_64 0:1.4.1-6.amzn2.0.2                                      
  git-core.x86_64 0:2.47.3-1.amzn2.0.1                                          
  git-core-doc.noarch 0:2.47.3-1.amzn2.0.1                                      
  groff-base.x86_64 0:1.22.2-8.amzn2.0.2                                        
  less.x86_64 0:458-9.amzn2.0.4                                                 
  libedit.x86_64 0:3.0-12.20121213cvs.amzn2.0.2                                 
  libidn.x86_64 0:1.28-4.amzn2.0.5                                              
  openssh.x86_64 0:7.4p1-22.amzn2.0.10                                          
  openssh-clients.x86_64 0:7.4p1-22.amzn2.0.10                                  
  pcre2.x86_64 0:10.23-11.amzn2.0.2                                             
  perl.x86_64 4:5.16.3-299.amzn2.0.3                                            
  perl-Carp.noarch 0:1.26-244.amzn2                                             
  perl-Encode.x86_64 0:2.51-7.amzn2.0.2                                         
  perl-Error.noarch 1:0.17020-2.amzn2                                           
  perl-Exporter.noarch 0:5.68-3.amzn2                                           
  perl-File-Path.noarch 0:2.09-2.amzn2.0.1                                      
  perl-File-Temp.noarch 0:0.23.01-3.amzn2                                       
  perl-Filter.x86_64 0:1.49-3.amzn2.0.2                                         
  perl-Getopt-Long.noarch 0:2.40-3.amzn2                                        
  perl-Git.noarch 0:2.47.3-1.amzn2.0.1                                          
  perl-HTTP-Tiny.noarch 0:0.033-3.amzn2.0.1                                     
  perl-PathTools.x86_64 0:3.40-5.amzn2.0.2                                      
  perl-Pod-Escapes.noarch 1:1.04-299.amzn2.0.3                                  
  perl-Pod-Perldoc.noarch 0:3.20-4.amzn2.0.1                                    
  perl-Pod-Simple.noarch 1:3.28-4.amzn2                                         
  perl-Pod-Usage.noarch 0:1.63-3.amzn2                                          
  perl-Scalar-List-Utils.x86_64 0:1.27-248.amzn2.0.2                            
  perl-Socket.x86_64 0:2.010-4.amzn2.0.2                                        
  perl-Storable.x86_64 0:2.45-3.amzn2.0.2                                       
  perl-TermReadKey.x86_64 0:2.30-20.amzn2.0.2                                   
  perl-Text-ParseWords.noarch 0:3.29-4.amzn2                                    
  perl-Time-HiRes.x86_64 4:1.9725-3.amzn2.0.2                                   
  perl-Time-Local.noarch 0:1.2300-2.amzn2                                       
  perl-constant.noarch 0:1.27-2.amzn2.0.1                                       
  perl-libs.x86_64 4:5.16.3-299.amzn2.0.3                                       
  perl-macros.x86_64 4:5.16.3-299.amzn2.0.3                                     
  perl-parent.noarch 1:0.225-244.amzn2.0.1                                      
  perl-podlators.noarch 0:2.5.1-3.amzn2.0.1                                     
  perl-threads.x86_64 0:1.87-4.amzn2.0.2                                        
  perl-threads-shared.x86_64 0:1.43-6.amzn2.0.2                                 

Complete!
 ---> Removed intermediate container a20cb72a4e73
 ---> 58a670327a8f
Step 3/5 : WORKDIR /home
 ---> Running in cd3d535cb916
 ---> Removed intermediate container cd3d535cb916
 ---> 1ca8a79bad1d
Step 4/5 : COPY builder/run.sh run.sh
 ---> 48f93026d50b
Step 5/5 : CMD ["/home/run.sh"]
 ---> Running in b2473a2c7159
 ---> Removed intermediate container b2473a2c7159
 ---> 17d6162ce0e3
Successfully built 17d6162ce0e3
Successfully tagged ne-example-builder:latest
[BUILDER] ---- Using config: ----
export MANIFEST_NAME="coconginx"
export MANIFEST_REPOSITORY="https://github.com/nerdysrisha/nitroenclave-nginx.git"
export MANIFEST_TAG="main"
export MANIFEST_EIF_NAME="nginx.eif"
export MANIFEST_EIF_DOCKER_IMAGE_NAME="ne-build-nginx-eif"
export MANIFEST_EIF_DOCKER_IMAGE_TAG="1.0"
export MANIFEST_EIF_DOCKER_TARGET=""
export MANIFEST_EIF_DOCKER_FILE_NAME="Dockerfile"
export MANIFEST_EIF_DOCKER_FILE_PATH="examples/x86_64/coconginx"
export MANIFEST_EIF_DOCKER_BUILD_PATH="examples/x86_64/coconginx"
[BUILDER] -----------------------
[BUILDER] All enclave application already exist in the /output folder. Skipping build...
Error response from daemon: No such image: coconginx-36b906d3-ff47-4731-87a4-b7adfe66e8ad:latest
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  341.3MB
Step 1/14 : FROM public.ecr.aws/amazonlinux/amazonlinux:2 as full_image
 ---> 44d98a2e35ef
Step 2/14 : RUN amazon-linux-extras install aws-nitro-enclaves-cli &&     yum install aws-nitro-enclaves-cli-devel jq -y
 ---> Running in 4acf11cbb484
Loaded plugins: ovl, priorities
Cleaning repos: amzn2-core amzn2extra-aws-nitro-enclaves-cli
0 metadata files removed
0 sqlite files removed
0 metadata files removed
Loaded plugins: ovl, priorities
Resolving Dependencies
--> Running transaction check
---> Package aws-nitro-enclaves-cli.x86_64 0:1.4.2-0.amzn2 will be installed
--> Processing Dependency: docker for package: aws-nitro-enclaves-cli-1.4.2-0.amzn2.x86_64
--> Processing Dependency: jq for package: aws-nitro-enclaves-cli-1.4.2-0.amzn2.x86_64
--> Processing Dependency: openssl for package: aws-nitro-enclaves-cli-1.4.2-0.amzn2.x86_64
--> Processing Dependency: systemd for package: aws-nitro-enclaves-cli-1.4.2-0.amzn2.x86_64
--> Processing Dependency: systemd for package: aws-nitro-enclaves-cli-1.4.2-0.amzn2.x86_64
--> Processing Dependency: systemd for package: aws-nitro-enclaves-cli-1.4.2-0.amzn2.x86_64
--> Running transaction check
---> Package docker.x86_64 0:25.0.13-1.amzn2.0.2 will be installed
--> Processing Dependency: containerd >= 1.3.2 for package: docker-25.0.13-1.amzn2.0.2.x86_64
--> Processing Dependency: device-mapper-libs >= 1.02.90-2.24 for package: docker-25.0.13-1.amzn2.0.2.x86_64
--> Processing Dependency: libcgroup >= 0.40.rc1-5.15 for package: docker-25.0.13-1.amzn2.0.2.x86_64
--> Processing Dependency: runc >= 1.0.0 for package: docker-25.0.13-1.amzn2.0.2.x86_64
--> Processing Dependency: iptables for package: docker-25.0.13-1.amzn2.0.2.x86_64
--> Processing Dependency: libsystemd.so.0(LIBSYSTEMD_209)(64bit) for package: docker-25.0.13-1.amzn2.0.2.x86_64
--> Processing Dependency: pigz for package: docker-25.0.13-1.amzn2.0.2.x86_64
--> Processing Dependency: xfsprogs for package: docker-25.0.13-1.amzn2.0.2.x86_64
--> Processing Dependency: xz for package: docker-25.0.13-1.amzn2.0.2.x86_64
--> Processing Dependency: libsystemd.so.0()(64bit) for package: docker-25.0.13-1.amzn2.0.2.x86_64
---> Package jq.x86_64 0:1.5-1.amzn2.0.3 will be installed
--> Processing Dependency: libonig.so.2()(64bit) for package: jq-1.5-1.amzn2.0.3.x86_64
---> Package openssl.x86_64 1:1.0.2k-24.amzn2.0.16 will be installed
--> Processing Dependency: make for package: 1:openssl-1.0.2k-24.amzn2.0.16.x86_64
---> Package systemd.x86_64 0:219-78.amzn2.0.24 will be installed
--> Processing Dependency: kmod >= 18-4 for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: /usr/sbin/groupadd for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: acl for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: dbus for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libcryptsetup.so.4(CRYPTSETUP_1.0)(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libdw.so.1(ELFUTILS_0.122)(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libdw.so.1(ELFUTILS_0.130)(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libdw.so.1(ELFUTILS_0.158)(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libkmod.so.2(LIBKMOD_5)(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libpam.so.0(LIBPAM_1.0)(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libaudit.so.1()(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libcryptsetup.so.4()(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libdw.so.1()(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libkmod.so.2()(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: liblz4.so.1()(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libpam.so.0()(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Processing Dependency: libqrencode.so.3()(64bit) for package: systemd-219-78.amzn2.0.24.x86_64
--> Running transaction check
---> Package acl.x86_64 0:2.2.51-14.amzn2 will be installed
---> Package audit-libs.x86_64 0:2.8.1-3.amzn2.1 will be installed
--> Processing Dependency: libcap-ng.so.0()(64bit) for package: audit-libs-2.8.1-3.amzn2.1.x86_64
---> Package containerd.x86_64 0:2.1.4-1.amzn2.0.2 will be installed
--> Processing Dependency: libseccomp(x86-64) >= 2.5.2 for package: containerd-2.1.4-1.amzn2.0.2.x86_64
---> Package cryptsetup-libs.x86_64 0:1.7.4-4.amzn2 will be installed
---> Package dbus.x86_64 1:1.10.24-7.amzn2.0.4 will be installed
--> Processing Dependency: dbus-libs(x86-64) = 1:1.10.24-7.amzn2.0.4 for package: 1:dbus-1.10.24-7.amzn2.0.4.x86_64
--> Processing Dependency: libdbus-1.so.3(LIBDBUS_1_3)(64bit) for package: 1:dbus-1.10.24-7.amzn2.0.4.x86_64
--> Processing Dependency: libdbus-1.so.3(LIBDBUS_PRIVATE_1.10.24)(64bit) for package: 1:dbus-1.10.24-7.amzn2.0.4.x86_64
--> Processing Dependency: libdbus-1.so.3()(64bit) for package: 1:dbus-1.10.24-7.amzn2.0.4.x86_64
---> Package device-mapper-libs.x86_64 7:1.02.170-6.amzn2.5 will be installed
--> Processing Dependency: device-mapper = 7:1.02.170-6.amzn2.5 for package: 7:device-mapper-libs-1.02.170-6.amzn2.5.x86_64
---> Package elfutils-libs.x86_64 0:0.176-2.amzn2.0.2 will be installed
--> Processing Dependency: default-yama-scope for package: elfutils-libs-0.176-2.amzn2.0.2.x86_64
---> Package iptables.x86_64 0:1.8.4-10.amzn2.1.2 will be installed
--> Processing Dependency: iptables-libs(x86-64) = 1.8.4-10.amzn2.1.2 for package: iptables-1.8.4-10.amzn2.1.2.x86_64
--> Processing Dependency: libip4tc.so.2()(64bit) for package: iptables-1.8.4-10.amzn2.1.2.x86_64
--> Processing Dependency: libip6tc.so.2()(64bit) for package: iptables-1.8.4-10.amzn2.1.2.x86_64
--> Processing Dependency: libnetfilter_conntrack.so.3()(64bit) for package: iptables-1.8.4-10.amzn2.1.2.x86_64
--> Processing Dependency: libnfnetlink.so.0()(64bit) for package: iptables-1.8.4-10.amzn2.1.2.x86_64
--> Processing Dependency: libpcap.so.1()(64bit) for package: iptables-1.8.4-10.amzn2.1.2.x86_64
--> Processing Dependency: libxtables.so.12()(64bit) for package: iptables-1.8.4-10.amzn2.1.2.x86_64
---> Package kmod.x86_64 0:25-3.amzn2.0.2 will be installed
---> Package kmod-libs.x86_64 0:25-3.amzn2.0.2 will be installed
---> Package libcgroup.x86_64 0:0.41-21.amzn2 will be installed
---> Package lz4.x86_64 0:1.7.5-2.amzn2.0.2 will be installed
---> Package make.x86_64 1:3.82-24.amzn2 will be installed
---> Package oniguruma.x86_64 0:5.9.6-1.amzn2.0.7 will be installed
---> Package pam.x86_64 0:1.1.8-23.amzn2.0.5 will be installed
--> Processing Dependency: cracklib-dicts >= 2.8 for package: pam-1.1.8-23.amzn2.0.5.x86_64
--> Processing Dependency: libpwquality >= 0.9.9 for package: pam-1.1.8-23.amzn2.0.5.x86_64
--> Processing Dependency: libcrack.so.2()(64bit) for package: pam-1.1.8-23.amzn2.0.5.x86_64
---> Package pigz.x86_64 0:2.3.4-1.amzn2.0.1 will be installed
---> Package qrencode-libs.x86_64 0:3.4.1-3.amzn2.0.2 will be installed
---> Package runc.x86_64 0:1.3.3-2.amzn2 will be installed
---> Package shadow-utils.x86_64 2:4.1.5.1-24.amzn2.0.3 will be installed
--> Processing Dependency: libsemanage.so.1(LIBSEMANAGE_1.0)(64bit) for package: 2:shadow-utils-4.1.5.1-24.amzn2.0.3.x86_64
--> Processing Dependency: libsemanage.so.1()(64bit) for package: 2:shadow-utils-4.1.5.1-24.amzn2.0.3.x86_64
---> Package systemd-libs.x86_64 0:219-78.amzn2.0.24 will be installed
---> Package xfsprogs.x86_64 0:5.0.0-10.amzn2.0.1 will be installed
---> Package xz.x86_64 0:5.2.2-1.amzn2.0.3 will be installed
--> Running transaction check
---> Package cracklib.x86_64 0:2.9.0-11.amzn2.0.2 will be installed
--> Processing Dependency: gzip for package: cracklib-2.9.0-11.amzn2.0.2.x86_64
---> Package cracklib-dicts.x86_64 0:2.9.0-11.amzn2.0.2 will be installed
---> Package dbus-libs.x86_64 1:1.10.24-7.amzn2.0.4 will be installed
---> Package device-mapper.x86_64 7:1.02.170-6.amzn2.5 will be installed
--> Processing Dependency: util-linux >= 2.23 for package: 7:device-mapper-1.02.170-6.amzn2.5.x86_64
---> Package elfutils-default-yama-scope.noarch 0:0.176-2.amzn2.0.2 will be installed
---> Package iptables-libs.x86_64 0:1.8.4-10.amzn2.1.2 will be installed
---> Package libcap-ng.x86_64 0:0.7.5-4.amzn2.0.4 will be installed
---> Package libnetfilter_conntrack.x86_64 0:1.0.6-1.amzn2.0.2 will be installed
--> Processing Dependency: libmnl.so.0(LIBMNL_1.0)(64bit) for package: libnetfilter_conntrack-1.0.6-1.amzn2.0.2.x86_64
--> Processing Dependency: libmnl.so.0(LIBMNL_1.1)(64bit) for package: libnetfilter_conntrack-1.0.6-1.amzn2.0.2.x86_64
--> Processing Dependency: libmnl.so.0()(64bit) for package: libnetfilter_conntrack-1.0.6-1.amzn2.0.2.x86_64
---> Package libnfnetlink.x86_64 0:1.0.1-4.amzn2.0.2 will be installed
---> Package libpcap.x86_64 14:1.5.3-11.amzn2 will be installed
---> Package libpwquality.x86_64 0:1.2.3-5.amzn2 will be installed
---> Package libseccomp.x86_64 0:2.5.2-1.amzn2.0.1 will be installed
---> Package libsemanage.x86_64 0:2.5-11.amzn2 will be installed
--> Processing Dependency: libustr-1.0.so.1(USTR_1.0)(64bit) for package: libsemanage-2.5-11.amzn2.x86_64
--> Processing Dependency: libustr-1.0.so.1(USTR_1.0.1)(64bit) for package: libsemanage-2.5-11.amzn2.x86_64
--> Processing Dependency: libustr-1.0.so.1()(64bit) for package: libsemanage-2.5-11.amzn2.x86_64
--> Running transaction check
---> Package gzip.x86_64 0:1.5-10.amzn2.0.1 will be installed
---> Package libmnl.x86_64 0:1.0.3-7.amzn2.0.2 will be installed
---> Package ustr.x86_64 0:1.0.4-16.amzn2.0.3 will be installed
---> Package util-linux.x86_64 0:2.30.2-2.amzn2.0.11 will be installed
--> Processing Dependency: libfdisk = 2.30.2-2.amzn2.0.11 for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libsmartcols = 2.30.2-2.amzn2.0.11 for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libfdisk.so.1(FDISK_2.26)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libfdisk.so.1(FDISK_2.27)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libfdisk.so.1(FDISK_2.28)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libfdisk.so.1(FDISK_2.29)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libfdisk.so.1(FDISK_2.30)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libsmartcols.so.1(SMARTCOLS_2.25)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libsmartcols.so.1(SMARTCOLS_2.27)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libsmartcols.so.1(SMARTCOLS_2.28)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libsmartcols.so.1(SMARTCOLS_2.29)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libsmartcols.so.1(SMARTCOLS_2.30)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libutempter.so.0(UTEMPTER_1.1)(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libfdisk.so.1()(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libsmartcols.so.1()(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Processing Dependency: libutempter.so.0()(64bit) for package: util-linux-2.30.2-2.amzn2.0.11.x86_64
--> Running transaction check
---> Package libfdisk.x86_64 0:2.30.2-2.amzn2.0.11 will be installed
---> Package libsmartcols.x86_64 0:2.30.2-2.amzn2.0.11 will be installed
---> Package libutempter.x86_64 0:1.1.6-4.amzn2.0.2 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package                     Arch   Version                Repository      Size
================================================================================
Installing:
 aws-nitro-enclaves-cli      x86_64 1.4.2-0.amzn2          amzn2extra-aws-nitro-enclaves-cli
                                                                          6.0 M
Installing for dependencies:
 acl                         x86_64 2.2.51-14.amzn2        amzn2-core      82 k
 audit-libs                  x86_64 2.8.1-3.amzn2.1        amzn2-core      99 k
 containerd                  x86_64 2.1.4-1.amzn2.0.2      amzn2extra-aws-nitro-enclaves-cli
                                                                           20 M
 cracklib                    x86_64 2.9.0-11.amzn2.0.2     amzn2-core      80 k
 cracklib-dicts              x86_64 2.9.0-11.amzn2.0.2     amzn2-core     3.6 M
 cryptsetup-libs             x86_64 1.7.4-4.amzn2          amzn2-core     224 k
 dbus                        x86_64 1:1.10.24-7.amzn2.0.4  amzn2-core     246 k
 dbus-libs                   x86_64 1:1.10.24-7.amzn2.0.4  amzn2-core     167 k
 device-mapper               x86_64 7:1.02.170-6.amzn2.5   amzn2-core     297 k
 device-mapper-libs          x86_64 7:1.02.170-6.amzn2.5   amzn2-core     326 k
 docker                      x86_64 25.0.13-1.amzn2.0.2    amzn2extra-aws-nitro-enclaves-cli
                                                                           46 M
 elfutils-default-yama-scope noarch 0.176-2.amzn2.0.2      amzn2-core      33 k
 elfutils-libs               x86_64 0.176-2.amzn2.0.2      amzn2-core     289 k
 gzip                        x86_64 1.5-10.amzn2.0.1       amzn2-core     129 k
 iptables                    x86_64 1.8.4-10.amzn2.1.2     amzn2-core     476 k
 iptables-libs               x86_64 1.8.4-10.amzn2.1.2     amzn2-core      93 k
 jq                          x86_64 1.5-1.amzn2.0.3        amzn2-core     152 k
 kmod                        x86_64 25-3.amzn2.0.2         amzn2-core     111 k
 kmod-libs                   x86_64 25-3.amzn2.0.2         amzn2-core      59 k
 libcap-ng                   x86_64 0.7.5-4.amzn2.0.4      amzn2-core      25 k
 libcgroup                   x86_64 0.41-21.amzn2          amzn2-core      66 k
 libfdisk                    x86_64 2.30.2-2.amzn2.0.11    amzn2-core     238 k
 libmnl                      x86_64 1.0.3-7.amzn2.0.2      amzn2-core      23 k
 libnetfilter_conntrack      x86_64 1.0.6-1.amzn2.0.2      amzn2-core      58 k
 libnfnetlink                x86_64 1.0.1-4.amzn2.0.2      amzn2-core      26 k
 libpcap                     x86_64 14:1.5.3-11.amzn2      amzn2-core     140 k
 libpwquality                x86_64 1.2.3-5.amzn2          amzn2-core      84 k
 libseccomp                  x86_64 2.5.2-1.amzn2.0.1      amzn2-core      65 k
 libsemanage                 x86_64 2.5-11.amzn2           amzn2-core     152 k
 libsmartcols                x86_64 2.30.2-2.amzn2.0.11    amzn2-core     155 k
 libutempter                 x86_64 1.1.6-4.amzn2.0.2      amzn2-core      25 k
 lz4                         x86_64 1.7.5-2.amzn2.0.2      amzn2-core      98 k
 make                        x86_64 1:3.82-24.amzn2        amzn2-core     420 k
 oniguruma                   x86_64 5.9.6-1.amzn2.0.7      amzn2-core     127 k
 openssl                     x86_64 1:1.0.2k-24.amzn2.0.16 amzn2-core     498 k
 pam                         x86_64 1.1.8-23.amzn2.0.5     amzn2-core     717 k
 pigz                        x86_64 2.3.4-1.amzn2.0.1      amzn2-core      81 k
 qrencode-libs               x86_64 3.4.1-3.amzn2.0.2      amzn2-core      50 k
 runc                        x86_64 1.3.3-2.amzn2          amzn2extra-aws-nitro-enclaves-cli
                                                                          3.9 M
 shadow-utils                x86_64 2:4.1.5.1-24.amzn2.0.3 amzn2-core     1.1 M
 systemd                     x86_64 219-78.amzn2.0.24      amzn2-core     5.0 M
 systemd-libs                x86_64 219-78.amzn2.0.24      amzn2-core     409 k
 ustr                        x86_64 1.0.4-16.amzn2.0.3     amzn2-core      96 k
 util-linux                  x86_64 2.30.2-2.amzn2.0.11    amzn2-core     2.3 M
 xfsprogs                    x86_64 5.0.0-10.amzn2.0.1     amzn2-core     1.0 M
 xz                          x86_64 5.2.2-1.amzn2.0.3      amzn2-core     228 k

Transaction Summary
================================================================================
Install  1 Package (+46 Dependent packages)

Total download size: 96 M
Installed size: 345 M
Downloading packages:
--------------------------------------------------------------------------------
Total                                               15 MB/s |  96 MB  00:06     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : libcap-ng-0.7.5-4.amzn2.0.4.x86_64                          1/47 
  Installing : audit-libs-2.8.1-3.amzn2.1.x86_64                           2/47 
  Installing : libseccomp-2.5.2-1.amzn2.0.1.x86_64                         3/47 
  Installing : runc-1.3.3-2.amzn2.x86_64                                   4/47 
  Installing : libnfnetlink-1.0.1-4.amzn2.0.2.x86_64                       5/47 
  Installing : 14:libpcap-1.5.3-11.amzn2.x86_64                            6/47 
  Installing : lz4-1.7.5-2.amzn2.0.2.x86_64                                7/47 
  Installing : iptables-libs-1.8.4-10.amzn2.1.2.x86_64                     8/47 
  Installing : containerd-2.1.4-1.amzn2.0.2.x86_64                         9/47 
  Installing : kmod-libs-25-3.amzn2.0.2.x86_64                            10/47 
  Installing : 1:make-3.82-24.amzn2.x86_64                                11/47 
  Installing : 1:openssl-1.0.2k-24.amzn2.0.16.x86_64                      12/47 
  Installing : acl-2.2.51-14.amzn2.x86_64                                 13/47 
  Installing : kmod-25-3.amzn2.0.2.x86_64                                 14/47 
  Installing : ustr-1.0.4-16.amzn2.0.3.x86_64                             15/47 
  Installing : libsemanage-2.5-11.amzn2.x86_64                            16/47 
  Installing : 2:shadow-utils-4.1.5.1-24.amzn2.0.3.x86_64                 17/47 
  Installing : libutempter-1.1.6-4.amzn2.0.2.x86_64                       18/47 
  Installing : xz-5.2.2-1.amzn2.0.3.x86_64                                19/47 
  Installing : libfdisk-2.30.2-2.amzn2.0.11.x86_64                        20/47 
  Installing : qrencode-libs-3.4.1-3.amzn2.0.2.x86_64                     21/47 
  Installing : oniguruma-5.9.6-1.amzn2.0.7.x86_64                         22/47 
  Installing : jq-1.5-1.amzn2.0.3.x86_64                                  23/47 
  Installing : pigz-2.3.4-1.amzn2.0.1.x86_64                              24/47 
  Installing : libsmartcols-2.30.2-2.amzn2.0.11.x86_64                    25/47 
  Installing : gzip-1.5-10.amzn2.0.1.x86_64                               26/47 
  Installing : cracklib-2.9.0-11.amzn2.0.2.x86_64                         27/47 
  Installing : cracklib-dicts-2.9.0-11.amzn2.0.2.x86_64                   28/47 
  Installing : pam-1.1.8-23.amzn2.0.5.x86_64                              29/47 
  Installing : libpwquality-1.2.3-5.amzn2.x86_64                          30/47 
  Installing : util-linux-2.30.2-2.amzn2.0.11.x86_64                      31/47 
  Installing : 7:device-mapper-1.02.170-6.amzn2.5.x86_64                  32/47 
  Installing : 7:device-mapper-libs-1.02.170-6.amzn2.5.x86_64             33/47 
  Installing : cryptsetup-libs-1.7.4-4.amzn2.x86_64                       34/47 
  Installing : elfutils-libs-0.176-2.amzn2.0.2.x86_64                     35/47 
  Installing : systemd-libs-219-78.amzn2.0.24.x86_64                      36/47 
  Installing : 1:dbus-libs-1.10.24-7.amzn2.0.4.x86_64                     37/47 
  Installing : systemd-219-78.amzn2.0.24.x86_64                           38/47 
Failed to get D-Bus connection: Operation not permitted
  Installing : elfutils-default-yama-scope-0.176-2.amzn2.0.2.noarch       39/47 
  Installing : 1:dbus-1.10.24-7.amzn2.0.4.x86_64                          40/47 
  Installing : libcgroup-0.41-21.amzn2.x86_64                             41/47 
  Installing : xfsprogs-5.0.0-10.amzn2.0.1.x86_64                         42/47 
  Installing : libmnl-1.0.3-7.amzn2.0.2.x86_64                            43/47 
  Installing : libnetfilter_conntrack-1.0.6-1.amzn2.0.2.x86_64            44/47 
  Installing : iptables-1.8.4-10.amzn2.1.2.x86_64                         45/47 
  Installing : docker-25.0.13-1.amzn2.0.2.x86_64                          46/47 
  Installing : aws-nitro-enclaves-cli-1.4.2-0.amzn2.x86_64                47/47 
chgrp: cannot access '/dev/nitro_enclaves': No such file or directory

    * In order to successfully run Nitro Enclaves, please add your user to group 'ne'

    * Before being able to run enclaves, the system administrator must reserve the required
      resources (i.e. CPUs and memory). Edit the allocator configuration file at
      /etc/nitro_enclaves/allocator.yaml and then start the allocator oneshot service:
      
        sudo systemctl start nitro-enclaves-allocator.service

      Resource allocation can be performed at system boot (recommended), by enabling
      the allocator service:

        sudo systemctl enable nitro-enclaves-allocator.service

  Verifying  : 1:dbus-libs-1.10.24-7.amzn2.0.4.x86_64                      1/47 
  Verifying  : libmnl-1.0.3-7.amzn2.0.2.x86_64                             2/47 
  Verifying  : lz4-1.7.5-2.amzn2.0.2.x86_64                                3/47 
  Verifying  : gzip-1.5-10.amzn2.0.1.x86_64                                4/47 
  Verifying  : jq-1.5-1.amzn2.0.3.x86_64                                   5/47 
  Verifying  : libsmartcols-2.30.2-2.amzn2.0.11.x86_64                     6/47 
  Verifying  : pigz-2.3.4-1.amzn2.0.1.x86_64                               7/47 
  Verifying  : oniguruma-5.9.6-1.amzn2.0.7.x86_64                          8/47 
  Verifying  : cracklib-2.9.0-11.amzn2.0.2.x86_64                          9/47 
  Verifying  : iptables-1.8.4-10.amzn2.1.2.x86_64                         10/47 
  Verifying  : 2:shadow-utils-4.1.5.1-24.amzn2.0.3.x86_64                 11/47 
  Verifying  : pam-1.1.8-23.amzn2.0.5.x86_64                              12/47 
  Verifying  : cryptsetup-libs-1.7.4-4.amzn2.x86_64                       13/47 
  Verifying  : 14:libpcap-1.5.3-11.amzn2.x86_64                           14/47 
  Verifying  : containerd-2.1.4-1.amzn2.0.2.x86_64                        15/47 
  Verifying  : systemd-libs-219-78.amzn2.0.24.x86_64                      16/47 
  Verifying  : libutempter-1.1.6-4.amzn2.0.2.x86_64                       17/47 
  Verifying  : elfutils-default-yama-scope-0.176-2.amzn2.0.2.noarch       18/47 
  Verifying  : 1:dbus-1.10.24-7.amzn2.0.4.x86_64                          19/47 
  Verifying  : qrencode-libs-3.4.1-3.amzn2.0.2.x86_64                     20/47 
  Verifying  : systemd-219-78.amzn2.0.24.x86_64                           21/47 
  Verifying  : libpwquality-1.2.3-5.amzn2.x86_64                          22/47 
  Verifying  : runc-1.3.3-2.amzn2.x86_64                                  23/47 
  Verifying  : aws-nitro-enclaves-cli-1.4.2-0.amzn2.x86_64                24/47 
  Verifying  : 7:device-mapper-libs-1.02.170-6.amzn2.5.x86_64             25/47 
  Verifying  : libcgroup-0.41-21.amzn2.x86_64                             26/47 
  Verifying  : cracklib-dicts-2.9.0-11.amzn2.0.2.x86_64                   27/47 
  Verifying  : util-linux-2.30.2-2.amzn2.0.11.x86_64                      28/47 
  Verifying  : libfdisk-2.30.2-2.amzn2.0.11.x86_64                        29/47 
  Verifying  : xfsprogs-5.0.0-10.amzn2.0.1.x86_64                         30/47 
  Verifying  : libcap-ng-0.7.5-4.amzn2.0.4.x86_64                         31/47 
  Verifying  : audit-libs-2.8.1-3.amzn2.1.x86_64                          32/47 
  Verifying  : xz-5.2.2-1.amzn2.0.3.x86_64                                33/47 
  Verifying  : ustr-1.0.4-16.amzn2.0.3.x86_64                             34/47 
  Verifying  : libnetfilter_conntrack-1.0.6-1.amzn2.0.2.x86_64            35/47 
  Verifying  : kmod-25-3.amzn2.0.2.x86_64                                 36/47 
  Verifying  : acl-2.2.51-14.amzn2.x86_64                                 37/47 
  Verifying  : libsemanage-2.5-11.amzn2.x86_64                            38/47 
  Verifying  : 1:openssl-1.0.2k-24.amzn2.0.16.x86_64                      39/47 
  Verifying  : libnfnetlink-1.0.1-4.amzn2.0.2.x86_64                      40/47 
  Verifying  : 1:make-3.82-24.amzn2.x86_64                                41/47 
  Verifying  : elfutils-libs-0.176-2.amzn2.0.2.x86_64                     42/47 
  Verifying  : iptables-libs-1.8.4-10.amzn2.1.2.x86_64                    43/47 
  Verifying  : libseccomp-2.5.2-1.amzn2.0.1.x86_64                        44/47 
  Verifying  : kmod-libs-25-3.amzn2.0.2.x86_64                            45/47 
  Verifying  : docker-25.0.13-1.amzn2.0.2.x86_64                          46/47 
  Verifying  : 7:device-mapper-1.02.170-6.amzn2.5.x86_64                  47/47 

Installed:
  aws-nitro-enclaves-cli.x86_64 0:1.4.2-0.amzn2                                 

Dependency Installed:
  acl.x86_64 0:2.2.51-14.amzn2                                                  
  audit-libs.x86_64 0:2.8.1-3.amzn2.1                                           
  containerd.x86_64 0:2.1.4-1.amzn2.0.2                                         
  cracklib.x86_64 0:2.9.0-11.amzn2.0.2                                          
  cracklib-dicts.x86_64 0:2.9.0-11.amzn2.0.2                                    
  cryptsetup-libs.x86_64 0:1.7.4-4.amzn2                                        
  dbus.x86_64 1:1.10.24-7.amzn2.0.4                                             
  dbus-libs.x86_64 1:1.10.24-7.amzn2.0.4                                        
  device-mapper.x86_64 7:1.02.170-6.amzn2.5                                     
  device-mapper-libs.x86_64 7:1.02.170-6.amzn2.5                                
  docker.x86_64 0:25.0.13-1.amzn2.0.2                                           
  elfutils-default-yama-scope.noarch 0:0.176-2.amzn2.0.2                        
  elfutils-libs.x86_64 0:0.176-2.amzn2.0.2                                      
  gzip.x86_64 0:1.5-10.amzn2.0.1                                                
  iptables.x86_64 0:1.8.4-10.amzn2.1.2                                          
  iptables-libs.x86_64 0:1.8.4-10.amzn2.1.2                                     
  jq.x86_64 0:1.5-1.amzn2.0.3                                                   
  kmod.x86_64 0:25-3.amzn2.0.2                                                  
  kmod-libs.x86_64 0:25-3.amzn2.0.2                                             
  libcap-ng.x86_64 0:0.7.5-4.amzn2.0.4                                          
  libcgroup.x86_64 0:0.41-21.amzn2                                              
  libfdisk.x86_64 0:2.30.2-2.amzn2.0.11                                         
  libmnl.x86_64 0:1.0.3-7.amzn2.0.2                                             
  libnetfilter_conntrack.x86_64 0:1.0.6-1.amzn2.0.2                             
  libnfnetlink.x86_64 0:1.0.1-4.amzn2.0.2                                       
  libpcap.x86_64 14:1.5.3-11.amzn2                                              
  libpwquality.x86_64 0:1.2.3-5.amzn2                                           
  libseccomp.x86_64 0:2.5.2-1.amzn2.0.1                                         
  libsemanage.x86_64 0:2.5-11.amzn2                                             
  libsmartcols.x86_64 0:2.30.2-2.amzn2.0.11                                     
  libutempter.x86_64 0:1.1.6-4.amzn2.0.2                                        
  lz4.x86_64 0:1.7.5-2.amzn2.0.2                                                
  make.x86_64 1:3.82-24.amzn2                                                   
  oniguruma.x86_64 0:5.9.6-1.amzn2.0.7                                          
  openssl.x86_64 1:1.0.2k-24.amzn2.0.16                                         
  pam.x86_64 0:1.1.8-23.amzn2.0.5                                               
  pigz.x86_64 0:2.3.4-1.amzn2.0.1                                               
  qrencode-libs.x86_64 0:3.4.1-3.amzn2.0.2                                      
  runc.x86_64 0:1.3.3-2.amzn2                                                   
  shadow-utils.x86_64 2:4.1.5.1-24.amzn2.0.3                                    
  systemd.x86_64 0:219-78.amzn2.0.24                                            
  systemd-libs.x86_64 0:219-78.amzn2.0.24                                       
  ustr.x86_64 0:1.0.4-16.amzn2.0.3                                              
  util-linux.x86_64 0:2.30.2-2.amzn2.0.11                                       
  xfsprogs.x86_64 0:5.0.0-10.amzn2.0.1                                          
  xz.x86_64 0:5.2.2-1.amzn2.0.3                                                 

Complete!
Installing aws-nitro-enclaves-cli
  2  httpd_modules                  available    [ =1.0  =stable ]
  3  memcached1.5                   available    \
        [ =1.5.1  =1.5.16  =1.5.17 ]
  9  R3.4                           available    [ =3.4.3  =stable ]
 18  libreoffice                    available    \
        [ =5.0.6.2_15  =5.3.6.1  =stable ]
 19  gimp                           available    [ =2.8.22 ]
 20  docker                         available    \
        [ =17.12.1  =18.03.1  =18.06.1  =18.09.9  =stable ]
 21  mate-desktop1.x                available    \
        [ =1.19.0  =1.20.0  =stable ]
 22  GraphicsMagick1.3              available    \
        [ =1.3.29  =1.3.32  =1.3.34  =stable ]
 25  testing                        available    [ =1.0  =stable ]
 26  ecs                            available    [ =stable ]
 27  corretto8                      available    \
        [ =1.8.0_192  =1.8.0_202  =1.8.0_212  =1.8.0_222  =1.8.0_232
          =1.8.0_242  =stable ]
 32  lustre2.10                     available    \
        [ =2.10.5  =2.10.8  =stable ]
 34  lynis                          available    [ =stable ]
 36  BCC                            available    [ =0.x  =stable ]
 37  mono                           available    [ =5.x  =stable ]
 38  nginx1                         available    [ =stable ]
 40  mock                           available    [ =stable ]
 43  livepatch                      available    [ =stable ]
 45  haproxy2                       available    [ =stable ]
 46  collectd                       available    [ =stable ]
 47  aws-nitro-enclaves-cli=latest  enabled      [ =stable ]
 48  R4                             available    [ =stable ]
 49  kernel-5.4                     available    [ =stable ]
 50  selinux-ng                     available    [ =stable ]
 52  tomcat9                        available    [ =stable ]
 55  kernel-5.10                    available    [ =stable ]
 56  redis6                         available    [ =stable ]
 59 †postgresql13                   available    [ =stable ]
 60  mock2                          available    [ =stable ]
 62  kernel-5.15                    available    [ =stable ]
 63  postgresql14                   available    [ =stable ]
 64  firefox                        available    [ =stable ]
 65  lustre                         available    [ =stable ]
 66 †php8.1                         available    [ =stable ]
 67  awscli1                        available    [ =stable ]
 68  php8.2                         available    [ =stable ]
 69  dnsmasq                        available    [ =stable ]
 70  unbound1.17                    available    [ =stable ]
 72  collectd-python3               available    [ =stable ]
† Note on end-of-support. Use 'info' subcommand.
Loaded plugins: ovl, priorities
Package jq-1.5-1.amzn2.0.3.x86_64 already installed and latest version
Resolving Dependencies
--> Running transaction check
---> Package aws-nitro-enclaves-cli-devel.x86_64 0:1.4.2-0.amzn2 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package           Arch   Version       Repository                         Size
================================================================================
Installing:
 aws-nitro-enclaves-cli-devel
                   x86_64 1.4.2-0.amzn2 amzn2extra-aws-nitro-enclaves-cli  15 M

Transaction Summary
================================================================================
Install  1 Package

Total download size: 15 M
Installed size: 49 M
Downloading packages:
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : aws-nitro-enclaves-cli-devel-1.4.2-0.amzn2.x86_64            1/1 
  Verifying  : aws-nitro-enclaves-cli-devel-1.4.2-0.amzn2.x86_64            1/1 

Installed:
  aws-nitro-enclaves-cli-devel.x86_64 0:1.4.2-0.amzn2                           

Complete!
 ---> Removed intermediate container 4acf11cbb484
 ---> 1b30fab82299
Step 3/14 : WORKDIR /ne-deps
 ---> Running in 34ad5d84c2c4
 ---> Removed intermediate container 34ad5d84c2c4
 ---> f4390ebd94d1
Step 4/14 : RUN BINS="    /usr/bin/nitro-cli     /usr/bin/nitro-enclaves-allocator     /usr/bin/jq     " &&     for bin in $BINS; do         { echo "$bin"; ldd "$bin" | grep -Eo "/.*lib.*/[^ ]+"; } |             while read path; do                 mkdir -p ".$(dirname $path)";                 cp -fL "$path" ".$path";             done     done
 ---> Running in a1f354e036a8
 ---> Removed intermediate container a1f354e036a8
 ---> bf0e18630958
Step 5/14 : RUN     mkdir -p /ne-deps/etc/nitro_enclaves &&     mkdir -p /ne-deps/run/nitro_enclaves &&     mkdir -p /ne-deps/var/log/nitro_enclaves &&     cp -rf /usr/share/nitro_enclaves/ /ne-deps/usr/share/ &&     cp -f /etc/nitro_enclaves/allocator.yaml /ne-deps/etc/nitro_enclaves/allocator.yaml
 ---> Running in 9577027d8e22
 ---> Removed intermediate container 9577027d8e22
 ---> b5b2b7a2b60d
Step 6/14 : FROM public.ecr.aws/amazonlinux/amazonlinux:2 as image
 ---> 44d98a2e35ef
Step 7/14 : COPY --from=full_image /ne-deps/etc /etc
 ---> 93f8465d1fa6
Step 8/14 : COPY --from=full_image /ne-deps/lib64 /lib64
 ---> b889f143db60
Step 9/14 : COPY --from=full_image /ne-deps/run /run
 ---> 5f8d1c1ee32c
Step 10/14 : COPY --from=full_image /ne-deps/usr /usr
 ---> 015c7004b5ab
Step 11/14 : COPY --from=full_image /ne-deps/var /var
 ---> c474660d9ecb
Step 12/14 : COPY bin/nginx.eif /home
 ---> 08d3f7eb533d
Step 13/14 : COPY coconginx/run.sh  /home
 ---> 6bc28ac406e8
Step 14/14 : CMD ["/home/run.sh"]
 ---> Running in efcc60918738
 ---> Removed intermediate container efcc60918738
 ---> 95570d1f8ea0
[Warning] One or more build-args [config_region] were not consumed
Successfully built 95570d1f8ea0
Successfully tagged coconginx-36b906d3-ff47-4731-87a4-b7adfe66e8ad:latest
sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ 


	
}

docker images

	sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ docker images
	REPOSITORY                                       TAG       IMAGE ID       CREATED         SIZE
	coconginx-36b906d3-ff47-4731-87a4-b7adfe66e8ad   latest    95570d1f8ea0   2 minutes ago   576MB
	<none>                                           <none>    b5b2b7a2b60d   2 minutes ago   1.12GB
	ne-example-builder                               latest    17d6162ce0e3   3 minutes ago   1.14GB
	public.ecr.aws/amazonlinux/amazonlinux           2         44d98a2e35ef   5 days ago      165MB
	kindest/node                                     <none>    4357c93ef232   2 months ago    985MB
	sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ 


docker ps -a


	sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ docker ps -a
	CONTAINER ID   IMAGE                       COMMAND                  CREATED         STATUS                     PORTS                       NAMES
	36c575bd465d   ne-example-builder:latest   "/home/run.sh"           3 minutes ago   Exited (0) 3 minutes ago                               funny_williamson
	94ceaa5df6ff   kindest/node:v1.34.0        "/usr/local/bin/entr…"   7 days ago      Up 42 minutes              127.0.0.1:42939->6443/tcp   intg-ks-control-plane
	3a37000fe3af   kindest/node:v1.34.0        "/usr/local/bin/entr…"   7 days ago      Up 42 minutes                                          intg-ks-worker2
	1e9f7266e483   kindest/node:v1.34.0        "/usr/local/bin/entr…"   7 days ago      Up 42 minutes                                          intg-ks-worker
	sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ 



docker tag coconginx-36b906d3-ff47-4731-87a4-b7adfe66e8ad:latest nerdysrisha/nginx-aws-nitro:latest


	sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ docker tag coconginx-36b906d3-ff47-4731-87a4-b7adfe66e8ad:latest nerdysrisha/nginx-aws-nitro:latest

	sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ docker images
	REPOSITORY                                       TAG       IMAGE ID       CREATED         SIZE
	coconginx-36b906d3-ff47-4731-87a4-b7adfe66e8ad   latest    95570d1f8ea0   4 minutes ago   576MB
	nerdysrisha/nginx-aws-nitro                      latest    95570d1f8ea0   4 minutes ago   576MB
	<none>                                           <none>    b5b2b7a2b60d   4 minutes ago   1.12GB
	ne-example-builder                               latest    17d6162ce0e3   6 minutes ago   1.14GB
	public.ecr.aws/amazonlinux/amazonlinux           2         44d98a2e35ef   5 days ago      165MB
	kindest/node                                     <none>    4357c93ef232   2 months ago    985MB
	sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ 




docker push nerdysrisha/nginx-aws-nitro:latest


	sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ 
	docker push nerdysrisha/nginx-aws-nitro:latest


	The push refers to repository [docker.io/nerdysrisha/nginx-aws-nitro]
	69d4bad02e9b: Pushed 
	76d4a3838e86: Pushed 
	00c39454ee1e: Pushed 
	4b12df13f98e: Pushed 
	79c36462cc3e: Pushed 
	a636f2a53545: Pushed 
	ffe8300eb21b: Pushed 
	b6551023130d: Pushed 
	latest: digest: sha256:d5792dc47e4ee186c1b2721934093ed2924d104450ba144635b28346279307a6 size: 1993
	sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ 




sridhara@ubuntu:~/Downloads/3-aws-scripts-eks-coco-linux/create$ dos2unix file6-nginx-deployment.yaml


dos2unix: converting file file6-nginx-deployment.yaml to Unix format...
sridhara@ubuntu:~/Downloads/3-aws-scripts-eks-coco-linux/create$ 



 



