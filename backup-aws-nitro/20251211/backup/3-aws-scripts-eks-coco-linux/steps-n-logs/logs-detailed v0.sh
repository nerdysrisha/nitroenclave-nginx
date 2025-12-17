


#Activities on the Bastion Host 

curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.3/2023-11-14/bin/linux/amd64/kubectl

[ec2-user@ip-10-1-1-86 ~]$ curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.3/2023-11-14/bin/linux/amd64/kubectl
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 47.5M  100 47.5M    0     0  14.6M      0  0:00:03  0:00:03 --:--:-- 14.6M
[ec2-user@ip-10-1-1-86 ~]$ ls -l
total 48704
-rw-rw-r-- 1 ec2-user ec2-user 49872896 Oct  2 17:26 kubectl
[ec2-user@ip-10-1-1-86 ~]$


#Make the kubectl executatble and also move it to proper location like /bin

[ec2-user@ip-10-1-1-86 ~]$ chmod +x ./kubectl && sudo mv ./kubectl /usr/local/bin
[ec2-user@ip-10-1-1-86 ~]$




#Configure AWS Credentials in Bastion. Obtain below values from Initial AWS access

export AWS_ACCESS_KEY_ID="ASIA5HFZTBRAOEMKNI66"
export AWS_SECRET_ACCESS_KEY="sOH4BT4iSphoBuCWYJq14d5zXPoJP5rBU8s9Ezul"
export AWS_SESSION_TOKEN="IQoJb3JpZ2luX2VjEJr//////////wEaCWV1LXdlc3QtMSJHMEUCIQDlZ+UcfhzsiYeYaVqkdkqN5R7ditpRilTlaqeVx80kPgIgG81NWfrNTQMjwU1Ah5IZa/aaO1Xm0lS+qbGVYBQVX7Aq/QIIMxAAGgw5MDg3NzQ4MDQ1NDQiDOLNozm0OGyzV5LurCraAg4ozGdfQwhxHoUVt4iq8s6bZaE5jsmFlnOeB1/3ObznXWso3cD860RiQXpCNuqXwALTJlwp/Winr7DUzLEo2AEFOYD0wcBgblK7OMi4QNuZJi4CL5SYHhALt1UA/U4AkLFMq/JXpbWJfFa400SwoT94oFx7gMkG/oR8c4gb2ivAfT9aUTpTFBzx2BKiaR4hg1diKzOzW/gUMZNZJMxUUfXqML9yKDoolc2G/prys5+t14umstgzeXN5yrBF4ax5a8COho/f4A5tfSvI7F/d+Grx/lxN/8cojuz/lS17YS7mmiK3X8GRXZTVqkTScrMCW5cRpvZbcaYcH+AshnrlUcdIXPrwUcqnK18aMqxtjxT3MOvQcxJe5/q676tHvQNN922qita6KYCH36B8+wZKItkL0Ex9KMfhjQ2UOPLDdwLeAS+l55Fy84fmkhrNU03hz+QAXdQYzil2pN0w2u36xgY6pwF6kEg5X3YkP8/cTzhm5I5BdWQkMzDwSE0Gptqwtb8XVKPgE0Mke0tLrnZ//DiDSrBO9lcgp3opX7kzPT047h46ghnhnoJ1NC5AUob/ymlaKtcuJSjbqG+XG66baQ/h56ojgmBDYEfSOqNjb6oN3d9v8y9QGI5nMxryDn2iG2Bven/+KM9PFJZOiEDe8tfTV4l3vU3po6tmYpxZi/OrA9ANeEyaa2xWMA=="


#Run below command 

aws configure

 [ec2-user@ip-10-1-1-86 ~]$ aws configure
AWS Access Key ID [None]: ASIA5HFZTBRAOEMKNI66
AWS Secret Access Key [None]: sOH4BT4iSphoBuCWYJq14d5zXPoJP5rBU8s9Ezul
Default region name [None]: eu-west-1
Default output format [None]: json
[ec2-user@ip-10-1-1-86 ~]$


#Add the token to the session 

 


[ec2-user@ip-10-1-1-86 ~]$ aws configure set aws_session_token "IQoJb3JpZ2luX2VjEJr//////////wEaCWV1LXdlc3QtMSJHMEUCIQDlZ+UcfhzsiYeYaVqkdkqN5R7ditpRilTlaqeVx80kPgIgG81NWfrNTQMjwU1Ah5IZa/aaO1Xm0lS+qbGVYBQVX7Aq/QIIMxAAGgw5MDg3NzQ4MDQ1NDQiDOLNozm0OGyzV5LurCraAg4ozGdfQwhxHoUVt4iq8s6bZaE5jsmFlnOeB1/3ObznXWso3cD860RiQXpCNuqXwALTJlwp/Winr7DUzLEo2AEFOYD0wcBgblK7OMi4QNuZJi4CL5SYHhALt1UA/U4AkLFMq/JXpbWJfFa400SwoT94oFx7gMkG/oR8c4gb2ivAfT9aUTpTFBzx2BKiaR4hg1diKzOzW/gUMZNZJMxUUfXqML9yKDoolc2G/prys5+t14umstgzeXN5yrBF4ax5a8COho/f4A5tfSvI7F/d+Grx/lxN/8cojuz/lS17YS7mmiK3X8GRXZTVqkTScrMCW5cRpvZbcaYcH+AshnrlUcdIXPrwUcqnK18aMqxtjxT3MOvQcxJe5/q676tHvQNN922qita6KYCH36B8+wZKItkL0Ex9KMfhjQ2UOPLDdwLeAS+l55Fy84fmkhrNU03hz+QAXdQYzil2pN0w2u36xgY6pwF6kEg5X3YkP8/cTzhm5I5BdWQkMzDwSE0Gptqwtb8XVKPgE0Mke0tLrnZ//DiDSrBO9lcgp3opX7kzPT047h46ghnhnoJ1NC5AUob/ymlaKtcuJSjbqG+XG66baQ/h56ojgmBDYEfSOqNjb6oN3d9v8y9QGI5nMxryDn2iG2Bven/+KM9PFJZOiEDe8tfTV4l3vU3po6tmYpxZi/OrA9ANeEyaa2xWMA=="
[ec2-user@ip-10-1-1-86 ~]$





#Test the access 

[ec2-user@ip-10-1-1-86 ~]$ aws sts get-caller-identity
{
    "Account": "908774804544",
    "UserId": "AROA5HFZTBRAFB6S6RNKI:sridhara_shastry",
    "Arn": "arn:aws:sts::908774804544:assumed-role/AWSReservedSSO_AWSAdministratorAccess_e52b283d4a7e1129/sridhara_shastry"
}
[ec2-user@ip-10-1-1-86 ~]$






#Configure cluster 


[ec2-user@ip-10-1-1-86 ~]$ aws eks update-kubeconfig --region eu-west-1 --name eks-coco
Added new context arn:aws:eks:eu-west-1:908774804544:cluster/eks-coco to /home/ec2-user/.kube/config
[ec2-user@ip-10-1-1-86 ~]$



#Fetch nodes. This may result in failure. Like below. Cat the config to see the version 

[ec2-user@ip-10-1-1-86 ~]$ kubectl get nodes
error: exec plugin: invalid apiVersion "client.authentication.k8s.io/v1alpha1"
[ec2-user@ip-10-1-1-86 ~]$ cat ~/.kube/config
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJVXdTbnVMWjRhVzB3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TlRFd01ESXhNRFF6TURGYUZ3MHpOVEE1TXpBeE1EUTRNREZhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUUNiRXMyMXdhZzF5U3AzbVhBbXJERHAvbVJaRXhjMHR4YWtUUkRDdFJvZTNuc2krNklTd09kejZTOVAKcFRCaExRTllWVnB5UWZpRHRqNEo3Wk9XV1VqL0dIb1YzS2hqTVhET3VKSHR0YWJCWXhMaFN5N1VjVGIyQTJJOAo3bDN0OEliT1crUVJ1NEtpSzZBSysxWTdIcXhwRGxQc09YekFhbm1mZ3ZUZmxTUWRoY0lKV1JJWkhRa0tETWNZCjJCRmpNUEsralAwYjQyMWgrKzJ1c1psK0NwcnpnaHVZTFhydXNQSTN5ZzAwWlpuZUdWeThjMHFWOWloYldlNEcKREhXNDZ2V29oNUtvdmdkYmZKTUUyR0w4NG5lL2h1UjQyMjJBQ0x3endObHN4aTB0U0dLQ2V3ZDUzOENPcHJBdQoySGdxY3B5RzZRTWJVcGRjR3gxdUE4NjR5cHc3QWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJUYnk1VnpyaWZPcHNTM3VjZ0ZhdWQvYmZBWWlUQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQVBmYnJiMGZHbApSNERWa3ovcTBiWWorSThPTDdES0J1ZjN1b1lYcThZeUdQeXROaGFGQ3RRRHM5eS91aXJMbWo5aW9kZ0pqbHFoCmxReDJCd2F5V2FOazhxdytoL2p2Yk1KVUp0M1IzcDFOcE5Zb3c0aGNlcUoxQ0toOXE2YnFYSklvUDhBZSttVnUKQTJ6ZXZ4U0pzZGtMVkZZZ3BYdzFZUHBSRUhuYjcxWEtQNkw2M25TMWZxeFRyaUZQZ3JLNVl4VklkdnJBSlRZcQpGa2FvSHhGL1krNnk1cFNoV1AxY0FSeDcxTGxhY01PMUJ4RStEL09nM01IdVlHbXZoOVlQS0hsTGdjMUpkZ2lNCnBOMlppTUJJelNTVFlpMXFuNUtSbk0ybmsvMU9hUTR5QlBlV01abUd4OHdTaDU0QlFuQ1FLTGZGL08ybERVMk0KTC9xaFRnNnNxYkI2Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
    server: https://02F11FF88705BDC88020F03D64CD622B.gr7.eu-west-1.eks.amazonaws.com
  name: arn:aws:eks:eu-west-1:908774804544:cluster/eks-coco
