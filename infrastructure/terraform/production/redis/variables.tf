
variable "env" {
  default = "prod"
}

variable "service" {
  default = "redis"
}

terraform {
  backend "s3" {
    bucket = "dflow-terraform-state-use2"
    key    = "redis/prod/main.tfstate"
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
  }
}
