resource "aws_security_group" "redis_prod" {
  name        = "${var.service}-${var.env}"
  description = "Prod VPC redis access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.terraform_remote_state.global.outputs.internal_cidr_blocks}"]
  }

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks =  [
      "${data.terraform_remote_state.global.outputs.internal_cidr_blocks}",
      "10.0.0.0/8"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc.id

  tags = {
    Name = "${var.env}_redis"
  }
}
