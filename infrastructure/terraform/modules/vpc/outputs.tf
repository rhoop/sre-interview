output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_nat" {
  value = aws_nat_gateway.vpc_nat.id
}

output "vpc_igw" {
  value = aws_internet_gateway.vpc.id
}

# private
output "subnet_private_1a_id" {
  value = aws_subnet.private-1a.id
}

output "subnet_private_1b_id" {
  value = aws_subnet.private-1b.id
}

output "subnet_private_1d_id" {
  value = aws_subnet.private-1d.id
}

output "subnet_private_1a_name" {
  value = aws_subnet.private-1a.tags.Name
}

output "subnet_private_1b_name" {
  value = aws_subnet.private-1b.tags.Name
}

output "subnet_private_1d_name" {
  value = aws_subnet.private-1d.tags.Name
}

# protected
output "subnet_protected_1a_id" {
  value = aws_subnet.protected-1a.id
}

output "subnet_protected_1b_id" {
  value = aws_subnet.protected-1b.id
}

output "subnet_protected_1d_id" {
  value = aws_subnet.protected-1d.id
}

output "subnet_protected_1a_name" {
  value = aws_subnet.protected-1a.tags.Name
}

output "subnet_protected_1b_name" {
  value = aws_subnet.protected-1b.tags.Name
}

output "subnet_protected_1d_name" {
  value = aws_subnet.protected-1d.tags.Name
}

# public
output "subnet_public_1a_id" {
  value = aws_subnet.public-1a.id
}

output "subnet_public_1b_id" {
  value = aws_subnet.public-1b.id
}

output "subnet_public_1d_id" {
  value = aws_subnet.public-1d.id
}

output "subnet_public_1a_name" {
  value = aws_subnet.public-1a.tags.Name
}

output "subnet_public_1b_name" {
  value = aws_subnet.public-1b.tags.Name
}

output "subnet_public_1d_name" {
  value = aws_subnet.public-1d.tags.Name
}

# vpn
output "subnet_vpn_1a_id" {
  value = aws_subnet.vpn-1a.id
}

output "subnet_vpn_1b_id" {
  value = aws_subnet.vpn-1b.id
}

output "subnet_vpn_1d_id" {
  value = aws_subnet.vpn-1d.id
}

output "subnet_vpn_1a_name" {
  value = aws_subnet.vpn-1a.tags.Name
}

output "subnet_vpn_1b_name" {
  value = aws_subnet.vpn-1b.tags.Name
}

output "subnet_vpn_1d_name" {
  value = aws_subnet.vpn-1d.tags.Name
}
