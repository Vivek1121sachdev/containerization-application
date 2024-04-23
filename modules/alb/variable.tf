variable "tag_prefix" {
  type        = string
  description = "tag prefix"
  default     = "CA"
}

variable "lb_name" {
  type        = string
  description = "Load Balancer Name"
}

variable "lb_type" {
  type        = string
  description = "Load Balancer Type"
}

variable "protocol" {
  type        = string
  description = "Protocol to use for routing"
  default     = "HTTP"
}
variable "tg_name" {
  type        = string
  description = "Target Group Name"
}

variable "target_type" {
  type        = string
  description = "Target Group Type"
}

variable "action_type" {
  type = string
  description = "Listener Default Action Type"
}

variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "app_port" {
  type        = number
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 3000
}

variable "http_port" {
  type        = number
  description = "http port"
  default     = 80
}

variable "public_subnet_id" {
  type        = list(string)
  description = "Public subnet ids"
}

variable "health_check_path" {
  description = "Target group health check path"
  default     = "/"
}