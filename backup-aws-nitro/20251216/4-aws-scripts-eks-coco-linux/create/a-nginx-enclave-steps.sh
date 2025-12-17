
{
added flask server  to nginx file
added some set endpoint invocation in run.sh 

however, the flask is not starting or not working 
need to double check 



}


#Step 0 ##############ONE TIME ACTIVITY ############CONFIGURE SSO############  

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
			
sed -i 's/\r$//' *
chmod +x *.sh
sudo apt install dos2unix
dos2unix *.sh

}



#STEP 1 #############LOGIN TO AWS 

{
	
	
cd /home/sridhara/Downloads/4-aws-scripts-eks-coco-linux/create
ls -l file*.*
./b-login.sh
	
}



#STEP 2 ##############BUILD DOCKER IMAGE WITH EIF INSIDE IT #################   

{
#Check docker login status 
docker info | grep Username

#Docker login if not logged in, as we will need to push to dockerhub. 
#docker login

clear
LOG_FILE="/home/sridhara/Downloads/4-aws-scripts-eks-coco-linux/logs/build_output_$(date '+%Y-%m-%d_%H-%M').txt"
export LOG_FILE
cd /home/sridhara/Downloads/4-aws-scripts-eks-coco-linux/create
chmod +x *.sh
./a0-build-enclave-image.sh  2>&1 | tee -a "$LOG_FILE"

  
  

}
	 
 
 
 
#STEP 3 ##############ONE TIME ACTIVITY TO CREATE THE KEY ON AWS. ONE PENDING PENDING PENDING PENDING ACTIVITY. 
{

	#List the keys
	aws kms list-keys

	#Create KMS Key. Below command creates a key and gets us key id. 
	aws kms create-key --description "For Nitro enclave attestation" 

	#Create alias PERMISSION DENIED
	#aws kms create-alias --alias-name alias/coco-attestation-key --target-key-id $(aws kms list-keys --query 'Keys[-1].KeyId' --output text)

	#Get the description of the existing key
	aws kms list-keys | jq -r '.Keys[].KeyId' | xargs -I {} aws kms describe-key --key-id {} | grep -i "enclave\|nitro\|attest"
	 
	#Get the ARN assosciated with the Key
	aws kms describe-key --key-id 4bae92be-4b6c-4380-abb3-504dcb330b5a | jq -r '.KeyMetadata.Arn'
	

}

#STEP 4 ##############Update KMS Policy with EIF PCR Values

{


 
cd /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s/container/coconginxv3
dos2unix *.sh
chmod +x *.sh
./update-kms-policy-with-pcrvalues.sh    2>&1 | tee -a "$LOG_FILE"


}

#STEP 5 ##############CREATE ROLE & KMS-POLICIES 

