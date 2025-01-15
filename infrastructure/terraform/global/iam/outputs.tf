# Outputs
output "instance_assume_role_policy" {
  value = data.aws_iam_policy_document.instance_assume_role_policy.json
}

output "aws_iam_instance_profile_deployed" {
  value = aws_iam_instance_profile.deployed.name
}

output "aws_iam_instance_profile_deployed_id" {
  value = aws_iam_instance_profile.deployed.id
}

output "aws_iam_instance_profile_builder" {
  value = aws_iam_instance_profile.builder.name
}

output "aws_iam_instance_profile_ecr" {
  value = aws_iam_instance_profile.ecr.name
}

output "dflow_main_ecr_policy" {
  value = data.aws_iam_policy_document.dflow_main_ecr_policy.json
}
