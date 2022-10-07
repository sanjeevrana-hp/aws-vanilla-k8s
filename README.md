# aws-vanilla-k8s
1. deploy the two EC2 (kube-master & kube-worker) using the terraform

   terraform apply --auto-approve

2. Run the below Ansible Playbooks
 
   ansible-playbook master-kubernet.yaml

   ansible-playbook worker-kubernet.yaml