contexts:
- context:
    cluster: arn:aws:eks:eu-west-1:908774804544:cluster/eks-coco
    user: arn:aws:eks:eu-west-1:908774804544:cluster/eks-coco
  name: arn:aws:eks:eu-west-1:908774804544:cluster/eks-coco
- context:
    cluster: arn:aws:eks:eu-west-1:908774804544:cluster/eks-coco
    user: arn:aws:eks:eu-west-1:908774804544:cluster/eks-coco
  name: eks-coco
current-context: eks-coco
kind: Config
preferences: {}
users:
- name: arn:aws:eks:eu-west-1:908774804544:cluster/eks-coco
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      args:
      - --region
      - eu-west-1
      - eks
      - get-token
      - --cluster-name
      - eks-coco
      command: aws
[ec2-user@ip-10-1-1-86 ~]$



#Change the version of 'user.exec.apiversion' as below. from v1alpha1 to v1beta1

[ec2-user@ip-10-1-1-86 ~]$ sed -i 's/client.authentication.k8s.io\/v1alpha1/client.authentication.k8s.io\/v1beta1/g' ~/.kube/config
[ec2-user@ip-10-1-1-86 ~]$
[ec2-user@ip-10-1-1-86 ~]$ cat ~/.kube/config
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJVXdTbnVMWjRhVzB3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TlRFd01ESXhNRFF6TURGYUZ3MHpOVEE1TXpBeE1EUTRNREZhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUUNiRXMyMXdhZzF5U3AzbVhBbXJERHAvbVJaRXhjMHR4YWtUUkRDdFJvZTNuc2krNklTd09kejZTOVAKcFRCaExRTllWVnB5UWZpRHRqNEo3Wk9XV1VqL0dIb1YzS2hqTVhET3VKSHR0YWJCWXhMaFN5N1VjVGIyQTJJOAo3bDN0OEliT1crUVJ1NEtpSzZBSysxWTdIcXhwRGxQc09YekFhbm1mZ3ZUZmxTUWRoY0lKV1JJWkhRa0tETWNZCjJCRmpNUEsralAwYjQyMWgrKzJ1c1psK0NwcnpnaHVZTFhydXNQSTN5ZzAwWlpuZUdWeThjMHFWOWloYldlNEcKREhXNDZ2V29oNUtvdmdkYmZKTUUyR0w4NG5lL2h1UjQyMjJBQ0x3endObHN4aTB0U0dLQ2V3ZDUzOENPcHJBdQoySGdxY3B5RzZRTWJVcGRjR3gxdUE4NjR5cHc3QWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJUYnk1VnpyaWZPcHNTM3VjZ0ZhdWQvYmZBWWlUQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQVBmYnJiMGZHbApSNERWa3ovcTBiWWorSThPTDdES0J1ZjN1b1lYcThZeUdQeXROaGFGQ3RRRHM5eS91aXJMbWo5aW9kZ0pqbHFoCmxReDJCd2F5V2FOazhxdytoL2p2Yk1KVUp0M1IzcDFOcE5Zb3c0aGNlcUoxQ0toOXE2YnFYSklvUDhBZSttVnUKQTJ6ZXZ4U0pzZGtMVkZZZ3BYdzFZUHBSRUhuYjcxWEtQNkw2M25TMWZxeFRyaUZQZ3JLNVl4VklkdnJBSlRZcQpGa2FvSHhGL1krNnk1cFNoV1AxY0FSeDcxTGxhY01PMUJ4RStEL09nM01IdVlHbXZoOVlQS0hsTGdjMUpkZ2lNCnBOMlppTUJJelNTVFlpMXFuNUtSbk0ybmsvMU9hUTR5QlBlV01abUd4OHdTaDU0QlFuQ1FLTGZGL08ybERVMk0KTC9xaFRnNnNxYkI2Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
    server: https://02F11FF88705BDC88020F03D64CD622B.gr7.eu-west-1.eks.amazonaws.com
  name: arn:aws:eks:eu-west-1:908774804544:cluster/eks-coco
contexts:
- context:
    cluster: arn:aws:eks:eu-west-1:908774804544:cluster/eks-coco
    user: arn:aws:eks:eu-west-1:908774804544:cluster/eks-coco
  name: arn:aws:eks:eu-west-1:908774804544:cluster/eks-coco
- context:
    cluster: arn:aws:eks:eu-west-1:908774804544:cluster/eks-coco
    user: arn:aws:eks:eu-west-1:908774804544:cluster/eks-coco
  name: eks-coco
current-context: eks-coco
kind: Config
preferences: {}
users:
- name: arn:aws:eks:eu-west-1:908774804544:cluster/eks-coco
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - --region
      - eu-west-1
      - eks
      - get-token
      - --cluster-name
      - eks-coco
      command: aws
[ec2-user@ip-10-1-1-86 ~]$




#Regenerating the kubeconfig as kubectl get nodes failed 

[ec2-user@ip-10-1-1-86 ~]$ kubectl version --client
Client Version: v1.28.3-eks-e71965b
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
[ec2-user@ip-10-1-1-86 ~]$ # Backup current config
[ec2-user@ip-10-1-1-86 ~]$ cp ~/.kube/config ~/.kube/config.backup
[ec2-user@ip-10-1-1-86 ~]$ # Regenerate kubeconfig (replace with your actual cluster name)
[ec2-user@ip-10-1-1-86 ~]$ aws eks update-kubeconfig --region eu-west-1 --name eks-coco
Updated context arn:aws:eks:eu-west-1:908774804544:cluster/eks-coco in /home/ec2-user/.kube/config
[ec2-user@ip-10-1-1-86 ~]$


#Again check the nodes and see the error

[ec2-user@ip-10-1-1-86 ~]$ kubectl get nodes
error: exec plugin: invalid apiVersion "client.authentication.k8s.io/v1alpha1"
[ec2-user@ip-10-1-1-86 ~]$




###############################approach 2 exploring ########### Using SSH from bastion 


# From your local machine
#Syntax:  scp -i your-bastion-key.pem your-worker-key.pem ec2-user@<bastion-public-ip>:~/

scp -i coco-eks-key.pem   coco-eks-key.pem ec2-user@3.249.239.65:~/


$ scp -i coco-eks-key.pem   coco-eks-key.pem ec2-user@3.249.239.65:~/
coco-eks-key.pem                                                                      100% 1706    17.0KB/s   00:00

sridhara@poc-laptop-01 MINGW64 /c/ws/cocopoc/3-aws-scripts-eks-coco/create
$


#Check if it is copied to bastion 

[ec2-user@ip-10-1-1-86 ~]$ ls -l
total 4
-r--r--r-- 1 ec2-user ec2-user 1706 Oct  2 17:55 coco-eks-key.pem
[ec2-user@ip-10-1-1-86 ~]$
[ec2-user@ip-10-1-1-86 ~]$


#Change the permissions 

[ec2-user@ip-10-1-1-86 ~]$ chmod 400 coco-eks-key.pem
[ec2-user@ip-10-1-1-86 ~]$
[ec2-user@ip-10-1-1-86 ~]$ ls -l
total 4
-r-------- 1 ec2-user ec2-user 1706 Oct  2 17:55 coco-eks-key.pem
[ec2-user@ip-10-1-1-86 ~]$


#Get the IP of worker node. From Host machine. Important 



