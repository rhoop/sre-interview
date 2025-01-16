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
  default = "prod"
}

variable "service" {
  default = "psql"
}

terraform {
  backend "s3" {
    bucket = "dflow-terraform-state-use2"
    key    = "psql/prod/main.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "global" {
  backend = "s3"

  config = {
    bucket = "dflow-terraform-state-use2"
    key    = "global/variables/main.tfstate"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "dflow-terraform-state-use2"
    key    = "vpc/production/main.tfstate"
    region = "us-east-2"
  }
}

