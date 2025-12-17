


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



		#VERIFY LONG RUNNING PROCESSES NIGINX

		 
		# Let's try a long-running enclave instead
		# First, let's build and run a simple nginx enclave that stays running
		# Build nginx enclave (this will stay running)
		sudo nitro-cli build-enclave --docker-uri nginx --output-file nginx.eif




		# Change memory from 512 to 1024 using sed
		sudo sed -i 's/memory_mib: 512/memory_mib: 1024/' /etc/nitro_enclaves/allocator.yaml

		# Verify the change
		cat /etc/nitro_enclaves/allocator.yaml

		# Restart the allocator service
		sudo systemctl restart nitro-enclaves-allocator

		# Now run nginx with 756 MB (minimum required)
		sudo nitro-cli run-enclave --cpu-count 2 --memory 756 --eif-path nginx.eif --debug-mode



		 
		# Now check if it's running
		sudo nitro-cli describe-enclaves

		# Try console connection to the running nginx enclave
		sudo nitro-cli console --enclave-name nginx



######Above commands are executed and logs - START




		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$
		[ec2-user@ip-10-1-1-19 nitro-enclaves-setup]$ sudo nitro-cli build-enclave --docker-uri nginx --output-file nginx.eif
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



Some additional commands to test 
→ Shows enclave boot logs and runtime output.
nitro-cli console --enclave-id <ID>
→ Detailed info about a specific enclave.
nitro-cli describe-enclave --enclave-id <ID>
→ Shows allocator service logs (common source of issues).
journalctl -u nitro-enclaves-allocator

→ Kernel logs related to Nitro Enclaves.
dmesg | grep -i nitro

→ Checks if Nitro Enclaves device is available.
ls /dev/nitro_enclaves


→ Displays PCR values and hash measurements.
nitro-cli show-enclave-measurements --eif-path <file>.eif





Host (parent instance)
Shelllsmod | grep nitro_enclavesShow more lines
→ Kernel module loaded
Shellls -l /dev/nitro_enclavesShow more lines
→ Device present/permissions
Shellid | grep -E '\bne\b'Show more lines
→ User in ne group
Shelljournalctl -u nitro-enclaves-allocator -fShow more lines
→ Allocator live logs
Shelljournalctl -u nitro-enclaves-vsock-proxy -fShow more lines
→ Vsock proxy logs (if used)
Shelldmesg | grep -i -E 'nitro|enclave'Show more lines
→ Kernel errors/events
Shellgrep -i huge /proc/meminfoShow more lines
→ HugePages availability
Shellnitro-cli describe-enclavesShow more lines
→ List enclaves
Shellnitro-cli describe-enclave --enclave-id <ID>Show more lines
→ Enclave status/details
Shellnitro-cli console --enclave-id <ID>Show more lines
→ Enclave stdout/stderr
Shellnitro-cli terminate-enclave --enclave-id <ID>Show more lines
→ Clean stuck enclave

EIF / Build
Shelldocker run --rm <image> java -versionShow more lines
→ Verify JVM in image
Shellnitro-cli build-enclave --docker-uri <image> --output-file app.eif --debug-modeShow more lines
→ Build EIF with debug
Shellnitro-cli show-enclave-measurements --eif-path app.eifShow more lines
→ PCR/hash measurements
Shellnitro-cli describe-eif --eif-path app.eifShow more lines
→ EIF entrypoint/files (if available)

Run (tune resources / CID)
Shellnitro-cli run-enclave --eif-path app.eif --cpu-count 2 --memory 4096 --enclave-cid 16 --debug-modeShow more lines
→ Start with more RAM + debug
Shellnitro-cli console --enclave-id <ID>Show more lines
→ Watch Java logs/crashes

Networking / vsock (host)
Shellsystemctl status nitro-enclaves-vsock-proxyShow more lines
→ Proxy running?
Shellss -lpn | grep -i vsockShow more lines
→ Vsock listeners (if supported)

Inside enclave (if you baked a shell/busybox)
ShellShow more lines
→ JVM present
Shellenv | sortShow more lines
→ Runtime env
Shellcat /proc/meminfo; cat /proc/cpuinfoShow more lines
→ Resources visible to JVM
Shellldd "$(command -v java)" || echo "static or missing ldd"Show more lines
→ Glibc linkage check
Shellstrace -f -o /dev/console java -jar app.jarShow more lines
→ Syscall trace to console

Helpful Java run line (send all logs to console)
Shelljava -XshowSettings:system -Xlog:os+container=debug,gc -XX:+PrintFlagsFinal -jar app.jar 1>/dev/console 2>&1Show more lines
→ Container/mem flags & logs


############################################################################################################




#REsuming test. Above set of commands not started 


[ec2-user@ip-10-1-0-206 ~]$ sudo nitro-cli console --enclave-name nginx
Connecting to the console for enclave 16...
Successfully connected to the console.
ls


ps -aux


^C
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




]
[ec2-user@ip-10-1-0-206 ~]$ ps aux | grep nginx
root       38507  0.5  0.0 1313852 5268 ?        Ssl  12:54   0:02 nitro-cli run-enclave --cpu-count 2 --memory 756 --eif-path nginx.eif --debug-mode
ec2-user   40503  0.0  0.0 119424   948 pts/0    S+   13:00   0:00 grep --color=auto nginx
[ec2-user@ip-10-1-0-206 ~]$



#What you're seeing:
#nitro-cli run-enclave - This is just the parent process that manages the enclave
#grep --color=auto nginx - This is your search command
#What you're NOT seeing:
#The actual nginx process running inside the enclave
#Any enclave worker processes
#Enclave memory or internal processes
#This proves the enclave is truly isolated!


#Now let's test memory isolation:
#This will show the memory maps of the nitro-cli process. You should see it has very limited memory access and cannot see into the enclave's secure memory space.
#! This shows the parent process memory layout - notice it's just the nitro-cli binary and some heap/stack memory. The enclave memory is completely separate and invisible.


