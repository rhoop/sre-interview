resource "aws_ecr_repository" "app-ecr" {
  name = "app"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository_policy" "app_api_ecr" {
  repository = aws_ecr_repository.app_api_ecr.name
  policy     = data.terraform_remote_state.iam.outputs.dflow_main_ecr_policy
}

