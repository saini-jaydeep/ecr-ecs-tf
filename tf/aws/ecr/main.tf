module "ecr" {
  source               = "../../../modules/aws-tf/ecr"
  aws_region           = var.aws_region
  repos                = var.repos
}