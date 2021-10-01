terraform {
  required_version = ">= 0.12.16"
  backend "s3" {
    bucket          = "abc-terraform-tfstate"
    key             = "ecs.tfstate"
    region          = "ap-south-1"
  }
}
