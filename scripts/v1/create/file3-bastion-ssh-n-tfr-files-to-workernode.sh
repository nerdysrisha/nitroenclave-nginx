#!/bin/bash




# Get bastion security group (current instance)
BASTION_SG=$(curl -s http://169.254.169.254/latest/meta-data/instance-id | xargs -I {} aws ec2 describe-instances --instance-ids {} --region eu-west-1 --query 'Reservations[*].Instances[*].SecurityGroups[*].GroupId' --output text)

# Get worker node security group and IP
WORKER_SG=$(aws ec2 describe-instances --filters "Name=tag:Owner,Values=sri" --region eu-west-1 --query 'Reservations[*].Instances[*].SecurityGroups[*].GroupId' --output text)
NITRONODE_IP=$(aws ec2 describe-instances --filters "Name=tag:Owner,Values=sri" --region eu-west-1 --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text)

echo "Bastion SG: $BASTION_SG"
echo "NitroNode SG: $WORKER_SG"
echo "NitroNode IP: $NITRONODE_IP"


#THIS COPY OF NITRO INSTALL ETC MAY NOT BE NEEDED, REMOVE IT. 

NITRO_SCRIPT_FILE="file-nitro-install-docker-nitrocli.sh"
#NGINX_BUILD_FILE="file-nitro-build-run-nginx.sh"
#JAR_FILE="payments-0.0.1-SNAPSHOT.jar"
KEY_FILE="coco-eks-key.pem"
echo "Copying file ${NITRO_SCRIPT_FILE} from bastion to workernode"
# Set executable permissions and SCP file to worker node
chmod +x $NITRO_SCRIPT_FILE
#chmod +x $NGINX_BUILD_FILE

scp -i $KEY_FILE -o StrictHostKeyChecking=no $NITRO_SCRIPT_FILE ec2-user@${NITRONODE_IP}:~/
#scp -i $KEY_FILE -o StrictHostKeyChecking=no $JAR_FILE ec2-user@${NITRONODE_IP}:~/
#scp -i $KEY_FILE -o StrictHostKeyChecking=no $NGINX_BUILD_FILE ec2-user@${NITRONODE_IP}:~/




echo "Adding SSH rule..."
aws ec2 authorize-security-group-ingress --group-id $WORKER_SG --protocol tcp --port 22 --source-group $BASTION_SG --region eu-west-1 2>/dev/null || echo "SSH rule already exists (OK)"


echo "Verifying SSH rule exists..."
aws ec2 describe-security-groups --group-ids $WORKER_SG --region eu-west-1 --query 'SecurityGroups[*].IpPermissions[?FromPort==`22`]'

echo "Connecting to nitro node..."
ssh -i $KEY_FILE ec2-user@$NITRONODE_IP


 

