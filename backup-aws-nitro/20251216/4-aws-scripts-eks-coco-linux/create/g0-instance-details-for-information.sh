~ $ aws ec2 describe-images --image-ids ami-0f608183105f43978 --region eu-west-1
{
    "Images": [
        {
            "PlatformDetails": "Linux/UNIX",
            "UsageOperation": "RunInstances",
            "BlockDeviceMappings": [
                {
                    "Ebs": {
                        "DeleteOnTermination": true,
                        "SnapshotId": "snap-0e2dfced2340bd88b",
                        "VolumeSize": 20,
                        "VolumeType": "gp2",
                        "Encrypted": false
                    },
                    "DeviceName": "/dev/xvda"
                }
            ],
            "Description": "EKS Kubernetes Worker AMI with AmazonLinux2 image, (k8s: 1.29.15, containerd: 1.7.27-1.eks.amzn2.0.4)",
:...skipping...
{
    "Images": [
        {
            "PlatformDetails": "Linux/UNIX",
            "UsageOperation": "RunInstances",
            "BlockDeviceMappings": [
                {
                    "Ebs": {
                        "DeleteOnTermination": true,
                        "SnapshotId": "snap-0e2dfced2340bd88b",
                        "VolumeSize": 20,
                        "VolumeType": "gp2",
                        "Encrypted": false
                    },
                    "DeviceName": "/dev/xvda"
                }
            ],
            "Description": "EKS Kubernetes Worker AMI with AmazonLinux2 image, (k8s: 1.29.15, containerd: 1.7.27-1.eks.amzn2.0.4)",
            "EnaSupport": true,
            "Hypervisor": "xen",
            "ImageOwnerAlias": "amazon",
            "Name": "amazon-eks-node-1.29-v20250920",
            "RootDeviceName": "/dev/xvda",
            "RootDeviceType": "ebs",
            "SriovNetSupport": "simple",
            "VirtualizationType": "hvm",
            "DeprecationTime": "2027-09-24T00:36:36.000Z",
            "SourceImageId": "ami-0509102cfe13516be",
            "SourceImageRegion": "us-west-2",
            "FreeTierEligible": true,
:...skipping...
{
    "Images": [
        {
            "PlatformDetails": "Linux/UNIX",
            "UsageOperation": "RunInstances",
            "BlockDeviceMappings": [
                {
{
    "Images": [
        {
            "PlatformDetails": "Linux/UNIX",
            "UsageOperation": "RunInstances",
            "BlockDeviceMappings": [
                {
                    "Ebs": {
                        "DeleteOnTermination": true,
                        "SnapshotId": "snap-0e2dfced2340bd88b",
                        "VolumeSize": 20,
                        "VolumeType": "gp2",
                        "Encrypted": false
                    },
                    "DeviceName": "/dev/xvda"
                }
            ],
            "Description": "EKS Kubernetes Worker AMI with AmazonLinux2 image, (k8s: 1.29.15, containerd: 1.7.27-1.eks.amzn2.0.4)",
            "EnaSupport": true,
            "Hypervisor": "xen",
            "ImageOwnerAlias": "amazon",
            "Name": "amazon-eks-node-1.29-v20250920",
            "RootDeviceName": "/dev/xvda",
            "RootDeviceType": "ebs",
            "SriovNetSupport": "simple",
            "VirtualizationType": "hvm",
            "DeprecationTime": "2027-09-24T00:36:36.000Z",
            "SourceImageId": "ami-0509102cfe13516be",
            "SourceImageRegion": "us-west-2",
            "FreeTierEligible": true,
            "ImageId": "ami-0f608183105f43978",
            "ImageLocation": "amazon/amazon-eks-node-1.29-v20250920",
            "State": "available",
            "OwnerId": "602401143452",
            "CreationDate": "2025-09-24T00:36:36.000Z",
            "Public": true,
            "Architecture": "x86_64",
            "ImageType": "machine"
        }
    ]
}



##############################Instance Type Details 


{
    "InstanceTypes": [
        {
            "InstanceType": "m5d.2xlarge",
            "CurrentGeneration": true,
            "FreeTierEligible": false,
            "SupportedUsageClasses": [
                "on-demand",
                "spot"
            ],
            "SupportedRootDeviceTypes": [
                "ebs"
            ],
            "SupportedVirtualizationTypes": [
                "hvm"
            ],
            "BareMetal": false,
            "Hypervisor": "nitro",
            "ProcessorInfo": {
                "SupportedArchitectures": [
                    "x86_64"
                ],
                "SustainedClockSpeedInGhz": 3.1,
                "Manufacturer": "Intel"
            },
            "VCpuInfo": {
                "DefaultVCpus": 8,
                "DefaultCores": 4,
                "DefaultThreadsPerCore": 2,
                "ValidCores": [
                    2,
                    4
                ],
                "ValidThreadsPerCore": [
                    1,
                    2
                ]
            },
            "MemoryInfo": {
                "SizeInMiB": 32768
            },
            "InstanceStorageSupported": true,
            "InstanceStorageInfo": {
                "TotalSizeInGB": 300,
                "Disks": [
                    {
                        "SizeInGB": 300,
                        "Count": 1,
                        "Type": "ssd"
                    }
                ],
                "NvmeSupport": "required",
:


