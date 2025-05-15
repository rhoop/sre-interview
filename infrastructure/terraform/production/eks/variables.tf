variable "aws_access_key" {
  default = ""
}

variable "aws_secret_key" {
  default = ""
}

variable "aws_region" {
  default = "us-east-2"
}

variable "env" {
  default = "production"
}

terraform {
  backend "s3" {
    bucket = "test-terraform-state-use2"
    key    = "services/production/eks/main.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "test-terraform-state-use2"
    key    = "vpc/production/main.tfstate"
    region = "us-east-2"
  }
}

