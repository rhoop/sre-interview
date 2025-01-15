output "singleton_ec2_security_group" {
  value = aws_security_group.singleton_ec2_secgroup.id
}

output "singleton_ec2_instance" {
  value = aws_instance.singleton_ec2_instance.id
}

output "singleton_ec2_instance_private_ip" {
  value = aws_instance.singleton_ec2_instance.private_ip
}

output "singleton_ec2_instance_public_ip" {
  value = aws_instance.singleton_ec2_instance.public_ip
}
