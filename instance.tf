
# Creating two random password for username and Password
resource "random_pet" "username" {
  length = 2
}
resource "random_string" "password" {
  length  = 20
  special = false
}
# Creating a local variable for generating randomness
locals {
  tstmp = formatdate("DD-MMM-YYYY:hh-mm", timestamp())
}

######## CREATING A SECURITY GROUP #########

resource "aws_security_group" "allow-all-security-group" {
  name        = "${var.name}-${random_pet.username.id}-SecurityGroup"
  description = "Allow everything for an ephemeral cluster"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name           = "${var.name}-SecurityGroup"
    DateOfCreation = local.tstmp
    resourceType   = "Security Group"
    resourceOwner  = "${var.name}"
  }
}

####### CREATING THE KEY PAIR  #######
# RSA key of size 4096 bits
resource "tls_private_key" "rsa-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "KeyPair" {
  key_name   = "${var.name}-${random_pet.username.id}-KeyPair"
  public_key = tls_private_key.rsa-key.public_key_openssh
  tags = {
    DateOfCreation = local.tstmp
  }
}

resource "local_file" "KeyPair_File" {
  content         = tls_private_key.rsa-key.private_key_pem
  filename        = "mykey-pair"
  file_permission = "0400"
}

####### CREATING THE EC2 Compute ###########
resource "aws_instance" "k8s" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  count         = 2
  key_name      = "${var.name}-${random_pet.username.id}-KeyPair"
  user_data     = <<EOF
    #!/bin/bash
    cd /var/tmp/
    apt-get update -y
    apt-get install wget
    wget https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/cluster-setup/latest/install_master.sh
    wget https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/cluster-setup/latest/install_worker.sh
    chmod 700 install_master.sh
    chmod 700 install_worker.sh
EOF
  tags = {
    Name           = var.host_names[count.index]
    DateOfCreation = local.tstmp
  }
}