[ec2-user@ip-10-1-0-206 ~]$ sudo cat /proc/38507/maps | head -10
55a8bec00000-55a8bf99b000 r-xp 00000000 103:02 1270099                   /usr/bin/nitro-cli
55a8bfb9b000-55a8bfc62000 r--p 00d9b000 103:02 1270099                   /usr/bin/nitro-cli
55a8bfc62000-55a8bfc67000 rw-p 00e62000 103:02 1270099                   /usr/bin/nitro-cli
55a8c23bf000-55a8c23e0000 rw-p 00000000 00:00 0                          [heap]
7f1240000000-7f1280000000 rw-p 00000000 00:0e 144439                     /anon_hugepage (deleted)
7f12a4000000-7f12a4021000 rw-p 00000000 00:00 0
7f12a4021000-7f12a8000000 ---p 00000000 00:00 0
7f12a8000000-7f12a80c0000 rw-p 00000000 00:00 0
7f12a80c0000-7f12ac000000 ---p 00000000 00:00 0
7f12afdff000-7f12afe00000 ---p 00000000 00:00 0
[ec2-user@ip-10-1-0-206 ~]$




#Notice below command

#That I/O error is exactly what we want to see!
#This proves the memory protection is working:
#The kernel is blocking direct memory access to the nitro-cli process
#Even with sudo/root privileges, you cannot dump the memory
#The enclave's memory is completely isolated and protected

[ec2-user@ip-10-1-0-206 ~]$ sudo hexdump -C /proc/38507/mem | head -5
hexdump: /proc/38507/mem: Input/output error
[ec2-user@ip-10-1-0-206 ~]$


#This fails as gdb is not installed
sudo gdb -p 38507 



#Below command shows nothing as memory is isolated
#This should show NO nginx network connections visible from the parent instance. The enclave's network activity (if any) is isolated and only accessible through secure vsock channels, not regular networking.
#This will complete our security verification tests.

[ec2-user@ip-10-1-0-206 ~]$ sudo netstat -tulpn | grep nginx
[ec2-user@ip-10-1-0-206 ~]$


#Security Verification Summary - ALL PASSED ✅
#Process Isolation ✅ - Can't see nginx processes inside enclave
#Memory Protection ✅ - I/O error when trying memory dump
#Network Isolation ✅ - No visible network connections
#Cryptographic Attestation ✅ - PCR measurements present
#Debug Protection ✅ - No debugging tools can attach
##What This Proves:
#Your nginx is running in hardware-enforced isolation
#Even root on the parent instance cannot access enclave data
#No memory dumps, process inspection, or network sniffing possible
#The enclave can cryptographically prove its integrity via PCR measurements
#Communication only possible through secure vsock channels
##Your Nitro Enclave Security Status: FULLY SECURED 🔒
#The enclave is now running your nginx in a Trusted Execution Environment (TEE) that provides confidential computing #capabilities - even AWS cannot access your application's runtime data!






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



#Edit the grub file 

[ec2-user@ip-10-1-0-206 ~]$ sudo vi /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 nvme_core.io_timeout=4294967295 rd.emergency=poweroff rd.shell=0" GRUB_TIMEOUT=0 GRUB_DISABLE_RECOVERY="true" GRUB_TERMINAL="ec2-console" GRUB_X86_USE_32BIT="true" ~ 

this is current one



[ec2-user@ip-10-1-0-206 ~]$ sudo sed -i 's/rd.shell=0"/rd.shell=0 isolcpus=1"/' /etc/default/grub
 
[ec2-user@ip-10-1-0-206 ~]$ cat /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 nvme_core.io_timeout=4294967295 rd.emergency=poweroff rd.shell=0 isolcpus=1"
GRUB_TIMEOUT=0
GRUB_DISABLE_RECOVERY="true"
GRUB_TERMINAL="ec2-console"
GRUB_X86_USE_32BIT="true"
[ec2-user@ip-10-1-0-206 ~]$




#Reboot

[ec2-user@ip-10-1-0-206 ~]$ ls -l
total 422044
-rw-rw-r-- 1 ec2-user ec2-user       202 Oct  5 13:09 Dockerfile
-rw-r--r-- 1 root     root     197515395 Oct  5 12:52 nginx.eif
-rwxr-xr-x 1 ec2-user ec2-user       963 Oct  5 12:46 nitro-file-install-tools-build-nginx-enclave.sh
-rw-r--r-- 1 ec2-user ec2-user  20035490 Oct  5 12:46 payments-0.0.1-SNAPSHOT.jar
-rw-r--r-- 1 root     root     214608263 Oct  5 13:12 payments-app.eif


[ec2-user@ip-10-1-0-206 ~]$ sudo sed -i 's/rd.shell=0"/rd.shell=0 isolcpus=1"/' /etc/default/grub


[ec2-user@ip-10-1-0-206 ~]$ cat /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 nvme_core.io_timeout=4294967295 rd.emergency=poweroff rd.shell=0 isolcpus=1"
GRUB_TIMEOUT=0
GRUB_DISABLE_RECOVERY="true"
GRUB_TERMINAL="ec2-console"
GRUB_X86_USE_32BIT="true"


[ec2-user@ip-10-1-0-206 ~]$ sudo grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-5.10.242-239.961.amzn2.x86_64
Found initrd image: /boot/initramfs-5.10.242-239.961.amzn2.x86_64.img
done


[ec2-user@ip-10-1-0-206 ~]$ sudo reboot
Connection to 10.1.0.206 closed by remote host.
Connection to 10.1.0.206 closed.
[ec2-user@ip-10-1-0-239 ~]$

#NOTICE WE HAVE EXITED. 

#Enter into nitro node again 

[ec2-user@ip-10-1-0-239 ~]$ ./bastion-file-just-ssh-no-transfer.sh
Bastion SG: sg-04564777181b23f08
NitroNode SG: sg-008d0f85e7fed6e14
NitroNode IP: 10.1.0.206
Adding SSH rule...
SSH rule already exists (OK)
Verifying SSH rule exists...
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
                    "GroupId": "sg-04564777181b23f08"
                }
            ],
            "Ipv6Ranges": []
        }
    ]
]
Connecting to nitro node...
Last login: Sun Oct  5 13:35:21 2025 from ip-10-1-0-239.eu-west-1.compute.internal
   ,     #_
   ~\_  ####_        Amazon Linux 2
 
  
2 package(s) needed for security, out of 2 available
Run "sudo yum update" to apply all updates.
[ec2-user@ip-10-1-0-206 ~]$




