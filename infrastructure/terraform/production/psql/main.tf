resource "aws_db_subnet_group" "psql_prod" {
  name = "platform-${var.service}-${var.env}"
  subnet_ids = [
    data.terraform_remote_state.vpc.outputs.subnet_private.a.id,
    data.terraform_remote_state.vpc.outputs.subnet_private.b.id,
    data.terraform_remote_state.vpc.outputs.subnet_private.c.id
  ]
}

resource "aws_security_group" "psql_prod" {
  name        = "${var.service}-${var.env}"
  description = "Prod VPC psql access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.terraform_remote_state.global.outputs.internal_cidr_blocks}"]
  }

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    cidr_blocks = [
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
    Name = "${var.env}_psql"
  }
}


resource "aws_db_instance" "default" {
  allocated_storage = 10
  db_name           = "mydb"
  engine            = "mysql"
  instance_class    = "db.t4g.micro"
  username          = "postgres"
  password          = "postgres"

  vpc_security_group_ids = [aws_security_group.psql_prod.id]
  db_subnet_group_name   = aws_db_subnet_group.psql_prod.name

  skip_final_snapshot = true
}
