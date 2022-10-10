#!/bin/bash
case $1 in
        "--create-cluster")
                echo "Creating the EC2 Instances, and installing the K8s"
		cd /terraform
                terraform init
                terraform apply --auto-approve
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
		public_ip=`terraform state show aws_instance.k8s[0] |grep public_dns |cut -d '"' -f2`
                echo "MSR URL ->  https://$public_ip:32529"
                echo "Storage URL ->  https://$public_ip:32528"
                ;;

        "--delete-cluster")
                echo "Deleting K8s, and EC2"
		cd /terraform
                terraform destroy --auto-approve
                ;;
esac


Help()
{
   echo "here's the options:"
   echo "------------------------"
   echo "--create-cluster  create the infra and install the k8s."
   echo "--delete-cluster  delete the k8s cluster with infra."
   echo "--create-msrv3  create the infra,k8s cluster along with MSRv3."
   echo
}

while getopts ":h" option; do
   case $option in
      h) # display Help
         Help
         exit;;
     \?) # incorrect option
         echo "Error: Invalid option"
         exit;;
   esac
done
