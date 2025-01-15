variable "aws_region" {
  type        = string
  description = "Region to run this plan"
  default     = "us-west-2"
}

variable "env" {
  type        = string
  description = "The zone to run this plan"
  default     = "dev"
}

variable "iam_profile" {
  type        = string
  description = "Profile to use on this box"
  default     = "deployed"
}

variable "disable_api_termination" {
  default = false
}

variable "monitoring" {
  default = false
}

variable "ebs_optimized" {
  default = true
}

variable "internal_cidr_blocks" {
  default = "172.16.0.0/12"
}

variable "root_block_device_volume_size" {
  default = 30
}

variable "root_block_device_volume_type" {
  default = "gp2"
}

variable "root_block_device_delete_on_termination" {
  default = true
}

variable "associate_public_ip_address" {
  default = false
}

variable "source_dest_check" {
  default = true
}

variable "user_data" {
  default = ""
}

variable "subnet_availability_zone" {}
variable "subnet_id" {}
variable "subnet_name" {}
variable "vpc_id" {}
variable "app_class" {}
variable "app_role" {}
variable "aws_ami" {}
variable "instance_type" {}
variable "aws_keypair_name" {}
variable "instance_name_tag_prefix" {}
variable "security_group_description" {}
variable "security_group_ids" {}
