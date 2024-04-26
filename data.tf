data "aws_ecr_image" "image" {
  repository_name = module.ecr.repository_name
  image_tag       = "12345"
}

locals {
  parameter = {
    vivek = "database123"
  }
}