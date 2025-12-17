
#VERIFY LONG RUNNING PROCESSES NIGINX

		 
sudo nitro-cli build-enclave --docker-uri nginx --output-file nginx.eif


cat /etc/nitro_enclaves/allocator.yaml
 

sudo nitro-cli run-enclave --cpu-count 2 --memory 1024 --eif-path nginx.eif --debug-mode


sudo nitro-cli describe-enclaves


sudo nitro-cli console --enclave-name nginx

 
sudo nitro-cli describe-enclaves


ls -l


#Delete / terminate

sudo nitro-cli terminate-enclave --enclave-id i-0b6fc662c970e1b41-enc199b932ccf02cc2

 
sudo nitro-cli describe-enclaves

#Java app
cat > Dockerfile < < 'EOF'
> # Single stage - much simpler
> FROM eclipse-temurin:22-jre-alpine
> WORKDIR /app
> COPY payments-0.0.1-SNAPSHOT.jar app.jar
> ENTRYPOINT ["java", "-jar", "app.jar"]
> EXPOSE 8080
> EOF


cat Dockerfile

docker build -t payments-app .

sudo nitro-cli build-enclave --docker-uri payments-app --output-file payments.eif
 


#start nitro enclave

sudo nitro-cli run-enclave --cpu-count 2 --memory 1024 --eif-path payments.eif --debug-mode


Start allocating memory...
Started enclave with enclave-cid: 17, memory: 1024 MiB, cpu-ids: [1, 5]
{
  "EnclaveName": "payments",
  "EnclaveID": "i-0b6fc662c970e1b41-enc199b93c432bdb9c",
  "ProcessID": 21473,
  "EnclaveCID": 17,
  "NumberOfCPUs": 2,
  "CPUIDs": [
    1,
    5
  ],
  "MemoryMiB": 1024
}
[ec2-user@ip-10-1-2-27 ~]$



#THIS DID NOT WORK 

 sudo nitro-cli console --enclave-id i-0b6fc662c970e1b41-enc199b93c432bdb9c
[ E11 ] Socket error. This is used as an error for catching any other socket operation errors not covered by previous custom errors.

 
[ec2-user@ip-10-1-2-27 ~]$ sudo nitro-cli describe-enclaves
[]


#dEBUG BROUGHT SOME ISSUES 

sudo dmesg | tail -20
 


#delete all enlaves 
sudo nitro-cli terminate-enclave --all

#Check cpus taken by enclaves (notice all four)
[ec2-user@ip-10-1-2-27 ~]$ cat /sys/module/nitro_enclaves/parameters/ne_cpus
1,5,2,6

#check total cpus 
[ec2-user@ip-10-1-2-27 ~]$ nproc
4

#here is the problem we have 4 cpus and all 4 taken by enclaves 


#Check the allocator. There's the issue! The config allocates 4 CPUs but you only have 4 total. Let's fix this:

cat /etc/nitro_enclaves/allocator.yaml

---
# Allocate 4 CPUs and 4GB memory for enclaves (leaves 4 CPUs for parent instance)
cpu_count: 4
memory_mib: 4096


#Fix
[ec2-user@ip-10-1-2-27 ~]$ sudo cp /etc/nitro_enclaves/allocator.yaml /etc/nitro_enclaves/allocator.yaml.backup
[ec2-user@ip-10-1-2-27 ~]$ echo "---
> # Allocate 2 CPUs and 4GB memory for enclaves (leaves 2 CPUs for parent instance)
> cpu_count: 2" | sudo tee /etc/nitro_enclaves/allocator.yaml
---
# Allocate 2 CPUs and 4GB memory for enclaves (leaves 2 CPUs for parent instance)
cpu_count: 2
[ec2-user@ip-10-1-2-27 ~]$



#Above fix did not work. doing below fix 

