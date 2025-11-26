sridhara@ubuntu:~$ cd /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s
 
sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$        source env.sh
sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$        ./enclavectl cleanup

Error when retrieving token from sso: Token has expired and refresh failed
[enclavectl] Attempt to delete launch template: lt_96a6a988-91e2-4ec2-a01e-a1e0a361bce4
[enclavectl] Deleting cluster_config.yaml...
[enclavectl] Deleting .config.ne.k8s.ctl...
[enclavectl] Deleting .setup.ne.k8s.ctl...
sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$        ./enclavectl configure --file settings.json
[enclavectl] Setup UUID doesnt exist. Creating one...
[enclavectl] Using setup UUID: 9c1f783a-844b-4cf1-9f5a-4ca0bd9f52c6
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
sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ docker info | grep Username
 Username: nerdysrisha
sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$  
        docker ps -a --format '{{.ID}} {{.Image}}' | grep -v 'kindest/node' | awk '{print $1}' | xargs -r docker rm -f
        docker images --format '{{.Repository}}:{{.Tag}} {{.ID}}' | grep -v '^kindest/node' | awk '{print $2}' | xargs -r docker rmi -f
        docker image prune -f
        docker builder prune --all --force
        docker volume prune -f
        docker network prune -f

Total reclaimed space: 0B
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Total reclaimed space: 0B
Total reclaimed space: 0B
sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ 


sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ #Removing existing .eif files so that freshly gets built everytime. 
        ls -lrt /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s/container/bin
        rm -f /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s/container/bin/*.*
        ls -lrt /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s/container/bin
total 0
total 0
sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ 





sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ #Note for easy deployments, created dedicated directory called 'versionednginx', under which multiple versions are provided
#Eg. v1 folder has super simple nginx without any vsock installations etc. 
#Eg. v2 folder has nginx related but with vsock. Important distinction and diff is the file path of github where for vsock driven setup, we need different enclave app that has additional configurations for vsock

        cd /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s
        ./enclavectl build --image coconginx  


        docker images
        docker ps -a
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  64.51kB
Step 1/5 : FROM public.ecr.aws/amazonlinux/amazonlinux:2
2: Pulling from amazonlinux/amazonlinux
efa4bf9cb5f8: Pull complete 
Digest: sha256:df35f537149d81cb0690e33883190dd7909dfc43bc252181498104f6ad49aef8
Status: Downloaded newer image for public.ecr.aws/amazonlinux/amazonlinux:2
 ---> cc9511194e67
Step 2/5 : RUN amazon-linux-extras install aws-nitro-enclaves-cli &&     yum install wget git aws-nitro-enclaves-cli-devel -y
 ---> Running in 07514b0495e3
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
Total                                               17 MB/s |  96 MB  00:05     
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
 ---> Removed intermediate container 07514b0495e3
 ---> 80391b3cf660
Step 3/5 : WORKDIR /home
 ---> Running in ede8c4d3c65a
 ---> Removed intermediate container ede8c4d3c65a
 ---> 918771fbfa76
Step 4/5 : COPY builder/run.sh run.sh
 ---> 4152a4496dff
Step 5/5 : CMD ["/home/run.sh"]
 ---> Running in 706d7fe2de31
 ---> Removed intermediate container 706d7fe2de31
 ---> eb9ea15c4865
Successfully built eb9ea15c4865
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
export MANIFEST_EIF_DOCKER_FILE_PATH="dockerfiles/v2"
export MANIFEST_EIF_DOCKER_BUILD_PATH="dockerfiles/v2"
[BUILDER] -----------------------
Cloning into 'coconginx'...
remote: Enumerating objects: 11, done.
remote: Counting objects: 100% (11/11), done.
remote: Compressing objects: 100% (7/7), done.
remote: Total 11 (delta 3), reused 10 (delta 2), pack-reused 0 (from 0)
Receiving objects: 100% (11/11), 12.96 KiB | 294.00 KiB/s, done.
Resolving deltas: 100% (3/3), done.
[+] Building 71.2s (10/10) FINISHED                                                                                                          docker:default
 => [internal] load build definition from Dockerfile                                                                                                   0.1s
 => => transferring dockerfile: 2.90kB                                                                                                                 0.0s
 => [internal] load metadata for public.ecr.aws/amazonlinux/amazonlinux:2023                                                                           3.0s
 => [internal] load .dockerignore                                                                                                                      0.2s
 => => transferring context: 2B                                                                                                                        0.0s
 => [1/6] FROM public.ecr.aws/amazonlinux/amazonlinux:2023@sha256:f5ca6cafc706233c641ad838e738047389943afd3585cb1df7eedfc4d9b1799d                     1.6s
 => => resolve public.ecr.aws/amazonlinux/amazonlinux:2023@sha256:f5ca6cafc706233c641ad838e738047389943afd3585cb1df7eedfc4d9b1799d                     0.1s
 => => sha256:f5ca6cafc706233c641ad838e738047389943afd3585cb1df7eedfc4d9b1799d 770B / 770B                                                             0.0s
 => => sha256:fb74284364222bd16641b0f0d36df624bf1d81758c1ad50a8b5764ab1ef9ebb0 528B / 528B                                                             0.0s
 => => sha256:ac90a73983be7974c18062a0a56d2c4ad6b9369b4eb2b4090141462a2ef428b9 662B / 662B                                                             0.0s
 => [2/6] RUN dnf update -y && dnf install -y nginx socat nc iproute procps-ng --allowerasing                                                         60.4s
 => [3/6] RUN echo "Hello from NGINX in Enclave via VSOCK proxy! PoC on Confidential Containers" > /usr/share/nginx/html/index.html &&     echo  serv  0.8s 
 => [4/6] RUN printf #!/bin/bash\n\nset -x\necho "=== Starting nginx and VSOCK proxy inside enclave ==="\necho "Timestamp: $(date)"\n\necho "=== Pre  0.9s 
 => [5/6] RUN nginx -t && echo "✅ Nginx configuration is valid"                                                                                        1.0s
 => [6/6] RUN echo "=== Startup script content ===" && cat /start.sh                                                                                   0.9s 
 => exporting to image                                                                                                                                 1.8s 
 => => exporting layers                                                                                                                                1.6s 
 => => writing image sha256:90f4d45bc54a74708830a0c8c9d2b535f9e23ee1e31ea01bdee74feec37b6885                                                           0.0s
 => => naming to docker.io/library/ne-build-nginx-eif:1.0                                                                                              0.0s
Start building the Enclave Image...
Using the locally available Docker image...
Enclave Image successfully created.
{
  "Measurements": {
    "HashAlgorithm": "Sha384 { ... }",
    "PCR0": "45e96d1b8d9d8f646ede82d4b880feb15f78e2c230ae6ce85013a3961bbcc3e8e87ae7716ce0698578f3d9ca937334f6",
    "PCR1": "0343b056cd8485ca7890ddd833476d78460aed2aa161548e4e26bedf321726696257d623e8805f3f605946b3d8b0c6aa",
    "PCR2": "0a5a93a9e94a13868ba406f922a3363a02653b3607b6b66177b1b45b77eb56e6fad8a222295d53b636500ff7d902beee"
  }
}
Error response from daemon: No such image: coconginx-9c1f783a-844b-4cf1-9f5a-4ca0bd9f52c6:latest
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  343.8MB
Step 1/21 : FROM public.ecr.aws/amazonlinux/amazonlinux:2 as full_image
 ---> cc9511194e67
Step 2/21 : RUN amazon-linux-extras install aws-nitro-enclaves-cli &&     yum install aws-nitro-enclaves-cli-devel jq socat -y  # ADDED: socat for vsock proxy
 ---> Running in 71014dd2b7fe
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
Total                                               16 MB/s |  96 MB  00:05     
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
---> Package socat.x86_64 0:1.7.3.2-2.amzn2.0.1 will be installed
--> Processing Dependency: libwrap.so.0()(64bit) for package: socat-1.7.3.2-2.amzn2.0.1.x86_64
--> Running transaction check
---> Package tcp_wrappers-libs.x86_64 0:7.6-77.amzn2.0.2 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package                      Arch   Version             Repository        Size
================================================================================
Installing:
 aws-nitro-enclaves-cli-devel x86_64 1.4.2-0.amzn2       amzn2extra-aws-nitro-enclaves-cli
                                                                           15 M
 socat                        x86_64 1.7.3.2-2.amzn2.0.1 amzn2-core       291 k
Installing for dependencies:
 tcp_wrappers-libs            x86_64 7.6-77.amzn2.0.2    amzn2-core        66 k

Transaction Summary
================================================================================
Install  2 Packages (+1 Dependent package)

Total download size: 15 M
Installed size: 50 M
Downloading packages:
--------------------------------------------------------------------------------
Total                                               14 MB/s |  15 MB  00:01     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : tcp_wrappers-libs-7.6-77.amzn2.0.2.x86_64                    1/3 
  Installing : socat-1.7.3.2-2.amzn2.0.1.x86_64                             2/3 
  Installing : aws-nitro-enclaves-cli-devel-1.4.2-0.amzn2.x86_64            3/3 
  Verifying  : socat-1.7.3.2-2.amzn2.0.1.x86_64                             1/3 
  Verifying  : aws-nitro-enclaves-cli-devel-1.4.2-0.amzn2.x86_64            2/3 
  Verifying  : tcp_wrappers-libs-7.6-77.amzn2.0.2.x86_64                    3/3 

Installed:
  aws-nitro-enclaves-cli-devel.x86_64 0:1.4.2-0.amzn2                           
  socat.x86_64 0:1.7.3.2-2.amzn2.0.1                                            

Dependency Installed:
  tcp_wrappers-libs.x86_64 0:7.6-77.amzn2.0.2                                   

Complete!
 ---> Removed intermediate container 71014dd2b7fe
 ---> d2aa0c71676c
Step 3/21 : RUN yum install -y gcc make tar &&     curl -O http://www.dest-unreach.org/socat/download/socat-1.7.4.4.tar.gz &&     tar xzf socat-1.7.4.4.tar.gz &&     cd socat-1.7.4.4 &&     ./configure --enable-vsock --prefix=/usr &&     make && make install &&     cd .. && rm -rf socat-1.7.4.4*
 ---> Running in 4f20f9e2f1c0
Loaded plugins: ovl, priorities
Package 1:make-3.82-24.amzn2.x86_64 already installed and latest version
Resolving Dependencies
--> Running transaction check
---> Package gcc.x86_64 0:7.3.1-17.amzn2 will be installed
--> Processing Dependency: cpp = 7.3.1-17.amzn2 for package: gcc-7.3.1-17.amzn2.x86_64
--> Processing Dependency: libgomp = 7.3.1-17.amzn2 for package: gcc-7.3.1-17.amzn2.x86_64
--> Processing Dependency: binutils >= 2.24 for package: gcc-7.3.1-17.amzn2.x86_64
--> Processing Dependency: glibc-devel >= 2.2.90-12 for package: gcc-7.3.1-17.amzn2.x86_64
--> Processing Dependency: libatomic >= 7.3.1-17.amzn2 for package: gcc-7.3.1-17.amzn2.x86_64
--> Processing Dependency: libcilkrts >= 7.3.1-17.amzn2 for package: gcc-7.3.1-17.amzn2.x86_64
--> Processing Dependency: libitm >= 7.3.1-17.amzn2 for package: gcc-7.3.1-17.amzn2.x86_64
--> Processing Dependency: libmpx >= 7.3.1-17.amzn2 for package: gcc-7.3.1-17.amzn2.x86_64
--> Processing Dependency: libquadmath >= 7.3.1-17.amzn2 for package: gcc-7.3.1-17.amzn2.x86_64
--> Processing Dependency: libsanitizer >= 7.3.1-17.amzn2 for package: gcc-7.3.1-17.amzn2.x86_64
--> Processing Dependency: libgomp.so.1()(64bit) for package: gcc-7.3.1-17.amzn2.x86_64
--> Processing Dependency: libmpc.so.3()(64bit) for package: gcc-7.3.1-17.amzn2.x86_64
--> Processing Dependency: libmpfr.so.4()(64bit) for package: gcc-7.3.1-17.amzn2.x86_64
---> Package tar.x86_64 2:1.26-35.amzn2.0.4 will be installed
--> Running transaction check
---> Package binutils.x86_64 0:2.29.1-31.amzn2.0.2 will be installed
---> Package cpp.x86_64 0:7.3.1-17.amzn2 will be installed
---> Package glibc-devel.x86_64 0:2.26-64.amzn2.0.5 will be installed
--> Processing Dependency: glibc-headers = 2.26-64.amzn2.0.5 for package: glibc-devel-2.26-64.amzn2.0.5.x86_64
--> Processing Dependency: glibc-headers for package: glibc-devel-2.26-64.amzn2.0.5.x86_64
---> Package libatomic.x86_64 0:7.3.1-17.amzn2 will be installed
---> Package libcilkrts.x86_64 0:7.3.1-17.amzn2 will be installed
---> Package libgomp.x86_64 0:7.3.1-17.amzn2 will be installed
---> Package libitm.x86_64 0:7.3.1-17.amzn2 will be installed
---> Package libmpc.x86_64 0:1.0.1-3.amzn2.0.2 will be installed
---> Package libmpx.x86_64 0:7.3.1-17.amzn2 will be installed
---> Package libquadmath.x86_64 0:7.3.1-17.amzn2 will be installed
---> Package libsanitizer.x86_64 0:7.3.1-17.amzn2 will be installed
---> Package mpfr.x86_64 0:3.1.1-4.amzn2.0.2 will be installed
--> Running transaction check
---> Package glibc-headers.x86_64 0:2.26-64.amzn2.0.5 will be installed
--> Processing Dependency: kernel-headers >= 2.2.1 for package: glibc-headers-2.26-64.amzn2.0.5.x86_64
--> Processing Dependency: kernel-headers for package: glibc-headers-2.26-64.amzn2.0.5.x86_64
--> Running transaction check
---> Package kernel-headers.x86_64 0:4.14.355-280.708.amzn2 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package            Arch       Version                     Repository      Size
================================================================================
Installing:
 gcc                x86_64     7.3.1-17.amzn2              amzn2-core      22 M
 tar                x86_64     2:1.26-35.amzn2.0.4         amzn2-core     846 k
Installing for dependencies:
 binutils           x86_64     2.29.1-31.amzn2.0.2         amzn2-core     5.8 M
 cpp                x86_64     7.3.1-17.amzn2              amzn2-core     9.2 M
 glibc-devel        x86_64     2.26-64.amzn2.0.5           amzn2-core     996 k
 glibc-headers      x86_64     2.26-64.amzn2.0.5           amzn2-core     517 k
 kernel-headers     x86_64     4.14.355-280.708.amzn2      amzn2-core     1.2 M
 libatomic          x86_64     7.3.1-17.amzn2              amzn2-core      46 k
 libcilkrts         x86_64     7.3.1-17.amzn2              amzn2-core      85 k
 libgomp            x86_64     7.3.1-17.amzn2              amzn2-core     205 k
 libitm             x86_64     7.3.1-17.amzn2              amzn2-core      85 k
 libmpc             x86_64     1.0.1-3.amzn2.0.2           amzn2-core      52 k
 libmpx             x86_64     7.3.1-17.amzn2              amzn2-core      52 k
 libquadmath        x86_64     7.3.1-17.amzn2              amzn2-core     189 k
 libsanitizer       x86_64     7.3.1-17.amzn2              amzn2-core     642 k
 mpfr               x86_64     3.1.1-4.amzn2.0.2           amzn2-core     208 k

Transaction Summary
================================================================================
Install  2 Packages (+14 Dependent packages)

Total download size: 42 M
Installed size: 121 M
Downloading packages:
--------------------------------------------------------------------------------
Total                                              3.3 MB/s |  42 MB  00:12     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : mpfr-3.1.1-4.amzn2.0.2.x86_64                               1/16 
  Installing : libmpc-1.0.1-3.amzn2.0.2.x86_64                             2/16 
  Installing : cpp-7.3.1-17.amzn2.x86_64                                   3/16 
  Installing : binutils-2.29.1-31.amzn2.0.2.x86_64                         4/16 
  Installing : libcilkrts-7.3.1-17.amzn2.x86_64                            5/16 
  Installing : libgomp-7.3.1-17.amzn2.x86_64                               6/16 
  Installing : libquadmath-7.3.1-17.amzn2.x86_64                           7/16 
  Installing : libsanitizer-7.3.1-17.amzn2.x86_64                          8/16 
  Installing : libatomic-7.3.1-17.amzn2.x86_64                             9/16 
  Installing : libmpx-7.3.1-17.amzn2.x86_64                               10/16 
  Installing : libitm-7.3.1-17.amzn2.x86_64                               11/16 
  Installing : kernel-headers-4.14.355-280.708.amzn2.x86_64               12/16 
  Installing : glibc-headers-2.26-64.amzn2.0.5.x86_64                     13/16 
  Installing : glibc-devel-2.26-64.amzn2.0.5.x86_64                       14/16 
  Installing : gcc-7.3.1-17.amzn2.x86_64                                  15/16 
  Installing : 2:tar-1.26-35.amzn2.0.4.x86_64                             16/16 
  Verifying  : kernel-headers-4.14.355-280.708.amzn2.x86_64                1/16 
  Verifying  : libitm-7.3.1-17.amzn2.x86_64                                2/16 
  Verifying  : glibc-devel-2.26-64.amzn2.0.5.x86_64                        3/16 
  Verifying  : libmpx-7.3.1-17.amzn2.x86_64                                4/16 
  Verifying  : libatomic-7.3.1-17.amzn2.x86_64                             5/16 
  Verifying  : libsanitizer-7.3.1-17.amzn2.x86_64                          6/16 
  Verifying  : libquadmath-7.3.1-17.amzn2.x86_64                           7/16 
  Verifying  : glibc-headers-2.26-64.amzn2.0.5.x86_64                      8/16 
  Verifying  : libgomp-7.3.1-17.amzn2.x86_64                               9/16 
  Verifying  : libcilkrts-7.3.1-17.amzn2.x86_64                           10/16 
  Verifying  : cpp-7.3.1-17.amzn2.x86_64                                  11/16 
  Verifying  : libmpc-1.0.1-3.amzn2.0.2.x86_64                            12/16 
  Verifying  : gcc-7.3.1-17.amzn2.x86_64                                  13/16 
  Verifying  : 2:tar-1.26-35.amzn2.0.4.x86_64                             14/16 
  Verifying  : mpfr-3.1.1-4.amzn2.0.2.x86_64                              15/16 
  Verifying  : binutils-2.29.1-31.amzn2.0.2.x86_64                        16/16 

Installed:
  gcc.x86_64 0:7.3.1-17.amzn2           tar.x86_64 2:1.26-35.amzn2.0.4          

Dependency Installed:
  binutils.x86_64 0:2.29.1-31.amzn2.0.2                                         
  cpp.x86_64 0:7.3.1-17.amzn2                                                   
  glibc-devel.x86_64 0:2.26-64.amzn2.0.5                                        
  glibc-headers.x86_64 0:2.26-64.amzn2.0.5                                      
  kernel-headers.x86_64 0:4.14.355-280.708.amzn2                                
  libatomic.x86_64 0:7.3.1-17.amzn2                                             
  libcilkrts.x86_64 0:7.3.1-17.amzn2                                            
  libgomp.x86_64 0:7.3.1-17.amzn2                                               
  libitm.x86_64 0:7.3.1-17.amzn2                                                
  libmpc.x86_64 0:1.0.1-3.amzn2.0.2                                             
  libmpx.x86_64 0:7.3.1-17.amzn2                                                
  libquadmath.x86_64 0:7.3.1-17.amzn2                                           
  libsanitizer.x86_64 0:7.3.1-17.amzn2                                          
  mpfr.x86_64 0:3.1.1-4.amzn2.0.2                                               

Complete!
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  647k  100  647k    0     0   783k      0 --:--:-- --:--:-- --:--:--  782k
checking which defines needed for makedepend... 
checking for a BSD-compatible install... /usr/bin/install -c
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables... 
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking for ranlib... ranlib
checking for ar... ar
checking how to run the C preprocessor... gcc -E
checking for grep that handles long lines and -e... /usr/bin/grep
checking for egrep... /usr/bin/grep -E
checking for ANSI C header files... yes
checking for sys/types.h... yes
checking for sys/stat.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for memory.h... yes
checking for strings.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for unistd.h... yes
checking stdbool.h usability... yes
checking stdbool.h presence... yes
checking for stdbool.h... yes
checking for inttypes.h... (cached) yes
checking for sys/wait.h that is POSIX.1 compatible... yes
checking fcntl.h usability... yes
checking fcntl.h presence... yes
checking for fcntl.h... yes
checking limits.h usability... yes
checking limits.h presence... yes
checking for limits.h... yes
checking for strings.h... (cached) yes
checking sys/param.h usability... yes
checking sys/param.h presence... yes
checking for sys/param.h... yes
checking sys/ioctl.h usability... yes
checking sys/ioctl.h presence... yes
checking for sys/ioctl.h... yes
checking sys/time.h usability... yes
checking sys/time.h presence... yes
checking for sys/time.h... yes
checking syslog.h usability... yes
checking syslog.h presence... yes
checking for syslog.h... yes
checking for unistd.h... (cached) yes
checking pwd.h usability... yes
checking pwd.h presence... yes
checking for pwd.h... yes
checking grp.h usability... yes
checking grp.h presence... yes
checking for grp.h... yes
checking for stdint.h... (cached) yes
checking for sys/types.h... (cached) yes
checking poll.h usability... yes
checking poll.h presence... yes
checking for poll.h... yes
checking sys/poll.h usability... yes
checking sys/poll.h presence... yes
checking for sys/poll.h... yes
checking sys/socket.h usability... yes
checking sys/socket.h presence... yes
checking for sys/socket.h... yes
checking sys/uio.h usability... yes
checking sys/uio.h presence... yes
checking for sys/uio.h... yes
checking for sys/stat.h... (cached) yes
checking netdb.h usability... yes
checking netdb.h presence... yes
checking for netdb.h... yes
checking sys/un.h usability... yes
checking sys/un.h presence... yes
checking for sys/un.h... yes
checking pty.h usability... yes
checking pty.h presence... yes
checking for pty.h... yes
checking netinet/in.h usability... yes
checking netinet/in.h presence... yes
checking for netinet/in.h... yes
checking netinet/in_systm.h usability... yes
checking netinet/in_systm.h presence... yes
checking for netinet/in_systm.h... yes
checking for netinet/ip.h... yes
checking netinet/tcp.h usability... yes
checking netinet/tcp.h presence... yes
checking for netinet/tcp.h... yes
checking for net/if.h... yes
checking arpa/nameser.h usability... yes
checking arpa/nameser.h presence... yes
checking for arpa/nameser.h... yes
checking for sys/types.h... (cached) yes
checking for netinet/in.h... (cached) yes
checking for arpa/nameser.h... (cached) yes
checking for netdb.h... (cached) yes
checking for resolv.h... yes
checking termios.h usability... yes
checking termios.h presence... yes
checking for termios.h... yes
checking linux/if_tun.h usability... yes
checking linux/if_tun.h presence... yes
checking for linux/if_tun.h... yes
checking net/if_dl.h usability... no
checking net/if_dl.h presence... no
checking for net/if_dl.h... no
checking linux/types.h usability... yes
checking linux/types.h presence... yes
checking for linux/types.h... yes
checking for linux/errqueue.h... yes
checking sys/utsname.h usability... yes
checking sys/utsname.h presence... yes
checking for sys/utsname.h... yes
checking sys/select.h usability... yes
checking sys/select.h presence... yes
checking for sys/select.h... yes
checking sys/file.h usability... yes
checking sys/file.h presence... yes
checking for sys/file.h... yes
checking util.h usability... no
checking util.h presence... no
checking for util.h... no
checking bsd/libutil.h usability... no
checking bsd/libutil.h presence... no
checking for bsd/libutil.h... no
checking libutil.h usability... no
checking libutil.h presence... no
checking for libutil.h... no
checking sys/stropts.h usability... no
checking sys/stropts.h presence... no
checking for sys/stropts.h... no
checking regex.h usability... yes
checking regex.h presence... yes
checking for regex.h... yes
checking linux/fs.h usability... yes
checking linux/fs.h presence... yes
checking for linux/fs.h... yes
checking linux/ext2_fs.h usability... no
checking linux/ext2_fs.h presence... no
checking for linux/ext2_fs.h... no
checking for setgrent... yes
checking for getgrent... yes
checking for endgrent... yes
checking for getgrouplist... yes
checking for cfmakeraw... yes
checking for library containing res_9_init... no
checking for hstrerror... yes
checking for gethostent... yes
checking for setsockopt... yes
checking for hstrerror prototype... yes
checking for getprotobynumber_r() variant... 1 /* Linux */
checking whether to include help... yes
checking whether to include STDIO support... yes
checking whether to include FD-number support... yes
checking whether to include direct file support... yes
checking whether to include direct create support... yes
checking whether to include gopen support... yes
checking whether to include explicit pipe support... yes
checking whether to include explicit termios support... yes
checking whether to include UNIX socket support... yes
checking whether to include abstract UNIX socket support... yes
checking whether to include IPv4 support... yes
checking whether to include IPv6 support... yes
checking for netinet/ip6.h... yes
checking netinet6/in6.h usability... no
checking netinet6/in6.h presence... no
checking for netinet6/in6.h... no
checking if __APPLE_USE_RFC_2292 is helpful... no
checking whether to include raw IP support... yes
checking whether to include generic socket support... yes
checking whether to include generic network interface support... yes
checking netpacket/packet.h usability... yes
checking netpacket/packet.h presence... yes
checking for netpacket/packet.h... yes
checking for netinet/if_ether.h... yes
checking whether to include TCP support... yes
checking whether to include UDP support... yes
checking whether to include SCTP support... yes
checking for IPPROTO_SCTP... yes
checking whether to include vsock support... yes
checking for linux/vm_sockets.h... yes
checking whether to include listen support... yes
checking whether to include socks4 support... yes
checking whether to include socks4a support... yes
checking whether to include proxy connect support... yes
checking whether to include exec support... yes
checking whether to include system (shell) support... yes
checking whether to include pty address support... yes
checking whether to include fs attributes support... yes
checking whether to include readline support... yes
checking for usable readline in default location... no
checking for usable readline in location /usr/local... no
checking for usable readline in location /opt/local... no
checking for usable readline in location /sw... no
checking for usable readline in location /opt/freeware... no
checking for usable readline in location /usr/sfw... no
configure: WARNING: no suitable version of readline found; perhaps you need to install a newer version
checking whether to include openssl support... yes
configure: checking for components of OpenSSL
./configure: line 5224: : command not found
configure: checked for openssl/ssl.h... no
configure: WARNING: not all components of OpenSSL found, disabling it
checking for OPENSSL_init_ssl... no
checking for SSL_library_init... no
checking whether to include OpenSSL method option... no
checking whether to include deprecated resolver option... no
checking whether to include openssl fips support... no
checking whether to include tun/tap address support... yes
checking whether to include system call tracing... yes
checking whether to include file descriptor analyzer... yes
checking whether to include retry support... yes
checking included message level... debug
checking for an ANSI C-conforming const... yes
checking for uid_t in sys/types.h... yes
checking for mode_t... yes
checking for off_t... yes
checking for pid_t... yes
checking for size_t... yes
checking for struct stat.st_blksize... yes
checking for struct stat.st_blocks... yes
checking for struct stat.st_rdev... yes
checking whether time.h and sys/time.h may both be included... yes
checking for nanosleep... yes
checking whether gcc needs -traditional... no
checking for working memcmp... yes
checking return type of signal handlers... void
checking for strftime... yes
checking for putenv... yes
checking for select... yes
checking for pselect... yes
checking for poll... yes
checking for socket... yes
checking for strtod... yes
checking for strtol... yes
checking for strtoul... yes
checking for uname... yes
checking for getpgid... yes
checking for getsid... yes
checking for gethostbyname... yes
checking for getaddrinfo... yes
checking for getprotobynumber... yes
checking for setgroups... yes
checking for inet_aton... yes
checking for grantpt... yes
checking for unlockpt... yes
checking for cfsetispeed... yes
checking for cfgetispeed... yes
checking for cfsetospeed... yes
checking for cfgetospeed... yes
checking for posix_memalign prototype... yes
checking for strdup prototype... yes
checking for strerror prototype... yes
checking for strstr prototype... yes
checking for getipnodebyname prototype... no
checking for strndup prototype... yes
checking for memrchr prototype... yes
checking for if_indextoname prototype... yes
checking for ptsname prototype... yes
checking for long long... yes
checking for sig_atomic_t... yes
checking for bool... yes
checking for socklen_t... yes
checking for struct stat64... yes
checking for off64_t... yes
checking for sighandler_t... yes
checking for uint8_t... yes
checking for uint16_t... yes
checking for uint32_t... yes
checking for uint64_t... yes
checking for fdset->fds_bits... yes
checking for struct termios . c_ispeed... yes
checking for struct termios . c_ospeed... yes
checking for sa_family_t... yes
checking for struct sock_extended_err... yes
checking for struct sigaction.sa_sigaction... yes
checking if _SVID3 is helpful... no
checking if _XPG4_2 is helpful... no
checking for struct timespec... yes
checking for struct linger... yes
checking for struct ip... yes
checking for struct ip_mreq... yes
checking for struct ip_mreqn... yes
checking for struct ipv6_mreq... yes
checking for struct ip_mreq_source... yes
checking for struct ifreq... yes
checking for struct ifreq.ifr_index... no
checking for struct ifreq.ifr_ifindex... yes
checking for struct sockaddr.sa_len... no
checking for component names of sockaddr_in6... s6_addr
checking for struct iovec... yes
checking for struct msghdr.msg_control... yes
checking for struct msghdr.msg_controllen... yes
checking for struct msghdr.msgflags... yes
checking for struct cmsghdr... yes
checking for struct in_pktinfo... yes
checking for ipi_spec_dst in struct in_pktinfo... yes
checking for struct in6_pktinfo... yes
checking for struct ip.ip_hl... yes
checking for sigaction... yes
checking for stat64... yes
checking for fstat64... yes
checking for lstat64... yes
checking for lseek64... yes
checking for truncate64... yes
checking for ftruncate64... yes
checking for strtoll... yes
checking for hstrerror... (cached) yes
checking for inet_ntop... yes
checking for openpty... no
checking for openpty in -lbsd... no
checking for openpty in -lutil... yes
checking for gettimeofday prototype... yes
checking for clock_gettime... yes
checking for flock... yes
checking for setenv... yes
checking for unsetenv... yes
checking for TLS_client_method... no
checking for TLS_client_method in -lcrypt... no
checking for TLS_server_method... no
checking for TLS_server_method in -lcrypt... no
checking for DTLS_client_method... no
checking for DTLS_client_method in -lcrypt... no
checking for DTLS_server_method... no
checking for DTLS_server_method in -lcrypt... no
checking for SSLv2_client_method... no
checking for SSLv2_client_method in -lcrypt... no
checking for SSLv2_server_method... no
checking for SSLv2_server_method in -lcrypt... no
checking for SSLv3_client_method... no
checking for SSLv3_client_method in -lcrypt... no
checking for SSLv3_server_method... no
checking for SSLv3_server_method in -lcrypt... no
checking for SSLv23_client_method... no
checking for SSLv23_client_method in -lcrypt... no
checking for SSLv23_server_method... no
checking for SSLv23_server_method in -lcrypt... no
checking for TLSv1_client_method... no
checking for TLSv1_client_method in -lcrypt... no
checking for TLSv1_server_method... no
checking for TLSv1_server_method in -lcrypt... no
checking for TLSv1_1_client_method... no
checking for TLSv1_1_client_method in -lcrypt... no
checking for TLSv1_1_server_method... no
checking for TLSv1_1_server_method in -lcrypt... no
checking for TLSv1_2_client_method... no
checking for TLSv1_2_client_method in -lcrypt... no
checking for TLSv1_2_server_method... no
checking for TLSv1_2_server_method in -lcrypt... no
checking for DTLSv1_client_method... no
checking for DTLSv1_client_method in -lcrypt... no
checking for DTLSv1_server_method... no
checking for DTLSv1_server_method in -lcrypt... no
checking for DTLSv1_2_client_method... no
checking for DTLSv1_2_client_method in -lcrypt... no
checking for DTLSv1_2_server_method... no
checking for DTLSv1_2_server_method in -lcrypt... no
checking for SSL_CTX_set_default_verify_paths... no
checking for RAND_egd... no
checking for RAND_egd in -lcrypt... no
checking for DH_set0_pqg... no
checking for DH_set0_pqg in -lcrypt... no
checking for ASN1_STRING_get0_data... no
checking for ASN1_STRING_get0_data in -lcrypt... no
checking for RAND_status... no
checking for SSL_CTX_clear_mode... no
checking for SSL_set_tlsext_host_name... no
checking for SSL_library_init... (cached) no
checking for ERR_error_string... no
checking for type EC_KEY... no
checking if snprintf conforms to C99... yes
checking if printf has Z modifier... no
checking shift offset of CRDLY... 9
checking shift offset of TABDLY... 11
checking shift offset of CSIZE... 4
configure: using compile -Werror method to find basic types
checking for equivalent simple type of uint16_t... 2 /* unsigned short */
checking for equivalent simple type of uint32_t... 4 /* unsigned int */
checking for equivalent simple type of uint64_t... 6 /* unsigned long */
checking for equivalent simple type of int16_t... 1 /* short */
checking for equivalent simple type of int32_t... 3 /* int */
checking for equivalent simple type of int64_t... 5 /* long */
checking for equivalent simple type of size_t... 6 /* unsigned long */
checking for equivalent simple type of mode_t... 4 /* unsigned int */
checking for equivalent simple type of pid_t... 3 /* int */
checking for equivalent simple type of uid_t... 4 /* unsigned int */
checking for equivalent simple type of gid_t... 4 /* unsigned int */
checking for equivalent simple type of time_t... 5 /* long */
checking for equivalent simple type of socklen_t... 4 /* unsigned int */
checking for equivalent simple type of off_t... 5 /* long */
checking for equivalent simple type of off64_t... 5 /* long */
checking for equivalent simple type of dev_t... 6 /* unsigned long */
checking for equivalent simple type of speed_t... 4 /* unsigned int */
checking for basic type of struct stat.st_ino... 6 /* unsigned long */
checking for basic type of struct stat.st_nlink... 6 /* unsigned long */
checking for basic type of struct stat.st_size... 5 /* long */
checking for basic type of struct stat.st_blksize... 5 /* long */
checking for basic type of struct stat.st_blocks... 5 /* long */
checking for basic type of struct stat64.st_dev... 6 /* unsigned long */
checking for basic type of struct stat64.st_ino... 6 /* unsigned long */
checking for basic type of struct stat64.st_nlink... 6 /* unsigned long */
checking for basic type of struct stat64.st_size... 5 /* long */
checking for basic type of struct stat64.st_blksize... 5 /* long */
checking for basic type of struct stat64.st_blocks... 5 /* long */
checking for basic type of struct timeval.tv_usec... 5 /* long */
checking for basic type of struct timespec.tv_nsec... 5 /* long */
checking for basic type of struct rlimit.rlim_max... 6 /* unsigned long */
checking for basic type of struct cmsghdr.cmsg_len... 6 /* unsigned long */
checking for /dev/ptmx... yes
checking for /proc... yes
checking for /proc/*/fd... yes
checking for /proc/*/path... no
checking whether to include libwrap support... yes
checking for components of libwrap... configure: WARNING: not all components of tcp wrappers found, disabling it
configure: checked for tcpd.h... no
checking for hosts_allow_table... no
checking for declaration of environ... yes
checking for var environ... yes
configure: creating ./config.status
config.status: creating Makefile
config.status: creating config.h
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o socat.o socat.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xioinitialize.o xioinitialize.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xiohelp.o xiohelp.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xioparam.o xioparam.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xiodiag.o xiodiag.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xioopen.o xioopen.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xioopts.o xioopts.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xiosignal.o xiosignal.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xiosigchld.o xiosigchld.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xioread.o xioread.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xiowrite.o xiowrite.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xiolayer.o xiolayer.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xioshutdown.o xioshutdown.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xioclose.o xioclose.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xioexit.o xioexit.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-process.o xio-process.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-fd.o xio-fd.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-fdnum.o xio-fdnum.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-stdio.o xio-stdio.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-pipe.o xio-pipe.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-gopen.o xio-gopen.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-creat.o xio-creat.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-file.o xio-file.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-named.o xio-named.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-socket.o xio-socket.c
xio-socket.c: In function 'xiocheckpeer':
xio-socket.c:1711:8: warning: unused variable 'result' [-Wunused-variable]
    int result;
        ^~~~~~
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-interface.o xio-interface.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-listen.o xio-listen.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-unix.o xio-unix.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-vsock.o xio-vsock.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-ip.o xio-ip.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-ip4.o xio-ip4.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-ip6.o xio-ip6.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-ipapp.o xio-ipapp.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-tcp.o xio-tcp.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-sctp.o xio-sctp.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-rawip.o xio-rawip.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-socks.o xio-socks.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-proxy.o xio-proxy.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-udp.o xio-udp.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-progcall.o xio-progcall.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-exec.o xio-exec.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-system.o xio-system.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-termios.o xio-termios.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-readline.o xio-readline.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-pty.o xio-pty.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-openssl.o xio-openssl.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-streams.o xio-streams.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-ascii.o xio-ascii.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xiolockfile.o xiolockfile.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-tcpwrap.o xio-tcpwrap.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-fs.o xio-fs.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o xio-tun.o xio-tun.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o error.o error.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o dalan.o dalan.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o procan.o procan.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o procan-cdefs.o procan-cdefs.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o hostan.o hostan.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o fdname.o fdname.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o sysutils.o sysutils.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o utils.o utils.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o nestlex.o nestlex.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o vsnprintf_r.o vsnprintf_r.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o snprinterr.o snprinterr.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o filan.o filan.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o sycls.o sycls.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o sslcls.o sslcls.c
ar r libxio.a xioinitialize.o xiohelp.o xioparam.o xiodiag.o xioopen.o xioopts.o xiosignal.o xiosigchld.o xioread.o xiowrite.o xiolayer.o xioshutdown.o xioclose.o xioexit.o xio-process.o xio-fd.o xio-fdnum.o xio-stdio.o xio-pipe.o xio-gopen.o xio-creat.o xio-file.o xio-named.o xio-socket.o xio-interface.o xio-listen.o xio-unix.o xio-vsock.o xio-ip.o xio-ip4.o xio-ip6.o xio-ipapp.o xio-tcp.o xio-sctp.o xio-rawip.o xio-socks.o xio-proxy.o xio-udp.o xio-progcall.o xio-exec.o xio-system.o xio-termios.o xio-readline.o xio-pty.o xio-openssl.o xio-streams.o xio-ascii.o xiolockfile.o xio-tcpwrap.o xio-fs.o xio-tun.o error.o dalan.o procan.o procan-cdefs.o hostan.o fdname.o sysutils.o utils.o nestlex.o vsnprintf_r.o snprinterr.o filan.o sycls.o sslcls.o
ar: creating libxio.a
ranlib libxio.a
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.   -o socat socat.o libxio.a -lutil 
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o procan_main.o procan_main.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.   -o procan procan_main.o procan.o procan-cdefs.o hostan.o error.o sycls.o sysutils.o utils.o vsnprintf_r.o snprinterr.o -lutil 
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.  -I.   -c -o filan_main.o filan_main.c
gcc -O -D_GNU_SOURCE -Wall -Wno-parentheses  -DHAVE_CONFIG_H -I.   -o filan filan_main.o filan.o fdname.o error.o sycls.o sysutils.o utils.o vsnprintf_r.o snprinterr.o -lutil 
mkdir -p /usr/bin
/usr/bin/install -c -m 755 socat /usr/bin
/usr/bin/install -c -m 755 procan /usr/bin
/usr/bin/install -c -m 755 filan /usr/bin
mkdir -p /usr/share/man/man1
/usr/bin/install -c -m 644 ./doc/socat.1 /usr/share/man/man1/
 ---> Removed intermediate container 4f20f9e2f1c0
 ---> 2cd71b19776a
