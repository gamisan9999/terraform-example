variable "project" {
  type    = "string"
  default = "terraform-demo-380476085523"
}

variable "region" {
  type    = "string"
  default = "ap-northeast-1"
}

variable "vpc_name" {
  type    = "string"
  default = "vpc"
}

variable "dns_hostnames" {
  type    = "string"
  default = "true"
}

variable "ip_address" {
  type    = "string"
  default = "10.0.0.0/16"
}

variable "ip_address_network_portion" {
  type    = "string"
  default = "10.0"
}

variable "public-route-igw" {
  type    = "string"
  default = ".0.0/23,.32.0/23,.64.0/23,.96.0/23,.128.0/23,.160.0/23"
}

variable "public-route-variable" {
  type    = "string"
  default = ".2.0/23,.34.0/23,.66.0/23,.98.0/23,.130.0/23,.162.0/23"
}

variable "protected-route-nat" {
  type    = "string"
  default = ".4.0/23,.36.0/23,.68.0/23,.100.0/23,.132.0/23,.164.0/23"
}

variable "private-route-local" {
  type    = "string"
  default = ".6.0/23,.38.0/23,.70.0/23,.102.0/23,.134.0/23,.166.0/23"
}

variable "availability_zone" {
  type    = "string"
  default = "ap-northeast-1a,ap-northeast-1c"
}

variable "environment" {
  type    = "string"
  default = "dev,dev,stg,stg,prd,prd"
}

variable "office_ip" {
  type    = "list"
  default = ["192.168.0.1/32"]
}

variable "PJCODE_ip" {
  type = "list"

  default = [
    "192.168.0.1/32",
  ]
}

variable "aws_rds_stg_password" {}
variable "aws_rds_prod_password" {}

variable "slack_webhook_url" {
  default = ""
}
