variable "tag-prefix" {
  type = string
  description = "tag-prefix"
}
variable "vpc_ip" {
  type = string
  description = "vpc ip address"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
 type = list(string)
 description = "Public Subnet CIDR values"
 default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
 type = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zone" {
  type = list(string)
  description = "availability zone"
  default = ["us-east-1a", "us-east-1b"]
}