locals {
  instance_type = "t2.medium"
}

provider "aws" {
  profile = "educate"
  region  = var.region
}


terraform {
  backend "s3" {
    key            = "instances/terraform.tfstate"
    profile        = "educate"
    dynamodb_table = "terraform-lock"
    region         = "us-east-1"
    bucket         = "systems-backend-dev"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "systems-backend-dev"
    profile = "educate"
    key     = "vpc/terraform.tfstate"
    region  = "us-east-1"
  }
}

//
//module "vpc" {
//  source      = "./vpc"
//  environment = var.environment
//  project     = var.project
//  azs         = 2
//}




data "aws_caller_identity" "current_info" {
}

data "aws_ami" "packer_builder" {
  most_recent = true
  name_regex  = "^educate-ff-\\d{14}"

  filter {
    name   = "name"
    values = ["educate-ff-*"]
  }
  owners = [data.aws_caller_identity.current_info.account_id]
}

resource "aws_security_group" "sg_public" {
  vpc_id = data.terraform_remote_state.vpc.outputs.out_vpc_id
  name = "${var.project}-sg-k8s-ssh"
  ingress {
    protocol  = "tcp"
    self      = false
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port   = 22
  }
  ingress {
      protocol  = "-1"
      self      = true
      from_port = 0
      to_port   = 0
    }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_public_html" {
  vpc_id = data.terraform_remote_state.vpc.outputs.out_vpc_id
  name = "${var.project}-sg-k8s-http"
  ingress {
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port   = 80
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "master" {
  count = 1
  ami           = data.aws_ami.packer_builder.id
  instance_type = "t2.medium"
  key_name      = "aws_educate"
  subnet_id     = element(data.terraform_remote_state.vpc.outputs.out_puplic_subnets_id, 1)
  security_groups = [aws_security_group.sg_public.id,aws_security_group.sg_public_html.id]
  tags = {
    Name = format("Projetos-Master-%02d", count.index)
  }
}
resource "aws_instance" "workers" {
  count         = 2
  ami           = data.aws_ami.packer_builder.id
  instance_type = "t2.medium"
  key_name      = "aws_educate"
  subnet_id     = element(data.terraform_remote_state.vpc.outputs.out_puplic_subnets_id, 1)
  security_groups = [aws_security_group.sg_public.id,aws_security_group.sg_public_html.id]
  tags = {
    Name = format("Projetos-Workers-%02d", count.index)
  }
}
data "template_file" "k8s_cluster_info" {
  template = file("${path.root}/dev_hosts.cfg")
  depends_on = [
    aws_instance.master, aws_instance.workers
  ]
  vars = {
    master_node_private_ip = aws_instance.master[0].private_ip
    master_node_public_ip = aws_instance.master[0].public_ip
    worker_node_public_ip = format("%s\n%s",element(aws_instance.workers.*.public_ip,1),element(aws_instance.workers.*.public_ip,2))
  }
}

resource "local_file" "k8s_config" {
  content  = data.template_file.k8s_cluster_info.rendered
  filename = "../ansible/hosts"
  depends_on = [aws_instance.master, aws_instance.workers]
}

resource "null_resource" "dev-hosts" {
  triggers = {
    template_rendered = timestamp()
  }
  provisioner "local-exec" {
    command = "bash ./data/ansible.sh"
  }
  depends_on = [aws_instance.workers, aws_instance.master]
}



