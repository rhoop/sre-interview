# ROLE
resource "aws_iam_role" "deployed" {
  name               = "deployed"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

# INSTANCE ROLE
resource "aws_iam_instance_profile" "deployed" {
  name = "deployed"
  role = aws_iam_role.deployed.name
}


############## DESCRIBE EC2 ##############
data "aws_iam_policy_document" "deployed_describe_ec2_doc" {
  statement {
    actions = [
      "ec2:Describe*",
    ]

    resources = ["*"]
  }
}

# CREATE POLICY
resource "aws_iam_policy" "deployed_describe_ec2" {
  name        = "deployed_describe_ec2"
  description = "Let EC2 ask AWS about instances"
  policy      = data.aws_iam_policy_document.deployed_describe_ec2_doc.json
}

# ATTACH
resource "aws_iam_policy_attachment" "deployed_describe_ec2" {
  name = "deployed_describe_ec2_attach"

  roles = [
    aws_iam_role.deployed.name,
  ]

  policy_arn = aws_iam_policy.deployed_describe_ec2.arn
}

############## DESCRIBE/GET ECR ##############
data "aws_iam_policy_document" "deployed_readonly_ecr_doc" {
  statement {
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:ListImages",
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }
}

# CREATE POLICY
resource "aws_iam_policy" "deployed_readonly_ecr" {
  name        = "deployed_readonly_ecr"
  description = "Let EC2 ask AWS about instances"
  policy      = data.aws_iam_policy_document.deployed_readonly_ecr_doc.json
}

# ATTACH
resource "aws_iam_policy_attachment" "deployed_readonly_ecr" {
  name = "deployed_readonly_ecr_attach"

  roles = [
    aws_iam_role.deployed.name,
  ]

  policy_arn = aws_iam_policy.deployed_readonly_ecr.arn
}