Step 4/21 : RUN yum update -y &&     yum install -y       procps-ng       util-linux       iproute       iputils       net-tools       bind-utils       strace       lsof       curl       jq       vim-minimal       less       tree       socat &&     yum clean all
 ---> Running in 8e5c7ff22038
Loaded plugins: ovl, priorities
No packages marked for update
Loaded plugins: ovl, priorities
Package util-linux-2.30.2-2.amzn2.0.11.x86_64 already installed and latest version
Package curl-8.3.0-1.amzn2.0.10.x86_64 already installed and latest version
Package jq-1.5-1.amzn2.0.3.x86_64 already installed and latest version
Package 2:vim-minimal-9.0.2153-1.amzn2.0.4.x86_64 already installed and latest version
Package socat-1.7.3.2-2.amzn2.0.1.x86_64 already installed and latest version
Resolving Dependencies
--> Running transaction check
---> Package bind-utils.x86_64 32:9.11.4-26.P2.amzn2.13.12 will be installed
--> Processing Dependency: bind-libs(x86-64) = 32:9.11.4-26.P2.amzn2.13.12 for package: 32:bind-utils-9.11.4-26.P2.amzn2.13.12.x86_64
--> Processing Dependency: bind-libs-lite(x86-64) = 32:9.11.4-26.P2.amzn2.13.12 for package: 32:bind-utils-9.11.4-26.P2.amzn2.13.12.x86_64
--> Processing Dependency: libidn.so.11(LIBIDN_1.0)(64bit) for package: 32:bind-utils-9.11.4-26.P2.amzn2.13.12.x86_64
--> Processing Dependency: libGeoIP.so.1()(64bit) for package: 32:bind-utils-9.11.4-26.P2.amzn2.13.12.x86_64
--> Processing Dependency: libbind9.so.160()(64bit) for package: 32:bind-utils-9.11.4-26.P2.amzn2.13.12.x86_64
--> Processing Dependency: libdns.so.1102()(64bit) for package: 32:bind-utils-9.11.4-26.P2.amzn2.13.12.x86_64
--> Processing Dependency: libidn.so.11()(64bit) for package: 32:bind-utils-9.11.4-26.P2.amzn2.13.12.x86_64
--> Processing Dependency: libirs.so.160()(64bit) for package: 32:bind-utils-9.11.4-26.P2.amzn2.13.12.x86_64
--> Processing Dependency: libisc.so.169()(64bit) for package: 32:bind-utils-9.11.4-26.P2.amzn2.13.12.x86_64
--> Processing Dependency: libisccfg.so.160()(64bit) for package: 32:bind-utils-9.11.4-26.P2.amzn2.13.12.x86_64
--> Processing Dependency: liblwres.so.160()(64bit) for package: 32:bind-utils-9.11.4-26.P2.amzn2.13.12.x86_64
---> Package iproute.x86_64 0:5.10.0-2.amzn2.0.3 will be installed
--> Processing Dependency: psmisc for package: iproute-5.10.0-2.amzn2.0.3.x86_64
---> Package iputils.x86_64 0:20180629-11.amzn2.1.20160308 will be installed
---> Package less.x86_64 0:458-9.amzn2.0.4 will be installed
--> Processing Dependency: groff-base for package: less-458-9.amzn2.0.4.x86_64
---> Package lsof.x86_64 0:4.87-6.amzn2 will be installed
---> Package net-tools.x86_64 0:2.0-0.22.20131004git.amzn2.0.3 will be installed
---> Package procps-ng.x86_64 0:3.3.10-26.amzn2 will be installed
---> Package strace.x86_64 0:4.26-1.amzn2.0.1 will be installed
---> Package tree.x86_64 0:1.6.0-10.amzn2.0.1 will be installed
--> Running transaction check
---> Package GeoIP.x86_64 0:1.5.0-11.amzn2.0.2 will be installed
---> Package bind-libs.x86_64 32:9.11.4-26.P2.amzn2.13.12 will be installed
--> Processing Dependency: bind-license = 32:9.11.4-26.P2.amzn2.13.12 for package: 32:bind-libs-9.11.4-26.P2.amzn2.13.12.x86_64
---> Package bind-libs-lite.x86_64 32:9.11.4-26.P2.amzn2.13.12 will be installed
---> Package groff-base.x86_64 0:1.22.2-8.amzn2.0.2 will be installed
---> Package libidn.x86_64 0:1.28-4.amzn2.0.5 will be installed
---> Package psmisc.x86_64 0:22.20-15.amzn2.0.2 will be installed
--> Running transaction check
---> Package bind-license.noarch 32:9.11.4-26.P2.amzn2.13.12 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package          Arch     Version                           Repository    Size
================================================================================
Installing:
 bind-utils       x86_64   32:9.11.4-26.P2.amzn2.13.12       amzn2-core   261 k
 iproute          x86_64   5.10.0-2.amzn2.0.3                amzn2-core   649 k
 iputils          x86_64   20180629-11.amzn2.1.20160308      amzn2-core   147 k
 less             x86_64   458-9.amzn2.0.4                   amzn2-core   119 k
 lsof             x86_64   4.87-6.amzn2                      amzn2-core   332 k
 net-tools        x86_64   2.0-0.22.20131004git.amzn2.0.3    amzn2-core   304 k
 procps-ng        x86_64   3.3.10-26.amzn2                   amzn2-core   292 k
 strace           x86_64   4.26-1.amzn2.0.1                  amzn2-core   921 k
 tree             x86_64   1.6.0-10.amzn2.0.1                amzn2-core    47 k
