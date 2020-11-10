terraform {
  backend "s3" {
    bucket = "terraform-russellgroves"
    key    = "state/projects/serverless-tf2/terraform.tfstate"
    region = "af-south-1"
  }
}