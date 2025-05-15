resource "aws_ecr_repository" "app_ecr" {
  name = "app"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository_policy" "app_ecr" {
  repository = aws_ecr_repository.app_ecr.name
  policy     = data.terraform_remote_state.iam.outputs.test_main_ecr_policy
}

