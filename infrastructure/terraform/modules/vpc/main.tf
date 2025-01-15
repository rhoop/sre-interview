resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr_prefix}.0.0/16"
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = var.env
  }
}

resource "aws_internet_gateway" "vpc" {
  vpc_id = aws_vpc.vpc.id
}

# VPN subnets

resource "aws_subnet" "vpn-1a" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-vpn-1a"
  }

  cidr_block        = "${var.cidr_prefix}.192.0/20"
  availability_zone = "${var.aws_region}a"
}

resource "aws_subnet" "vpn-1b" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-vpn-1b"
  }

  cidr_block        = "${var.cidr_prefix}.208.0/20"
  availability_zone = "${var.aws_region}b"
}

resource "aws_subnet" "vpn-1d" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-vpn-1d"
  }

  cidr_block        = "${var.cidr_prefix}.224.0/20"
  availability_zone = "${var.aws_region}c"
}

# Public subnets

resource "aws_subnet" "public-1a" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-public-1a"
  }

  cidr_block        = "${var.cidr_prefix}.0.0/20"
  availability_zone = "${var.aws_region}a"
}

resource "aws_subnet" "public-1b" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-public-1b"
  }

  cidr_block        = "${var.cidr_prefix}.64.0/20"
  availability_zone = "${var.aws_region}b"
}

resource "aws_subnet" "public-1d" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-public-1d"
  }

  cidr_block        = "${var.cidr_prefix}.128.0/20"
  availability_zone = "${var.aws_region}c"
}

# Private subsets

resource "aws_subnet" "private-1a" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-private-1a"
  }

  cidr_block        = "${var.cidr_prefix}.16.0/20"
  availability_zone = "${var.aws_region}a"
}

resource "aws_subnet" "private-1b" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-private-1b"
  }

  cidr_block        = "${var.cidr_prefix}.80.0/20"
  availability_zone = "${var.aws_region}b"
}

resource "aws_subnet" "private-1d" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-private-1d"
  }

  cidr_block        = "${var.cidr_prefix}.144.0/20"
  availability_zone = "${var.aws_region}c"
}

# Protected subsets

resource "aws_subnet" "protected-1a" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-protected-1a"
  }

  cidr_block        = "${var.cidr_prefix}.32.0/20"
  availability_zone = "${var.aws_region}a"
}

resource "aws_subnet" "protected-1b" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-protected-1b"
  }

  cidr_block        = "${var.cidr_prefix}.96.0/20"
  availability_zone = "${var.aws_region}b"
}

resource "aws_subnet" "protected-1d" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-protected-1d"
  }

  cidr_block        = "${var.cidr_prefix}.160.0/20"
  availability_zone = "${var.aws_region}c"
}

/// NAT
resource "aws_eip" "vpc-nat-1a" {
  depends_on = [aws_internet_gateway.vpc]
  domain     = "vpc"
  tags = {
    Name = "${var.env}-NAT"
  }
}

resource "aws_nat_gateway" "vpc_nat" {
  allocation_id = aws_eip.vpc-nat-1a.id
  subnet_id     = aws_subnet.public-1a.id
  depends_on    = [aws_internet_gateway.vpc]
  tags = {
    Name = "${var.env}-NAT"
  }
}

/// Packer
resource "aws_security_group" "vpc_packer" {
  name        = "${var.env}_packer"
  description = "Packer Group for AMI Building. Needs SSH Access."

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8301
    to_port     = 8301
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 8301
    to_port     = 8301
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.vpc.id
}
