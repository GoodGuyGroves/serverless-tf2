# VPC
data "aws_vpc" "terraform-vpc" {
  id = var.vpc_id
}

# Subnets
## Private
### 1a
# data "aws_subnet" "terraform-private-1a" {
#   id = var.aws_subnet_terraform-private-1a
# }

# ### 1b
# data "aws_subnet" "terraform-private-1b" {
#   id = var.aws_subnet_terraform-private-1b
# }

# ### 1c
# data "aws_subnet" "terraform-private-1c" {
#   id = var.aws_subnet_terraform-private-1c
# }

## Public
### 1a
data "aws_subnet" "terraform-public-1a" {
  id = var.aws_subnet_terraform-public-1a
}

# ### 1b
# data "aws_subnet" "terraform-public-1b" {
#   id = var.aws_subnet_terraform-public-1b
# }

# ### 1c
# data "aws_subnet" "terraform-public-1c" {
#   id = var.aws_subnet_terraform-public-1c
# }