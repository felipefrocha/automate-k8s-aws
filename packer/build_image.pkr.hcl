variable "ami_id" {
  type = string
  default = "ami-085925f297f89fce1"
}

variable "aws_region" {
  type = string
  default = "us-east-1"
}
variable "vpc_id" {
  type = string
}
variable "subnet_id" {
  type = string
}

variable "ssh_username" {
  type = string
  default = "ubuntu"
}

variable "instance_type" {
  type = string
  default = "t2.medium"
}

source "amazon-ebs" "k8s-images-ready" {
  region = var.aws_region
  profile = "educate"
  source_ami = var.ami_id
  instance_type = var.instance_type
  ssh_username = var.ssh_username
  ami_name = format("educate-ff-%s", formatdate("YYYYMMDDhhmmss",timestamp()))
  ssh_keypair_name = "aws_educate"
  ssh_private_key_file = "../aws_educate.pem"
  vpc_id = var.vpc_id
  subnet_id = var.subnet_id
}

build {
  sources = [
    "source.amazon-ebs.k8s-images-ready",
  ]

  provisioner "shell"  {
    scripts  = [
      "./provisioners/scripts/python.sh",
      ]
  }

  provisioner "ansible"  {
    playbook_file = "../ansible/main.yml"
    user = var.ssh_username
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=false"
    ]
  }
}