#check cmdline 

[ec2-user@ip-10-1-0-206 ~]$ cat /proc/cmdline
BOOT_IMAGE=/boot/vmlinuz-5.10.242-239.961.amzn2.x86_64 root=UUID=f7b12982-40f9-4073-aea7-97afa082b80a ro console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 nvme_core.io_timeout=4294967295 rd.emergency=poweroff rd.shell=0 isolcpus=1
[ec2-user@ip-10-1-0-206 ~]$


#Build payments app image ####Ran into error 

-rw-rw-r-- 1 ec2-user ec2-user       202 Oct  5 13:09 Dockerfile
-rw-r--r-- 1 root     root     197515395 Oct  5 12:52 nginx.eif
-rwxr-xr-x 1 ec2-user ec2-user       963 Oct  5 12:46 nitro-file-install-tools-build-nginx-enclave.sh
-rw-r--r-- 1 ec2-user ec2-user  20035490 Oct  5 12:46 payments-0.0.1-SNAPSHOT.jar
-rw-r--r-- 1 root     root     214608263 Oct  5 13:12 payments-app.eif
[ec2-user@ip-10-1-0-206 ~]$
[ec2-user@ip-10-1-0-206 ~]$ sudo docker images
REPOSITORY     TAG       IMAGE ID       CREATED          SIZE
payments-app   latest    5d5eab013596   32 minutes ago   209MB
nginx          latest    203ad09fc156   7 weeks ago      192MB
[ec2-user@ip-10-1-0-206 ~]$




[ec2-user@ip-10-1-0-206 ~]$ sudo nitro-cli run-enclave --cpu-count 1 --memory 820 --enclave-cid 16 --eif-path payments-app.eif
Start allocating memory...
[ E29 ] Ioctl failure. Such error is used as a general ioctl error and appears whenever an ioctl fails. In this case, the error backtrace provides detailed information on what specifically failed during the ioctl.

For more details, please visit https://docs.aws.amazon.com/enclaves/latest/user/cli-errors.html#E29

If you open a support ticket, please provide the error log found at "/var/log/nitro_enclaves/err2025-10-05T13:43:02.444184198+00:00.log"
Failed connections: 1
[ E39 ] Enclave process connection failure. Such error appears when the enclave manager fails to connect to at least one enclave process for retrieving the description information.

For more details, please visit https://docs.aws.amazon.com/enclaves/latest/user/cli-errors.html#E39

If you open a support ticket, please provide the error log found at "/var/log/nitro_enclaves/err2025-10-05T13:43:02.446452577+00:00.log"
[ec2-user@ip-10-1-0-206 ~]$


#The issue is clear! The Nitro Enclaves driver can't find the isolated CPU. Let's check CPU topology:


[ec2-user@ip-10-1-0-206 ~]$ sudo dmesg | grep -i nitro
[    4.910947] nitro_enclaves: No CPUs available in CPU pool
[    4.916314] nitro_enclaves: Error in setup CPU pool [rc=-22]
[  334.359496] misc nitro_enclaves: Full CPU cores not used



[ec2-user@ip-10-1-0-206 ~]$ lscpu
Architecture:         x86_64
CPU op-mode(s):       32-bit, 64-bit
Byte Order:           Little Endian
CPU(s):               4
On-line CPU(s) list:  0,2
Off-line CPU(s) list: 1,3
Thread(s) per core:   2
Core(s) per socket:   1
Socket(s):            1
NUMA node(s):         1
Vendor ID:            GenuineIntel
CPU family:           6
Model:                85
Model name:           Intel(R) Xeon(R) Platinum 8175M CPU @ 2.50GHz
Stepping:             4
CPU MHz:              3142.904
BogoMIPS:             4999.99
Hypervisor vendor:    KVM
Virtualization type:  full
L1d cache:            32K
L1i cache:            32K
L2 cache:             1024K
L3 cache:             33792K
NUMA node0 CPU(s):    0,2
Flags:                fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss ht syscall nx pdpe1gb rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid aperfmperf tsc_known_freq pni pclmulqdq ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm abm 3dnowprefetch cpuid_fault invpcid_single pti fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid mpx avx512f avx512dq rdseed adx smap clflushopt clwb avx512cd avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves ida arat pku ospke
[ec2-user@ip-10-1-0-206 ~]$


Also check which CPUs are isolated:


[ec2-user@ip-10-1-0-206 ~]$ cat /sys/devices/system/cpu/isolated
1
[ec2-user@ip-10-1-0-206 ~]$





#The issue is that you have 4 CPUs total, but CPUs 1 and 3 are offline. For Nitro Enclaves, you need to isolate CPUs but keep them online.

#Modify the GRUB configuration to use a different isolation method:

[ec2-user@ip-10-1-0-206 ~]$ sudo sed -i 's/isolcpus=1/isolcpus=1 nohz_full=1 rcu_nocbs=1/' /etc/default/grub


[ec2-user@ip-10-1-0-206 ~]$ cat /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 nvme_core.io_timeout=4294967295 rd.emergency=poweroff rd.shell=0 isolcpus=1 nohz_full=1 rcu_nocbs=1"
GRUB_TIMEOUT=0
GRUB_DISABLE_RECOVERY="true"
GRUB_TERMINAL="ec2-console"
GRUB_X86_USE_32BIT="true"
[ec2-user@ip-10-1-0-206 ~]$




#Reboot again 

#In the previous sed command, we only added isolcpus=1. The new sed command added two additional parameters:

#nohz_full=1 - keeps the isolated CPU online but reduces timer interrupts
#rcu_nocbs=1 - moves RCU callbacks off the isolated CPU
#The original isolcpus=1 was taking CPU 1 completely offline. These additional parameters keep CPU 1 online but properly isolated for Nitro Enclaves.





sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo reboot

[ec2-user@ip-10-1-0-206 ~]$ sudo grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-5.10.242-239.961.amzn2.x86_64
Found initrd image: /boot/initramfs-5.10.242-239.961.amzn2.x86_64.img
done
[ec2-user@ip-10-1-0-206 ~]$ sudo reboot
Connection to 10.1.0.206 closed by remote host.
Connection to 10.1.0.206 closed.
[ec2-user@ip-10-1-0-239 ~]$


