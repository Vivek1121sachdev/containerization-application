variable "tag-prefix" {
  type = string
  description = "tag prefix"
  default = "CA"
}

variable "cidr_block" {
  type = string
  description = "CIDR block IP"
}

variable "vpc_id" {
  type = string
  description = "vpc id"
}

variable "ig_id" {
  type = string
  description = "internet gateway id"
}

variable "nat_gw_id" {
  type = string
  description = "nat gateway id"
}

variable "public_subnet_id" {
  type = list(string)
  description = "public subnet id"
}

variable "private_subnet_id" {
  type = list(string)
  description = "private_subnet_id"
}