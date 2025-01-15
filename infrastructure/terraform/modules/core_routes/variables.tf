variable "aws_region" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "env" {}
variable "prod_cidr" {
  default = ""
}
variable "prod_connection_id" {
  default = ""
}
variable "uat_cidr" {
  default = ""
}
variable "uat_connection_id" {
  default = ""
}
variable "staging_cidr" {
  default = ""
}
variable "staging_connection_id" {
  default = ""
}
variable "dev_cidr" {
  default = ""
}
variable "dev_connection_id" {
  default = ""
}
variable "s3_bucket_prefix" {}
variable "s3_bucket_region" {}

