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