sridhara@poc-laptop-01 MINGW64 /c/ws/cocopoc/3-aws-scripts-eks-coco/create
$ kubectl get nodes -o wide
NAME                                      STATUS   ROLES    AGE   VERSION                INTERNAL-IP   EXTERNAL-IP     OS-IMAGE         KERNEL-VERSION                  CONTAINER-RUNTIME
ip-10-1-1-19.eu-west-1.compute.internal   Ready    <none>   66m   v1.29.15-eks-113cf36   10.1.1.19     54.78.222.108   Amazon Linux 2   5.10.242-239.961.amzn2.x86_64   containerd://1.7.27

sridhara@poc-laptop-01 MINGW64 /c/ws/cocopoc/3-aws-scripts-eks-coco/create
$



#Check the security group and its setting on host machine. 

$ # First, let's see what security groups are attached to this worker node
aws ec2 describe-instances --filters "Name=private-ip-address,Values=10.1.1.19" --query 'Reservations[*].Instances[*].SecurityGroups[*].GroupId' --output table --region eu-west-1
--------------------------
|    DescribeInstances   |
+------------------------+
|  sg-0be89234f52456550  |
+------------------------+


sridhara@poc-laptop-01 MINGW64 /c/ws/cocopoc/3-aws-scripts-eks-coco/create
$

#Check port allowing 

$ aws ec2 describe-security-groups --group-ids sg-0be89234f52456550 --region eu-west-1 --query 'SecurityGroups[*].IpPermissions[?FromPort==`22`]'
[
    []
]

#That's the problem! ABOVE.  The security group has NO SSH rules at all.
#Let's get your bastion's security group ID first:
#Run this on the BASTION HOST 

[ec2-user@ip-10-1-1-86 ~]$ # Get your current instance's security group (assuming you're on the bastion)


[ec2-user@ip-10-1-1-86 ~]$ curl -s http://169.254.169.254/latest/meta-data/instance-id | xargs -I {} aws ec2 describe-instances --instance-ids {} --region eu-west-1 --query 'Reservations[*].Instances[*].SecurityGroups[*].GroupId' --output text
sg-03843ec28e98e7300
[ec2-user@ip-10-1-1-86 ~]$


#Execute this on the BASTION HOST. 

[ec2-user@ip-10-1-1-86 ~]$ aws ec2 authorize-security-group-ingress --group-id sg-0be89234f52456550 --protocol tcp --port 22 --source-group sg-03843ec28e98e7300 --region eu-west-1
[ec2-user@ip-10-1-1-86 ~]$


#Verify the addition on the BASTION HOST 

[ec2-user@ip-10-1-1-86 ~]$ aws ec2 describe-security-groups --group-ids sg-0be89234f52456550 --region eu-west-1 --query 'SecurityGroups[*].IpPermissions[?FromPort==`22`]'
[
    [
        {
            "PrefixListIds": [],
            "FromPort": 22,
            "IpRanges": [],
            "ToPort": 22,
            "IpProtocol": "tcp",
            "UserIdGroupPairs": [
                {
                    "UserId": "908774804544",
                    "GroupId": "sg-03843ec28e98e7300"
                }
            ],
            "Ipv6Ranges": []
        }
    ]
]
[ec2-user@ip-10-1-1-86 ~]$



#Connect to the worker node. 

[ec2-user@ip-10-1-1-86 ~]$ ssh -i coco-eks-key.pem ec2-user@10.1.1.19
The authenticity of host '10.1.1.19 (10.1.1.19)' can't be established.
ECDSA key fingerprint is SHA256:5ofXTmbSwLEXAm4vSGIuzNLl3FSFB+FvnEJWb1Qbv+0.
ECDSA key fingerprint is MD5:f2:d8:96:fc:c3:a1:33:27:78:e6:ff:1c:aa:0f:56:2d.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '10.1.1.19' (ECDSA) to the list of known hosts.
Last login: Sat Sep 20 02:24:56 2025 from 15.221.164.189
   ,     #_
   ~\_  ####_        Amazon Linux 2
  ~~  \_#####\
  ~~     \###|       AL2 End of Life is 2026-06-30.
  ~~       \#/ ___
   ~~       V~' '->
    ~~~         /    A newer version of Amazon Linux is available!
      ~~._.   _/
         _/ _/       Amazon Linux 2023, GA and supported until 2028-03-15.
       _/m/'           https://aws.amazon.com/linux/amazon-linux-2023/

2 package(s) needed for security, out of 2 available
Run "sudo yum update" to apply all updates.
[ec2-user@ip-10-1-1-19 ~]$





#NOW WE ARE INSIDE THE WORKER NODE --- REMEMBER 
 


 

#Notice it is NOT installed. The issue is that the standard Amazon Linux 2 EKS AMI doesn't include Nitro Enclaves support by default. We need to either:
#Install Nitro Enclaves on this node, or
#Use a custom AMI with Nitro Enclaves pre-installed


#Check the linux version 

		[ec2-user@ip-10-1-1-19 ~]$ cat /etc/os-release
		NAME="Amazon Linux"
		VERSION="2"
		ID="amzn"
		ID_LIKE="centos rhel fedora"
		VERSION_ID="2"
		PRETTY_NAME="Amazon Linux 2"
		ANSI_COLOR="0;33"
		CPE_NAME="cpe:2.3:o:amazon:amazon_linux:2"
		HOME_URL="https://amazonlinux.com/"
		SUPPORT_END="2026-06-30"
		[ec2-user@ip-10-1-1-19 ~]$
 
#Install docker 

		[ec2-user@ip-10-1-1-19 aws-nitro-enclaves-cli]$ sudo yum install -y docker
		Loaded plugins: priorities, update-motd, versionlock
		amzn2-core                                                                                                               | 3.6 kB  00:00:00
		Package docker-25.0.8-1.amzn2.0.6.x86_64 already installed and latest version
		Nothing to do
		[ec2-user@ip-10-1-1-19 aws-nitro-enclaves-cli]$ sudo systemctl start docker
		[ec2-user@ip-10-1-1-19 aws-nitro-enclaves-cli]$ sudo systemctl enable docker
		Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.
		[ec2-user@ip-10-1-1-19 aws-nitro-enclaves-cli]$ sudo usermod -a -G docker $USER
		[ec2-user@ip-10-1-1-19 aws-nitro-enclaves-cli]$ newgrp docker
		[ec2-user@ip-10-1-1-19 aws-nitro-enclaves-cli]$


#Check docker commands 

		[ec2-user@ip-10-1-1-19 aws-nitro-enclaves-cli]$ docker ps
		CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
		[ec2-user@ip-10-1-1-19 aws-nitro-enclaves-cli]$
		[ec2-user@ip-10-1-1-19 aws-nitro-enclaves-cli]$ docker images
		REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
		[ec2-user@ip-10-1-1-19 aws-nitro-enclaves-cli]$
		[ec2-user@ip-10-1-1-19 aws-nitro-enclaves-cli]$ docker container ls
		CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
		[ec2-user@ip-10-1-1-19 aws-nitro-enclaves-cli]$



		 
#THIS LINE ADDED ON SECOND DAY INSTALLATION OF NITROENCLAVES. NOTICE THE IP CHANGE FOR REFERENCE. 


			#Enable nitro cli packages if not. sometime install doest not work directly 

			[ec2-user@ip-10-1-2-77 ~]$ # Check if the repository is still enabled
			[ec2-user@ip-10-1-2-77 ~]$ sudo amazon-linux-extras list | grep nitro
			 47  aws-nitro-enclaves-cli   available    [ =stable ]
			[ec2-user@ip-10-1-2-77 ~]$ sudo amazon-linux-extras enable aws-nitro-enclaves-cli
			  2  httpd_modules                  available    [ =1.0  =stable ]
			  3  memcached1.5                   available    \
					[ =1.5.1  =1.5.16  =1.5.17 ]
			  9  R3.4                           available    [ =3.4.3  =stable ]
			 18  libreoffice                    available    \
					[ =5.0.6.2_15  =5.3.6.1  =stable ]
			 19  gimp                           available    [ =2.8.22 ]
			 20  docker=latest                  enabled      \
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
			  _  kernel-5.4                     available    [ =stable ]
			 50  selinux-ng                     available    [ =stable ]
			 52  tomcat9                        available    [ =stable ]
			 55  kernel-5.10=latest             enabled      [ =stable ]
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

			Now you can install:
			 # yum clean metadata
			 # yum install aws-nitro-enclaves-cli
			[ec2-user@ip-10-1-2-77 ~]$



		 




