output "route_tables" {
  value = tomap({
    "prod" = tomap({
      "private"   = module.prod_routes.route_table_private,
      "protected" = module.prod_routes.route_table_protected,
      "public"    = module.prod_routes.route_table_public,
    }),
  })
}