Installing for dependencies:
 GeoIP            x86_64   1.5.0-11.amzn2.0.2                amzn2-core   1.1 M
 bind-libs        x86_64   32:9.11.4-26.P2.amzn2.13.12       amzn2-core   160 k
 bind-libs-lite   x86_64   32:9.11.4-26.P2.amzn2.13.12       amzn2-core   1.1 M
 bind-license     noarch   32:9.11.4-26.P2.amzn2.13.12       amzn2-core    93 k
 groff-base       x86_64   1.22.2-8.amzn2.0.2                amzn2-core   948 k
 libidn           x86_64   1.28-4.amzn2.0.5                  amzn2-core   209 k
 psmisc           x86_64   22.20-15.amzn2.0.2                amzn2-core   141 k

Transaction Summary
================================================================================
Install  9 Packages (+7 Dependent packages)

Total download size: 6.7 M
Installed size: 17 M
Downloading packages:
--------------------------------------------------------------------------------
Total                                              5.2 MB/s | 6.7 MB  00:01     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : GeoIP-1.5.0-11.amzn2.0.2.x86_64                             1/16 
  Installing : 32:bind-license-9.11.4-26.P2.amzn2.13.12.noarch             2/16 
  Installing : 32:bind-libs-lite-9.11.4-26.P2.amzn2.13.12.x86_64           3/16 
  Installing : libidn-1.28-4.amzn2.0.5.x86_64                              4/16 
  Installing : 32:bind-libs-9.11.4-26.P2.amzn2.13.12.x86_64                5/16 
  Installing : psmisc-22.20-15.amzn2.0.2.x86_64                            6/16 
  Installing : groff-base-1.22.2-8.amzn2.0.2.x86_64                        7/16 
  Installing : less-458-9.amzn2.0.4.x86_64                                 8/16 
  Installing : iproute-5.10.0-2.amzn2.0.3.x86_64                           9/16 
  Installing : 32:bind-utils-9.11.4-26.P2.amzn2.13.12.x86_64              10/16 
  Installing : iputils-20180629-11.amzn2.1.20160308.x86_64                11/16 
  Installing : lsof-4.87-6.amzn2.x86_64                                   12/16 
  Installing : net-tools-2.0-0.22.20131004git.amzn2.0.3.x86_64            13/16 
  Installing : strace-4.26-1.amzn2.0.1.x86_64                             14/16 
  Installing : tree-1.6.0-10.amzn2.0.1.x86_64                             15/16 
  Installing : procps-ng-3.3.10-26.amzn2.x86_64                           16/16 
  Verifying  : procps-ng-3.3.10-26.amzn2.x86_64                            1/16 
  Verifying  : 32:bind-libs-9.11.4-26.P2.amzn2.13.12.x86_64                2/16 
  Verifying  : libidn-1.28-4.amzn2.0.5.x86_64                              3/16 
  Verifying  : 32:bind-libs-lite-9.11.4-26.P2.amzn2.13.12.x86_64           4/16 
  Verifying  : 32:bind-utils-9.11.4-26.P2.amzn2.13.12.x86_64               5/16 
  Verifying  : iputils-20180629-11.amzn2.1.20160308.x86_64                 6/16 
  Verifying  : groff-base-1.22.2-8.amzn2.0.2.x86_64                        7/16 
  Verifying  : tree-1.6.0-10.amzn2.0.1.x86_64                              8/16 
  Verifying  : strace-4.26-1.amzn2.0.1.x86_64                              9/16 
  Verifying  : GeoIP-1.5.0-11.amzn2.0.2.x86_64                            10/16 
  Verifying  : net-tools-2.0-0.22.20131004git.amzn2.0.3.x86_64            11/16 
  Verifying  : 32:bind-license-9.11.4-26.P2.amzn2.13.12.noarch            12/16 
  Verifying  : iproute-5.10.0-2.amzn2.0.3.x86_64                          13/16 
  Verifying  : lsof-4.87-6.amzn2.x86_64                                   14/16 
  Verifying  : psmisc-22.20-15.amzn2.0.2.x86_64                           15/16 
  Verifying  : less-458-9.amzn2.0.4.x86_64                                16/16 

