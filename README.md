
# K8s Cluster on AWS EC2 using terraform



## Documentation

This code is to deploy the EC2 Ubuntu 20.04 on AWS Cloud through the terraform. After this we have to use the ansible playbooks to install the vanilla K8s cluster. 

We use the dynamic inventory for ansible-playbook execution using the plugin aws_ec2.

Please pull the GitHub code "https://github.com/sanjeevrana-hp/aws-vanilla-k8s.git"

Update the credentials in ~/.aws/credentials, else export the AWS access_key, secret_key and region on the shell.


##  Pre Requisite

Need the aws account, IAM user with privileges to deploy the EC2.

Need Access and Secret Keys

On the Workstation

- Install the terraform
- Install the python3, pip, python3-pip, and boto3
- Install the Ansible


## Installation

Once the GitHub repository is cloned, and all the pre-requisites are done on the workstation then execute the below commands.
1. deploy the two EC2 (kube-master & kube-worker) using the terraform

```bash
cd /terraform
terraform init
terraform apply --auto-approve
```

2. Run the below Ansible Playbooks to install K8s
```python
cd /terraform/ansible
ansible-playbook master-kubernet.yaml
ansible-playbook worker-kubernet.yaml
```