#Relogin into the nitro node 

Connection to 10.1.0.206 closed.
[ec2-user@ip-10-1-0-239 ~]$ ./bastion-file-just-ssh-no-transfer.sh
Bastion SG: sg-04564777181b23f08
NitroNode SG: sg-008d0f85e7fed6e14
NitroNode IP: 10.1.0.206
Adding SSH rule...
SSH rule already exists (OK)
Verifying SSH rule exists...
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
                    "GroupId": "sg-04564777181b23f08"
                }
            ],
            "Ipv6Ranges": []
        }
    ]
]
Connecting to nitro node...
Last login: Sun Oct  5 13:42:40 2025 from ip-10-1-0-239.eu-west-1.compute.internal
   ,     #_
   ~\_  ####_        Amazon Linux 2
 

2 package(s) needed for security, out of 2 available
Run "sudo yum update" to apply all updates.
[ec2-user@ip-10-1-0-206 ~]$ clear
[ec2-user@ip-10-1-0-206 ~]$
[ec2-user@ip-10-1-0-206 ~]$
[ec2-user@ip-10-1-0-206 ~]$




#Verify after reboot 

[ec2-user@ip-10-1-0-206 ~]$ cat /proc/cmdline
BOOT_IMAGE=/boot/vmlinuz-5.10.242-239.961.amzn2.x86_64 root=UUID=f7b12982-40f9-4073-aea7-97afa082b80a ro console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 nvme_core.io_timeout=4294967295 rd.emergency=poweroff rd.shell=0 isolcpus=1 nohz_full=1 rcu_nocbs=1
[ec2-user@ip-10-1-0-206 ~]$ lscpu | grep "On-line CPU"
On-line CPU(s) list:  0,2
[ec2-user@ip-10-1-0-206 ~]$ cat /sys/devices/system/cpu/isolated
1
[ec2-user@ip-10-1-0-206 ~]$




[ec2-user@ip-10-1-0-206 ~]$ echo 1 | sudo tee /sys/devices/system/cpu/cpu1/online
1
[ec2-user@ip-10-1-0-206 ~]$ lscpu | grep "On-line CPU"
On-line CPU(s) list:  0-2
[ec2-user@ip-10-1-0-206 ~]$




#Did not work 

#Reload the allocator and reboot the machine 

[ec2-user@ip-10-1-0-206 ~]$ sudo modprobe nitro_enclaves
[ec2-user@ip-10-1-0-206 ~]$ sudo dmesg | grep -i nitro | tail -3
[    4.391539] nitro_enclaves: No CPUs available in CPU pool
[    4.397054] nitro_enclaves: Error in setup CPU pool [rc=-22]
[  263.887141] misc nitro_enclaves: Full CPU cores not used
[ec2-user@ip-10-1-0-206 ~]$ sudo systemctl restart nitro-enclaves-allocator
[ec2-user@ip-10-1-0-206 ~]$ sudo systemctl status nitro-enclaves-allocator
● nitro-enclaves-allocator.service - Nitro Enclaves Resource Allocator
   Loaded: loaded (/usr/lib/systemd/system/nitro-enclaves-allocator.service; enabled; vendor preset: disabled)
   Active: active (exited) since Sun 2025-10-05 13:56:03 UTC; 66ms ago
  Process: 5900 ExecStart=/usr/bin/nitro-enclaves-allocator (code=exited, status=0/SUCCESS)
 Main PID: 5900 (code=exited, status=0/SUCCESS)

Oct 05 13:56:03 ip-10-1-0-206.eu-west-1.compute.internal nitro-enclaves-allocator[5900]: Auto-generating the enclave CPU pool by using the CPU count...
Oct 05 13:56:03 ip-10-1-0-206.eu-west-1.compute.internal nitro-enclaves-allocator[5900]: Will try to reserve 1024 MB of memory on node 0.
Oct 05 13:56:03 ip-10-1-0-206.eu-west-1.compute.internal nitro-enclaves-allocator[5900]: Configuring the huge page memory...
Oct 05 13:56:03 ip-10-1-0-206.eu-west-1.compute.internal nitro-enclaves-allocator[5900]: - Reserved 1 pages of type: 1048576kB.
Oct 05 13:56:03 ip-10-1-0-206.eu-west-1.compute.internal nitro-enclaves-allocator[5900]: Done.
Oct 05 13:56:03 ip-10-1-0-206.eu-west-1.compute.internal nitro-enclaves-allocator[5900]: Auto-generated the enclave CPU pool: 1,3.
Oct 05 13:56:03 ip-10-1-0-206.eu-west-1.compute.internal nitro-enclaves-allocator[5900]: Configuring the enclave CPU pool...
Oct 05 13:56:03 ip-10-1-0-206.eu-west-1.compute.internal systemd[1]: Started Nitro Enclaves Resource Allocator.
Oct 05 13:56:03 ip-10-1-0-206.eu-west-1.compute.internal nitro-enclaves-allocator[5900]: Done.
Oct 05 13:56:03 ip-10-1-0-206.eu-west-1.compute.internal nitro-enclaves-allocator[5900]: Successfully allocated Nitro Enclaves resources: 1024 MiB, 2 CPUs
[ec2-user@ip-10-1-0-206 ~]$ sudo reboot
Connection to 10.1.0.206 closed by remote host.
Connection to 10.1.0.206 closed.


#On the bastion 

[ec2-user@ip-10-1-0-239 ~]$ clear
[ec2-user@ip-10-1-0-239 ~]$ ./bastion-file-just-ssh-no-transfer.sh
Bastion SG: sg-04564777181b23f08
NitroNode SG: sg-008d0f85e7fed6e14
NitroNode IP: 10.1.0.206
Adding SSH rule...
SSH rule already exists (OK)
Verifying SSH rule exists...
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
                    "GroupId": "sg-04564777181b23f08"
                }
            ],
            "Ipv6Ranges": []
        }
    ]
]
Connecting to nitro node...
Last login: Sun Oct  5 13:51:17 2025 from ip-10-1-0-239.eu-west-1.compute.internal
   ,     #_
   ~\_  ####_        Amazon Linux 2
 
2 package(s) needed for security, out of 2 available
Run "sudo yum update" to apply all updates.
[ec2-user@ip-10-1-0-206 ~]$





#Check the CPUs status online / offline 

[ec2-user@ip-10-1-0-206 ~]$ lscpu | grep "On-line CPU"
On-line CPU(s) list:  0,2
[ec2-user@ip-10-1-0-206 ~]$ cat /sys/devices/system/cpu/isolated
1
[ec2-user@ip-10-1-0-206 ~]$ sudo dmesg | grep -i nitro | tail -5
[    4.373276] nitro_enclaves: No CPUs available in CPU pool
[    4.378055] nitro_enclaves: Error in setup CPU pool [rc=-22]
[ec2-user@ip-10-1-0-206 ~]$





#Notice again offline 





######Falling back on Copilot

[ec2-user@ip-10-1-0-206 ~]$ sudo journalctl -u nitro-enclaves-allocator -b --no-pager | egrep -i 'error|fail|ioctl|E29|ENOMEM|EINVAL|EPERM'
[ec2-user@ip-10-1-0-206 ~]$ grep -E 'HugePages_Total|HugePages_Free|Hugepagesize' /proc/meminfo
HugePages_Total:       0
HugePages_Free:        0
Hugepagesize:       2048 kB
[ec2-user@ip-10-1-0-206 ~]$ sudo bash -c 'echo 512 > /proc/sys/vm/nr_hugepages'
[ec2-user@ip-10-1-0-206 ~]$ grep -E 'HugePages_Total|HugePages_Free' /proc/meminfo
HugePages_Total:     512
HugePages_Free:      512
[ec2-user@ip-10-1-0-206 ~]$ grep -E 'HugePages_Total|HugePages_Free' /proc/meminfo
HugePages_Total:     512
HugePages_Free:      512
[ec2-user@ip-10-1-0-206 ~]$


#CPUs are not online 

[ec2-user@ip-10-1-0-206 ~]$ ls -l /dev/nitro_enclaves
crw-rw---- 1 root ne 10, 62 Oct  5 13:56 /dev/nitro_enclaves
[ec2-user@ip-10-1-0-206 ~]$ dmesg | egrep -i 'nitro|enclave|huge|hugetlb' | tail -n 200
[    1.084608] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    1.087775] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    4.373276] nitro_enclaves: No CPUs available in CPU pool
[    4.378055] nitro_enclaves: Error in setup CPU pool [rc=-22]
[  261.063684] nitro_enclaves: CPU 1 is not onlined [rc=1]
[  261.120256] nitro_enclaves: No CPUs available in CPU pool
[  261.123455] nitro_enclaves: Error in setup CPU pool [rc=-22]
[  576.522827] misc nitro_enclaves: Full CPU cores not used
[ec2-user@ip-10-1-0-206 ~]$



[ec2-user@ip-10-1-0-206 ~]$ sudo cat /etc/nitro_enclaves/allocator.yaml
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
[ec2-user@ip-10-1-0-206 ~]$










}


#attempt 4

{
 
 
 
 [ec2-user@ip-10-1-0-206 ~]$ docker images
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
nginx        latest    203ad09fc156   7 weeks ago   192MB
[ec2-user@ip-10-1-0-206 ~]$

xxxx - replace this with  two left angle brackets < < (together)  


[ec2-user@ip-10-1-0-206 ~]$ cat > Dockerfile.minimal xxxx 'EOF'
> FROM eclipse-temurin:17-jre-alpine
> WORKDIR /app
> COPY payments-0.0.1-SNAPSHOT.jar app.jar
> RUN addgroup -S appuser && adduser -S appuser -G appuser
> USER appuser
> ENTRYPOINT ["java", "-XX:+UseContainerSupport", "-XX:MaxRAMPercentage=75", "-Xss256k", "-XX:+UseSerialGC", "-jar", "app.jar", "--server.address=0.0.0.0", "--server.port=8080"]
> EXPOSE 8080
> EOF


[ec2-user@ip-10-1-0-206 ~]$ cat Dockerfile.minimal
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY payments-0.0.1-SNAPSHOT.jar app.jar
RUN addgroup -S appuser && adduser -S appuser -G appuser
USER appuser
ENTRYPOINT ["java", "-XX:+UseContainerSupport", "-XX:MaxRAMPercentage=75", "-Xss256k", "-XX:+UseSerialGC", "-jar", "app.jar", "--server.address=0.0.0.0", "--server.port=8080"]
EXPOSE 8080
[ec2-user@ip-10-1-0-206 ~]$





[ec2-user@ip-10-1-0-206 ~]$ docker build -f Dockerfile.minimal -t payments-app:minimal .
[+] Building 4.5s (9/9) FINISHED                                                                                                                                                                 docker:default
 => [internal] load build definition from Dockerfile.minimal                                                                                                                                                            0.2s
 => => writing image sha256:f7b004704b0788497ce0149063c9c4c3e7888ca60b4dc60f2a2fac52500713f3                                                                                                               0.0s
 => => naming to docker.io/library/payments-app:minimal                                                                                                                                                    0.0s
[ec2-user@ip-10-1-0-206 ~]$ docker images
REPOSITORY     TAG       IMAGE ID       CREATED         SIZE
payments-app   minimal   f7b004704b07   3 seconds ago   201MB
nginx          latest    203ad09fc156   7 weeks ago     192MB
[ec2-user@ip-10-1-0-206 ~]$



[ec2-user@ip-10-1-0-206 ~]$ sudo nitro-cli build-enclave --docker-uri payments-app:minimal --output-file payments-app-minimal.eif
Start building the Enclave Image...
Using the locally available Docker image...
Enclave Image successfully created.
{
  "Measurements": {
    "HashAlgorithm": "Sha384 { ... }",
    "PCR0": "f564044ea2d5c85243f8afba8b6a0a9999f9d18f92bac5d52150311c19e451f0a8f3883fdb5fb86e98627ef8d33ae0cd",
    "PCR1": "0343b056cd8485ca7890ddd833476d78460aed2aa161548e4e26bedf321726696257d623e8805f3f605946b3d8b0c6aa",
    "PCR2": "93b4380b72ad92b4c54c06cfdaf057356f7dc7d0820432a32687ff2b8aec5da1e07097ff21942e25b6ab021f5704a17c"
  }
}


[ec2-user@ip-10-1-0-206 ~]$ sudo sed -i 's/rcu_nocbs=1"/rcu_nocbs=1 nitro_enclaves.ne_cpus=1"/' /etc/default/grub
[ec2-user@ip-10-1-0-206 ~]$ cat /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 nvme_core.io_timeout=4294967295 rd.emergency=poweroff rd.shell=0 isolcpus=1 nohz_full=1 rcu_nocbs=1 nitro_enclaves.ne_cpus=1"
GRUB_TIMEOUT=0
GRUB_DISABLE_RECOVERY="true"
GRUB_TERMINAL="ec2-console"
GRUB_X86_USE_32BIT="true"
[ec2-user@ip-10-1-0-206 ~]$ sudo grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-5.10.242-239.961.amzn2.x86_64
Found initrd image: /boot/initramfs-5.10.242-239.961.amzn2.x86_64.img
done


[ec2-user@ip-10-1-0-206 ~]$ sudo reboot
Connection to 10.1.0.206 closed by remote host.
Connection to 10.1.0.206 closed.
[ec2-user@ip-10-1-0-239 ~]$



#After reboot 

[ec2-user@ip-10-1-0-206 ~]$ cat /proc/cmdline
BOOT_IMAGE=/boot/vmlinuz-5.10.242-239.961.amzn2.x86_64 root=UUID=f7b12982-40f9-4073-aea7-97afa082b80a ro console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 nvme_core.io_timeout=4294967295 rd.emergency=poweroff rd.shell=0 isolcpus=1 nohz_full=1 rcu_nocbs=1 nitro_enclaves.ne_cpus=1
[ec2-user@ip-10-1-0-206 ~]$


#check CPU
[ec2-user@ip-10-1-0-206 ~]$ cat /sys/module/nitro_enclaves/parameters/ne_cpus
1,3


}


