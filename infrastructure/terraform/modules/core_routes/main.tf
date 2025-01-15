data "terraform_remote_state" "systems" {
  backend = "s3"

  config = {
    bucket = "${var.s3_bucket_prefix}-terraform-state-${var.s3_bucket_region}" // "
    key    = "vpc/systems/main.tfstate"
    region = var.aws_region
  }
}

# Routing table for vpn subnets
resource "aws_route_table" "vpn" {
  vpc_id = data.terraform_remote_state.systems.outputs.vpc.id

  tags = {
    Name = "${var.env}_vpn" //"
  }
}

resource "aws_route" "vpn_egress" {
  route_table_id         = aws_route_table.vpn.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = data.terraform_remote_state.systems.outputs.vpc.igw
}

resource "aws_route" "vpn_to_prod" {
  route_table_id            = aws_route_table.vpn.id
  destination_cidr_block    = var.prod_cidr
  vpc_peering_connection_id = var.prod_connection_id
}

# resource "aws_route" "vpn_to_uat" {
#   route_table_id            = aws_route_table.vpn.id
#   destination_cidr_block    = var.uat_cidr
#   vpc_peering_connection_id = var.uat_connection_id
# }

resource "aws_route" "vpn_to_staging" {
  route_table_id            = aws_route_table.vpn.id
  destination_cidr_block    = var.staging_cidr
  vpc_peering_connection_id = var.staging_connection_id
}

# resource "aws_route" "vpn_to_dev" {
#   route_table_id            = aws_route_table.vpn.id
#   destination_cidr_block    = var.dev_cidr
#   vpc_peering_connection_id = var.dev_connection_id
# }

resource "aws_route_table_association" "vpn-1a" {
  subnet_id      = data.terraform_remote_state.systems.outputs.subnet_vpn.a.id
  route_table_id = aws_route_table.vpn.id
}

resource "aws_route_table_association" "vpn-1b" {
  subnet_id      = data.terraform_remote_state.systems.outputs.subnet_vpn.b.id
  route_table_id = aws_route_table.vpn.id
}

resource "aws_route_table_association" "vpn-1d" {
  subnet_id      = data.terraform_remote_state.systems.outputs.subnet_vpn.c.id
  route_table_id = aws_route_table.vpn.id
}

# resource "aws_route" "vpn_to_vpn_udp" {
#   route_table_id         = aws_route_table.vpn.id
#   destination_cidr_block = "172.31.0.0/16"
#   instance_id            = "i-02633eaa42db6df7f"
# }

# resource "aws_route" "vpn_to_vpn_tcp" {
#   route_table_id         = aws_route_table.vpn.id
#   destination_cidr_block = "172.32.0.0/16"
#   instance_id            = "i-02633eaa42db6df7f"
# }

# Routing table for public subnets
resource "aws_route_table" "public" {
  vpc_id = data.terraform_remote_state.systems.outputs.vpc.id

  tags = {
    Name = "${var.env}_public" //"
  }
}

resource "aws_route" "public_egress" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = data.terraform_remote_state.systems.outputs.vpc.igw
}

resource "aws_route_table_association" "public-1a" {
  subnet_id      = data.terraform_remote_state.systems.outputs.subnet_public.a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-1b" {
  subnet_id      = data.terraform_remote_state.systems.outputs.subnet_public.b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-1d" {
  subnet_id      = data.terraform_remote_state.systems.outputs.subnet_public.c.id
  route_table_id = aws_route_table.public.id
}

# resource "aws_route" "public_to_vpn_udp" {
#   route_table_id         = aws_route_table.public.id
#   destination_cidr_block = "172.31.0.0/16"
#   instance_id            = "i-02633eaa42db6df7f"
# }

# resource "aws_route" "public_to_vpn_tcp" {
#   route_table_id         = aws_route_table.public.id
#   destination_cidr_block = "172.32.0.0/16"
#   instance_id            = "i-02633eaa42db6df7f"
# }

# Routing table for private subnets
resource "aws_route_table" "private" {
  vpc_id = data.terraform_remote_state.systems.outputs.vpc.id

  tags = {
    Name = "${var.env}_private" //"
  }
}

resource "aws_route" "private_egress" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = data.terraform_remote_state.systems.outputs.vpc.nat
}

resource "aws_route" "private_to_prod" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = var.prod_cidr
  vpc_peering_connection_id = var.prod_connection_id
}

# resource "aws_route" "private_to_uat" {
#   route_table_id            = aws_route_table.private.id
#   destination_cidr_block    = var.uat_cidr
#   vpc_peering_connection_id = var.uat_connection_id
# }

resource "aws_route" "private_to_staging" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = var.staging_cidr
  vpc_peering_connection_id = var.staging_connection_id
}

# resource "aws_route" "private_to_dev" {
#   route_table_id            = aws_route_table.private.id
#   destination_cidr_block    = var.dev_cidr
#   vpc_peering_connection_id = var.dev_connection_id
# }

# resource "aws_route" "private_to_vpn_udp" {
#   route_table_id         = aws_route_table.private.id
#   destination_cidr_block = "172.31.0.0/16"
#   instance_id            = "i-02633eaa42db6df7f"
# }

# resource "aws_route" "private_to_vpn_tcp" {
#   route_table_id         = aws_route_table.private.id
#   destination_cidr_block = "172.32.0.0/16"
#   instance_id            = "i-02633eaa42db6df7f"
# }

resource "aws_route_table_association" "private-1a" {
  subnet_id      = data.terraform_remote_state.systems.outputs.subnet_private.a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-1b" {
  subnet_id      = data.terraform_remote_state.systems.outputs.subnet_private.b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-1d" {
  subnet_id      = data.terraform_remote_state.systems.outputs.subnet_private.c.id
  route_table_id = aws_route_table.private.id
}

# Routing table for protected subnets
resource "aws_route_table" "protected" {
  vpc_id = data.terraform_remote_state.systems.outputs.vpc.id

  tags = {
    Name = "${var.env}_protected" //"
  }
}

resource "aws_route_table_association" "protected-1a" {
  subnet_id      = data.terraform_remote_state.systems.outputs.subnet_protected.a.id
  route_table_id = aws_route_table.protected.id
}

resource "aws_route_table_association" "protected-1b" {
  subnet_id      = data.terraform_remote_state.systems.outputs.subnet_protected.b.id
  route_table_id = aws_route_table.protected.id
}

resource "aws_route_table_association" "protected-1d" {
  subnet_id      = data.terraform_remote_state.systems.outputs.subnet_protected.c.id
  route_table_id = aws_route_table.protected.id
}