Installed:
  bind-utils.x86_64 32:9.11.4-26.P2.amzn2.13.12                                 
  iproute.x86_64 0:5.10.0-2.amzn2.0.3                                           
  iputils.x86_64 0:20180629-11.amzn2.1.20160308                                 
  less.x86_64 0:458-9.amzn2.0.4                                                 
  lsof.x86_64 0:4.87-6.amzn2                                                    
  net-tools.x86_64 0:2.0-0.22.20131004git.amzn2.0.3                             
  procps-ng.x86_64 0:3.3.10-26.amzn2                                            
  strace.x86_64 0:4.26-1.amzn2.0.1                                              
  tree.x86_64 0:1.6.0-10.amzn2.0.1                                              

Dependency Installed:
  GeoIP.x86_64 0:1.5.0-11.amzn2.0.2                                             
  bind-libs.x86_64 32:9.11.4-26.P2.amzn2.13.12                                  
  bind-libs-lite.x86_64 32:9.11.4-26.P2.amzn2.13.12                             
  bind-license.noarch 32:9.11.4-26.P2.amzn2.13.12                               
  groff-base.x86_64 0:1.22.2-8.amzn2.0.2                                        
  libidn.x86_64 0:1.28-4.amzn2.0.5                                              
  psmisc.x86_64 0:22.20-15.amzn2.0.2                                            

Complete!
Loaded plugins: ovl, priorities
Cleaning repos: amzn2-core amzn2extra-aws-nitro-enclaves-cli
Cleaning up everything
Maybe you want: rm -rf /var/cache/yum, to also free up space taken by orphaned data from disabled or removed repos
 ---> Removed intermediate container 8e5c7ff22038
 ---> d6de80390a1d
Step 5/21 : RUN /usr/bin/socat -h | grep -i sock && echo " !!!! vsock support verified !!!!"
 ---> Running in e757f3f1ac89
      abstract-client:<filename>	groups=FD,SOCKET,RETRY,UNIX
      abstract-connect:<filename>	groups=FD,SOCKET,RETRY,UNIX
      abstract-listen:<filename>	groups=FD,SOCKET,LISTEN,CHILD,RETRY,UNIX
      abstract-recv:<filename>	groups=FD,SOCKET,RETRY,UNIX
      abstract-recvfrom:<filename>	groups=FD,SOCKET,CHILD,RETRY,UNIX
      abstract-sendto:<filename>	groups=FD,SOCKET,RETRY,UNIX
      exec:<command-line>	groups=FD,FIFO,SOCKET,EXEC,FORK,TERMIOS,PTY,PARENT,UNIX
      fd:<num>	groups=FD,FIFO,CHR,BLK,REG,SOCKET,TERMIOS,UNIX,IP4,IP6,UDP,TCP,SCTP
      gopen:<filename>	groups=FD,FIFO,CHR,BLK,REG,SOCKET,NAMED,OPEN,TERMIOS,UNIX
      interface:<interface>	groups=FD,SOCKET
      ip-datagram:<host>:<protocol>	groups=FD,SOCKET,RANGE,IP4,IP6
      ip-recv:<protocol>	groups=FD,SOCKET,RANGE,IP4,IP6
      ip-recvfrom:<protocol>	groups=FD,SOCKET,CHILD,RANGE,IP4,IP6
      ip-sendto:<host>:<protocol>	groups=FD,SOCKET,IP4,IP6
      ip4-datagram:<host>:<protocol>	groups=FD,SOCKET,RANGE,IP4
      ip4-recv:<protocol>	groups=FD,SOCKET,RANGE,IP4
      ip4-recvfrom:<protocol>	groups=FD,SOCKET,CHILD,RANGE,IP4
      ip4-sendto:<host>:<protocol>	groups=FD,SOCKET,IP4
      ip6-datagram:<host>:<protocol>	groups=FD,SOCKET,RANGE,IP6
      ip6-recv:<protocol>	groups=FD,SOCKET,RANGE,IP6
      ip6-recvfrom:<protocol>	groups=FD,SOCKET,CHILD,RANGE,IP6
      ip6-sendto:<host>:<protocol>	groups=FD,SOCKET,IP6
      proxy:<proxy-server>:<host>:<port>	groups=FD,SOCKET,CHILD,RETRY,IP4,IP6,TCP,HTTP
      sctp-connect:<host>:<port>	groups=FD,SOCKET,CHILD,RETRY,IP4,IP6,SCTP
      sctp-listen:<port>	groups=FD,SOCKET,LISTEN,CHILD,RETRY,RANGE,IP4,IP6,SCTP
      sctp4-connect:<host>:<port>	groups=FD,SOCKET,CHILD,RETRY,IP4,SCTP
      sctp4-listen:<port>	groups=FD,SOCKET,LISTEN,CHILD,RETRY,RANGE,IP4,SCTP
      sctp6-connect:<host>:<port>	groups=FD,SOCKET,CHILD,RETRY,IP6,SCTP
      sctp6-listen:<port>	groups=FD,SOCKET,LISTEN,CHILD,RETRY,RANGE,IP6,SCTP
      socket-connect:<domain>:<protocol>:<remote-address>	groups=FD,SOCKET,CHILD,RETRY
      socket-datagram:<domain>:<type>:<protocol>:<remote-address>	groups=FD,SOCKET,RANGE
      socket-listen:<domain>:<protocol>:<local-address>	groups=FD,SOCKET,LISTEN,CHILD,RETRY,RANGE
      socket-recv:<domain>:<type>:<protocol>:<local-address>	groups=FD,SOCKET,RANGE
      socket-recvfrom:<domain>:<type>:<protocol>:<local-address>	groups=FD,SOCKET,CHILD,RANGE
      socket-sendto:<domain>:<type>:<protocol>:<remote-address>	groups=FD,SOCKET
      socks4:<socks-server>:<host>:<port>	groups=FD,SOCKET,CHILD,RETRY,IP4,IP6,TCP,SOCKS4
      socks4a:<socks-server>:<host>:<port>	groups=FD,SOCKET,CHILD,RETRY,IP4,IP6,TCP,SOCKS4
      stderr	groups=FD,FIFO,CHR,BLK,REG,SOCKET,TERMIOS,UNIX,IP4,IP6,UDP,TCP,SCTP
      stdin	groups=FD,FIFO,CHR,BLK,REG,SOCKET,TERMIOS,UNIX,IP4,IP6,UDP,TCP,SCTP
      stdio	groups=FD,FIFO,CHR,BLK,REG,SOCKET,TERMIOS,UNIX,IP4,IP6,UDP,TCP,SCTP
      stdout	groups=FD,FIFO,CHR,BLK,REG,SOCKET,TERMIOS,UNIX,IP4,IP6,UDP,TCP,SCTP
      system:<shell-command>	groups=FD,FIFO,SOCKET,EXEC,FORK,TERMIOS,PTY,PARENT,UNIX
      tcp-connect:<host>:<port>	groups=FD,SOCKET,CHILD,RETRY,IP4,IP6,TCP
      tcp-listen:<port>	groups=FD,SOCKET,LISTEN,CHILD,RETRY,RANGE,IP4,IP6,TCP
      tcp4-connect:<host>:<port>	groups=FD,SOCKET,CHILD,RETRY,IP4,TCP
      tcp4-listen:<port>	groups=FD,SOCKET,LISTEN,CHILD,RETRY,RANGE,IP4,TCP
      tcp6-connect:<host>:<port>	groups=FD,SOCKET,CHILD,RETRY,IP6,TCP
      tcp6-listen:<port>	groups=FD,SOCKET,LISTEN,CHILD,RETRY,RANGE,IP6,TCP
      udp-connect:<host>:<port>	groups=FD,SOCKET,IP4,IP6,UDP
      udp-datagram:<host>:<port>	groups=FD,SOCKET,RANGE,IP4,IP6,UDP
      udp-listen:<port>	groups=FD,SOCKET,LISTEN,CHILD,RANGE,IP4,IP6,UDP
      udp-recv:<port>	groups=FD,SOCKET,RANGE,IP4,IP6,UDP
      udp-recvfrom:<port>	groups=FD,SOCKET,CHILD,RANGE,IP4,IP6,UDP
      udp-sendto:<host>:<port>	groups=FD,SOCKET,IP4,IP6,UDP
      udp4-connect:<host>:<port>	groups=FD,SOCKET,IP4,UDP
      udp4-datagram:<host>:<port>	groups=FD,SOCKET,RANGE,IP4,UDP
      udp4-listen:<port>	groups=FD,SOCKET,LISTEN,CHILD,RANGE,IP4,UDP
      udp4-recv:<port>	groups=FD,SOCKET,RANGE,IP4,UDP
      udp4-recvfrom:<port>	groups=FD,SOCKET,CHILD,RANGE,IP4,UDP
      udp4-sendto:<host>:<port>	groups=FD,SOCKET,IP4,UDP
      udp6-connect:<host>:<port>	groups=FD,SOCKET,IP6,UDP
      udp6-datagram:<host>:<port>	groups=FD,SOCKET,RANGE,IP6,UDP
      udp6-listen:<port>	groups=FD,SOCKET,LISTEN,CHILD,RANGE,IP6,UDP
      udp6-recv:<port>	groups=FD,SOCKET,RANGE,IP6,UDP
      udp6-recvfrom:<port>	groups=FD,SOCKET,CHILD,RANGE,IP6,UDP
      udp6-sendto:<host>:<port>	groups=FD,SOCKET,IP6,UDP
      unix-client:<filename>	groups=FD,SOCKET,NAMED,RETRY,UNIX
      unix-connect:<filename>	groups=FD,SOCKET,NAMED,RETRY,UNIX
      unix-listen:<filename>	groups=FD,SOCKET,NAMED,LISTEN,CHILD,RETRY,UNIX
      unix-recv:<filename>	groups=FD,SOCKET,NAMED,RETRY,UNIX
      unix-recvfrom:<filename>	groups=FD,SOCKET,NAMED,CHILD,RETRY,UNIX
      unix-sendto:<filename>	groups=FD,SOCKET,NAMED,RETRY,UNIX
      vsock-connect:<cid>:<port>	groups=FD,SOCKET,CHILD,RETRY
      vsock-listen:<port>	groups=FD,SOCKET,LISTEN,CHILD,RETRY
 !!!! vsock support verified !!!!
 ---> Removed intermediate container e757f3f1ac89
 ---> d5f802087dff
Step 6/21 : WORKDIR /ne-deps
 ---> Running in 90274c3f4fc7
 ---> Removed intermediate container 90274c3f4fc7
 ---> 818e0135d614
Step 7/21 : RUN BINS="    /usr/bin/nitro-cli     /usr/bin/nitro-enclaves-allocator     /usr/bin/jq     /usr/bin/socat     " &&     for bin in $BINS; do         { echo "$bin"; ldd "$bin" | grep -Eo "/.*lib.*/[^ ]+"; } |             while read path; do                 mkdir -p ".$(dirname $path)";                 cp -fL "$path" ".$path";             done     done
 ---> Running in 255f94b61c53
 ---> Removed intermediate container 255f94b61c53
 ---> d711ef1c9973
Step 8/21 : RUN     mkdir -p /ne-deps/etc/nitro_enclaves &&     mkdir -p /ne-deps/run/nitro_enclaves &&     mkdir -p /ne-deps/var/log/nitro_enclaves &&     cp -rf /usr/share/nitro_enclaves/ /ne-deps/usr/share/ &&     cp -f /etc/nitro_enclaves/allocator.yaml /ne-deps/etc/nitro_enclaves/allocator.yaml
 ---> Running in 744b3c0ab23b
 ---> Removed intermediate container 744b3c0ab23b
 ---> 4de7835218f3
Step 9/21 : FROM public.ecr.aws/amazonlinux/amazonlinux:2 as image
 ---> cc9511194e67
