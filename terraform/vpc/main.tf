provider "aws" {
  profile = "educate"
  region  = var.region
}

terraform {
  backend "s3" {
    key            = "vpc/terraform.tfstate"
    profile        = "educate"
    dynamodb_table = "terraform-lock"
    region         = "us-east-1"
    bucket         = "systems-backend-dev"
  }
}
resource "random_integer" "subnet" {
  min = 1
  max = var.azs
}
locals {
  random = random_integer.subnet.result
}

/**
 * VPC
 */

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_main_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project}-vpc-main-${var.environment}"
  }
}

/**
 * Available zones
 */
 
data "aws_availability_zones" "available" {
  state = "available"
}


/**
 * Subnets - privates and public
 */

resource "aws_subnet" "privates" {
  count = var.azs

  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  vpc_id = aws_vpc.main.id


  tags = {
    Name = "${var.project}-subnet-private-${var.environment}-${count.index}"
  }
}

resource "aws_subnet" "publics" {
  count                   = var.azs
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, (var.azs + count.index))
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project}-subnet-public-${var.environment}-${count.index}"
  }
}


/**
 * Internet Gateway
 */
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-igw-${var.environment}"
  }
}


/**
 * Route Main
 */

resource "aws_default_route_table" "r" {
  default_route_table_id = aws_vpc.main.main_route_table_id

  tags = {
    Name = "${var.project}-route-main-${var.environment}"
  }
}

resource "aws_route" "internet_access" {
  route_table_id = aws_vpc.main.main_route_table_id

  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project}-public-rt-${var.environment}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = aws_instance.nat_inscance.id
  }

  tags = {
    Name = "${var.project}-private-rt-${var.environment}"
  }
}

resource "aws_route_table_association" "public" {
  count          = var.azs
  subnet_id      = element(aws_subnet.publics.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "privates" {
  count          = var.azs
  subnet_id      = element(aws_subnet.privates.*.id, count.index)
  route_table_id = aws_route_table.private.id
}



/**
 * NAT Instance
 * This is a anti pattern, and its is being used only for AWS Educate Free account
 */
resource "aws_security_group" "this" {
  name        = "${var.project}-sg-nat-${var.environment}"
  vpc_id      = aws_vpc.main.id
  description = "SG for NAT instances for a private subnet"
  tags = {
    Terrraform  = true
    Environment = var.environment
  }
  ingress {
    from_port   = 80
    description = "Internet Ingress"
    cidr_blocks = aws_subnet.privates.*.cidr_block
    protocol    = "tcp"
    to_port     = 80
  }
  ingress {
    from_port   = 443
    description = "Internet Ingress"
    cidr_blocks = aws_subnet.privates.*.cidr_block
    protocol    = "tcp"
    to_port     = 443
  }
  egress {
    from_port        = 80
    description      = "Internet Ingress"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    to_port          = 80
  }
  egress {
    from_port        = 443
    description      = "Internet Ingress"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    to_port          = 443
  }
}


resource "aws_instance" "nat_inscance" {
  ami           = data.aws_ami.this.id //"ami-00a9d4a05375b2763" //data.aws_ami.ubuntu.id
  instance_type = "t2.nano"

  key_name = "aws_educate"

  subnet_id = element(aws_subnet.publics.*.id, local.random)

  tags = {
    Name = "${var.project}-nat-ec2-${var.environment}"
  }
  depends_on = [aws_subnet.publics]
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }
}

/**
 * Saida de dados
 */

data "template_file" "vpc_info" {
  template = file("${path.root}/vpc_config.cfg")
  depends_on = [
    aws_subnet.publics, aws_vpc.main
  ]
  vars = {
    vpc_id    = aws_vpc.main.id
    subnet_id = element(aws_subnet.publics.*.id, local.random)
  }
}

resource "local_file" "vpc_info" {
  content  = data.template_file.vpc_info.rendered
  filename = "../../packer/vpc_config.auto.pkrvars.hcl"
}