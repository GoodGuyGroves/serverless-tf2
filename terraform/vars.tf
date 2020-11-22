variable "AWS_ACCESS_KEY" {
}

variable "AWS_SECRET_KEY" {
}

variable "AWS_REGION" {
  type    = string
  default = "af-south-1"
}

variable "vpc_id" {
  type    = string
}

# variable "aws_subnet_terraform-private-1a" {
#   type    = string
#   default = "subnet-01809371ff742bcb3"
# }

# variable "aws_subnet_terraform-private-1b" {
#   type    = string
#   default = "subnet-0aeb300537d979a4e"
# }

# variable "aws_subnet_terraform-private-1c" {
#   type    = string
#   default = "subnet-0aba41fbc93c61019"
# }

variable "aws_subnet_terraform-public-1a" {
  type    = string
}

# variable "aws_subnet_terraform-public-1b" {
#   type    = string
#   default = "subnet-09b4e31e9a35c82ce"
# }

# variable "aws_subnet_terraform-public-1c" {
#   type    = string
#   default = "subnet-06c486c835ff8df04"
# }