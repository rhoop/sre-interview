terraform {
  backend "s3" {
    bucket = "test-terraform-state-use2"
    key    = "global/iam/main.tfstate"
  }
}

data "terraform_remote_state" "global" {
  backend = "s3"

  config = {
    bucket = "test-terraform-state-use2"
    key    = "global/variables/main.tfstate"
  }
}

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
