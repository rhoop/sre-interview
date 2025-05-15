terraform {
  backend "s3" {
    bucket = "test-terraform-state-use2"
    key    = "global/variables/main.tfstate"
  }
}
