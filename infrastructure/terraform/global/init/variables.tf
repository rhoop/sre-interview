terraform {
  backend "s3" {
    bucket = "dflow-terraform-state-use2"
    key    = "global/init/main.tfstate"
  }
}