Step 10/21 : COPY --from=full_image /ne-deps/etc /etc
 ---> 46632701a8f9
Step 11/21 : COPY --from=full_image /ne-deps/lib64 /lib64
 ---> 8b5be79ee1a9
Step 12/21 : COPY --from=full_image /ne-deps/run /run
 ---> 1a570b4f56c6
Step 13/21 : COPY --from=full_image /ne-deps/usr /usr
 ---> c45a6b66606e
Step 14/21 : COPY --from=full_image /ne-deps/var /var
 ---> 4a90f2c367f2
Step 15/21 : COPY bin/nginx.eif /home
 ---> 08f787b398b5
Step 16/21 : COPY coconginx/run.sh  /home
 ---> ea394cc03858
Step 17/21 : RUN printf '#!/bin/bash\n\nENCLAVE_CID=$1\nTCP_PORT=${2:-80}\nVSOCK_PORT=${3:-5000}\n\necho "Starting VSOCK proxy: TCP:$TCP_PORT -> VSOCK:$ENCLAVE_CID:$VSOCK_PORT"\n\nexec socat TCP-LISTEN:$TCP_PORT,fork,reuseaddr VSOCK-CONNECT:$ENCLAVE_CID:$VSOCK_PORT\n' > /home/vsock-proxy.sh
 ---> Running in 66b71d838100
 ---> Removed intermediate container 66b71d838100
 ---> 1010a23497b9
Step 18/21 : RUN printf '#!/bin/bash\n\nENCLAVE_CID=$1\nHEALTH_PORT=5001\n\necho "Starting health check for enclave CID: $ENCLAVE_CID"\n\nwhile true; do\n    if echo "health" | socat -t 1 - VSOCK-CONNECT:$ENCLAVE_CID:$HEALTH_PORT 2>/dev/null; then\n        echo "$(date): Enclave health check PASSED"\n    else\n        echo "$(date): Enclave health check FAILED"\n    fi\n    sleep 30\ndone\n' > /home/health-check.sh
 ---> Running in 21738d27e9ef
 ---> Removed intermediate container 21738d27e9ef
 ---> 1fb594c0627c
Step 19/21 : RUN chmod +x /home/run.sh /home/vsock-proxy.sh /home/health-check.sh
 ---> Running in 99234552998c
 ---> Removed intermediate container 99234552998c
 ---> b0d6c156fec3
Step 20/21 : RUN ls -la /home/ && echo "=== Script contents ===" &&     head -5 /home/run.sh /home/vsock-proxy.sh /home/health-check.sh &&     echo "=== All scripts verified ==="
 ---> Running in e56cb2d7d1c0
total 335748
drwxr-xr-x 1 root root      4096 Nov 25 05:57 .
drwxr-xr-x 1 root root      4096 Nov 25 05:57 ..
-rwxr-xr-x 1 root root       353 Nov 25 05:57 health-check.sh
-rw-r--r-- 1 root root 343781046 Nov 25 05:46 nginx.eif
-rwxrwxr-x 1 root root      1989 Nov 19 14:18 run.sh
-rwxr-xr-x 1 root root       233 Nov 25 05:57 vsock-proxy.sh
=== Script contents ===
==> /home/run.sh <==
#!/bin/bash -e
# Copyright 2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.

readonly EIF_PATH="/home/nginx.eif"
readonly ENCLAVE_CPU_COUNT=2

==> /home/vsock-proxy.sh <==
#!/bin/bash

ENCLAVE_CID=$1
TCP_PORT=${2:-80}
VSOCK_PORT=${3:-5000}

==> /home/health-check.sh <==
#!/bin/bash

ENCLAVE_CID=$1
HEALTH_PORT=5001

=== All scripts verified ===
 ---> Removed intermediate container e56cb2d7d1c0
 ---> 26fa88793a8b
Step 21/21 : CMD ["/home/run.sh"]
 ---> Running in db7aa19dc80d
 ---> Removed intermediate container db7aa19dc80d
 ---> ac723f1c9deb
[Warning] One or more build-args [config_region] were not consumed
Successfully built ac723f1c9deb
Successfully tagged coconginx-9c1f783a-844b-4cf1-9f5a-4ca0bd9f52c6:latest
REPOSITORY                                       TAG       IMAGE ID       CREATED                  SIZE
coconginx-9c1f783a-844b-4cf1-9f5a-4ca0bd9f52c6   latest    ac723f1c9deb   Less than a second ago   589MB
<none>                                           <none>    4de7835218f3   13 seconds ago           1.72GB
ne-build-nginx-eif                               1.0       90f4d45bc54a   12 minutes ago           339MB
ne-example-builder                               latest    eb9ea15c4865   13 minutes ago           1.14GB
public.ecr.aws/amazonlinux/amazonlinux           2         cc9511194e67   3 days ago               165MB
kindest/node                                     <none>    4357c93ef232   2 months ago             985MB
CONTAINER ID   IMAGE                       COMMAND                  CREATED          STATUS                      PORTS                       NAMES
b84cbbbc1ed2   ne-example-builder:latest   "/home/run.sh"           13 minutes ago   Exited (0) 11 minutes ago                               amazing_turing
94ceaa5df6ff   kindest/node:v1.34.0        "/usr/local/bin/entr…"   2 weeks ago      Up 46 minutes               127.0.0.1:42939->6443/tcp   intg-ks-control-plane
3a37000fe3af   kindest/node:v1.34.0        "/usr/local/bin/entr…"   2 weeks ago      Up 46 minutes                                           intg-ks-worker2
1e9f7266e483   kindest/node:v1.34.0        "/usr/local/bin/entr…"   2 weeks ago      Up 46 minutes                                           intg-ks-worker
sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ 




sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ 
#Dynamically tagging the coconginx-xxxxxx:xxxx to appropriate one as in the command. 
        docker images --format '{{.Repository}}:{{.Tag}}' | grep '^coconginx-' | while read image; do
          docker tag "$image" nerdysrisha/nginx-aws-nitro:latest
        done

        docker images
 
#Push the image to docker hub. 
docker push nerdysrisha/nginx-aws-nitro:latest


REPOSITORY                                       TAG       IMAGE ID       CREATED          SIZE
coconginx-9c1f783a-844b-4cf1-9f5a-4ca0bd9f52c6   latest    ac723f1c9deb   5 minutes ago    589MB
nerdysrisha/nginx-aws-nitro                      latest    ac723f1c9deb   5 minutes ago    589MB
<none>                                           <none>    4de7835218f3   6 minutes ago    1.72GB
ne-build-nginx-eif                               1.0       90f4d45bc54a   18 minutes ago   339MB
ne-example-builder                               latest    eb9ea15c4865   19 minutes ago   1.14GB
public.ecr.aws/amazonlinux/amazonlinux           2         cc9511194e67   3 days ago       165MB
kindest/node                                     <none>    4357c93ef232   2 months ago     985MB
The push refers to repository [docker.io/nerdysrisha/nginx-aws-nitro]
741199c80444: Pushed 
25380eaea2e9: Pushed 
5076659285ce: Pushed 
3536a1a1ca37: Pushed 
4ce4b0b71bad: Pushed 
ae4cafba3f68: Pushed 
9ce44f44cb04: Pushed 
975b6e755fea: Pushed 
d1b1376a46cc: Pushed 
3bb3f0e0f978: Pushed 
309f3361db9d: Pushed 
latest: digest: sha256:92a7406d4ff2af05e0b319bc37a9d7109c19daba6c5e66ffb38912aa132b9752 size: 2615
sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ 




sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s$ 
cd /home/sridhara/Downloads/3-aws-scripts-eks-coco-linux/create
./b-login.sh

Confidential Containers...Logging into your profile
===================================================
Attempting to automatically open the SSO authorization page in your default browser.
If the browser does not open, open the following URL:

https://oidc.eu-west-1.amazonaws.com/authorize?response_type=code&client_id=rrFLdrEYaBra0q6ZANcobGV1LXdlc3QtMQ&redirect_uri=http%3A%2F%2F127.0.0.1%3A37091%2Foauth%2Fcallback&state=00ba1311-78ba-4391-8c87-e69af77e3d92&code_challenge_method=S256&scopes=sso%3Aaccount%3Aaccess&code_challenge=DIdGy8BZRm12N5RP0R-X_FgwAt6i5ziryFVY3DhrF7w
Successfully logged into Start URL: https://d-93671b9731.awsapps.com/start/#

Extracting temporary credentials...
Getting current caller identity...
{
    "UserId": "AROA5HFZTBRAFB6S6RNKI:sridhara_shastry",
    "Account": "908774804544",
    "Arn": "arn:aws:sts::908774804544:assumed-role/AWSReservedSSO_AWSAdministratorAccess_e52b283d4a7e1129/sridhara_shastry"
}
Getting credentials from SSO cache...
Credentials extracted successfully
Getting region...
Region: eu-west-1
Writing to file...
Credentials saved to  file0-bastion-aws-temporary-creds
File contents:
export AWS_ACCESS_KEY_ID=ASIA5HFZTBRADZDEBORM
export AWS_SECRET_ACCESS_KEY=WHmvVa3+ss1Ak0OEy5qqEAzoB+S5VwS8NZ98Ty5y
export AWS_SESSION_TOKEN=IQoJb3JpZ2luX2VjEKD//////////wEaCWV1LXdlc3QtMSJHMEUCIGsb0nXZr2xeKOB+dp0gO/yKdvmRtIZuQjG0wMoQfnAJAiEA8J8UCSSc4ELyNygLX+7Zw84eOv+ptzlL0njeW5XJQIQq/wIIaRAAGgw5MDg3NzQ4MDQ1NDQiDEFIwcRozXEI8/LadSrcAi5ortUEV/OcaveN0v7l+6XmPdBJ3dVyEx/NUZLLByerJVt/XuhdCkeUxJBtJK/hWCOui9NqOCuUfryLRwpBHzOAkNCSCmwpMNdryAwLTziZo4R4J7IUquybtt/aihJtQ9+KU+EHi2RGRzPyiUyBjdZKhCw4cIvmk5GrcCvzR6ReN/Ho41N4jPRt8Mdt6PCafVpAbmodKkKCVdtDLhgNvYaoumLs35CwIR4PXGpbep/g/jGxjQFVUwFpM3E+OEFn9zXIhwvsmZjMMlgNQnUSHg4jm6vLh9pDC9uwyjuzwqo5f+HGJdWTijmz4VRtNOO28I+CFavCmJVyMmgT7no+9I2LuHq+IF1yLAFoDnm5qyD7KD8+z54UiH6RCb0jfPnw/34fcRDE45ir6JTMshE+xVHrrFoBsU4kuci5iy28OgX8875RZQKneCAZxu+J79MY7uSItitLFZlTvFKtbDD9wJXJBjqlAeA8DtHUhqeAWWuzant9N5YhJTtmaJLErPK2d0QiZMNmtwd+urQs7nzhcHIdepg3fzW58fNhLKjdCgJkJr2yzdnPX/jiLOpBjkewt40wFDraceMXh1t/A6PqHOxHKLxLbGSRVkkggmYpWaashaUMKDLGEr4FrfrEezSpZp7nXmhU1g3POx1Izaok8AwQ/CoJ7RSej0sY29WHkIdBNlJ3gkNNWJPOEw==
export AWS_CREDENTIAL_EXPIRATION=2025-11-25T08:53:32+00:00
AWS_DEFAULT_REGION=eu-west-1
Done.
sridhara@ubuntu:~/Downloads/3-aws-scripts-eks-coco-linux/create$ 



sridhara@ubuntu:~/Downloads/3-aws-scripts-eks-coco-linux/create$ 
./c-create-coco-eks-keypair.sh

./d-create-coco-eks-vpc.sh

./e-create-coco-eks-iamrole.sh

./f-create-coco-eks.sh
#Wait for 10 mins
Confidential Containers- NITRO ENCLAVES
===================================================
Removing EKS Keypair in the current directory with name coco-eks-keypair (if-exists)
========================================================================
Creating EKS Keypair in the current directory with name coco-eks-keypair
========================================================================
Creating keypair for worker node access...
Executing: aws ec2 create-key-pair --key-name coco-eks-key --tag-specifications 'ResourceType=key-pair,Tags=[{Key=Env,Value=dev},{Key=Project,Value=coco},{Key=Owner,Value=sri}]' --query 'KeyMaterial' --output text
Setting keypair permissions...
Executing: chmod 400 coco-eks-key.pem
Verifying keypair in AWS...
Executing: aws ec2 describe-key-pairs --key-names coco-eks-key --query 'KeyPairs[0].KeyName' --output text
=== Keypair Creation Complete ===
Keypair Name: coco-eks-key
Private Key File: coco-eks-key.pem
File Permissions: -r-------- 1 sridhara sridhara 1679 Nov 25 07:54 coco-eks-key.pem