[ec2-user@ip-10-1-2-27 ~]$ echo "---
> cpu_count: 2
> memory_mib: 4096" | sudo tee /etc/nitro_enclaves/allocator.yaml
---
cpu_count: 2
memory_mib: 4096
[ec2-user@ip-10-1-2-27 ~]$
[ec2-user@ip-10-1-2-27 ~]$ sudo systemctl restart nitro-enclaves-allocator
[ec2-user@ip-10-1-2-27 ~]$ journalctl -u nitro-enclaves-allocator.service -n 10 --no-pager
-- Logs begin at Mon 2025-10-06 10:36:59 UTC, end at Mon 2025-10-06 11:27:57 UTC. --
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: Auto-generating the enclave CPU pool by using the CPU count...
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: Will try to reserve 4096 MB of memory on node 0.
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: Configuring the huge page memory...
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: - Reserved 4 pages of type: 1048576kB.
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: Done.
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: Auto-generated the enclave CPU pool: 1,5.
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: Configuring the enclave CPU pool...
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: Done.
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: Successfully allocated Nitro Enclaves resources: 4096 MiB, 2 CPUs
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal systemd[1]: Started Nitro Enclaves Resource Allocator.
[ec2-user@ip-10-1-2-27 ~]$ systemctl status nitro-enclaves-allocator.service
● nitro-enclaves-allocator.service - Nitro Enclaves Resource Allocator
   Loaded: loaded (/usr/lib/systemd/system/nitro-enclaves-allocator.service; enabled; vendor preset: disabled)
   Active: active (exited) since Mon 2025-10-06 11:27:57 UTC; 34s ago
  Process: 35747 ExecStart=/usr/bin/nitro-enclaves-allocator (code=exited, status=0/SUCCESS)
 Main PID: 35747 (code=exited, status=0/SUCCESS)

Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: Auto-generating the enclave CPU pool by using the CPU count...
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: Will try to reserve 4096 MB of memory on node 0.
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: Configuring the huge page memory...
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: - Reserved 4 pages of type: 1048576kB.
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: Done.
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: Auto-generated the enclave CPU pool: 1,5.
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: Configuring the enclave CPU pool...
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: Done.
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: Successfully allocated Nitro Enclaves resources: 4096 MiB, 2 CPUs
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal systemd[1]: Started Nitro Enclaves Resource Allocator.
[ec2-user@ip-10-1-2-27 ~]$



#Did not work above one. more trouble shooting 


[ec2-user@ip-10-1-2-27 ~]$ lsmod | grep nitro
[ec2-user@ip-10-1-2-27 ~]$ dmesg | grep -i nitro
[ 1254.473297] nitro_enclaves: No CPUs available in CPU pool
[ 1254.478559] nitro_enclaves: Error in setup CPU pool [rc=-22]
[ 2664.167750] nitro_enclaves: No CPUs available in CPU pool
[ 2664.172935] nitro_enclaves: Error in setup CPU pool [rc=-22]
[ 2691.271437] misc nitro_enclaves: Full CPU cores not used
[ 2723.215840] nitro_enclaves: CPU 5 is not in CPU pool
[ 2723.221052] nitro_enclaves: Error in setup CPU pool [rc=-22]
[ 3060.031548] nitro_enclaves: No CPUs available in CPU pool
[ 3060.036767] nitro_enclaves: Error in setup CPU pool [rc=-22]
[ 3120.183819] misc nitro_enclaves: Full CPU cores not used
[ec2-user@ip-10-1-2-27 ~]$ ls -la payments.eif
-rw-r--r-- 1 root root 214608205 Oct  6 11:15 payments.eif
[ec2-user@ip-10-1-2-27 ~]$





#More debug commands 

[ec2-user@ip-10-1-2-27 ~]$ nproc
6
[ec2-user@ip-10-1-2-27 ~]$ lscpu | grep "CPU(s):"
CPU(s):               8
NUMA node0 CPU(s):    0,2-4,6,7
[ec2-user@ip-10-1-2-27 ~]$ cat /etc/nitro_enclaves/allocator.yaml
---
cpu_count: 2
memory_mib: 4096
[ec2-user@ip-10-1-2-27 ~]$ sudo systemctl stop nitro-enclaves-allocator
[ec2-user@ip-10-1-2-27 ~]$ cat /sys/devices/system/cpu/online
0,2-4,6-7
[ec2-user@ip-10-1-2-27 ~]$ systemctl status nitro-enclaves-allocator
● nitro-enclaves-allocator.service - Nitro Enclaves Resource Allocator
   Loaded: loaded (/usr/lib/systemd/system/nitro-enclaves-allocator.service; enabled; vendor preset: disabled)
   Active: inactive (dead) since Mon 2025-10-06 11:31:47 UTC; 11s ago
  Process: 35747 ExecStart=/usr/bin/nitro-enclaves-allocator (code=exited, status=0/SUCCESS)
 Main PID: 35747 (code=exited, status=0/SUCCESS)

Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: Will try to reserve 4096 MB of memory on node 0.
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: Configuring the huge page memory...
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: - Reserved 4 pages of type: 1048576kB.
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: Done.
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: Auto-generated the enclave CPU pool: 1,5.
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: Configuring the enclave CPU pool...
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: Done.
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[35747]: Successfully allocated Nitro Enclaves resources: 4096 MiB, 2 CPUs
Oct 06 11:27:57 ip-10-1-2-27.eu-west-1.compute.internal systemd[1]: Started Nitro Enclaves Resource Allocator.
Oct 06 11:31:47 ip-10-1-2-27.eu-west-1.compute.internal systemd[1]: Stopped Nitro Enclaves Resource Allocator.
[ec2-user@ip-10-1-2-27 ~]$


#I see the issue. Your instance has 8 logical CPUs but only 6 are online (0,2-4,6-7). The allocator is trying to use CPUs that aren't available. 



