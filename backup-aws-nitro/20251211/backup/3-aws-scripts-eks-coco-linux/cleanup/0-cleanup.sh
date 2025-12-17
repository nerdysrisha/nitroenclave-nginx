#!/bin/bash

# Remove 'set -e' to allow continuation on errors

./1-delete-coco-eks-bastion-ec2.sh || echo "Step 1 failed, continuing..."
./2-delete-force-terminate-workernode.sh || echo "Step 2 failed, continuing..."
./3-delete-coco-eks-nodegroup.sh || echo "Step 3 failed, continuing..."
./4-delete-coco-nodegroup-launchtemplate.sh || echo "Step 4 failed, continuing..."
./5-delete-coco-eks.sh || echo "Step 5 failed, continuing..."
./6-delete-coco-eks-iamrole.sh || echo "Step 6 failed, continuing..."
./7-delete-coco-eks-vpc.sh || echo "Step 7 failed, continuing..."
./8-delete-coco-eks-keypair.sh || echo "Step 8 failed, continuing..."
