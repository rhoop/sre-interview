module "prod_routes" {
  source           = "../../modules//leef_routes"
  env              = "production"
  s3_bucket_prefix = data.terraform_remote_state.global.outputs.s3_bucket_prefix
  s3_bucket_region = data.terraform_remote_state.global.outputs.s3_bucket_region
  aws_access_key   = var.aws_access_key
  aws_secret_key   = var.aws_secret_key
  aws_region       = var.aws_region
}

