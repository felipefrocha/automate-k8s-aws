variable "project" {
  description = "Name to be used on all the resources as identifier, also the name of the ECS cluster"
  type        = string
  default     = "systems"
}

variable "environment" {
  description = "The environment"
  type        = string
  default     = "dev"
}

variable "region" {
  default = "us-east-1"
}

variable "ami" {
  default = "ami-07ebfd5b3428b6f4d"
}
variable "cluster-size" {
  default = 3
}