Usage: ssh -i coco-eks-key.pem ec2-user@<worker-node-ip>
=== Ready for EKS setup ===
Confidential Containers.
===================================================
Creating VPC, IGW, PUB_SUBNETS, PVT_SUBNETS, ROUTE TABLE, ELASTIC IP, NATGW, 
=============================================================================

 1. Creating VPC:  Done. ID:vpc-0110d769bec9f4e5c

 2. Enabling DNS Support and hostnames for VPC created:  Done

 3. Creating IGW:  Done. ID: igw-09d503e7824f70ac9

 4. Attaching IGW to VPC:  Done

 5. Using two Regions for subnets eu-west-1a & eu-west-1b 
 
 6. Creating public Subnet for NAT GW:  Done. ID: subnet-06af5b1166d78a6a6

 7. Creating private Subnet1 for workernode:  Done. ID: subnet-053252fef68e5f14d

 8. Creating private Subnet1 for workernode:  Done. ID:subnet-024df4fc155c6310f

 9. Creating Public Route Table:  Done. ID: rtb-0e3098654c2f5d01d

True Adding route to IGW in public route table: 
 Done.

rtbassoc-04654f554a2c73c22et with public RT: 
ASSOCIATIONSTATE        associated
 Done.

 12. Allocating Elastic IP for NAT GW:  Done. ID: eipalloc-08407e3ad37acd20b

 13. Creating NAT GW in Public Subnet:  Done. ID:nat-0fa1841e74686c94d

 14. Waiting for NAT GW to become available:  NAT GW Ready

 15. Configuring Internet routing and public IP assignments. Important Step.Configuring internet route and auto-assign public IP for EKS compatibility: 
{
    "Return": true
}
 Done

 16. Modifying subnet attributes to auto-assign public IPs:  Done

--------------------------------------------nt zones..: 
|              DescribeSubnets             |
+---------------------------+--------------+
|  subnet-024df4fc155c6310f |  eu-west-1b  |
|  subnet-053252fef68e5f14d |  eu-west-1a  |
+---------------------------+--------------+
EKS networking configuration completed successfully!
Confidential Containers.
===================================================

 1. Creating Cluster Trust Policy (json) in current directory, for Cluster Role:  Done.

{2. Creating Cluster Cluster Role(eks-coco-cluster-role) using json file: 
    "Role": {
        "Path": "/",
        "RoleName": "eks-coco-cluster-role",
        "RoleId": "AROA5HFZTBRAOV52LP3D2",
        "Arn": "arn:aws:iam::908774804544:role/eks-coco-cluster-role",
        "CreateDate": "2025-11-25T07:57:13+00:00",
        "AssumeRolePolicyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "Service": "eks.amazonaws.com"
                    },
                    "Action": "sts:AssumeRole"
                }
            ]
        },
        "Tags": [
            {
                "Key": "Env",
                "Value": "dev"
            },
            {
                "Key": "Project",
                "Value": "coco"
            },
            {
                "Key": "Owner",
                "Value": "sri"
            }
        ]
    }
}

 3. Attaching Policy (AmazonEKSClusterPolicy) to role (eks-coco-cluster-role): 


 Done.

 4. Creating Nodegroup Trust Policy (json) in current directory, for Cluster Role:  Done.

{5. Creating Nodegroup Role (eks-coco-nodegroup-role) using the json file. : 
    "Role": {
        "Path": "/",
        "RoleName": "eks-coco-nodegroup-role",
        "RoleId": "AROA5HFZTBRAGQHZH2WZR",
        "Arn": "arn:aws:iam::908774804544:role/eks-coco-nodegroup-role",
        "CreateDate": "2025-11-25T07:57:24+00:00",
        "AssumeRolePolicyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "Service": "ec2.amazonaws.com"
                    },
                    "Action": "sts:AssumeRole"
                }
            ]
        },
        "Tags": [
            {
                "Key": "Env",
                "Value": "dev"
            },
            {
                "Key": "Project",
                "Value": "coco"
            },
            {
                "Key": "Owner",
                "Value": "sri"
            }
        ]
    }
}

 6. Attaching Policy (AmazonEKSWorkerNodePolicy) to Role (eks-coco-nodegroup-role). :  Done.

 7. Attaching Policy (AmazonEKS_CNI_Policy) to Role (eks-coco-nodegroup-role). :  Done.

 8. Attaching Policy (AmazonEC2ContainerRegistryReadOnly) to Role (eks-coco-nodegroup-role).:  Done.

 9. Creating Nitro Enclave Policy (json file) in current directory:  Done.

{10. Creating and Attaching Policies using json file: 
    "Policy": {
        "PolicyName": "CustomNitroEnclavesAccess",
        "PolicyId": "ANPA5HFZTBRAJ3ITD7LDF",
        "Arn": "arn:aws:iam::908774804544:policy/CustomNitroEnclavesAccess",
        "Path": "/",
        "DefaultVersionId": "v1",
        "AttachmentCount": 0,
        "PermissionsBoundaryUsageCount": 0,
        "IsAttachable": true,
        "CreateDate": "2025-11-25T07:57:39+00:00",
        "UpdateDate": "2025-11-25T07:57:39+00:00"
    }
}

 11. Attaching Policy (CustomNitroEnclavesAccess) to Role (eks-coco-nodegroup-role):  Done.

 12. Creating NodeInstance Trust Policy (json) in current directory, for NodeInstance Role:  Done.

{13. Creating NodeInstance Role using the json file (NodeInstanceTrustPolicy.json): 
    "Role": {
        "Path": "/",
        "RoleName": "NodeInstanceRole",
        "RoleId": "AROA5HFZTBRAAPVG7FKUE",
        "Arn": "arn:aws:iam::908774804544:role/NodeInstanceRole",
        "CreateDate": "2025-11-25T07:57:44+00:00",
        "AssumeRolePolicyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "Service": "ec2.amazonaws.com"
                    },
                    "Action": "sts:AssumeRole"
                }
            ]
        }
    }
}

 14. Attaching Policy (AmazonEKSWorkerNodePolicy) to Role (NodeInstanceRole):  Done.

 15. Attaching Policy (AmazonEKS_CNI_Policy) to Role (NodeInstanceRole):  Done.

 16. Attaching Policy (AmazonEC2ContainerRegistryReadOnly) to Role (NodeInstanceRole):  Done.

 17. Attaching Policy (AmazonSSMManagedInstanceCore) to Role (NodeInstanceRole):  Done.

{18. Creating Instance Profile (NodeInstanceProfile): 
    "InstanceProfile": {
        "Path": "/",
        "InstanceProfileName": "NodeInstanceProfile",
        "InstanceProfileId": "AIPA5HFZTBRAKSN5GCWLZ",
        "Arn": "arn:aws:iam::908774804544:instance-profile/NodeInstanceProfile",
        "CreateDate": "2025-11-25T07:58:01+00:00",
        "Roles": []
    }
}

 19. Adding Role (NodeInstanceRole) to Instance Profile (NodeInstanceProfile): 
 20. Removing the JSON Policy files from current directory:  Done.

 All IAM roles and policies created successfully!Confidential Containers.
===================================================

 1. Getting VPC ID & Subnet IDs:  Done. ID:vpc-0110d769bec9f4e5c and subnet-024df4fc155c6310f,subnet-053252fef68e5f14d

 2. Creating EKS Cluster and waiting for activation...Waiting for cluster 'eks-coco' to become active...
 Done.

 3. Installing Add-on components 'vpc-cni, kube-proxy, coredns'... Done.

 4. Updating the kubeconfig... Done.

 5. Context in use...arn:aws:eks:eu-west-1:908774804544:cluster/eks-coco
 Done.
✅ EKS cluster created and ready.
sridhara@ubuntu:~/Downloads/3-aws-scripts-eks-coco-linux/create$ 





sridhara@ubuntu:~/Downloads/3-aws-scripts-eks-coco-linux/create$ 
./g1-create-coco-nodegroup-launchtemplate-amzonlinux2.sh
./h-create-coco-eks-nodegroup.sh
#Wait for 10 mins


./i-modify-security-groups-usedby-nitronode.sh

kubectl get nodes 
Creating template eks-coco-nitro-template
{
    "LaunchTemplate": {
        "LaunchTemplateId": "lt-0738256e8ccdafc6d",
        "LaunchTemplateName": "eks-coco-nitro-template",
        "CreateTime": "2025-11-25T08:07:11+00:00",
        "CreatedBy": "arn:aws:sts::908774804544:assumed-role/AWSReservedSSO_AWSAdministratorAccess_e52b283d4a7e1129/sridhara_shastry",
        "DefaultVersionNumber": 1,
        "LatestVersionNumber": 1,
        "Operator": {
            "Managed": false
        }
    }
}
Template created and listing as below
----------------------------------------------------------------------------------------------------------------------------------------------
|                                                           DescribeLaunchTemplates                                                          |
+--------------------------------------------------------------------------------------------------------------------------------------------+
||                                                              LaunchTemplates                                                             ||
|+----------------------+-------------------------------------------------------------------------------------------------------------------+|
||  CreateTime          |  2025-11-25T08:07:11+00:00                                                                                        ||
||  CreatedBy           |  arn:aws:sts::908774804544:assumed-role/AWSReservedSSO_AWSAdministratorAccess_e52b283d4a7e1129/sridhara_shastry   ||
||  DefaultVersionNumber|  1                                                                                                                ||
||  LatestVersionNumber |  1                                                                                                                ||
||  LaunchTemplateId    |  lt-0738256e8ccdafc6d                                                                                             ||
||  LaunchTemplateName  |  eks-coco-nitro-template                                                                                          ||
|+----------------------+-------------------------------------------------------------------------------------------------------------------+|
|||                                                                Operator                                                                |||
||+--------------------------------------------------------------------------+-------------------------------------------------------------+||
|||  Managed                                                                 |  False                                                      |||
||+--------------------------------------------------------------------------+-------------------------------------------------------------+||
Confidential Containers.
===================================================

 1. Getting VPC ID, Subnet IDs and Node role ARN Done. ID:vpc-0110d769bec9f4e5c , subnet-024df4fc155c6310f,subnet-053252fef68e5f14d , arn:aws:iam::908774804544:role/eks-coco-nodegroup-role

 2. Creating Nodegroup eks-coco-nodegroup... Done.
Waiting for nodegroup to become active...
✅ Nodegroup is active and ready.
Confidential Containers.
===================================================
Adding port 30080 rule to security group sg-08f455853c4d24960...
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-0ee6a8ee8f8e87274",
            "GroupId": "sg-08f455853c4d24960",
            "GroupOwnerId": "908774804544",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 30080,
            "ToPort": 30080,
            "CidrIpv4": "0.0.0.0/0",
            "SecurityGroupRuleArn": "arn:aws:ec2:eu-west-1:908774804544:security-group-rule/sgr-0ee6a8ee8f8e87274"
        }
    ]
}
✓ Validated: Port 30080 rule exists in sg-08f455853c4d24960
NAME                                       STATUS   ROLES    AGE    VERSION
ip-10-1-1-205.eu-west-1.compute.internal   Ready    <none>   111s 



sridhara@ubuntu:~/Downloads/3-aws-scripts-eks-coco-linux/create$ 

#Install Nitro Enclaves Device Plugin on aws kubernetes 
        kubectl apply -f https://raw.githubusercontent.com/aws/aws-nitro-enclaves-k8s-device-plugin/main/aws-nitro-enclaves-k8s-ds.yaml
        kubectl get ns

#Label the node 
        kubectl get nodes
 
#Label the node by fetching name dynamically. 
        kubectl label node $(kubectl get nodes -o jsonpath='{.items[0].metadata.name}') aws-nitro-enclaves-k8s-dp=enabled

#Validate once labelled
        kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{" "}{.metadata.labels.aws-nitro-enclaves-k8s-dp}{"\n"}{end}'
