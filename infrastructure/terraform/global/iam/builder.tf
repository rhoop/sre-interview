resource "aws_iam_user" "builder" {
  name = "builder"
}
# build server should be unique
resource "aws_iam_role" "builder" {
  name               = "builder"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource "aws_iam_instance_profile" "builder" {
  name = "builder"
  role = aws_iam_role.builder.name
}

data "aws_iam_policy_document" "builder_ec2_control" {
  statement {
    actions = [
      "ec2:*",
      "elasticloadbalancing:*",
      "cloudwatch:*",
      "autoscaling:*",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "builder_ec2_control_policy" {
  name        = "builder_ec2_control"
  description = "Manage EC2"
  policy      = data.aws_iam_policy_document.builder_ec2_control.json
}

resource "aws_iam_policy_attachment" "builder_ec2_control_policy" {
  name = "builder_ec2_control_policy"

  roles = [
    aws_iam_role.builder.name,
  ]
  users = [
    aws_iam_user.builder.name
  ]

  policy_arn = aws_iam_policy.builder_ec2_control_policy.arn
}



