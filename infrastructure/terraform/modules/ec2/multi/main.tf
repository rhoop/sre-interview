resource "aws_instance" "multi_ec2_instance" {
  ami                         = var.aws_ami
  availability_zone           = var.subnet_availability_zone
  instance_type               = var.instance_type
  key_name                    = var.aws_keypair_name
  vpc_security_group_ids      = var.security_group_ids
  subnet_id                   = var.subnet_id
  disable_api_termination     = var.disable_api_termination
  monitoring                  = var.monitoring
  ebs_optimized               = var.ebs_optimized
  iam_instance_profile        = var.iam_profile
  associate_public_ip_address = var.associate_public_ip_address
  source_dest_check           = var.source_dest_check
  user_data                   = var.user_data

  tags = {
    Name      = "${var.instance_name_tag_prefix}-${var.subnet_name}"
    vpc       = var.env
    app_class = var.app_class
    app_role  = var.app_role
  }

  root_block_device {
    volume_size           = var.root_block_device_volume_size
    volume_type           = var.root_block_device_volume_type
    delete_on_termination = var.root_block_device_delete_on_termination

    tags = {
      Name = "${var.instance_name_tag_prefix}-${var.subnet_name}"
    }
  }

  lifecycle {
    ignore_changes = [ami, user_data]
  }
}
