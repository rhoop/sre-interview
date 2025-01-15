provider "aws" {
  region = var.aws_region
}

# Filter out local zones, which are not currently supported
# with managed node groups
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  cluster_name = "dflow-production-eks"
}


module "eks" {
  source = "terraform-aws-modules/eks/aws"
  # version = "19.15.3"

  cluster_name    = local.cluster_name
  cluster_version = "1.31"

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc.id
  subnet_ids = [
    data.terraform_remote_state.vpc.outputs.subnet_private.a.id,
    data.terraform_remote_state.vpc.outputs.subnet_private.b.id,
    data.terraform_remote_state.vpc.outputs.subnet_private.c.id
  ]
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    ondemand = {
      name = "dflow-production-spot"

      instance_types = ["t3.small", "t3.medium"]

      capacity_type      = "SPOT"
      min_size           = 3
      max_size           = 20
      desired_size       = 3
      kubelet_extra_args = "--node-labels=node.kubernetes.io/lifecycle=spot,instance_type=normal"

    }

  }
}
resource "aws_ec2_tag" "public_subnet_elb_shared" {
  for_each    = data.terraform_remote_state.vpc.outputs.subnet_public
  resource_id = each.value.id
  key         = "kubernetes.io/cluster/${local.cluster_name}"
  value       = "shared"
}

resource "aws_ec2_tag" "public_subnet_elb_enabled" {
  for_each    = data.terraform_remote_state.vpc.outputs.subnet_public
  resource_id = each.value.id
  key         = "kubernetes.io/role/elb"
  value       = 1
}

resource "aws_ec2_tag" "private_subnet_elb_shared" {
  for_each    = data.terraform_remote_state.vpc.outputs.subnet_private
  resource_id = each.value.id
  key         = "kubernetes.io/cluster/${local.cluster_name}"
  value       = "shared"
}

resource "aws_ec2_tag" "private_subnet_elb_enabled" {
  for_each    = data.terraform_remote_state.vpc.outputs.subnet_private
  resource_id = each.value.id
  key         = "kubernetes.io/role/internal-elb"
  value       = 1
}

# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"


  create_role                   = true
  role_name                     = "AmazonEKS-EBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

resource "aws_eks_addon" "ebs-csi" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  # addon_version            = "v1.26.1-eksbuild.1"
  service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
  tags = {
    "eks_addon" = "ebs-csi"
    "terraform" = "true"
  }
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = module.eks.cluster_name
  addon_name                  = "coredns"
  # addon_version               = "v1.11.1-eksbuild.4"
  resolve_conflicts_on_create = "OVERWRITE"
  service_account_role_arn    = "arn:aws:iam::491085427149:role/AmazonEKS-EBSCSIRole-dflow-production-eks"

  tags = {
    "eks_addon" = "coredns"
    "terraform" = "true"
  }
}

resource "aws_eks_addon" "eks-pod-identity-agent" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "eks-pod-identity-agent"
  # addon_version            = "v1.0.0-eksbuild.1"
  service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
  # resolve_conflicts_on_create = "OVERWRITE"
  tags = {
    "eks_addon" = "eks-pod-identity-agent"
    "terraform" = "true"
  }
}

resource "aws_eks_addon" "kube-proxy" {
  cluster_name                = module.eks.cluster_name
  addon_name                  = "kube-proxy"
  # addon_version               = "v1.29.0-eksbuild.1"
  resolve_conflicts_on_create = "OVERWRITE"
  service_account_role_arn    = "arn:aws:iam::491085427149:role/AmazonEKS-EBSCSIRole-dflow-production-eks"
  tags = {
    "eks_addon" = "kube-proxy"
    "terraform" = "true"
  }
}

resource "aws_eks_addon" "vpc-cni" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "vpc-cni"
  # addon_version = "v1.14.1-eksbuild.1"
  # resolve_conflicts_on_create = "OVERWRITE"
  tags = {
    "eks_addon" = "vpc-cni"
    "terraform" = "true"
  }
}

# resource "aws_eks_addon" "aws-efs-csi-driver" {
#   cluster_name  = module.eks.cluster_name
#   addon_name    = "aws-efs-csi-driver"
  # addon_version = "v1.7.2-eksbuild.1"
#   # resolve_conflicts_on_create = "OVERWRITE"
#   tags = {
#     "eks_addon" = "aws-efs-csi-driver"
#     "terraform" = "true"
#   }
# }