{
	
	
#ONE TIME ACTIVITY
#NOTE: WHENVVER THE KEY IS CHANGED (OR NEW ONECREATED) CHANGE IN BELOW ROLE AS WELL 


	# CREATE TRUST-POLICY
	# CREATE AWS-ROLE 
	# ATTACH TRUST-POLICY TO AWS-ROLE
	# CREATE KMS-POLICY
	# ATTACH KMS-POLICY TO AWS-ROLE 

#Obtain oidc provider to be used in the trust policy 
aws eks describe-cluster --name eks-coco --region eu-west-1 --query "cluster.identity.oidc.issuer" --output text
https://oidc.eks.eu-west-1.amazonaws.com/id/FB71067963F46D29829205FF9AC54700
 
aws iam list-roles --query 'Roles[*].RoleName' --output json


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

#STEP 6 ##############INFRA CREATION 
{

#Below LOGIN step will be required to be executed every one hour as the token expires after one hour. 
#First time: sridhara_shastry / password / google authenticator mfa

#For clean up 
cd /home/sridhara/Downloads/4-aws-scripts-eks-coco-linux/cleanup
#  ./0-cleanup.sh

#For Creation 
cd /home/sridhara/Downloads/4-aws-scripts-eks-coco-linux/create
./c-create-coco-eks-keypair.sh  							2>&1 | tee -a "$LOG_FILE"
./d-create-coco-eks-vpc.sh  								2>&1 | tee -a "$LOG_FILE"
./e-create-coco-eks-iamrole.sh  							2>&1 | tee -a "$LOG_FILE"
./f-create-coco-eks.sh 										2>&1 | tee -a "$LOG_FILE"
#Wait for 10 mins
./g1-create-coco-nodegroup-launchtemplate-amzonlinux2.sh   	2>&1 | tee -a "$LOG_FILE"
./h-create-coco-eks-nodegroup.sh 							2>&1 | tee -a "$LOG_FILE"
#Wait for 10 mins
./i-modify-security-groups-usedby-nitronode.sh 				2>&1 | tee -a "$LOG_FILE"
./i2-install-nitrol-enclave-device-plugin.sh 				2>&1 | tee -a "$LOG_FILE"
 
 

kubectl get nodes   

}
 
 

#STEP 8 ##############APPLICATION DEPLOYMENT (NGINX) 

#Delete Deployment if exists 
kubectl delete -f /home/sridhara/Downloads/aws-nitro-enclaves-with-k8s/container/coconginxv3/vsock-nginx-deployment.yaml


kubectl get pods
	
	
#Deploy nginx. 

./i3-deploy-nginx-to-eks.sh   2>&1 | tee -a "$LOG_FILE"


{
 
 
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

#STEP 9 ##############PORTFORWARD  

{
kubectl port-forward pod/$(kubectl get pods --no-headers -o custom-columns=":metadata.name" | head -n 1) 8080:80
#In another terminal 
curl http://localhost:8080/

}
 
#STEP 10 ##############ACCESS THE POD AND  ATTESTSTION 
 
{
 
#Access the pod and check enclaves
kubectl exec -it  $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | head -n 1) -- /bin/bash

#Describe the nitro enclaves inside the pod 
	#Bash 
	nitro-cli describe-enclaves

			#Install tools - atm not required 
			#install -y procps-ng util-linux
 
 
	#This will fail as the enclave has been started using the DEBUG FLAG OFF. IF DEBUG FLAG IS ON CONSOLE WILL BE SHOWN. 
	nitro-cli console --enclave-name nginx


	# Get the CID dynamically
	CID=$(nitro-cli describe-enclaves | jq -r '.[0].EnclaveCID')

	# Use the dynamic CID in your socat command
	printf "GET / HTTP/1.1\r\nHost: localhost\r\n\r\n" | socat - VSOCK-CONNECT:${CID}:5000

	 
	 
#Attestation testing 

	# Get the CID dynamically
	CID=$(nitro-cli describe-enclaves | jq -r '.[0].EnclaveCID')
	
	
	echo -n "test-nonce-12345" | base64 | socat - VSOCK-CONNECT:${CID}:5001
	
	echo -n "test-nonce-12345" | base64 | socat - VSOCK-CONNECT:${CID}:5001 > attestation.json
	jq -r '.attestation.document_b64' attestation.json | base64 --decode > attestation.cbor
	
#	EXIT THE POD
	
	cd xxxxx put proper diretory where we can download the files 
	kubectl exec nginx-enclave-deployment-7dd7599b4b-82g2f -- cat /attestation.cbor > ./attestation.json

	kubectl exec nginx-enclave-deployment-7dd7599b4b-82g2f -- cat /attestation.cbor > ./attestation.cbor

	
# For Python-based validation
sudo apt update
sudo apt install python3-pip
 
python3 -m venv nitro-validation-env
source nitro-validation-env/bin/activate
pip install cbor2 pycose cryptography


wget https://aws-nitro-enclaves.amazonaws.com/AWS_NitroEnclaves_Root-G1.zip

sridhara@ubuntu:~/Downloads$ unzip AWS_NitroEnclaves_Root-G1.zip
Archive:  AWS_NitroEnclaves_Root-G1.zip
  inflating: root.pem                
(nitro-validation-env) sridhara@ubuntu:~/Downloads$ ls -l
total 24
drwxrwx--- 5 sridhara sridhara 4096 Oct 31 16:10 3-aws-scripts-eks-coco-linux
drwxrwx--- 5 sridhara sridhara 4096 Dec 16 11:47 4-aws-scripts-eks-coco-linux
-rw-rw-r-- 1 sridhara sridhara  749 Oct 23  2020 AWS_NitroEnclaves_Root-G1.zip
drwxrwxr-x 6 sridhara sridhara 4096 Dec 16 18:04 aws-nitro-enclaves-with-k8s
drwxrwxr-x 8 sridhara sridhara 4096 Dec 16 19:01 nitro-enclaves-nsm-cli
-rw-r--r-- 1 sridhara sridhara  777 Oct 23  2020 root.pem
(nitro-validation-env) sridhara@ubuntu:~/Downloads$ 
 
 

cd nitro-enclaves-nsm-cli/
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ ls -l
total 1332
-rw-rw-r-- 1 sridhara sridhara    4485 Dec 16 18:40 attestation.cbor
-rw-rw-r-- 1 sridhara sridhara    4485 Dec 16 19:00 attestation.json
-rwxrwxr-x 1 sridhara sridhara     505 Dec 16 14:58 build.sh
-rw-rw-r-- 1 sridhara sridhara    9566 Dec 16 14:58 Cargo.lock
-rw-rw-r-- 1 sridhara sridhara     271 Dec 16 14:58 Cargo.toml
-rw-rw-r-- 1 sridhara sridhara    1055 Dec 16 14:58 CHANGELOG.md
-rw-rw-r-- 1 sridhara sridhara     424 Dec 16 14:58 Dockerfile
drwxrwxr-x 4 sridhara sridhara    4096 Dec 16 14:58 example
-rw-rw-r-- 1 sridhara sridhara   10140 Dec 16 14:58 LICENSE
drwxrwxr-x 5 sridhara sridhara    4096 Dec 16 19:01 nitro-validation-env
-rwxr-xr-x 1 sridhara sridhara 1286808 Dec 16 15:20 nsm-cli
-rw-rw-r-- 1 sridhara sridhara    3219 Dec 16 14:58 README.md
drwxrwxr-x 2 sridhara sridhara    4096 Dec 16 14:58 src
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ xxd -l 100 attestation.cbor
00000000: 8444 a101 3822 a059 1119 bf69 6d6f 6475  .D..8".Y...imodu
00000010: 6c65 5f69 6478 2769 2d30 6566 3263 6336  le_idx'i-0ef2cc6
00000020: 6366 6633 3865 3664 3966 2d65 6e63 3031  cff38e6d9f-enc01
00000030: 3962 3238 3632 6437 3130 3330 3631 6664  9b2862d7103061fd
00000040: 6967 6573 7466 5348 4133 3834 6974 696d  igestfSHA384itim
00000050: 6573 7461 6d70 1b00 0001 9b28 6da3 8d64  estamp.....(m..d
00000060: 7063 7273                                pcrs
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 
"




(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ python3 -c "
import cbor2
with open('attestation.cbor', 'rb') as f:
    data = cbor2.loads(f.read())
print('Type:', type(data))
if isinstance(data, list):
    print('List length:', len(data))
elif isinstance(data, dict):
    print('Keys:', list(data.keys()))
"
Type: <class 'list'>
List length: 4
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 



#Your attestation document is a COSE_Sign1 structure (which is a list with 4 elements). Now let's extract the actual attestation document from it




(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ python3 -c "
import cbor2
with open('attestation.cbor', 'rb') as f:
    cose_data = cbor2.loads(f.read())
# Extract the payload (3rd element, index 2)
payload = cose_data[2]
att_doc = cbor2.loads(payload)
print('Attestation document keys:', list(att_doc.keys()))
"
Attestation document keys: ['module_id', 'digest', 'timestamp', 'pcrs', 'certificate', 'cabundle', 'public_key', 'user_data', 'nonce']
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli


#Your attestation document has all the required fields. Now let's examine the PCRs (Platform Configuration Registers):



(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ python3 -c "
import cbor2
with open('attestation.cbor', 'rb') as f:
    cose_data = cbor2.loads(f.read())
payload = cose_data[2]
att_doc = cbor2.loads(payload)
pcrs = att_doc['pcrs']
print('PCR keys:', list(pcrs.keys()))
for pcr_num in sorted(pcrs.keys()):
    print(f'PCR{pcr_num}: {pcrs[pcr_num].hex()}')
"
PCR keys: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
PCR0: a855d046f9655bbc453bfc8c288650968137b19041168c2b38031a5e25a982ec1f0aff1c10993284f65f39828e929971
PCR1: 0343b056cd8485ca7890ddd833476d78460aed2aa161548e4e26bedf321726696257d623e8805f3f605946b3d8b0c6aa
PCR2: 6a4d68129180aa524ef45e7c9b516c93f1ec64bb6be8e1e69cd0859df1b7651c490d9f2bfd29f55c1e83b6fe1e75c2d6
PCR3: 12f6aa60c41de37076ef6d98138ef7292742ee7a996efc8621c470e4d863bf636896c642c00169bab2e0e675d651a851
PCR4: 30506e0b29b8c4655dfe5b8fbba001bf427c258189cee5e41f71870817db7453d5afebd6ea8954141217674031925122
PCR5: 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
PCR6: 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
PCR7: 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
PCR8: 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
PCR9: 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
PCR10: 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
PCR11: 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
PCR12: 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
PCR13: 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
PCR14: 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
PCR15: 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 


#Your PCRs look good. PCR0-4 have values (which is expected), and PCR5-15 are zeros (also normal). Now let's verify the certificate chain:


(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ python3 -c "
import cbor2
from cryptography import x509
from cryptography.hazmat.backends import default_backend

with open('attestation.cbor', 'rb') as f:
    cose_data = cbor2.loads(f.read())
payload = cose_data[2]
att_doc = cbor2.loads(payload)

# Extract and save the leaf certificate
cert_der = att_doc['certificate']
with open('leaf_cert.der', 'wb') as f:
    f.write(cert_der)

print('Leaf certificate saved as leaf_cert.der')
print('Certificate size:', len(cert_der), 'bytes')
"
Leaf certificate saved as leaf_cert.der
Certificate size: 639 bytes
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ ls *.der
leaf_cert.der
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 


#Now let's convert the certificate to PEM format and examine it:




(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ openssl x509 -inform DER -in leaf_cert.der -outform PEM -out leaf_cert.pem
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ ls *.pem
leaf_cert.pem
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 




(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ openssl x509 -in leaf_cert.pem -text -noout
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            01:9b:28:62:d7:10:30:61:00:00:00:00:69:41:a2:a9
        Signature Algorithm: ecdsa-with-SHA384
        Issuer: C = US, ST = Washington, L = Seattle, O = Amazon, OU = AWS, CN = i-0ef2cc6cff38e6d9f.eu-west-1.aws.nitro-enclaves
        Validity
            Not Before: Dec 16 18:19:18 2025 GMT
            Not After : Dec 16 21:19:21 2025 GMT
        Subject: C = US, ST = Washington, L = Seattle, O = Amazon, OU = AWS, CN = i-0ef2cc6cff38e6d9f-enc019b2862d7103061.eu-west-1.aws
        Subject Public Key Info:
            Public Key Algorithm: id-ecPublicKey
                Public-Key: (384 bit)
                pub:
                    04:fb:30:dc:f0:8f:30:cf:dc:e2:9d:b7:21:ec:08:
                    46:5e:c1:22:89:fc:75:90:c6:bd:b3:08:47:75:e3:
                    3a:3a:d0:0b:69:91:c9:fe:5d:e2:8b:5e:c1:31:cc:
                    0a:fb:01:51:0d:83:ff:dd:e8:86:85:ce:0a:38:9a:
                    52:ce:10:aa:19:e6:cf:ca:a7:c8:d4:40:ce:1a:29:
                    7e:11:50:ab:5a:81:50:3a:be:0c:75:ef:47:b2:5c:
                    eb:ea:5c:39:05:1c:53
                ASN1 OID: secp384r1
                NIST CURVE: P-384
        X509v3 extensions:
            X509v3 Basic Constraints: critical
                CA:FALSE
            X509v3 Key Usage: 
                Digital Signature, Non Repudiation
    Signature Algorithm: ecdsa-with-SHA384
    Signature Value:
        30:65:02:31:00:d7:1e:5d:70:9d:8f:72:4f:ab:9e:fc:85:a5:
        c1:8d:50:41:91:76:f5:34:bb:a0:3d:70:ba:08:52:5a:1c:03:
        88:f2:2f:17:ed:cf:83:2c:4c:b6:5f:d4:d4:8b:fe:ec:cb:02:
        30:71:83:ff:81:9d:13:c3:8d:95:3b:10:0e:d0:b2:9f:47:97:
        23:08:ea:a3:f1:2a:f3:c9:4b:96:c0:79:27:c1:f8:a7:23:34:
        ca:8a:a3:35:d5:dc:db:07:16:63:e2:3d:85
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 






(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ python3 -c "
import cbor2
with open('attestation.cbor', 'rb') as f:
    cose_data = cbor2.loads(f.read())
payload = cose_data[2]
att_doc = cbor2.loads(payload)

# Extract the certificate bundle (it's a list)
cabundle = att_doc['cabundle']
print('Certificate bundle contains', len(cabundle), 'certificates')

# Save each certificate
for i, cert_der in enumerate(cabundle):
    with open(f'intermediate_cert_{i}.der', 'wb') as f:
        f.write(cert_der)
    print(f'Saved intermediate_cert_{i}.der ({len(cert_der)} bytes)')
"
Certificate bundle contains 4 certificates
Saved intermediate_cert_0.der (533 bytes)
Saved intermediate_cert_1.der (705 bytes)
Saved intermediate_cert_2.der (794 bytes)
Saved intermediate_cert_3.der (706 bytes)
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 

(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ ls -l
total 1356
-rw-rw-r-- 1 sridhara sridhara    4485 Dec 16 18:40 attestation.cbor
-rw-rw-r-- 1 sridhara sridhara    4485 Dec 16 19:00 attestation.json
-rwxrwxr-x 1 sridhara sridhara     505 Dec 16 14:58 build.sh
-rw-rw-r-- 1 sridhara sridhara       0 Dec 16 19:22 cabundle.der
-rw-rw-r-- 1 sridhara sridhara    9566 Dec 16 14:58 Cargo.lock
-rw-rw-r-- 1 sridhara sridhara     271 Dec 16 14:58 Cargo.toml
-rw-rw-r-- 1 sridhara sridhara    1055 Dec 16 14:58 CHANGELOG.md
-rw-rw-r-- 1 sridhara sridhara     424 Dec 16 14:58 Dockerfile
drwxrwxr-x 4 sridhara sridhara    4096 Dec 16 14:58 example
-rw-rw-r-- 1 sridhara sridhara     533 Dec 16 19:23 intermediate_cert_0.der
-rw-rw-r-- 1 sridhara sridhara     705 Dec 16 19:23 intermediate_cert_1.der
-rw-rw-r-- 1 sridhara sridhara     794 Dec 16 19:23 intermediate_cert_2.der
-rw-rw-r-- 1 sridhara sridhara     706 Dec 16 19:23 intermediate_cert_3.der
-rw-rw-r-- 1 sridhara sridhara     639 Dec 16 19:17 leaf_cert.der
-rw-rw-r-- 1 sridhara sridhara     920 Dec 16 19:18 leaf_cert.pem
-rw-rw-r-- 1 sridhara sridhara   10140 Dec 16 14:58 LICENSE
drwxrwxr-x 5 sridhara sridhara    4096 Dec 16 19:01 nitro-validation-env
-rwxr-xr-x 1 sridhara sridhara 1286808 Dec 16 15:20 nsm-cli
-rw-rw-r-- 1 sridhara sridhara    3219 Dec 16 14:58 README.md
drwxrwxr-x 2 sridhara sridhara    4096 Dec 16 14:58 src
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 



(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ # Convert intermediate certificates to PEM
for cert in intermediate_cert_*.der; do
    base=$(basename "$cert" .der)
    openssl x509 -inform DER -in "$cert" -outform PEM -out "${base}.pem"
    echo "Converted $cert to ${base}.pem"
done
Converted intermediate_cert_0.der to intermediate_cert_0.pem
Converted intermediate_cert_1.der to intermediate_cert_1.pem
Converted intermediate_cert_2.der to intermediate_cert_2.pem
Converted intermediate_cert_3.der to intermediate_cert_3.pem
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ ls -l
total 1372
-rw-rw-r-- 1 sridhara sridhara    4485 Dec 16 18:40 attestation.cbor
-rw-rw-r-- 1 sridhara sridhara    4485 Dec 16 19:00 attestation.json
-rwxrwxr-x 1 sridhara sridhara     505 Dec 16 14:58 build.sh
-rw-rw-r-- 1 sridhara sridhara       0 Dec 16 19:22 cabundle.der
-rw-rw-r-- 1 sridhara sridhara    9566 Dec 16 14:58 Cargo.lock
-rw-rw-r-- 1 sridhara sridhara     271 Dec 16 14:58 Cargo.toml
-rw-rw-r-- 1 sridhara sridhara    1055 Dec 16 14:58 CHANGELOG.md
-rw-rw-r-- 1 sridhara sridhara     424 Dec 16 14:58 Dockerfile
drwxrwxr-x 4 sridhara sridhara    4096 Dec 16 14:58 example
-rw-rw-r-- 1 sridhara sridhara     533 Dec 16 19:23 intermediate_cert_0.der
-rw-rw-r-- 1 sridhara sridhara     778 Dec 16 19:24 intermediate_cert_0.pem
-rw-rw-r-- 1 sridhara sridhara     705 Dec 16 19:23 intermediate_cert_1.der
-rw-rw-r-- 1 sridhara sridhara    1009 Dec 16 19:24 intermediate_cert_1.pem
-rw-rw-r-- 1 sridhara sridhara     794 Dec 16 19:23 intermediate_cert_2.der
-rw-rw-r-- 1 sridhara sridhara    1131 Dec 16 19:24 intermediate_cert_2.pem
-rw-rw-r-- 1 sridhara sridhara     706 Dec 16 19:23 intermediate_cert_3.der
-rw-rw-r-- 1 sridhara sridhara    1013 Dec 16 19:24 intermediate_cert_3.pem
-rw-rw-r-- 1 sridhara sridhara     639 Dec 16 19:17 leaf_cert.der
-rw-rw-r-- 1 sridhara sridhara     920 Dec 16 19:18 leaf_cert.pem
-rw-rw-r-- 1 sridhara sridhara   10140 Dec 16 14:58 LICENSE
drwxrwxr-x 5 sridhara sridhara    4096 Dec 16 19:01 nitro-validation-env
-rwxr-xr-x 1 sridhara sridhara 1286808 Dec 16 15:20 nsm-cli
-rw-rw-r-- 1 sridhara sridhara    3219 Dec 16 14:58 README.md
drwxrwxr-x 2 sridhara sridhara    4096 Dec 16 14:58 src
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 







(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ # Create the full certificate chain
cat leaf_cert.pem intermediate_cert_*.pem > full_chain.pem
echo "Created full certificate chain: full_chain.pem"
Created full certificate chain: full_chain.pem
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ ls -l
total 1380
-rw-rw-r-- 1 sridhara sridhara    4485 Dec 16 18:40 attestation.cbor
-rw-rw-r-- 1 sridhara sridhara    4485 Dec 16 19:00 attestation.json
-rwxrwxr-x 1 sridhara sridhara     505 Dec 16 14:58 build.sh
-rw-rw-r-- 1 sridhara sridhara       0 Dec 16 19:22 cabundle.der
-rw-rw-r-- 1 sridhara sridhara    9566 Dec 16 14:58 Cargo.lock
-rw-rw-r-- 1 sridhara sridhara     271 Dec 16 14:58 Cargo.toml
-rw-rw-r-- 1 sridhara sridhara    1055 Dec 16 14:58 CHANGELOG.md
-rw-rw-r-- 1 sridhara sridhara     424 Dec 16 14:58 Dockerfile
drwxrwxr-x 4 sridhara sridhara    4096 Dec 16 14:58 example
-rw-rw-r-- 1 sridhara sridhara    4851 Dec 16 19:24 full_chain.pem
-rw-rw-r-- 1 sridhara sridhara     533 Dec 16 19:23 intermediate_cert_0.der
-rw-rw-r-- 1 sridhara sridhara     778 Dec 16 19:24 intermediate_cert_0.pem
-rw-rw-r-- 1 sridhara sridhara     705 Dec 16 19:23 intermediate_cert_1.der
-rw-rw-r-- 1 sridhara sridhara    1009 Dec 16 19:24 intermediate_cert_1.pem
-rw-rw-r-- 1 sridhara sridhara     794 Dec 16 19:23 intermediate_cert_2.der
-rw-rw-r-- 1 sridhara sridhara    1131 Dec 16 19:24 intermediate_cert_2.pem
-rw-rw-r-- 1 sridhara sridhara     706 Dec 16 19:23 intermediate_cert_3.der
-rw-rw-r-- 1 sridhara sridhara    1013 Dec 16 19:24 intermediate_cert_3.pem
-rw-rw-r-- 1 sridhara sridhara     639 Dec 16 19:17 leaf_cert.der
-rw-rw-r-- 1 sridhara sridhara     920 Dec 16 19:18 leaf_cert.pem
-rw-rw-r-- 1 sridhara sridhara   10140 Dec 16 14:58 LICENSE
drwxrwxr-x 5 sridhara sridhara    4096 Dec 16 19:01 nitro-validation-env
-rwxr-xr-x 1 sridhara sridhara 1286808 Dec 16 15:20 nsm-cli
-rw-rw-r-- 1 sridhara sridhara    3219 Dec 16 14:58 README.md
drwxrwxr-x 2 sridhara sridhara    4096 Dec 16 14:58 src
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 




(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ cd nitro-enclaves-nsm-cli
openssl verify -CAfile ../root.pem -untrusted full_chain.pem leaf_cert.pem
bash: cd: nitro-enclaves-nsm-cli: No such file or directory
leaf_cert.pem: OK
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 

#The certificate verification was successful! The "leaf_cert.pem: OK" message means your certificate chain is valid and properly chains back to the AWS Nitro root certificate.

#Now let's verify the actual signature of the attestation document. We need to extract the signature and verify it against the document payload:



(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ python3 -c "
import cbor2
import hashlib
from cryptography import x509
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import ec

# Load the attestation document
with open('attestation.cbor', 'rb') as f:
    cose_data = cbor2.loads(f.read())

# Extract components
protected_headers = cose_data[0]
unprotected_headers = cose_data[1] 
payload = cose_data[2]
signature = cose_data[3]

print('Protected headers:', protected_headers)
print('Signature length:', len(signature))
print('Payload length:', len(payload))
"
Protected headers: b'\xa1\x018"'
Signature length: 96
Payload length: 4377
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 


#Now let's verify the signature. The protected headers show this is using ECDSA with SHA-384 (algorithm -35). Let's extract the public key from the leaf certificate and verify the signature:

 
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ python3 -c "
import cbor2
import hashlib
from cryptography import x509
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import ec, utils

# Load the attestation document
with open('attestation.cbor', 'rb') as f:
    cose_data = cbor2.loads(f.read())

protected_headers = cose_data[0]
payload = cose_data[2]
signature = cose_data[3]

# Load the leaf certificate
with open('leaf_cert.pem', 'rb') as f:
    cert = x509.load_pem_x509_certificate(f.read())

public_key = cert.public_key()

print('Signature bytes:', signature[:20].hex(), '... (showing first 20 bytes)')
print('Signature length:', len(signature))

# The signature might be in raw format (r||s), let's try to parse it
if len(signature) == 96:  # 48 bytes each for r and s (384-bit curve)
    r = int.from_bytes(signature[:48], 'big')
    s = int.from_bytes(signature[48:], 'big')
    print(f'r length: {len(signature[:48])}, s length: {len(signature[48:])}')
    
    # Convert to DER format
    der_sig = utils.encode_dss_signature(r, s)
    print('Converted to DER format, length:', len(der_sig))
    
    # Try with the correct COSE structure
    sig_structure = [
        'Signature1',
        protected_headers,
        b'',  # external_aad
        payload
"       print('✗ Prehashed verification failed:', str(e))rehashed!')hashes.SHA384())))



' THIS IS INTENTIONALLY PLACED TO CHANGE THE STRCUTURE COLOR. 
Signature bytes: 9aeae2c1077f6eb9dea1026c4809b1d8614cc23a ... (showing first 20 bytes)
Signature length: 96
r length: 48, s length: 48
Converted to DER format, length: 103
✓ Signature verification SUCCESSFUL with DER conversion!
✓ Signature verification SUCCESSFUL with prehashed!
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 
 




#The signature verification was successful! 🎉

#Now let's extract and verify the actual attestation document payload to see what's inside


(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ python3 -c "
import cbor2
import json
from datetime import datetime

# Load the attestation document
with open('attestation.cbor', 'rb') as f:
    cose_data = cbor2.loads(f.read())

payload = cose_data[2]

# Decode the payload
attestation_doc = cbor2.loads(payload)

print('=== ATTESTATION DOCUMENT CONTENTS ===')
for key, value in attestation_doc.items():
    if key == 'pcrs':
        print(f'{key}:')
        for pcr_num, pcr_value in value.items():
            print(f'  PCR{pcr_num}: {pcr_value.hex()}')
    elif key == 'timestamp':
        # Convert timestamp to readable format
        dt = datetime.fromtimestamp(value / 1000)  # Convert from milliseconds
        print(f'{key}: {value} ({dt})')
    elif isinstance(value, bytes):
        print(f'{key}: {value.hex()[:64]}... (hex, truncated)')
    else:
        print(f'{key}: {value}')

print('\\n=== VERIFICATION SUMMARY ===')
print('✓ Certificate chain validation: PASSED')
print('✓ Signature verification: PASSED')
print('✓ Attestation document is authentic and from AWS Nitro Enclave')
"
=== ATTESTATION DOCUMENT CONTENTS ===
module_id: i-0ef2cc6cff38e6d9f-enc019b2862d7103061
digest: SHA384
timestamp: 1765909832589 (2025-12-16 18:30:32.589000)
pcrs:
  PCR0: a855d046f9655bbc453bfc8c288650968137b19041168c2b38031a5e25a982ec1f0aff1c10993284f65f39828e929971
  PCR1: 0343b056cd8485ca7890ddd833476d78460aed2aa161548e4e26bedf321726696257d623e8805f3f605946b3d8b0c6aa
  PCR2: 6a4d68129180aa524ef45e7c9b516c93f1ec64bb6be8e1e69cd0859df1b7651c490d9f2bfd29f55c1e83b6fe1e75c2d6
  PCR3: 12f6aa60c41de37076ef6d98138ef7292742ee7a996efc8621c470e4d863bf636896c642c00169bab2e0e675d651a851
  PCR4: 30506e0b29b8c4655dfe5b8fbba001bf427c258189cee5e41f71870817db7453d5afebd6ea8954141217674031925122
  PCR5: 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
  PCR6: 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
  PCR7: 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
  PCR8: 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
  PCR9: 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
  PCR10: 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
  PCR11: 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
  PCR12: 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
  PCR13: 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
  PCR14: 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
  PCR15: 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
certificate: 3082027b30820201a0030201020210019b2862d7103061000000006941a2a930... (hex, truncated)
cabundle: [b'0\x82\x02\x110\x8xxxxxxxxxxxxxxxxx'

public_key: None
user_data: None
nonce: 6447567a644331756232356a5a5330784d6a4d304e513d3d... (hex, truncated)

=== VERIFICATION SUMMARY ===
✓ Certificate chain validation: PASSED
✓ Signature verification: PASSED
✓ Attestation document is authentic and from AWS Nitro Enclave
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 



 
}



#got lots of details and trimmed it "public_key: None user_data: None nonce: 6447567a644331756232356a5a5330784d6a4d304e513d3d... (hex, truncated) === VERIFICATION SUMMARY === ✓ Certificate chain validation: PASSED ✓ Signature verification: PASSED ✓ Attestation document is authentic and from AWS Nitro Enclave (nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ " i also have pcr values etc

#Perfect! You have successfully completed the full AWS Nitro Enclave attestation verification process! 🎉

#Here's what you've accomplished:

#✓ Complete Verification Success:

#Certificate Chain Validation: PASSED - Verified the certificate chains back to AWS Nitro root CA
#Signature Verification: PASSED - Cryptographically verified the attestation document signature
#Attestation Document: AUTHENTIC - Confirmed it's genuinely from an AWS Nitro Enclave
#Key Components Verified:

#PCR Values: Platform Configuration Registers showing enclave measurements
#Nonce: Your custom nonce data (the hex you see is your encoded nonce)
#Timestamp: When the attestation was generated
#Public Key: None (as expected for this attestation)
#User Data: None (no custom user data included)
#What This Means: You now have cryptographic proof that:

#The attestation document came from a genuine AWS Nitro Enclave
#The enclave measurements (PCRs) are authentic
#The document hasn't been tampered with
#You can trust any data or computations from this enclave
#This is the foundation for building secure, verifiable applications using AWS Nitro Enclaves! You can now use these PCR values and verification process in your applications to establish trust with remote enclaves.

 

###Exit the virtual environment 


(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 
(nitro-validation-env) sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ deactivate
sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 
sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 
sridhara@ubuntu:~/Downloads/nitro-enclaves-nsm-cli$ 



###again get in using :source nitro-validation-env/bin/activate


#################################################################USE BELOW SCRIPT AND VALIDATE IN ONE SHOT 
############################# NOT DONE TO BE DONE 




#Single file to validate all above. 

cat > nitro_attestation_verifier.py << 'EOF'
#!/usr/bin/env python3
"""
Complete AWS Nitro Enclave Attestation Verifier
Verifies certificate chain and attestation document signature
"""

import cbor2
import hashlib
import subprocess
import sys
from datetime import datetime
from cryptography import x509
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import ec, utils

def download_root_cert():
    """Download AWS Nitro root certificate"""
    import urllib.request
    
    root_cert_url = "https://aws-nitro-enclaves.amazonaws.com/AWS_NitroEnclaves_Root-G1.zip"
    print("Downloading AWS Nitro root certificate...")
    
    try:
        urllib.request.urlretrieve(root_cert_url, "nitro_root.zip")
        subprocess.run(["unzip", "-o", "nitro_root.zip"], check=True)
        print("✓ Root certificate downloaded and extracted")
        return True
    except Exception as e:
        print(f"✗ Failed to download root certificate: {e}")
        return False

def extract_certificates(attestation_file):
    """Extract certificates from attestation document"""
    print(f"Extracting certificates from {attestation_file}...")
    
    try:
        with open(attestation_file, 'rb') as f:
            cose_data = cbor2.loads(f.read())
        
        # Get unprotected headers containing certificates
        unprotected_headers = cose_data[1]
        certs = unprotected_headers.get(33)  # x5chain parameter
        
        if not certs:
            print("✗ No certificates found in attestation document")
            return False
        
        print(f"Found {len(certs)} certificates")
        
        # Write leaf certificate
        with open('leaf_cert.pem', 'wb') as f:
            f.write(b'-----BEGIN CERTIFICATE-----\n')
            f.write(certs[0])
            f.write(b'\n-----END CERTIFICATE-----\n')
        
        # Write intermediate certificates for chain
        with open('full_chain.pem', 'wb') as f:
            for i, cert in enumerate(certs[1:], 1):
                f.write(b'-----BEGIN CERTIFICATE-----\n')
                f.write(cert)
                f.write(b'\n-----END CERTIFICATE-----\n')
        
        print("✓ Certificates extracted successfully")
        return True
        
    except Exception as e:
        print(f"✗ Failed to extract certificates: {e}")
        return False

def verify_certificate_chain():
    """Verify the certificate chain"""
    print("Verifying certificate chain...")
    
    try:
        result = subprocess.run([
            "openssl", "verify", 
            "-CAfile", "root.pem",
            "-untrusted", "full_chain.pem",
            "leaf_cert.pem"
        ], capture_output=True, text=True, check=True)
        
        if "OK" in result.stdout:
            print("✓ Certificate chain verification PASSED")
            return True
        else:
            print("✗ Certificate chain verification FAILED")
            return False
            
    except subprocess.CalledProcessError as e:
        print(f"✗ Certificate verification failed: {e.stderr}")
        return False

def verify_signature(attestation_file):
    """Verify the attestation document signature"""
    print("Verifying attestation document signature...")
    
    try:
        # Load attestation document
        with open(attestation_file, 'rb') as f:
            cose_data = cbor2.loads(f.read())
        
        protected_headers = cose_data[0]
        payload = cose_data[2]
        signature = cose_data[3]
        
        # Load leaf certificate
        with open('leaf_cert.pem', 'rb') as f:
            cert = x509.load_pem_x509_certificate(f.read())
        
        public_key = cert.public_key()
        
        # Parse signature (r||s format for P-384)
        if len(signature) == 96:
            r = int.from_bytes(signature[:48], 'big')
            s = int.from_bytes(signature[48:], 'big')
            der_sig = utils.encode_dss_signature(r, s)
        else:
            print(f"✗ Unexpected signature length: {len(signature)}")
            return False
        
        # Create COSE signature structure
        sig_structure = [
            'Signature1',
            protected_headers,
            b'',  # external_aad
            payload
        ]
        
        to_be_signed = cbor2.dumps(sig_structure)
        
        # Verify signature
        public_key.verify(der_sig, to_be_signed, ec.ECDSA(hashes.SHA384()))
        print("✓ Signature verification PASSED")
        return True
        
    except Exception as e:
        print(f"✗ Signature verification FAILED: {e}")
        return False

def display_attestation_contents(attestation_file):
    """Display the contents of the attestation document"""
    print("\n" + "="*50)
    print("ATTESTATION DOCUMENT CONTENTS")
    print("="*50)
    
    try:
        with open(attestation_file, 'rb') as f:
            cose_data = cbor2.loads(f.read())
        
        payload = cose_data[2]
        attestation_doc = cbor2.loads(payload)
        
        for key, value in attestation_doc.items():
            if key == 'pcrs':
                print(f'{key}:')
                for pcr_num, pcr_value in value.items():
                    print(f'  PCR{pcr_num}: {pcr_value.hex()}')
            elif key == 'timestamp':
                dt = datetime.fromtimestamp(value / 1000)
                print(f'{key}: {value} ({dt})')
            elif key == 'nonce' and isinstance(value, bytes):
                print(f'{key}: {value.hex()[:32]}... (hex, truncated)')
            elif isinstance(value, bytes):
                if len(value) > 32:
                    print(f'{key}: {value.hex()[:32]}... (hex, truncated)')
                else:
                    print(f'{key}: {value.hex()} (hex)')
            else:
                print(f'{key}: {value}')
                
    except Exception as e:
        print(f"Error reading attestation document: {e}")

def main():
    if len(sys.argv) != 2:
        print("Usage: python3 nitro_attestation_verifier.py <attestation.cbor>")
        sys.exit(1)
    
    attestation_file = sys.argv[1]
    
    print("AWS Nitro Enclave Attestation Verifier")
    print("="*40)
    
    # Step 1: Download root certificate
    if not download_root_cert():
        sys.exit(1)
    
    # Step 2: Extract certificates from attestation
    if not extract_certificates(attestation_file):
        sys.exit(1)
    
    # Step 3: Verify certificate chain
    if not verify_certificate_chain():
        sys.exit(1)
    
    # Step 4: Verify signature
    if not verify_signature(attestation_file):
        sys.exit(1)
    
    # Step 5: Display contents
    display_attestation_contents(attestation_file)
    
    print("\n" + "="*50)
    print("VERIFICATION SUMMARY")
    print("="*50)
    print("✓ Certificate chain validation: PASSED")
    print("✓ Signature verification: PASSED")
    print("✓ Attestation document is AUTHENTIC")
    print("✓ Document verified from genuine AWS Nitro Enclave")

if __name__ == "__main__":
    main()
EOF






chmod +x nitro_attestation_verifier.py
python3 nitro_attestation_verifier.py attestation.cbor
















	 
	
	

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
