# ecr default user
resource "aws_iam_role" "ecr" {
  name               = "ecr"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource "aws_iam_instance_profile" "ecr" {
  name = "ecr"
  role = aws_iam_role.ecr.name
}

# Used for all ECR Repos by default
# Allows build and deploy
data "aws_iam_policy_document" "test_main_ecr_policy" {
  statement {
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:ListImages",
      "ecr:CompleteLayerUpload",
    ]

    principals {
      type = "AWS"

      identifiers = [
        aws_iam_role.builder.arn,
      ]
    }
  }
}

# This is for read and write to ECR for users
data "aws_iam_policy_document" "test_pullpush_ecr_policy_doc" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:ListImages",
      "ecr:CompleteLayerUpload",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "test_pullpush_ecr_policy" {
  name        = "test_pullpush_ecr"
  description = "Push and Pull ECR"
  policy      = data.aws_iam_policy_document.test_pullpush_ecr_policy_doc.json
}

resource "aws_iam_policy_attachment" "test_pullpush_ecr_policy" {
  name = "test_pullpush_ecr_attach"

  roles = [
    aws_iam_role.builder.name,
  ]

  policy_arn = aws_iam_policy.test_pullpush_ecr_policy.arn
}
