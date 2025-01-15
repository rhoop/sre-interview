output "aws_region" {
  value = "us-east-2"
}

output "customer" {
  value = "dflow"
}


output "external_domain" {
  value = "dflow.net"
}

output "aws_keypair_name" {
  value = "dflow"
}


output "iam_profile" {
  value = "deployed"
}

output "iam_builder_profile" {
  value = "builder"
}

output "internal_cidr_blocks" {
  value = "10.0.0.0/8"
}

output "systems_cidr_prefix" {
  value = "10.10"
}

output "stage_cidr_prefix" {
  value = "10.20"
}

output "prod_cidr_prefix" {
  value = "10.40"
}


output "s3_log_id" {
  value = "dflow-prod-s3-logs"
}

output "s3_bucket_prefix" {
  value = "dflow"
}

output "s3_bucket_region" {
  value = "use2"
}


output "aws_account_number" {
  value = "491085427149"
}