namespace/nitro-enclaves created
daemonset.apps/aws-nitro-enclaves-k8s-daemonset created
NAME              STATUS   AGE
default           Active   7m21s
kube-node-lease   Active   7m21s
kube-public       Active   7m21s
kube-system       Active   7m21s
nitro-enclaves    Active   3s
NAME                                       STATUS   ROLES    AGE     VERSION
ip-10-1-1-205.eu-west-1.compute.internal   Ready    <none>   2m43s   v1.29.15-eks-113cf36
node/ip-10-1-1-205.eu-west-1.compute.internal labeled
ip-10-1-1-205.eu-west-1.compute.internal enabled
sridhara@ubuntu:~/Downloads/3-aws-scripts-eks-coco-linux/create$ 





sridhara@ubuntu:~/Downloads/3-aws-scripts-eks-coco-linux/create$ 
#Switch to create directory 
        cd /home/sridhara/Downloads/3-aws-scripts-eks-coco-linux/create
        ls -l file*.*




#Create namespace and switch
        kubectl create namespace integrations
        kubectl config set-context --current --namespace=integrations

 
-rwxrwx--x 1 sridhara sridhara 1340 Nov 15 21:06 file1-bastion-configure-aws-on-bastion.sh
-rwxrwx--x 1 sridhara sridhara 1310 Nov 15 21:06 file2-bastion-just-ssh-to-workernode.sh
-rwxrwx--x 1 sridhara sridhara 1941 Nov 15 21:06 file3-bastion-ssh-n-tfr-files-to-workernode.sh
-rwxrwx--x 1 sridhara sridhara  782 Nov 15 21:06 file4-nitro-install-docker-nitrocli.sh
-rwxrwx--x 1 sridhara sridhara 1219 Nov 15 21:06 file5-nitro-build-run-nginx.sh
-rw-rw-r-- 1 sridhara sridhara  885 Nov 19 11:08 file6-hello-deployment.yaml
-rw-rw-r-- 1 sridhara sridhara 1203 Nov 19 11:08 file6-nginx-deployment-v2.yaml
-rw-rw-r-- 1 sridhara sridhara 1581 Nov 19 11:08 file6-nginx-deployment-v3.yaml
-rw-rw-r-- 1 sridhara sridhara 1085 Nov 19 11:08 file6-nginx-deployment.yaml
-rw-rw-r-- 1 sridhara sridhara  240 Nov 19 11:08 file7-nginx-service.yaml
namespace/integrations created
Context "arn:aws:eks:eu-west-1:908774804544:cluster/eks-coco" modified.
sridhara@ubuntu:~/Downloads/3-aws-scripts-eks-coco-linux/create$ 



sridhara@ubuntu:~/Downloads/3-aws-scripts-eks-coco-linux/create$        
        #Create Deployment 
        cd /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s/container/versionednginx/v2/
        dos2unix *.yaml
        kubectl apply -f vsock-nginx-deployment.yaml 
        kubectl get pods
         
dos2unix: converting file vsock-nginx-deployment.yaml to Unix format...
deployment.apps/nginx-enclave-deployment created
NAME                                        READY   STATUS              RESTARTS   AGE
nginx-enclave-deployment-5cc6cfbd5d-t5gwt   0/1     ContainerCreating   0          2s
sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s/container/versionednginx/v2$ kubectl get pods
NAME                                        READY   STATUS    RESTARTS   AGE
nginx-enclave-deployment-5cc6cfbd5d-t5gwt   1/1     Running   0          19s
sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s/container/versionednginx/v2$ 





sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s/container/versionednginx/v2$ 

#Get logs 
kubectl get pods
kubectl logs $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | head -n 1)


#Describe pod 
kubectl describe pod $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | head -n 1)

 
NAME                                        READY   STATUS    RESTARTS   AGE
nginx-enclave-deployment-5cc6cfbd5d-t5gwt   1/1     Running   0          58s
Start allocating memory...
Started enclave with enclave-cid: 16, memory: 2048 MiB, cpu-ids: [1, 5]
{
  "EnclaveName": "nginx",
  "EnclaveID": "i-05a2bee49f88a0059-enc19aba13381b9ce2",
  "ProcessID": 8,
  "EnclaveCID": 16,
  "NumberOfCPUs": 2,
  "CPUIDs": [
    1,
    5
  ],
  "MemoryMiB": 2048
}
-------------------------------
Enclave ID is i-05a2bee49f88a0059-enc19aba13381b9ce2
-------------------------------
Enclave CID: 16
Starting VSOCK proxy for enclave CID: 16
VSOCK proxy started: TCP:80 -> VSOCK:16:5000
Waiting for nginx inside enclave to start. 30 Seconds Wait...
Nginx enclave with VSOCK proxy is ready!
Access via: curl http://localhost:80
Starting health check for enclave CID: 16
Tue Nov 25 08:14:10 UTC 2025: Enclave health check FAILED
Name:             nginx-enclave-deployment-5cc6cfbd5d-t5gwt
Namespace:        integrations
Priority:         0
Service Account:  default
Node:             ip-10-1-1-205.eu-west-1.compute.internal/10.1.1.205
Start Time:       Tue, 25 Nov 2025 08:13:22 +0000
Labels:           app=nginx-enclave
                  pod-template-hash=5cc6cfbd5d
Annotations:      <none>
Status:           Running
IP:               10.1.1.118
IPs:
  IP:           10.1.1.118
Controlled By:  ReplicaSet/nginx-enclave-deployment-5cc6cfbd5d
Containers:
  nginx-container:
    Container ID:   containerd://9d61c70de8f2300e5067ed2dbc10bc4606b98463ceb6f53aa43f6fe71e5b396f
    Image:          nerdysrisha/nginx-aws-nitro:latest
    Image ID:       docker.io/nerdysrisha/nginx-aws-nitro@sha256:92a7406d4ff2af05e0b319bc37a9d7109c19daba6c5e66ffb38912aa132b9752
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Tue, 25 Nov 2025 08:13:33 +0000
    Ready:          True
    Restart Count:  0
    Limits:
      aws.ec2.nitro/nitro_enclaves:  1
      cpu:                           1
      hugepages-2Mi:                 2Gi
      memory:                        2Gi
    Requests:
      aws.ec2.nitro/nitro_enclaves:  1
      cpu:                           1
      hugepages-2Mi:                 2Gi
      memory:                        2Gi
    Environment:                     <none>
    Mounts:
      /dev/hugepages from hugepage (rw)
      /dev/vsock from vsock-device (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-zvrbw (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       True 
  ContainersReady             True 
  PodScheduled                True 
Volumes:
  hugepage:
    Type:       EmptyDir (a temporary directory that shares a pods lifetime)
    Medium:     HugePages-2Mi
    SizeLimit:  <unset>
  vsock-device:
    Type:          HostPath (bare host directory volume)
    Path:          /dev/vsock
    HostPathType:  
  kube-api-access-zvrbw:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    Optional:                false
    DownwardAPI:             true
QoS Class:                   Guaranteed
Node-Selectors:              <none>
Tolerations:                 :NoSchedule op=Exists
                             :NoExecute op=Exists
                             aws.ec2.nitro/nitro_enclaves:NoSchedule op=Exists
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  68s   default-scheduler  Successfully assigned integrations/nginx-enclave-deployment-5cc6cfbd5d-t5gwt to ip-10-1-1-205.eu-west-1.compute.internal
  Normal  Pulling    69s   kubelet            Pulling image "nerdysrisha/nginx-aws-nitro:latest"
  Normal  Pulled     58s   kubelet            Successfully pulled image "nerdysrisha/nginx-aws-nitro:latest" in 10.098s (10.098s including waiting)
  Normal  Created    58s   kubelet            Created container: nginx-container
  Normal  Started    58s   kubelet            Started container nginx-container
sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s/container/versionednginx/v2$ 




sridhara@ubuntu:~/Downloads/aws-nitro-enclaves-with-k8s/container/versionednginx/v2$ 
#Access the pod and check enclaves
 
kubectl exec -it  $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | head -n 1) -- /bin/bash
bash-4.2# 
bash-4.2# nitro-cli describe-enclaves
[
  {
    "EnclaveName": "nginx",
    "EnclaveID": "i-05a2bee49f88a0059-enc19aba13381b9ce2",
    "ProcessID": 8,
    "EnclaveCID": 16,
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
      "PCR0": "45e96d1b8d9d8f646ede82d4b880feb15f78e2c230ae6ce85013a3961bbcc3e8e87ae7716ce0698578f3d9ca937334f6",
      "PCR1": "0343b056cd8485ca7890ddd833476d78460aed2aa161548e4e26bedf321726696257d623e8805f3f605946b3d8b0c6aa",
      "PCR2": "0a5a93a9e94a13868ba406f922a3363a02653b3607b6b66177b1b45b77eb56e6fad8a222295d53b636500ff7d902beee"
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
(2/29): cracklib-2.9.0-11.amzn2.0.2.x86_64.rpm                                                                                       |  80 kB  00:00:00     
(3/29): audit-libs-2.8.1-3.amzn2.1.x86_64.rpm                                                                                        |  99 kB  00:00:00     
(4/29): cryptsetup-libs-1.7.4-4.amzn2.x86_64.rpm                                                                                     | 224 kB  00:00:00     
(5/29): dbus-1.10.24-7.amzn2.0.4.x86_64.rpm                                                                                          | 246 kB  00:00:00     
(6/29): cracklib-dicts-2.9.0-11.amzn2.0.2.x86_64.rpm                                                                                 | 3.6 MB  00:00:00     
(7/29): dbus-libs-1.10.24-7.amzn2.0.4.x86_64.rpm                                                                                     | 167 kB  00:00:00     
(8/29): device-mapper-1.02.170-6.amzn2.5.x86_64.rpm                                                                                  | 297 kB  00:00:00     
(9/29): device-mapper-libs-1.02.170-6.amzn2.5.x86_64.rpm                                                                             | 326 kB  00:00:00     
(10/29): elfutils-default-yama-scope-0.176-2.amzn2.0.2.noarch.rpm                                                                    |  33 kB  00:00:00     
(11/29): gzip-1.5-10.amzn2.0.1.x86_64.rpm                                                                                            | 129 kB  00:00:00     
(12/29): elfutils-libs-0.176-2.amzn2.0.2.x86_64.rpm                                                                                  | 289 kB  00:00:00     
(13/29): kmod-25-3.amzn2.0.2.x86_64.rpm                                                                                              | 111 kB  00:00:00     
(14/29): kmod-libs-25-3.amzn2.0.2.x86_64.rpm                                                                                         |  59 kB  00:00:00     
(15/29): libcap-ng-0.7.5-4.amzn2.0.4.x86_64.rpm                                                                                      |  25 kB  00:00:00     
(16/29): libfdisk-2.30.2-2.amzn2.0.11.x86_64.rpm                                                                                     | 238 kB  00:00:00     
(17/29): libpwquality-1.2.3-5.amzn2.x86_64.rpm                                                                                       |  84 kB  00:00:00     
(18/29): libsemanage-2.5-11.amzn2.x86_64.rpm                                                                                         | 152 kB  00:00:00     
(19/29): libsmartcols-2.30.2-2.amzn2.0.11.x86_64.rpm                                                                                 | 155 kB  00:00:00     
(20/29): libutempter-1.1.6-4.amzn2.0.2.x86_64.rpm                                                                                    |  25 kB  00:00:00     
(21/29): pam-1.1.8-23.amzn2.0.5.x86_64.rpm                                                                                           | 717 kB  00:00:00     
(22/29): procps-ng-3.3.10-26.amzn2.x86_64.rpm                                                                                        | 292 kB  00:00:00     
(23/29): qrencode-libs-3.4.1-3.amzn2.0.2.x86_64.rpm                                                                                  |  50 kB  00:00:00     
(24/29): shadow-utils-4.1.5.1-24.amzn2.0.3.x86_64.rpm                                                                                | 1.1 MB  00:00:00     
(25/29): systemd-219-78.amzn2.0.24.x86_64.rpm                                                                                        | 5.0 MB  00:00:00     
(26/29): lz4-1.7.5-2.amzn2.0.2.x86_64.rpm                                                                                            |  98 kB  00:00:00     
(27/29): systemd-libs-219-78.amzn2.0.24.x86_64.rpm                                                                                   | 409 kB  00:00:00     
(28/29): ustr-1.0.4-16.amzn2.0.3.x86_64.rpm                                                                                          |  96 kB  00:00:00     
(29/29): util-linux-2.30.2-2.amzn2.0.11.x86_64.rpm                                                                                   | 2.3 MB  00:00:00     
------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                        44 MB/s |  16 MB  00:00:00     
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
bash-4.2# 