#INSTALL THE NITRO-ENCLAVES-CLI #############################################################



		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ sudo yum install -y aws-nitro-enclaves-cli
		Loaded plugins: priorities, update-motd, versionlock
		Resolving Dependencies
		--> Running transaction check
		---> Package aws-nitro-enclaves-cli.x86_64 0:1.4.2-0.amzn2 will be installed
		--> Finished Dependency Resolution

		Dependencies Resolved

		================================================================================================================================================
		 Package                              Arch                 Version                        Repository                                       Size
		================================================================================================================================================
		Installing:
		 aws-nitro-enclaves-cli               x86_64               1.4.2-0.amzn2                  amzn2extra-aws-nitro-enclaves-cli               6.0 M

		Transaction Summary
		================================================================================================================================================
		Install  1 Package

		Total download size: 6.0 M
		Installed size: 19 M
		Downloading packages:
		aws-nitro-enclaves-cli-1.4.2-0.amzn2.x86_64.rpm                                                                          | 6.0 MB  00:00:00
		Running transaction check
		Running transaction test
		Transaction test succeeded
		Running transaction
		  Installing : aws-nitro-enclaves-cli-1.4.2-0.amzn2.x86_64                                                                                  1/1

			* In order to successfully run Nitro Enclaves, please add your user to group 'ne'

			* Before being able to run enclaves, the system administrator must reserve the required
			  resources (i.e. CPUs and memory). Edit the allocator configuration file at
			  /etc/nitro_enclaves/allocator.yaml and then start the allocator oneshot service:

				sudo systemctl start nitro-enclaves-allocator.service

			  Resource allocation can be performed at system boot (recommended), by enabling
			  the allocator service:

				sudo systemctl enable nitro-enclaves-allocator.service

		  Verifying  : aws-nitro-enclaves-cli-1.4.2-0.amzn2.x86_64                                                                                  1/1

		Installed:
		  aws-nitro-enclaves-cli.x86_64 0:1.4.2-0.amzn2

		Complete!





		 
#THIS LINE ADDED ON SECOND DAY INSTALLATION OF NITROENCLAVES. NOTICE THE IP CHANGE FOR REFERENCE. 

			[ec2-user@ip-10-1-2-77 ~]$ sudo yum install -y aws-nitro-enclaves-cli aws-nitro-enclaves-cli-devel
			Loaded plugins: priorities, update-motd, versionlock
			amzn2-core                                                                                       | 3.6 kB  00:00:00
			amzn2extra-aws-nitro-enclaves-cli                                                                | 2.9 kB  00:00:00
			amzn2extra-docker                                                                                | 2.9 kB  00:00:00
			amzn2extra-kernel-5.10                                                                           | 3.0 kB  00:00:00
			(1/2): amzn2extra-aws-nitro-enclaves-cli/2/x86_64/updateinfo                                     |  25 kB  00:00:00
			(2/2): amzn2extra-aws-nitro-enclaves-cli/2/x86_64/primary_db                                     | 158 kB  00:00:00
			Resolving Dependencies
			--> Running transaction check
			---> Package aws-nitro-enclaves-cli.x86_64 0:1.4.2-0.amzn2 will be installed
			---> Package aws-nitro-enclaves-cli-devel.x86_64 0:1.4.2-0.amzn2 will be installed
			--> Finished Dependency Resolution

			Dependencies Resolved

			========================================================================================================================
			 Package                             Arch          Version               Repository                                Size
			========================================================================================================================
			Installing:
			 aws-nitro-enclaves-cli              x86_64        1.4.2-0.amzn2         amzn2extra-aws-nitro-enclaves-cli        6.0 M
			 aws-nitro-enclaves-cli-devel        x86_64        1.4.2-0.amzn2         amzn2extra-aws-nitro-enclaves-cli         15 M

			Transaction Summary
			========================================================================================================================
			Install  2 Packages

			Total download size: 21 M
			Installed size: 68 M
			Downloading packages:
			(1/2): aws-nitro-enclaves-cli-1.4.2-0.amzn2.x86_64.rpm                                           | 6.0 MB  00:00:00
			(2/2): aws-nitro-enclaves-cli-devel-1.4.2-0.amzn2.x86_64.rpm                                     |  15 MB  00:00:00
			------------------------------------------------------------------------------------------------------------------------
			Total                                                                                    81 MB/s |  21 MB  00:00:00
			Running transaction check
			Running transaction test
			Transaction test succeeded
			Running transaction
			  Installing : aws-nitro-enclaves-cli-devel-1.4.2-0.amzn2.x86_64                                                    1/2
			  Installing : aws-nitro-enclaves-cli-1.4.2-0.amzn2.x86_64                                                          2/2

				* In order to successfully run Nitro Enclaves, please add your user to group 'ne'

				* Before being able to run enclaves, the system administrator must reserve the required
				  resources (i.e. CPUs and memory). Edit the allocator configuration file at
				  /etc/nitro_enclaves/allocator.yaml and then start the allocator oneshot service:

					sudo systemctl start nitro-enclaves-allocator.service

				  Resource allocation can be performed at system boot (recommended), by enabling
				  the allocator service:

					sudo systemctl enable nitro-enclaves-allocator.service

			  Verifying  : aws-nitro-enclaves-cli-1.4.2-0.amzn2.x86_64                                                          1/2
			  Verifying  : aws-nitro-enclaves-cli-devel-1.4.2-0.amzn2.x86_64                                                    2/2

			Installed:
			  aws-nitro-enclaves-cli.x86_64 0:1.4.2-0.amzn2           aws-nitro-enclaves-cli-devel.x86_64 0:1.4.2-0.amzn2

			Complete!
			[ec2-user@ip-10-1-2-77 ~]$








#Start allocator 



		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ sudo systemctl start nitro-enclaves-allocator



#enable nitro enclaves allocator  


		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ sudo systemctl enable nitro-enclaves-allocator
		Created symlink from /etc/systemd/system/multi-user.target.wants/nitro-enclaves-allocator.service to /usr/lib/systemd/system/nitro-enclaves-allocator.service.
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$


###Let us follow the instructions given in the logs 

		# First, add your user to the 'ne' group
		sudo usermod -a -G ne ec2-user

		# Check the allocator configuration
		cat /etc/nitro_enclaves/allocator.yaml

		# Start and enable the allocator service (as you mentioned you'll run)
		sudo systemctl start nitro-enclaves-allocator.service
		sudo systemctl enable nitro-enclaves-allocator.service

		# After starting the services, you'll need to log out and back in 
		# for the group membership to take effect, OR run:
		newgrp ne


######Above commands are executed and logs - START


		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ sudo usermod -a -G ne ec2-user
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ cat /etc/nitro_enclaves/allocator.yaml
		---
		# Enclave configuration file.
		#
		# How much memory to allocate for enclaves (in MiB).
		memory_mib: 512
		#
		# How many CPUs to reserve for enclaves.
		cpu_count: 2
		#
		# Alternatively, the exact CPUs to be reserved for the enclave can be explicitly
		# configured by using `cpu_pool` (like below), instead of `cpu_count`.
		# Note: cpu_count and cpu_pool conflict with each other. Only use exactly one of them.
		# Example of reserving CPUs 2, 3, and 6 through 9:
		# cpu_pool: 2,3,6-9
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ sudo systemctl start nitro-enclaves-allocator.service
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ sudo systemctl enable nitro-enclaves-allocator.service
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ newgrp ne
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$



######Above commands are executed and logs - END


		# Check the allocator configuration file
		cat /etc/nitro_enclaves/allocator.yaml

		# Check if the allocator service is running properly
		sudo systemctl status nitro-enclaves-allocator

		# Apply the group membership without logging out
		newgrp ne


