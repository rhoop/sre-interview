terraform {
  backend "s3" {
    bucket = "dflow-terraform-state-use2"
    key    = "global/ecr/main.tfstate"
  }
}


data "terraform_remote_state" "iam" {
  backend = "s3"

  config = {
    bucket = "dflow-terraform-state-use2"
    key    = "global/iam/main.tfstate"
  }
}
