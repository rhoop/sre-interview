resource "aws_security_group" "singleton_ec2_secgroup" {
  name        = "${var.env}_${var.app_role}"
  description = var.security_group_description

  vpc_id = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "singleton_ec2_secgroup_22_tcp" {
  security_group_id = aws_security_group.singleton_ec2_secgroup.id

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = var.internal_cidr_blocks

}

resource "aws_security_group_rule" "singleton_ec2_secgroup_8301_tcp" {
  security_group_id = aws_security_group.singleton_ec2_secgroup.id
  type              = "ingress"
  from_port         = 8301
  to_port           = 8301
  protocol          = "tcp"
  cidr_blocks       = var.internal_cidr_blocks
}

resource "aws_security_group_rule" "singleton_ec2_secgroup_8301_udp" {
  security_group_id = aws_security_group.singleton_ec2_secgroup.id
  type              = "ingress"
  from_port         = 8301
  to_port           = 8301
  protocol          = "udp"
  cidr_blocks       = var.internal_cidr_blocks
}

resource "aws_security_group_rule" "singleton_ec2_secgroup_egress" {
  security_group_id = aws_security_group.singleton_ec2_secgroup.id

  type        = "egress"
  from_port   = 0
  to_port     = 65535
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_instance" "singleton_ec2_instance" {
  ami                         = var.aws_ami
  availability_zone           = var.subnet_availability_zone
  instance_type               = var.instance_type
  key_name                    = var.aws_keypair_name
  vpc_security_group_ids      = ["${aws_security_group.singleton_ec2_secgroup.id}"]
  subnet_id                   = var.subnet_id
  disable_api_termination     = var.disable_api_termination
  monitoring                  = var.monitoring
  ebs_optimized               = var.ebs_optimized
  iam_instance_profile        = var.iam_profile
  associate_public_ip_address = var.associate_public_ip_address
  source_dest_check           = var.source_dest_check
  user_data                   = var.user_data

  dynamic "instance_market_options" {
    for_each = var.spot != false ? [0] : []
    content {
      market_type = "spot"
    }
  }

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
