# Create ECR repositories.
# https://www.terraform.io/docs/providers/aws/r/ecr_repository.html
# Please see: https://github.com/hashicorp/terraform/issues/17179

resource "aws_ecr_repository" "repos" {
  for_each             = var.repos
  name                 = each.key
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}
