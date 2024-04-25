variable "tag-prefix" {
  type        = string
  description = "tag-prefix"
}
variable "vpc_ip" {
  type        = string
  description = "vpc ip address"
  default     = "10.0.0.0/16"
}

variable "public_cidr_block" {
  type        = string
  description = "CIDR block IP"
}

variable "public_subnet" {
  type        = map(any)
  description = "Public Subnet"
  default = {
    "us-east-1a" = "10.0.1.0/24"
    "us-east-1b" = "10.0.2.0/24"
  }
}

variable "private_subnet_ecs" {
  type        = map(any)
  description = "Private Subnet for ECS"
  default = {
    "us-east-1a" = "10.0.3.0/24"
    "us-east-1b" = "10.0.4.0/24"
  }
}

variable "private_subnet_rds" {
  type        = map(any)
  description = "Private Subnet for RDS"
  default = {
    "us-east-1a" = "10.0.5.0/24"
    "us-east-1b" = "10.0.6.0/24"
  }
}

# variable "availability_zone" {
#   type = list(string)
#   description = "availability zone"
#   default = ["us-east-1a", "us-east-1b"]
# }