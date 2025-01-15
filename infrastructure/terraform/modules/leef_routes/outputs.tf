output "route_table_public" {
  value = aws_route_table.public.id
}

output "route_table_private" {
  value = aws_route_table.private.id
}

output "route_table_protected" {
  value = aws_route_table.protected.id
}
