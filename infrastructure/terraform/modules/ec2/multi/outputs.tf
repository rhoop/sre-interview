# output "multi_ec2_security_group" {
#   value = aws_security_group.multi_ec2_secgroup.id
# }

output "multi_ec2_instance" {
  value = aws_instance.multi_ec2_instance.id
}

output "multi_ec2_instance_private_ip" {
  value = aws_instance.multi_ec2_instance.private_ip
}

output "multi_ec2_instance_public_ip" {
  value = aws_instance.multi_ec2_instance.public_ip
}
