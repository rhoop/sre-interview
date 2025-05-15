
resource "aws_elasticache_subnet_group" "redis_prod" {
  name       = "platform-${var.service}-${var.env}"
  subnet_ids = [
    data.terraform_remote_state.vpc.outputs.subnet_private.a.id,
    data.terraform_remote_state.vpc.outputs.subnet_private.b.id,
    data.terraform_remote_state.vpc.outputs.subnet_private.c.id
  ]
}

resource "aws_elasticache_cluster" "test" {
  cluster_id           = "cluster-test"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1


  port                 = 6379
  security_group_ids         = [aws_security_group.redis_prod.id]
  subnet_group_name          = aws_elasticache_subnet_group.redis_prod.name

  log_delivery_configuration {
    destination      = "redis/platform/prod"
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "slow-log"
  }

}




