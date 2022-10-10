
# K8s Cluster on AWS EC2 using terraform
[![Up to Date](https://github.com/ikatyang/emoji-cheat-sheet/workflows/Up%20to%20Date/badge.svg)](https://github.com/ikatyang/emoji-cheat-sheet/actions?query=workflow%3A%22Up+to+Date%22)



## Documentation

This code is to deploy the EC2 Ubuntu 20.04 on AWS Cloud through the terraform. After this we have to use the ansible playbooks to install the vanilla K8s cluster. 

We use the dynamic inventory for ansible-playbook execution using the plugin aws_ec2.

Please pull the GitHub code "https://github.com/sanjeevrana-hp/aws-vanilla-k8s.git"

Update the credentials in ~/.aws/credentials, else export the AWS access_key, secret_key and region on the shell.


##  Pre Requisite

Need the aws account, IAM user with privileges to deploy the EC2.

Need Access and Secret Keys

On the Workstation.:point_down:

- Install the terraform
  ```python
  https://learn.hashicorp.com/tutorials/terraform/install-cli
  ```

- Install the python3, pip, python3-pip, and boto3
  ```python
  apt-get install python3 -y
  apt-get install python3-pip -y
  pip3 install boto3
  ansible-galaxy collection install community.kubernetes
  ```

- Install the Ansible
  ```python
  apt-get update
  apt-get install ansible -y
  ```

## Installation

Once the GitHub repository is cloned, and all the pre-requisites are done on the workstation then execute the below commands.


1. The below script will create the two EC2 (kube-master & kube-worker) using the terraform, and install the k8s using the ansible-playbook :ok_hand:
```python
cd /terraform/
./infra-k8.sh --create-cluster
```

2. This will create the two EC2 (kube-master & kube-worker) using the terraform, and install the k8s using the ansible-playbook, and the configure the storagecalss and install Mirantis MSRv3

```python
cd /terraform/
./infra-k8.sh 

2. This will delete the infrastructure :cowboy_hat_face:

```python
cd /terraform/
./infra-k8.sh --create-msrv3
```


To access the ec2, there is a keypair generated in the /terraform directory, so you can execute the below command. Public IP address for the instances will display at the end of the script.

- ssh -i mykey-pair ubuntu@ec_ipaddress