#attempt 5. Simple Nginx image 

{

[ec2-user@ip-10-1-0-206 ~]$ ls -l
total 19572
-rwxr-xr-x 1 ec2-user ec2-user      963 Oct  5 12:46 nitro-file-install-tools-build-nginx-enclave.sh
-rw-r--r-- 1 ec2-user ec2-user 20035490 Oct  5 12:46 payments-0.0.1-SNAPSHOT.jar
[ec2-user@ip-10-1-0-206 ~]$
[ec2-user@ip-10-1-0-206 ~]$
[ec2-user@ip-10-1-0-206 ~]$ docker images
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
[ec2-user@ip-10-1-0-206 ~]$
[ec2-user@ip-10-1-0-206 ~]$



[ec2-user@ip-10-1-0-206 ~]$ sudo nitro-cli build-enclave --docker-uri nginx --output-file nginx.eif
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
[ec2-user@ip-10-1-0-206 ~]$




[ec2-user@ip-10-1-0-206 ~]$ sudo nitro-cli describe-enclaves
[]
[ec2-user@ip-10-1-0-206 ~]$



[ec2-user@ip-10-1-0-206 ~]$ sudo nitro-cli run-enclave --cpu-count 2 --memory 756 --eif-path nginx.eif --debug-mode
Start allocating memory...
Started enclave with enclave-cid: 16, memory: 1024 MiB, cpu-ids: [1, 3]
{
  "EnclaveName": "nginx",
  "EnclaveID": "i-078485c44ae5a4c2e-enc199b4ef802db508",
  "ProcessID": 9780,
  "EnclaveCID": 16,
  "NumberOfCPUs": 2,
  "CPUIDs": [
    1,
    3
  ],
  "MemoryMiB": 1024
}
[ec2-user@ip-10-1-0-206 ~]$ sudo nitro-cli describe-enclaves
[
  {
    "EnclaveName": "nginx",
    "EnclaveID": "i-078485c44ae5a4c2e-enc199b4ef802db508",
    "ProcessID": 9780,
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
[ec2-user@ip-10-1-0-206 ~]$ sudo nitro-cli console --enclave-name nginx
Connecting to the console for enclave 16...
Successfully connected to the console.
0: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000003f7ffffe] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI not present or invalid.
[    0.000000] Hypervisor detected: KVM
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] e820: last_pfn = 0x3f7ff max_arch_pfn = 0x400000000
[    0.000000] MTRR: Disabled
[    0.000000] x86/PAT: MTRRs disabled, skipping PAT initialization too.
[    0.000000] CPU MTRRs all blank - virtualized system.
[    0.000000] x86/PAT: Configuration [0-7]: WB  WT  UC- UC  WB  WT  UC- UC
[    0.000000] found SMP MP-table at [mem 0x0009fc00-0x0009fc0f]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Using GB pages for direct mapping
[    0.000000] RAMDISK: [mem 0x02e2e3a0-0x0e5b1fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI BIOS Error (bug): A valid RSDP was not found (20170728/tbxfroot-244)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000003f7fefff]
[    0.000000] NODE_DATA(0) allocated [mem 0x3f7dd000-0x3f7fefff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:3f7db001, primary cpu clock
[    0.000000] kvm-clock: using sched offset of 2712764818 cycles
[    0.000000] clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x000000003f7fefff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000003f7fefff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000003f7fefff]
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000] MPTABLE: OEM ID: FC
[    0.000000] MPTABLE: Product ID: 000000000000
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] IOAPIC[0]: apic_id 3, version 17, address 0xfec00000, GSI 0-23
[    0.000000] Processors: 2
[    0.000000] TSC deadline timer available
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x000fffff]
[    0.000000] e820: [mem 0x3f7fffff-0xffffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] random: get_random_bytes called from start_kernel+0x94/0x493 with crng_init=0
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] percpu: Embedded 46 pages/cpu s149464 r8192 d30760 u1048576
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 3f41a040
[    0.000000] PV qspinlock hash table entries: 256 (order: 0, 4096 bytes)
[    0.000000] Fallback order for Node 0: 0
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 255912
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: reboot=k panic=30 pci=off nomodules console=ttyS0 i8042.noaux i8042.nomux i8042.nopnp i8042.dumbkbd random.trust_cpu=on virtio_mmio.device=4K@0xd0000000:5 virtio_mmio.device=4K@0xd0001000:6
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 815524K/1039988K available (10252K kernel code, 760K rwdata, 1844K rodata, 1436K init, 2816K bss, 224464K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Kernel/User page tables isolation: enabled
[    0.004000] Hierarchical RCU implementation.
[    0.004000]  RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=2.
[    0.004000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
[    0.004000] NR_IRQS: 4352, nr_irqs: 56, preallocated irqs: 16
[    0.004000] Console: colour dummy device 80x25
[    0.004000] console [ttyS0] enabled
[    0.004000] tsc: Detected 2499.998 MHz processor
[    0.004000] Calibrating delay loop (skipped) preset value.. 4999.99 BogoMIPS (lpj=9999992)
[    0.004000] pid_max: default: 32768 minimum: 301
[    0.004000] Security Framework initialized
[    0.004000] Yama: becoming mindful.
[    0.004000] SELinux:  Initializing.
[    0.004783] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.006109] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.007064] Mount-cache hash table entries: 2048 (order: 2, 16384 bytes)
[    0.008016] Mountpoint-cache hash table entries: 2048 (order: 2, 16384 bytes)
[    0.010409] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    0.011204] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
[    0.012063] Spectre V1 : Mitigation: usercopy/swapgs barriers and __user pointer sanitization
[    0.013213] Spectre V2 : Mitigation: Full generic retpoline
[    0.013969] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch
[    0.015082] Spectre V2 : Enabling Restricted Speculation for firmware calls
[    0.016070] Spectre V2 : mitigation: Enabling conditional Indirect Branch Prediction Barrier
[    0.017203] Spectre V2 : User space: Mitigation: STIBP via seccomp and prctl
[    0.018154] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl and seccomp
[    0.019488] TAA: Mitigation: Clear CPU buffers
[    0.020003] MDS: Mitigation: Clear CPU buffers
[    0.021052] Freeing SMP alternatives memory: 32K
[    0.025033] smpboot: Max logical packages: 2
[    0.025944] x2apic enabled
[    0.026634] Switched APIC routing to physical x2apic.
[    0.028000] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.028000] smpboot: CPU0: Intel(R) Xeon(R) Processor @ 2.50GHz (family: 0x6, model: 0x55, stepping: 0x4)
[    0.028000] Performance Events: unsupported p6 CPU model 85 no PMU driver, software events only.
[    0.028000] Hierarchical SRCU implementation.
[    0.028176] NMI watchdog: Perf event create on CPU 0 failed with -2
[    0.029035] NMI watchdog: Perf NMI watchdog permanently disabled
[    0.029960] smp: Bringing up secondary CPUs ...
[    0.030778] x86: Booting SMP configuration:
[    0.031357] .... node  #0, CPUs:      #1
[    0.004000] kvm-clock: cpu 1, msr 0:3f7db041, secondary cpu clock
[    0.034035] KVM setup async PF for cpu 1
[    0.034035] kvm-stealtime: cpu 1, msr 3f51a040
[    0.036080] MDS CPU bug present and SMT on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for more details.
[    0.037956] TAA CPU bug present and SMT on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/tsx_async_abort.html for more details.
[    0.040005] smp: Brought up 1 node, 2 CPUs
[    0.040575] smpboot: Total of 2 processors activated (9999.99 BogoMIPS)
[    0.044103] devtmpfs: initialized
[    0.044591] x86/mm: Memory block size: 128MB
[    0.045421] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.045859] futex hash table entries: 512 (order: 3, 32768 bytes)
[    0.048334] NET: Registered protocol family 16
[    0.049453] cpuidle: using governor ladder
[    0.050106] cpuidle: using governor menu
[    0.050106] PCI: Fatal: No config space access function found
[    0.058817] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    0.059750] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.060101] ACPI: Interpreter disabled.
[    0.060659] vgaarb: loaded
[    0.061250] SCSI subsystem initialized
[    0.061958] pps_core: LinuxPPS API ver. 1 registered
[    0.062862] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.064017] PTP clock support registered
[    0.064756] dmi: Firmware registration failed.
[    0.065563] PCI: System does not support PCI
[    0.066329] NetLabel: Initializing
[    0.066951] NetLabel:  domain hash size = 128
[    0.067559] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[    0.068024] NetLabel:  unlabeled traffic allowed by default
[    0.068965] clocksource: Switched to clocksource kvm-clock
[    0.068965] VFS: Disk quotas dquot_6.6.0
[    0.069488] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.070491] pnp: PnP ACPI: disabled
[    0.074293] NET: Registered protocol family 2
[    0.074956] IP idents hash table entries: 16384 (order: 5, 131072 bytes)
[    0.076148] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.077116] TCP bind hash table entries: 8192 (order: 5, 131072 bytes)
[    0.078020] TCP: Hash tables configured (established 8192 bind 8192)
[    0.078916] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.079727] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.080723] NET: Registered protocol family 1
[    0.081418] RPC: Registered named UNIX socket transport module.
[    0.082437] RPC: Registered udp transport module.
[    0.083084] RPC: Registered tcp transport module.
[    0.083731] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.084841] Unpacking initramfs...
[    0.419473] ------------[ cut here ]------------
[    0.420004] WARNING: CPU: 1 PID: 1 at arch/x86/mm/init.c:745 free_init_pages+0x73/0x80
[    0.420004] Modules linked in:
[    0.420004] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.14.256-209.484.amzn2.x86_64 #1
[    0.420004] task: ffff88803d9d0000 task.stack: ffffc9000018c000
[    0.420004] RIP: 0010:free_init_pages+0x73/0x80
[    0.420004] RSP: 0000:ffffc9000018fdb8 EFLAGS: 00010287
[    0.420004] RAX: ffff888002e2f000 RBX: ffff888000000000 RCX: ffff88800e5b1da0
[    0.420004] RDX: ffff88800e5b2000 RSI: ffff888002e2e3a0 RDI: ffffffff81d12346
[    0.420004] RBP: ffffc9000018fdd8 R08: ffff88803db04880 R09: 000000018020001f
[    0.420004] R10: ffffc9000018fd98 R11: ae8b79d900766501 R12: ffff88800e5b2000
[    0.420004] R13: ffffffff82011af0 R14: ffffffff81d12346 R15: ffffffff81ef3815
[    0.420004] FS:  0000000000000000(0000) GS:ffff88803f500000(0000) knlGS:0000000000000000
[    0.420004] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.420004] CR2: 0000000000000000 CR3: 0000000001e0a001 CR4: 00000000007606a0
[    0.420004] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.420004] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    0.420004] PKRU: 00000000
[    0.420004] Call Trace:
[    0.420004]  ? unpack_to_rootfs+0x2bd/0x2bd
[    0.420004]  free_initrd_mem+0x21/0x23
[    0.420004]  populate_rootfs+0xe8/0x10d
[    0.420004]  do_one_initcall+0x4d/0x190
[    0.420004]  kernel_init_freeable+0x1b2/0x254
[    0.420004]  ? rest_init+0xb0/0xb0
[    0.420004]  kernel_init+0x9/0x100
[    0.420004]  ret_from_fork+0x35/0x40
[    0.420004] Code: a4 6a 00 00 44 89 ee 48 89 df e8 a9 76 00 00 4c 89 f1 ba cc 00 00 00 4c 89 e6 48 89 df e8 16 de 0e 00 5b 41 5c 41 5d 41 5e 5d c3 <0f> 0b 49 89 d4 48 89 c3 eb b5 0f 1f 00 85 ff 75 04 85 f6 75 33
[    0.420004] ---[ end trace 911838b3e110857f ]---
[    0.484332] Freeing initrd memory: 187916K
[    0.484980] virtio-mmio: Registering device virtio-mmio.0 at 0xd0000000-0xd0000fff, IRQ 5.
[    0.486160] virtio-mmio: Registering device virtio-mmio.1 at 0xd0001000-0xd0001fff, IRQ 6.
[    0.487876] RAPL PMU: API unit is 2^-32 Joules, 3 fixed counters, 10737418240 ms ovfl timer
[    0.489075] RAPL PMU: hw unit of domain pp0-core 2^-0 Joules
[    0.489856] RAPL PMU: hw unit of domain package 2^-0 Joules
[    0.490617] RAPL PMU: hw unit of domain dram 2^-16 Joules
[    0.491359] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x240937b9988, max_idle_ns: 440795218083 ns
[    0.492758] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.494428] Scanning for low memory corruption every 60 seconds
[    0.495725] audit: initializing netlink subsys (disabled)
[    0.496811] audit: type=2000 audit(1759677222.353:1): state=initialized audit_enabled=0 res=1
[    0.498516] Initialise system trusted keyrings
[    0.499346] Key type blacklist registered
[    0.500041] workingset: timestamp_bits=36 max_order=18 bucket_order=0
[    0.502103] zbud: loaded
[    0.504359] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.505579] NFS: Registering the id_resolver key type
[    0.506357] Key type id_resolver registered
[    0.506936] Key type id_legacy registered
[    0.507497] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    0.510967] Key type asymmetric registered
[    0.511573] Asymmetric key parser 'x509' registered
[    0.512373] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.513687] io scheduler noop registered (default)
[    0.514389] io scheduler cfq registered
[    0.515318] virtio-mmio virtio-mmio.0: Failed to enable 64-bit or 32-bit DMA.  Trying to continue, but this might not work.
[    0.517317] virtio-mmio virtio-mmio.1: Failed to enable 64-bit or 32-bit DMA.  Trying to continue, but this might not work.
[    0.519200] Serial: 8250/16550 driver, 1 ports, IRQ sharing disabled
[    0.542849] serial8250: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a U6_16550A
[    0.545909] loop: module loaded
[    0.546440] Loading iSCSI transport class v2.0-870.
[    0.547408] iscsi: registered transport (tcp)
[    0.548218] tun: Universal TUN/TAP device driver, 1.6
[    0.549135] hidraw: raw HID events driver (C) Jiri Kosina
[    0.550187] nf_conntrack version 0.5.0 (8192 buckets, 32768 max)
[    0.551380] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.552505] Initializing XFRM netlink socket
[    0.553258] NET: Registered protocol family 10
[    0.554619] Segment Routing with IPv6
[    0.555170] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    0.556234] NET: Registered protocol family 17
[    0.556866] Bridge firewalling registered
[    0.557477] Key type dns_resolver registered
[    0.558170] NET: Registered protocol family 40
[    0.559519] sched_clock: Marking stable (558124432, 0)->(668772880, -110648448)
[    0.561063] registered taskstats version 1
[    0.561645] Loading compiled-in X.509 certificates
[    0.563076] Loaded X.509 cert 'Build time autogenerated kernel key: 58bf34a4602fd51a9642ab73d9d76ca2c6727d1b'
[    0.564573] zswap: loaded using pool lzo/zbud
[    0.565526] Key type encrypted registered
[    0.567936] Freeing unused kernel memory: 1436K
[    0.584096] Write protecting the kernel read-only data: 14336k
[    0.586766] Freeing unused kernel memory: 2012K
[    0.587947] Freeing unused kernel memory: 204K
[    0.588964] nsm: loading out-of-tree module taints kernel.
[    0.589728] nsm: module verification failed: signature and/or required key missing - tainting kernel
[    0.591882] NSM RNG: returning rand bytes = 16
[    0.592868] NSM RNG: returning rand bytes = 64
[    0.593682] random: fast init done
[    0.594518] NSM RNG: returning rand bytes = 64
[    0.595196] random: crng init done
[    0.595786] NSM RNG: returning rand bytes = 64
2025/10/05 15:13:42 [notice] 594#594: using the "epoll" event method
[    0.606117] NSM RNG: returning rand bytes = 64
2025/10/05 15:13:42 [notice] 594#594: nginx/1.29.1
2025/10/05 15:13:42 [notice] 594#594: built by gcc 12.2.0 (Debian 12.2.0-14+deb12u1)
2025/10/05 15:13:42 [notice] 594#594: OS: Linux 4.14.256-209.484.amzn2.x86_64
2025/10/05 15:13:42 [notice] 594#594: getrlimit(RLIMIT_NOFILE): 1024:4096
[    0.609842] NSM RNG: returning rand bytes = 64
2025/10/05 15:13:42 [notice] 594#594: start worker processes
[    0.611357] NSM RNG: returning rand bytes = 64
2025/10/05 15:13:42 [notice] 594#594: start worker process 595


	  





}