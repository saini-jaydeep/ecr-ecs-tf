module "ecs" {
  source               = "../../../modules/aws-tf/fargate"
  region               = var.aws_region
  cluser_name          = var.cluser_name
  log_group_name       = var.log_group_name
  td_name              = var.td_name
  service_name          = var.service_name
  network_mode         = var.network_mode
  cpu                  = var.cpu
  memory               = var.memory
  schedule_expression  = var.schedule_expression
  ingress_ports        = var.ingress_ports
  cidr_blocks          = var.cidr_blocks
}