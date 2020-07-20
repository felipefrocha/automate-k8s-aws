variable "project" {
  description = "Name to be used on all the resources as identifier, also the name of the ECS cluster"
  type        = string
  default     = "systems"
}

variable "environment" {
  description = "The environment"
  type        = string
  default     = "educate"
}

variable "region" {
  default = "us-east-1"
}

variable "vpc_main_cidr_block" {
  default     = "192.168.0.0/24"
  description = "Range of IPv4 address for the VPC main"
}

variable "azs" {
  type        = number
  description = "Availiablity zones where to put subnets"
  default     = 2
}