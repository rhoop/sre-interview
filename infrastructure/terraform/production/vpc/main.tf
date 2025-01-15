module "vpc" {
  source           = "../../modules//vpc"
  env              = var.env
  cidr_prefix      = data.terraform_remote_state.global.outputs.prod_cidr_prefix
  aws_access_key   = var.aws_access_key
  aws_secret_key   = var.aws_secret_key
  s3_bucket_prefix = data.terraform_remote_state.global.outputs.customer
  aws_region       = var.aws_region
}



output "subnet_protected" {
  value = tomap({
    "a" = tomap({
      "id"   = module.vpc.subnet_protected_1a_id,
      "name" = module.vpc.subnet_protected_1a_name,
      "zone" = "us-east-2a"
    }),
    "b" = tomap({
      "id"   = module.vpc.subnet_protected_1b_id,
      "name" = module.vpc.subnet_protected_1b_name,
      "zone" = "us-east-2b"
    }),
    "c" = tomap({
      "id"   = module.vpc.subnet_protected_1d_id,
      "name" = module.vpc.subnet_protected_1d_name,
      "zone" = "us-east-2c"
    }),
  })
}

output "subnet_private" {
  value = tomap({
    "a" = tomap({
      "id"   = module.vpc.subnet_private_1a_id,
      "name" = module.vpc.subnet_private_1a_name,
      "zone" = "us-east-2a"
    }),
    "b" = tomap({
      "id"   = module.vpc.subnet_private_1b_id,
      "name" = module.vpc.subnet_private_1b_name,
      "zone" = "us-east-2b"
    }),
    "c" = tomap({
      "id"   = module.vpc.subnet_private_1d_id,
      "name" = module.vpc.subnet_private_1d_name,
      "zone" = "us-east-2c"
    }),
  })

}

output "subnet_public" {
  value = tomap({
    "a" = tomap({
      "id"   = module.vpc.subnet_public_1a_id,
      "name" = module.vpc.subnet_public_1a_name,
      "zone" = "us-east-2a"
    }),
    "b" = tomap({
      "id"   = module.vpc.subnet_public_1b_id,
      "name" = module.vpc.subnet_public_1b_name,
      "zone" = "us-east-2b"
    }),
    "c" = tomap({
      "id"   = module.vpc.subnet_public_1d_id,
      "name" = module.vpc.subnet_public_1d_name,
      "zone" = "us-east-2c"
    }),
  })

}

output "subnet_vpn" {
  value = tomap({
    "a" = tomap({
      "id"   = module.vpc.subnet_vpn_1a_id,
      "name" = module.vpc.subnet_vpn_1a_name,
      "zone" = "us-east-2a"
    }),
    "b" = tomap({
      "id"   = module.vpc.subnet_vpn_1b_id,
      "name" = module.vpc.subnet_vpn_1b_name,
      "zone" = "us-east-2b"
    }),
    "c" = tomap({
      "id"   = module.vpc.subnet_vpn_1d_id,
      "name" = module.vpc.subnet_vpn_1d_name,
      "zone" = "us-east-2c"
    }),
  })
}

output "vpc" {
  value = tomap({
    "cidr" = "${data.terraform_remote_state.global.outputs.prod_cidr_prefix}.0.0/16",
    "id"   = module.vpc.vpc_id,
    "nat"  = module.vpc.vpc_nat,
    "igw"  = module.vpc.vpc_igw
  })

}
