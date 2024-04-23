variable "tag-prefix" {
  type = string
  description = "tag prefix"
  default = "CA"
}

variable "vpc_id" {
  type = string
  description = "vpc id"
}

variable "public_subnet_id" {
  type = string
  description = "public subnet id"
}