#More debug and resetting the cpu configuration 

[ec2-user@ip-10-1-2-27 ~]$ echo "---
> cpu_count: 2
> memory_mib: 4096" | sudo tee /etc/nitro_enclaves/allocator.yaml
---
cpu_count: 2
memory_mib: 4096
[ec2-user@ip-10-1-2-27 ~]$
[ec2-user@ip-10-1-2-27 ~]$ sudo systemctl start nitro-enclaves-allocator
[ec2-user@ip-10-1-2-27 ~]$
[ec2-user@ip-10-1-2-27 ~]$ journalctl -u nitro-enclaves-allocator.service --since "1 minute ago" --no-pager | tail -10
Oct 06 11:36:32 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[39060]: Auto-generating the enclave CPU pool by using the CPU count...
Oct 06 11:36:33 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[39060]: Will try to reserve 4096 MB of memory on node 0.
Oct 06 11:36:33 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[39060]: Configuring the huge page memory...
Oct 06 11:36:33 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[39060]: - Reserved 4 pages of type: 1048576kB.
Oct 06 11:36:33 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[39060]: Done.
Oct 06 11:36:33 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[39060]: Auto-generated the enclave CPU pool: 1,5.
Oct 06 11:36:33 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[39060]: Configuring the enclave CPU pool...
Oct 06 11:36:33 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[39060]: Done.
Oct 06 11:36:33 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[39060]: Successfully allocated Nitro Enclaves resources: 4096 MiB, 2 CPUs
Oct 06 11:36:33 ip-10-1-2-27.eu-west-1.compute.internal systemd[1]: Started Nitro Enclaves Resource Allocator.
[ec2-user@ip-10-1-2-27 ~]$ systemctl status nitro-enclaves-allocator
● nitro-enclaves-allocator.service - Nitro Enclaves Resource Allocator
   Loaded: loaded (/usr/lib/systemd/system/nitro-enclaves-allocator.service; enabled; vendor preset: disabled)
   Active: active (exited) since Mon 2025-10-06 11:36:33 UTC; 29s ago
  Process: 39060 ExecStart=/usr/bin/nitro-enclaves-allocator (code=exited, status=0/SUCCESS)
 Main PID: 39060 (code=exited, status=0/SUCCESS)

Oct 06 11:36:32 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[39060]: Auto-generating the enclave CPU pool by using the CPU count...
Oct 06 11:36:33 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[39060]: Will try to reserve 4096 MB of memory on node 0.
Oct 06 11:36:33 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[39060]: Configuring the huge page memory...
Oct 06 11:36:33 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[39060]: - Reserved 4 pages of type: 1048576kB.
Oct 06 11:36:33 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[39060]: Done.
Oct 06 11:36:33 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[39060]: Auto-generated the enclave CPU pool: 1,5.
Oct 06 11:36:33 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[39060]: Configuring the enclave CPU pool...
Oct 06 11:36:33 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[39060]: Done.
Oct 06 11:36:33 ip-10-1-2-27.eu-west-1.compute.internal nitro-enclaves-allocator[39060]: Successfully allocated Nitro Enclaves resources: 4096 MiB, 2 CPUs
Oct 06 11:36:33 ip-10-1-2-27.eu-west-1.compute.internal systemd[1]: Started Nitro Enclaves Resource Allocator.
[ec2-user@ip-10-1-2-27 ~]$





####still memroy failing issue 



#going with python 


[ec2-user@ip-10-1-2-27 ~]$ git
bash: git: command not found
[ec2-user@ip-10-1-2-27 ~]$ sudo yum install -y git
Loaded plugins: priorities, update-motd, versionlock
amzn2-core                                                                                                                               | 3.6 kB  00:00:00
Resolving Dependencies
--> Running transaction check
---> Package git.x86_64 0:2.47.3-1.amzn2.0.1 will be installed
--> Processing Dependency: git-core = 2.47.3-1.amz



