**# aws-vanilla-k8s#**
1. *deploy the two EC2 (kube-master & kube-worker) using the terraform*

   <sub>terraform apply --auto-approve<sub>

2. *Run the below Ansible Playbooks*
 
   <sub>ansible-playbook master-kubernet.yaml<sub>

   <sub>ansible-playbook worker-kubernet.yaml<sub>
