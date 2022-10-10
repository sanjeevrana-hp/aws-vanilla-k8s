#!/bin/bash
case $1 in
        "--create-cluster")
                echo "Creating the EC2 Instances, and installing the K8s"
		cd /terraform
                terraform init
                terraform apply --auto-approve
		terraform state show aws_instance.k8s[0] |grep public_ip|tail -1|cut -d '"' -f2 > /tmp/kube-server_ip
		sleep 45
		cd /terraform/ansible
                ansible-playbook master-kubernet.yaml
                ansible-playbook worker-kubernet.yaml
		cd /terraform
		terraform output
                ;;

        "--create-msrv3")
                echo "Creating the EC2 Instances, and installing the K8s"
                cd /terraform
                terraform init
                terraform apply --auto-approve
		terraform state show aws_instance.k8s[0] |grep public_ip|tail -1|cut -d '"' -f2 > /tmp/kube-server_ip
                sleep 45
		echo "Installing the K8s"
                cd /terraform/ansible
                ansible-playbook master-kubernet.yaml
                ansible-playbook worker-kubernet.yaml
		sleep 20
		echo "Installing the StorageClasses"
		cd /terraform/ansible/storage-classes
		ansible-playbook storage-classes.yaml
		sleep 120
		echo "Installing the MSRv3"
		cd /terraform/ansible/MSRv3
		ansible-playbook msrv3-install.yaml
		cd /terraform
		terraform output
                ;;

        "--delete-cluster")
                echo "Deleting K8s, and EC2"
		cd /terraform
                terraform destroy --auto-approve
                ;;
        *)
                echo "Not a valid argument"
                echo
                ;;
esac

Help()
{
   echo "here's the options:"
   echo "--create-cluster create the infra and install the k8s."
   echo "--delete-cluster     delete the k8s cluster with infra."
   echo "--create-msrv3 create the infra,k8s cluster along with MSRv3."
}

Help
echo "Thanks for searching the options !!"
