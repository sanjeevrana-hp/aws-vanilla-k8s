variable "host_names" {
  type    = list(any)
  default = ["kube-server", "kube-worker"]
}

variable "instance_type" {
  default = "t2.large"
}

variable "region" {
  default = "ap-northeast-1"
}

variable "aws_shared_credentials_file" {
  type    = string
  default = "~/.aws/credentials"
}

variable "aws_profile" {
  type    = string
  default = "default"
}

variable "name" {
}