[ec2-user@ip-10-1-2-27 ~]$ mkdir python-enclave && cd python-enclave
[ec2-user@ip-10-1-2-27 python-enclave]$
[ec2-user@ip-10-1-2-27 python-enclave]$ cat < < EOF > Dockerfile
> FROM amazonlinux:2
> RUN yum install -y python3
> WORKDIR /app
> COPY hello.py .
> CMD ["python3", "hello.py"]
> EOF
[ec2-user@ip-10-1-2-27 python-enclave]$
[ec2-user@ip-10-1-2-27 python-enclave]$ echo 'print("Hello from Nitro Enclave!")' > hello.py
[ec2-user@ip-10-1-2-27 python-enclave]$
[ec2-user@ip-10-1-2-27 python-enclave]$ sudo docker build -t python-hello .
[+] Building 11.9s (9/9) FINISHED                                                                                                                docker:default
 => [internal] load build definition from Dockerfile                                                                                                       0.0s
 => => transferring dockerfile: 140B                                                                                                                       0.0s
 => [internal] load metadata for docker.io/library/amazonlinux:2                                                                                           0.0s
 => [internal] load .dockerignore                                                                                                                          0.0s
 => => transferring context: 2B                                                                                                                            0.0s
 => CACHED [1/4] FROM docker.io/library/amazonlinux:2                                                                                                      0.0s
 => [internal] load build context                                                                                                                          0.0s
 => => transferring context: 70B                                                                                                                           0.0s
 => [2/4] RUN yum install -y python3                                                                                                                       9.4s
 => [3/4] WORKDIR /app                                                                                                                                     0.0s
 => [4/4] COPY hello.py .                                                                                                                                  0.0s
 => exporting to image                                                                                                                                     2.3s
 => => exporting layers                                                                                                                                    2.3s
 => => writing image sha256:00254da57febb5d7591ec406625f6fc4d48f5cf88f69ebfb73db8b54e31ff9a8                                                               0.0s
 => => naming to docker.io/library/python-hello                                                                                                            0.0s
[ec2-user@ip-10-1-2-27 python-enclave]$ docker images
REPOSITORY     TAG       IMAGE ID       CREATED          SIZE
python-hello   latest    00254da57feb   17 seconds ago   653MB
payments-app   latest    4a2672036d38   7 minutes ago    954MB
<none>         <none>    047e161f5636   49 minutes ago   209MB
amazonlinux    2         8dcd65ff79b6   2 weeks ago      165MB
nginx          latest    203ad09fc156   7 weeks ago      192MB
[ec2-user@ip-10-1-2-27 python-enclave]$






######Building a long running python 


[ec2-user@ip-10-1-2-27 python-enclave]$ clear
[ec2-user@ip-10-1-2-27 python-enclave]$ cat < < EOF > hello.py
> import time
>
> # Simulated sensitive data
> credit_card = "4111 1111 1111 1111"
> expiry_date = "12/27"
> cvv = "123"
> account_number = "9876543210"
>
> print("🔐 Enclave started. Processing payment information securely...")
>
> for i in range(10):
>     print(f"[{i * 30}s] Processing account {account_number} with card ending in {credit_card[-4:]}")
>     time.sleep(30)
>
> print("✅ Payment processing complete. Enclave shutting down.")
> EOF
[ec2-user@ip-10-1-2-27 python-enclave]$
 
 
 
 
[ec2-user@ip-10-1-2-27 python-enclave]$ cat hello.py
import time

# Simulated sensitive data
credit_card = "4111 1111 1111 1111"
expiry_date = "12/27"
cvv = "123"
account_number = "9876543210"

print("🔐 Enclave started. Processing payment information securely...")

for i in range(10):
    print(f"[{i * 30}s] Processing account {account_number} with card ending in {credit_card[-4:]}")
    time.sleep(30)

print("✅ Payment processing complete. Enclave shutting down.")
[ec2-user@ip-10-1-2-27 python-enclave]$





#Docker build 

sudo docker build -t python-longrun .



ls -la /usr/share/nitro_enclaves/blobs/
sudo nitro-cli build-enclave --docker-uri nginx --output-file nginx.eif


cat /etc/nitro_enclaves/allocator.yaml

sudo systemctl restart nitro-enclaves-allocator

sudo nitro-cli run-enclave --cpu-count 2 --memory 756 --eif-path nginx.eif --debug-mode

# Check enclave status and measurements
sudo nitro-cli describe-enclaves

sudo nitro-cli console --enclave-name nginx




# Verify the enclave is in a separate memory space
sudo nitro-cli console --enclave-name nginx


# Try to access enclave memory from parent - should fail
sudo gdb -p $(pgrep nitro-cli)

# Try memory dump tools - should not see enclave memory
sudo cat /proc/$(pgrep nitro-cli)/maps
sudo hexdump -C /proc/$(pgrep nitro-cli)/mem

# Check if you can see enclave processes from parent
ps aux | grep nginx  # Should only show parent processes, not enclave processes



# Get the enclave measurements (PCRs)
sudo nitro-cli describe-enclaves | grep -A 10 "Measurements"

# These measurements prove the enclave integrity
# PCR0: Enclave image file
# PCR1: Linux kernel and bootstrap
# PCR2: Application



# From parent instance - try to connect to enclave directly
# This should work through vsock, not regular networking
nc -l 8000  # This won't reach the enclave nginx

# Proper way to communicate with enclave
# Use vsock (Virtual Socket) - enclave's secure communication channel


# Check if enclave was built with proper measurements
nitro-cli describe-eif --eif-path nginx.eif

# Verify no debugging/inspection tools work
sudo strace -p $(pgrep nitro-cli)  # Should show limited system calls