######Above commands are executed and logs - START

		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ cat /etc/nitro_enclaves/allocator.yaml
		---
		# Enclave configuration file.
		#
		# How much memory to allocate for enclaves (in MiB).
		memory_mib: 512
		#
		# How many CPUs to reserve for enclaves.
		cpu_count: 2
		#
		# Alternatively, the exact CPUs to be reserved for the enclave can be explicitly
		# configured by using `cpu_pool` (like below), instead of `cpu_count`.
		# Note: cpu_count and cpu_pool conflict with each other. Only use exactly one of them.
		# Example of reserving CPUs 2, 3, and 6 through 9:
		# cpu_pool: 2,3,6-9
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ sudo systemctl status nitro-enclaves-allocator
		● nitro-enclaves-allocator.service - Nitro Enclaves Resource Allocator
		   Loaded: loaded (/usr/lib/systemd/system/nitro-enclaves-allocator.service; enabled; vendor preset: disabled)
		   Active: active (exited) since Thu 2025-10-02 18:57:48 UTC; 4min 17s ago
		 Main PID: 74228 (code=exited, status=0/SUCCESS)

		Oct 02 18:57:48 ip-10-1-1-19.eu-west-1.compute.internal nitro-enclaves-allocator[74228]: Auto-generating the enclave CPU pool by using the......
		Oct 02 18:57:48 ip-10-1-1-19.eu-west-1.compute.internal nitro-enclaves-allocator[74228]: Will try to reserve 512 MB of memory on node 0.
		Oct 02 18:57:48 ip-10-1-1-19.eu-west-1.compute.internal nitro-enclaves-allocator[74228]: Configuring the huge page memory...
		Oct 02 18:57:48 ip-10-1-1-19.eu-west-1.compute.internal nitro-enclaves-allocator[74228]: - Reserved 256 pages of type: 2048kB.
		Oct 02 18:57:48 ip-10-1-1-19.eu-west-1.compute.internal nitro-enclaves-allocator[74228]: Done.
		Oct 02 18:57:48 ip-10-1-1-19.eu-west-1.compute.internal nitro-enclaves-allocator[74228]: Auto-generated the enclave CPU pool: 1,3.
		Oct 02 18:57:48 ip-10-1-1-19.eu-west-1.compute.internal nitro-enclaves-allocator[74228]: Configuring the enclave CPU pool...
		Oct 02 18:57:48 ip-10-1-1-19.eu-west-1.compute.internal nitro-enclaves-allocator[74228]: Done.
		Oct 02 18:57:48 ip-10-1-1-19.eu-west-1.compute.internal nitro-enclaves-allocator[74228]: Successfully allocated Nitro Enclaves resources: ...PUs
		Oct 02 18:57:48 ip-10-1-1-19.eu-west-1.compute.internal systemd[1]: Started Nitro Enclaves Resource Allocator.
		Hint: Some lines were ellipsized, use -l to show in full.
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ newgrp ne
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$

######Above commands are executed and logs - END


		# Install the devel package which should contain the kernel blobs
		sudo yum install -y aws-nitro-enclaves-cli-devel

		# Check if blobs directory exists now
		ls -la /usr/share/nitro_enclaves/blobs/

 
######Above commands are executed and logs - START

		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ sudo yum install -y aws-nitro-enclaves-cli-devel
		Loaded plugins: priorities, update-motd, versionlock
		amzn2-core                                                                                                               | 3.6 kB  00:00:00
		Resolving Dependencies
		--> Running transaction check
		---> Package aws-nitro-enclaves-cli-devel.x86_64 0:1.4.2-0.amzn2 will be installed
		--> Finished Dependency Resolution

		Dependencies Resolved

		================================================================================================================================================
		 Package                                   Arch                Version                     Repository                                      Size
		================================================================================================================================================
		Installing:
		 aws-nitro-enclaves-cli-devel              x86_64              1.4.2-0.amzn2               amzn2extra-aws-nitro-enclaves-cli               15 M

		Transaction Summary
		================================================================================================================================================
		Install  1 Package

		Total download size: 15 M
		Installed size: 49 M
		Downloading packages:
		aws-nitro-enclaves-cli-devel-1.4.2-0.amzn2.x86_64.rpm                                                                    |  15 MB  00:00:00
		Running transaction check
		Running transaction test
		Transaction test succeeded
		Running transaction
		  Installing : aws-nitro-enclaves-cli-devel-1.4.2-0.amzn2.x86_64                                                                            1/1
		  Verifying  : aws-nitro-enclaves-cli-devel-1.4.2-0.amzn2.x86_64                                                                            1/1

		Installed:
		  aws-nitro-enclaves-cli-devel.x86_64 0:1.4.2-0.amzn2

		Complete!
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$




		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ ls -la /usr/share/nitro_enclaves/blobs/
		total 49848
		drwxr-xr-x 2 root root      100 Oct  2 19:07 .
		drwxr-xr-x 4 root root       35 Oct  2 19:07 ..
		-rw-r--r-- 1 root root  5083088 Mar 25  2025 bzImage
		-rw-r--r-- 1 root root    79576 Mar 25  2025 bzImage.config
		-rw-r--r-- 1 root root      120 Mar 25  2025 cmdline
		-rwxr-xr-x 1 root root   742968 Mar 25  2025 init
		-rwxr-xr-x 1 root root 45104328 Mar 25  2025 linuxkit
		-rw-r--r-- 1 root root    20504 Mar 25  2025 ns



######Above commands are executed and logs - END






	# Now let's try building a simple enclave again
	nitro-cli build-enclave --docker-uri hello-world --output-file hello.eif

	# If that works, let's also check our allocated resources are working
	nitro-cli describe-enclaves


######Above commands are executed and logs - START


		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ nitro-cli build-enclave --docker-uri hello-world --output-file hello.eif
		Start building the Enclave Image...
		Enclave Image successfully created.
		{
		  "Measurements": {
			"HashAlgorithm": "Sha384 { ... }",
			"PCR0": "a3e599e2843d01810c1859a2612c3ecbcae35107ee51c34755614588be4d1311c23333ab779f24f9007a1ffe945a21c9",
			"PCR1": "0343b056cd8485ca7890ddd833476d78460aed2aa161548e4e26bedf321726696257d623e8805f3f605946b3d8b0c6aa",
			"PCR2": "a4022ba0d3683df2b4da9d1213803c602b37ce972488f16ab9f59e706f492af60e9966c1475005b55981cab8d9e3c147"
		  }
		}
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ nitro-cli describe-enclaves
		[]
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$


		#The empty [] from describe-enclaves is correct - it means no enclaves are currently running (which is expected since we just built the image but haven't launched it yet).



######Above commands are executed and logs - END


		# Launch the enclave with the image we just built
		nitro-cli run-enclave --cpu-count 2 --memory 512 --eif-path hello.eif --debug-mode

		# Check if it's running
		nitro-cli describe-enclaves

######Above commands are executed and logs - START

		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ ls -l
		total 5732
		drwxrwxr-x 22 ec2-user ec2-user    4096 Oct  2 18:26 aws-nitro-enclaves-cli
		-rw-r--r--  1 ec2-user ne       5863261 Oct  2 19:09 hello.eif
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ nitro-cli run-enclave --cpu-count 2 --memory 512 --eif-path hello.eif --debug-mode
		Start allocating memory...
		Started enclave with enclave-cid: 16, memory: 512 MiB, cpu-ids: [1, 3]
		{
		  "EnclaveName": "hello",
		  "EnclaveID": "i-085fa5ca0e3bda2cb-enc199a65672b92a8d",
		  "ProcessID": 78896,
		  "EnclaveCID": 16,
		  "NumberOfCPUs": 2,
		  "CPUIDs": [
			1,
			3
		  ],
		  "MemoryMiB": 512
		}
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ nitro-cli describe-enclaves
		[]
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$

		#The [] from describe-enclaves is actually expected behavior here. The hello-world container runs, prints its message, and then exits immediately - so by the time you run describe-enclaves, it's already finished!

######Above commands are executed and logs - END



		#VERIFY LONG RUNNING PROCESSES 

		 
		# Let's try a long-running enclave instead
		# First, let's build and run a simple nginx enclave that stays running
		# Build nginx enclave (this will stay running)
		nitro-cli build-enclave --docker-uri nginx --output-file nginx.eif




		# Change memory from 512 to 1024 using sed
		sudo sed -i 's/memory_mib: 512/memory_mib: 1024/' /etc/nitro_enclaves/allocator.yaml

		# Verify the change
		cat /etc/nitro_enclaves/allocator.yaml

		# Restart the allocator service
		sudo systemctl restart nitro-enclaves-allocator

		# Now run nginx with 756 MB (minimum required)
		nitro-cli run-enclave --cpu-count 2 --memory 756 --eif-path nginx.eif --debug-mode



		 
		# Now check if it's running
		nitro-cli describe-enclaves

		# Try console connection to the running nginx enclave
		nitro-cli console --enclave-name nginx



