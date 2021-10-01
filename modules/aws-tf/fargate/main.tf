resource "aws_ecs_cluster" "cluster" {
  name = var.cluser_name
}

resource "aws_cloudwatch_log_group" "task_log_group" {
  retention_in_days = 1
  name_prefix       = var.log_group_name
}

resource "aws_default_vpc" "default" {
}

data "aws_subnet_ids" "subnets" {
  vpc_id = aws_default_vpc.default.id
}

data "template_file" "definition" {
  template = file("~/trustlogix/modules/aws-tf/fargate/def.json")
  vars = {
    region          = var.region
    log_group       = aws_cloudwatch_log_group.task_log_group.name
    image_tag       = data.aws_ecr_repository.ecr_repository.repository_url
    definition_name = var.td_name
  }
}

resource "aws_ecs_task_definition" "definition" {
  family                   = var.td_name
  container_definitions    = data.template_file.definition.rendered
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.service_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = var.network_mode
  cpu                      = var.cpu
  memory                   = var.memory
}

resource "aws_security_group" "ecs" {
  vpc_id = aws_default_vpc.default.id
  dynamic "ingress" {
    iterator = port
    for_each = var.ingress_ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = var.cidr_blocks
    }
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }
}



resource "aws_ecs_service" "service" {
  name                               = var.service_name
  task_definition                    = aws_ecs_task_definition.definition.arn
  cluster                            = aws_ecs_cluster.cluster.id
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 0
  launch_type                        = "FARGATE"
  network_configuration {
    subnets          = data.aws_subnet_ids.subnets.ids
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs.id]
  }
}


resource "aws_cloudwatch_event_rule" "scheduled_task" {
  name                = "scheduled-ecs-event-rule"
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "scheduled_task" {
  target_id = "trustlogix-svc-target"
  rule      = aws_cloudwatch_event_rule.scheduled_task.name
  arn       = aws_ecs_cluster.cluster.arn
  role_arn  = aws_iam_role.scheduled_task_cloudwatch.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.definition.arn
    launch_type         = "FARGATE"
    network_configuration {
      subnets          = data.aws_subnet_ids.subnets.ids
      assign_public_ip = true
      security_groups  = [aws_security_group.ecs.id]
    }
  }
}
