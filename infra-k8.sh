#!/bin/bash
case $1 in
        "--create")
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
        "--delete")
                echo "Deleting K8s, and EC2"
		cd /terraform
                terraform destroy --auto-approve
                ;;
        *)
                echo "Not a valid argument"
                echo
                ;;
esac