######Above commands are executed and logs - START

		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ nitro-cli build-enclave --docker-uri nginx --output-file nginx.eif
		Start building the Enclave Image...
		Enclave Image successfully created.
		{
		  "Measurements": {
			"HashAlgorithm": "Sha384 { ... }",
			"PCR0": "d5182754070779a5909ce4b83b967f6173dec9a7a679bdd4fc5ecf2627bd8d9761eb7ccf518826bde8bb584ff4f62fae",
			"PCR1": "0343b056cd8485ca7890ddd833476d78460aed2aa161548e4e26bedf321726696257d623e8805f3f605946b3d8b0c6aa",
			"PCR2": "2f8e4a26a68d59d294c3eaf405be652637c62c4ae6ee87c272a9118e933c23f1ccaef2b122b65df838a707caf641ce17"
		  }
		}
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ ls -l
		total 198620
		drwxrwxr-x 22 ec2-user ec2-user      4096 Oct  2 18:26 aws-nitro-enclaves-cli
		-rw-r--r--  1 ec2-user ne         5863261 Oct  2 19:09 hello.eif
		-rw-r--r--  1 ec2-user ne       197515395 Oct  2 19:15 nginx.eif


		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ sudo sed -i 's/memory_mib: 512/memory_mib: 1024/' /etc/nitro_enclaves/allocator.yaml
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ cat /etc/nitro_enclaves/allocator.yaml
		---
		# Enclave configuration file.
		#
		# How much memory to allocate for enclaves (in MiB).
		memory_mib: 1024
		#
		# How many CPUs to reserve for enclaves.
		cpu_count: 2
		#
		# Alternatively, the exact CPUs to be reserved for the enclave can be explicitly
		# configured by using `cpu_pool` (like below), instead of `cpu_count`.
		# Note: cpu_count and cpu_pool conflict with each other. Only use exactly one of them.
		# Example of reserving CPUs 2, 3, and 6 through 9:
		# cpu_pool: 2,3,6-9
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ sudo systemctl restart nitro-enclaves-allocator
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ nitro-cli run-enclave --cpu-count 2 --memory 756 --eif-path nginx.eif --debug-mode
		Start allocating memory...
		Started enclave with enclave-cid: 17, memory: 1024 MiB, cpu-ids: [1, 3]
		{
		  "EnclaveName": "nginx",
		  "EnclaveID": "i-085fa5ca0e3bda2cb-enc199a65df9f4c82b",
		  "ProcessID": 81699,
		  "EnclaveCID": 17,
		  "NumberOfCPUs": 2,
		  "CPUIDs": [
			1,
			3
		  ],
		  "MemoryMiB": 1024
		}
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$


		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ nitro-cli describe-enclaves
		[
		  {
			"EnclaveName": "nginx",
			"EnclaveID": "i-085fa5ca0e3bda2cb-enc199a65df9f4c82b",
			"ProcessID": 81699,
			"EnclaveCID": 17,
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


		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ nitro-cli console --enclave-name nginx
		Connecting to the console for enclave 17...
		Successfully connected to the console.
		0: [mem 0x0000000000000000-0x000000000009fbff] usable
		[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000003f7ffffe] usable
		[    0.000000] NX (Execute Disable) protection: active
		[    0.000000] DMI not present or invalid.
		[    0.000000] Hypervisor detected: KVM
		[    0.000000] tsc: Fast TSC calibration using PIT
		[    0.000000] e820: last_pfn = 0x3f7ff max_arch_pfn = 0x400000000



		[    0.585876] NSM RNG: returning rand bytes = 64
		[    0.586766] NSM RNG: returning rand bytes = 64
		2025/10/02 19:20:04 [notice] 594#594: using the "epoll" event method
		2025/10/02 19:20:04 [notice] 594#594: nginx/1.29.1
		2025/10/02 19:20:04 [notice] 594#594: built by gcc 12.2.0 (Debian 12.2.0-14+deb12u1)
		2025/10/02 19:20:04 [notice] 594#594: OS: Linux 4.14.256-209.484.amzn2.x86_64
		2025/10/02 19:20:04 [notice] 594#594: getrlimit(RLIMIT_NOFILE): 1024:4096
		2025/10/02 19:20:04 [notice] 594#594: start worker processes
		2025/10/02 19:20:04 [notice] 594#594: start worker process 595
		2025/10/02 19:20:04 [notice] 594#594: start worker process 596



		#truncated the big log .... 

######Above commands are executed and logs - END



#Let us build enclave using the jar file 

		# Run this in powershell 
		cd C:\ws\sboot\lab053b
		mvn clean package

		#Run this in bash shell 
		cd /c/ws/sboot/lab053b/target
		sridhara@poc-laptop-01 MINGW64 /c/ws/sboot/lab053b/target (main)
		$ ls -l
		total 19580
		drwxr-xr-x 1 sridhara 197121        0 Oct  2 20:45 classes/
		drwxr-xr-x 1 sridhara 197121        0 Oct  2 20:45 generated-sources/
		drwxr-xr-x 1 sridhara 197121        0 Oct  2 20:45 generated-test-sources/
		drwxr-xr-x 1 sridhara 197121        0 Oct  2 20:45 maven-archiver/
		drwxr-xr-x 1 sridhara 197121        0 Oct  2 20:45 maven-status/
		-rw-r--r-- 1 sridhara 197121 20035737 Oct  2 20:45 payments-0.0.1-SNAPSHOT.jar
		-rw-r--r-- 1 sridhara 197121     5773 Oct  2 20:45 payments-0.0.1-SNAPSHOT.jar.original
		drwxr-xr-x 1 sridhara 197121        0 Oct  2 20:45 surefire-reports/
		drwxr-xr-x 1 sridhara 197121        0 Oct  2 20:45 test-classes/
		#SCP 
		sridhara@poc-laptop-01 MINGW64 /c/ws/sboot/lab053b/target (main)
		$ scp -i "C:/ws/cocopoc/3-aws-scripts-eks-coco/create/coco-eks-key.pem" payments-0.0.1-SNAPSHOT.jar ec2-user@3.249.239.65:/home/ec2-user/
		payments-0.0.1-SNAPSHOT.jar                                                           100%   19MB   2.4MB/s   00:07

		sridhara@poc-laptop-01 MINGW64 /c/ws/sboot/lab053b/target (main)
		$

 
 #Exit from worker node and come back to bastion ec2
		 
		[ec2-user@ip-10-1-1-19 aws-nitro-enclaves-cli]$ exit
		logout
		Connection to 10.1.1.19 closed.
		[ec2-user@ip-10-1-1-86 ~]$
		[ec2-user@ip-10-1-1-86 ~]$
		[ec2-user@ip-10-1-1-86 ~]$


		#Check the jar file is copied 

		[ec2-user@ip-10-1-1-86 ~]$ pwd
		/home/ec2-user
		[ec2-user@ip-10-1-1-86 ~]$
		[ec2-user@ip-10-1-1-86 ~]$ ls -l
		total 19572
		-r-------- 1 ec2-user ec2-user     1706 Oct  2 17:55 coco-eks-key.pem
		-rw-r--r-- 1 ec2-user ec2-user 20035737 Oct  2 19:52 payments-0.0.1-SNAPSHOT.jar
		[ec2-user@ip-10-1-1-86 ~]$
		[ec2-user@ip-10-1-1-86 ~]$



#Move the jar file from bastion to worker node 

		scp -i coco-eks-key.pem payments-0.0.1-SNAPSHOT.jar ec2-user@10.1.1.19:/home/ec2-user/

		[ec2-user@ip-10-1-1-86 ~]$ scp -i coco-eks-key.pem payments-0.0.1-SNAPSHOT.jar ec2-user@10.1.1.19:/home/ec2-user/
		payments-0.0.1-SNAPSHOT.jar                                                                                   100%   19MB 298.1MB/s   00:00
		[ec2-user@ip-10-1-1-86 ~]$




#SSH back to worker node 

		[ec2-user@ip-10-1-1-86 ~]$ ssh -i coco-eks-key.pem ec2-user@10.1.1.19
		Last login: Thu Oct  2 18:04:43 2025 from ip-10-1-1-86.eu-west-1.compute.internal
		   ,     #_
		   ~\_  ####_        Amazon Linux 2
		  ~~  \_#####\
		  ~~     \###|       AL2 End of Life is 2026-06-30.
		  ~~       \#/ ___
		   ~~       V~' '->
			~~~         /    A newer version of Amazon Linux is available!
			  ~~._.   _/
				 _/ _/       Amazon Linux 2023, GA and supported until 2028-03-15.
			   _/m/           https://aws.amazon.com/linux/amazon-linux-2023/

		[ec2-user@ip-10-1-1-19 ~]$


#Now we are in the worker node. Check the jar file is copied or not

		[ec2-user@ip-10-1-1-19 ~]$ ls -l
		total 19568
		drwxrwxr-x 5 ec2-user ec2-user      101 Oct  2 18:21 aws-nitro-enclaves-cli
		-rw-r--r-- 1 ec2-user ec2-user 20035737 Oct  2 19:58 payments-0.0.1-SNAPSHOT.jar
		[ec2-user@ip-10-1-1-19 ~]$
		[ec2-user@ip-10-1-1-19 ~]


#Create a docker file 

# Create new Dockerfile with Java 17
cat > Dockerfile << 'EOF'
# Single stage - much simpler
FROM eclipse-temurin:22-jre-alpine
WORKDIR /app
COPY payments-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
EXPOSE 8080
EOF



#Created the docker file and did a cat of it for ready reference. 

		[ec2-user@ip-10-1-1-19 ~]$ ls -l
		total 261088
		drwxrwxr-x 5 ec2-user ec2-user       101 Oct  2 18:21 aws-nitro-enclaves-cli
		-rw-rw-r-- 1 ec2-user ec2-user       170 Oct  2 20:17 Dockerfile
		-rw-r--r-- 1 ec2-user ec2-user  20035737 Oct  2 19:58 payments-0.0.1-SNAPSHOT.jar
		-rw-rw-r-- 1 ec2-user ec2-user 247311365 Oct  2 20:06 payments-app.eif
		[ec2-user@ip-10-1-1-19 ~]$ cat Dockerfile
		# Single stage - much simpler
		FROM eclipse-temurin:22-jre-alpine
		WORKDIR /app
		COPY payments-0.0.1-SNAPSHOT.jar app.jar
		ENTRYPOINT ["java", "-jar", "app.jar"]
		EXPOSE 8080
		[ec2-user@ip-10-1-1-19 ~]$




#Build docker image and check the image created. 

		[ec2-user@ip-10-1-1-19 ~]$ 
 
		[ec2-user@ip-10-1-1-19 ~]$ docker build -t payments-app .
		[+] Building 4.9s (8/8) FINISHED                                                                                                 docker:default
		 => [internal] load build definition from Dockerfile                                                                                       0.0s
		 => => transferring dockerfile: 209B 		


		#Docker images 
		[ec2-user@ip-10-1-1-19 ~]$ docker images
		REPOSITORY     TAG       IMAGE ID       CREATED          SIZE
		payments-app   latest    193044100965   32 seconds ago   209MB
		[ec2-user@ip-10-1-1-19 ~]$
		[ec2-user@ip-10-1-1-19 ~]$


#Check the application by using the docker run. Notice it is running 

		[ec2-user@ip-10-1-1-19 ~]$ # Test your Docker image first
		[ec2-user@ip-10-1-1-19 ~]$ docker run --rm payments-app:latest

		

		2025-10-02T20:20:50.345Z  INFO 1 --- [nerdylabs] [           main] com.nerdy.lab.Lab1Application            : Starting Lab1Application v0.0.1-SNAPSHOT using Java 22.0.2 with PID 1 (/app/app.jar started by root in /app)
		2025-10-02T20:20:50.349Z  INFO 1 --- [nerdylabs] [           main] com.nerdy.lab.Lab1Application            : No active profile set, falling back to 1 default profile: "default"
		2025-10-02T20:20:52.194Z  INFO 1 --- [nerdylabs] [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port 8080 (http)
		2025-10-02T20:20:52.216Z  INFO 1 --- [nerdylabs] [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
		2025-10-02T20:20:52.217Z  INFO 1 --- [nerdylabs] [           main] o.apache.catalina.core.StandardEngine    : Starting Servlet engine: [Apache Tomcat/10.1.30]
		2025-10-02T20:20:52.267Z  INFO 1 --- [nerdylabs] [           main] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
		2025-10-02T20:20:52.270Z  INFO 1 --- [nerdylabs] [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 1795 ms
		2025-10-02T20:20:52.907Z  INFO 1 --- [nerdylabs] [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port 8080 (http) with context path '/'
		2025-10-02T20:20:52.932Z  INFO 1 --- [nerdylabs] [           main] com.nerdy.lab.Lab1Application            : Started Lab1Application in 3.374 seconds (process running for 4.152)


#Run as Deamon 

		# Run with port mapping
		docker run -d --name payments-app-test -p 8080:8080 payments-app:latest

		 
		[ec2-user@ip-10-1-1-19 ~]$
		[ec2-user@ip-10-1-1-19 ~]$ docker run -d --name payments-app-test -p 8080:8080 payments-app:latest
		f9c9ba99d69d1e5675f925bb4991872f08a87ec8e019c1d51780408b2e650bd7
		[ec2-user@ip-10-1-1-19 ~]$
		[ec2-user@ip-10-1-1-19 ~]$ docker ps
		CONTAINER ID   IMAGE                 COMMAND               CREATED         STATUS         PORTS                                       NAMES
		f9c9ba99d69d   payments-app:latest   "java -jar app.jar"   5 seconds ago   Up 4 seconds   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   payments-app-test
		[ec2-user@ip-10-1-1-19 ~]$
		[ec2-user@ip-10-1-1-19 ~]$


		
#Test the curl. Single line curl 


		  curl -X POST http://localhost:8080/payment/process -H "Content-Type: application/json" -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.fake.payload" -H "X-Message-Id: MSG-12345" -d '{"accountNumber": "123456789","creditCardNumber": "4111111111111111","expiryDate": "12/28","cvv": "123","amount": 500.00,"destinationAccount": "987654321","senderName": "John Doe","receiverName": "Jane Smith"}'



		[ec2-user@ip-10-1-1-19 ~]$   curl -X POST http://localhost:8080/payment/process -H "Content-Type: application/json" -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.fake.payload" -H "X-Message-Id: MSG-12345" -d '{"accountNumber": "123456789","creditCardNumber": "4111111111111111","expiryDate": "12/28","cvv": "123","amount": 500.00,"destinationAccount": "987654321","senderName": "John Doe","receiverName": "Jane Smith"}'
		{"status":"SUCCESS","referenceNumber":"fc7e99c6-1a75-42e6-a838-64dd89c11bdc","message":"Payment processed successfully for John Doe to Jane Smith","processedAmount":500.0,"balanceAmount":6518.01}[ec2-user@ip-10-1-1-19 ~]$
		[ec2-user@ip-10-1-1-19 ~]$



#Stop the container and remove 

		[ec2-user@ip-10-1-1-19 ~]$ docker stop payments-app-test
		payments-app-test
		[ec2-user@ip-10-1-1-19 ~]$ docker rm payments-app-test
		payments-app-test
		[ec2-user@ip-10-1-1-19 ~]$




		
#Convert to Nitro Enclave by using 'build-enclave' option 



		[ec2-user@ip-10-1-1-19 ~]$ ls -l
		total 19572
		drwxrwxr-x 5 ec2-user ec2-user      101 Oct  2 18:21 aws-nitro-enclaves-cli
		-rw-rw-r-- 1 ec2-user ec2-user      170 Oct  2 20:17 Dockerfile
		-rw-r--r-- 1 ec2-user ec2-user 20035737 Oct  2 19:58 payments-0.0.1-SNAPSHOT.jar
		
		
		[ec2-user@ip-10-1-1-19 ~]$  nitro-cli build-enclave --docker-uri payments-app:latest --output-file payments-app.eif
		Start building the Enclave Image...
		Using the locally available Docker image...
		Enclave Image successfully created.
		{
		  "Measurements": {
			"HashAlgorithm": "Sha384 { ... }",
			"PCR0": "26803f96958eeea58e687f207d5c478b59c5b3e9dfb3e353d7d12903713282c7951abc8ed42eed448cede995e7f28630",
			"PCR1": "0343b056cd8485ca7890ddd833476d78460aed2aa161548e4e26bedf321726696257d623e8805f3f605946b3d8b0c6aa",
			"PCR2": "9de7f118e164c638f11b5b372f493a5a864c1e03ebd019a394eb6e1cff96a19ce731a2166d6ce8ef2def13f79c839f10"
		  }
		}
		[ec2-user@ip-10-1-1-19 ~]$ ls -l
		total 229152
		drwxrwxr-x 5 ec2-user ec2-user       101 Oct  2 18:21 aws-nitro-enclaves-cli
		-rw-rw-r-- 1 ec2-user ec2-user       170 Oct  2 20:17 Dockerfile
		-rw-r--r-- 1 ec2-user ec2-user  20035737 Oct  2 19:58 payments-0.0.1-SNAPSHOT.jar
		-rw-rw-r-- 1 ec2-user ec2-user 214608717 Oct  2 20:31 payments-app.eif
		[ec2-user@ip-10-1-1-19 ~]$


#BELOW ARE OPTIONAL 
#Before running the nitro enclave, remove the existing ones including images 

		[ec2-user@ip-10-1-1-19 ~]$ # List current enclaves
		[ec2-user@ip-10-1-1-19 ~]$ nitro-cli describe-enclaves
		[
		  {
			"EnclaveName": "nginx",
			"EnclaveID": "i-085fa5ca0e3bda2cb-enc199a65df9f4c82b",
			"ProcessID": 81699,
			"EnclaveCID": 17,
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
		[ec2-user@ip-10-1-1-19 ~]$


# Terminate all enclaves (replace ENCLAVE-ID with actual ID)

		[ec2-user@ip-10-1-1-19 ~]$ nitro-cli terminate-enclave --enclave-id i-085fa5ca0e3bda2cb-enc199a65df9f4c82b
		Successfully terminated enclave i-085fa5ca0e3bda2cb-enc199a65df9f4c82b.
		{
		  "EnclaveName": "nginx",
		  "EnclaveID": "i-085fa5ca0e3bda2cb-enc199a65df9f4c82b",
		  "Terminated": true
		}
		[ec2-user@ip-10-1-1-19 ~]$


#Remove docker images 

		[ec2-user@ip-10-1-1-19 ~]$ docker images
		REPOSITORY     TAG       IMAGE ID       CREATED         SIZE
		payments-app   latest    3434a4f8bc25   5 minutes ago   243MB
		nginx          latest    203ad09fc156   7 weeks ago     192MB
		hello-world    latest    1b44b5a3e06a   7 weeks ago     10.1kB
		[ec2-user@ip-10-1-1-19 ~]$ docker ps
		CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
		[ec2-user@ip-10-1-1-19 ~]$ docker ps -a
		CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
		[ec2-user@ip-10-1-1-19 ~]$ docker rmi nginx hello-world
		Untagged: nginx:latest
		Untagged: nginx@sha256:8adbdcb969e2676478ee2c7ad333956f0c8e0e4c5a7463f4611d7a2e7a7ff5dc
		Deleted: sha256:203ad09fc1566a329c1d2af8d1f219b28fd2c00b69e743bd572b7f662365432d
		Untagged: hello-world:latest
		Untagged: hello-world@sha256:54e66cc1dd1fcb1c3c58bd8017914dbed8701e2d8c74d9262e26bd9cc1642d31
		Deleted: sha256:1b44b5a3e06a9aae883e7bf25e45c100be0bb81a0e01b32de604f3ac44711634
		[ec2-user@ip-10-1-1-19 ~]$ clear
		[ec2-user@ip-10-1-1-19 ~]$ docker images
		REPOSITORY     TAG       IMAGE ID       CREATED         SIZE
		payments-app   latest    3434a4f8bc25   5 minutes ago   243MB
		[ec2-user@ip-10-1-1-19 ~]$

#UPTO TO THIS OPTIONAL 



#Run java pp in nitro enclave 

		nitro-cli run-enclave --cpu-count 2 --memory 1024 --eif-path payments-app.eif --debug-mode

		[ec2-user@ip-10-1-1-19 ~]$ nitro-cli run-enclave --cpu-count 2 --memory 1024 --eif-path payments-app.eif --debug-mode
		Start allocating memory...
		Started enclave with enclave-cid: 19, memory: 1024 MiB, cpu-ids: [1, 3]
		{
		  "EnclaveName": "payments-app",
		  "EnclaveID": "i-085fa5ca0e3bda2cb-enc199a6a080bc19eb",
		  "ProcessID": 105580,
		  "EnclaveCID": 19,
		  "NumberOfCPUs": 2,
		  "CPUIDs": [
			1,
			3
		  ],
		  "MemoryMiB": 1024
		}
		[ec2-user@ip-10-1-1-19 ~]$


		[ec2-user@ip-10-1-1-19 ~]$ nitro-cli describe-enclaves
		[]
		[ec2-user@ip-10-1-1-19 ~]$ nitro-cli console --enclave-id i-085fa5ca0e3bda2cb-enc199a6a080bc19eb
		[ E11 ] Socket error. This is used as an error for catching any other socket operation errors not covered by previous custom errors.

		For more details, please visit https://docs.aws.amazon.com/enclaves/latest/user/cli-errors.html#E11

		If you open a support ticket, please provide the error log found at "/var/log/nitro_enclaves/err2025-10-02T20:33:35.985846604+00:00.log"
		[ec2-user@ip-10-1-1-19 ~]$


		## failed 
		


## Repeating the steps from docker file creation 

# Create new Dockerfile for enclave
cat > Dockerfile << 'EOF'
FROM eclipse-temurin:22-jre-alpine
WORKDIR /app
COPY payments-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-Xmx512m", "-jar", "app.jar", "--server.address=0.0.0.0", "--server.port=8080"]
EXPOSE 8080
EOF



		[ec2-user@ip-10-1-1-19 ~]$ ls -l
		total 19572
		drwxrwxr-x 5 ec2-user ec2-user      101 Oct  2 18:21 aws-nitro-enclaves-cli
		-rw-rw-r-- 1 ec2-user ec2-user      202 Oct  2 20:35 Dockerfile
		-rw-r--r-- 1 ec2-user ec2-user 20035737 Oct  2 19:58 payments-0.0.1-SNAPSHOT.jar
		[ec2-user@ip-10-1-1-19 ~]$ cat Dockerfile
		FROM eclipse-temurin:22-jre-alpine
		WORKDIR /app
		COPY payments-0.0.1-SNAPSHOT.jar app.jar
		ENTRYPOINT ["java", "-Xmx512m", "-jar", "app.jar", "--server.address=0.0.0.0", "--server.port=8080"]
		EXPOSE 8080
		[ec2-user@ip-10-1-1-19 ~]$


#Removing existing docker images

	[ec2-user@ip-10-1-1-19 ~]$ docker images
	REPOSITORY     TAG       IMAGE ID       CREATED          SIZE
	payments-app   latest    193044100965   18 minutes ago   209MB
	[ec2-user@ip-10-1-1-19 ~]$ docker ps
	CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
	[ec2-user@ip-10-1-1-19 ~]$ docker rmi payments-app
	Untagged: payments-app:latest
	Deleted: sha256:193044100965b6637b45449896685cde0a7885d676a6943d8d7b57f942ba1bda
	[ec2-user@ip-10-1-1-19 ~]$



#Buidling the docker images 

	[ec2-user@ip-10-1-1-19 ~]$ docker build -t payments-app .
	[+] Building 0.6s (8/8) FINISHED                                                                                                 docker:default
	 => [internal] load build definition from Dockerfile                                                                                       0.0s
	 => => transferring dockerfile: 241B                                                                                                       0.0s
	 => [internal] load    TRUNCATED
	 

#Build Nitro enclave app

	[ec2-user@ip-10-1-1-19 ~]$ nitro-cli build-enclave --docker-uri payments-app:latest --output-file payments-app.eif
	Start building the Enclave Image...
	Using the locally available Docker image...
	Enclave Image successfully created.
	{
	  "Measurements": {
		"HashAlgorithm": "Sha384 { ... }",
		"PCR0": "7a026eaa1d3a076905dd626d91fc90b16763c76bab1f8a1abd227b4afbe1908bba7d8d09583cfff0fe4819643974b822",
		"PCR1": "0343b056cd8485ca7890ddd833476d78460aed2aa161548e4e26bedf321726696257d623e8805f3f605946b3d8b0c6aa",
		"PCR2": "5631b41910f3b8bc9f366271bf00a6c84e1536fefb62ad8ca8297a09cf734112a5c86211a9dfbabecff1a1a81d3bc73e"
	  }
	}
	[ec2-user@ip-10-1-1-19 ~]$  nitro-cli describe-enclaves
	[]
	[ec2-user@ip-10-1-1-19 ~]$
	
#Run now with more memory 

# Run with more memory


nitro-cli run-enclave --cpu-count 2 --memory 1536 --eif-path payments-app.eif --debug-mode


	

############################################################################################################

STUCK HERE .. DOCKER BUILD SUCCESS
DOCKER RUN SUCCESS
NITRO BUILD SUCCESS
NITRO RUN FAILING 


stopped the bastion host
killed the worker node


tomorrow in office start the bastion
run the h2 spin up sh file 


CHECK THESE WHEN THE ENTIRE SETUP IS DONE AGAIN. 

# Check system logs
sudo journalctl -u nitro-enclaves-allocator
dmesg | grep -i enclave

# Check enclave allocator logs
sudo journalctl -u nitro-enclaves-allocator -f

# Check kernel messages
dmesg | grep -i enclave | tail -10

# Check if allocator is running
systemctl status nitro-enclaves-allocator



###Kuberentes deployment 

Kubernetes-driven Nitro Enclave deployment steps:

• Enable Nitro Enclaves on EKS worker nodes - Configure EC2 instances with enclave support 
• Install Nitro Enclaves device plugin - DaemonSet to expose enclave resources to K8s 
• Build Docker image with your Java app - Standard containerization process 
• Convert Docker image to EIF format - Use nitro-cli build-enclave command 
• Store EIF in accessible location - S3, ECR, or shared storage for nodes 
• Create ConfigMap with EIF path - Reference to enclave image file location 
• Update deployment.yaml with enclave resources - Request nitro-enclaves/enclave resource 
• Add init container to download EIF - Fetch EIF file to worker node 
• Deploy using kubectl apply - Standard K8s deployment process 
• Monitor enclave pods - Check pod status and enclave allocation


############################################################################################################
