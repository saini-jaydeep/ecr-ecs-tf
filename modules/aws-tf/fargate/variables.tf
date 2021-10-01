variable "region" {
  description = "AWS Region"
  default     = "ap-south-1"
}

variable "cluser_name" {
  description = "Cluster Name"
  default     = "trustlogix-cluster"
}

variable "log_group_name" {
  description = "Log Group Name"
  default     = "trustlogix-log"
}

variable "service_name" {
  description = "Service Name"
  default     = "trustlogix-svc"
}
variable "td_name" {
  description = "Service Name"
  default     = "trustlogix-td"
}

variable "network_mode" {
  description = "Network Mode"
  default     = "awsvpc"
}

variable "cpu" {
  description = "CPU"
  default     = "512"
}

variable "memory" {
  description = "Memory"
  default     = "1024"
}

variable "schedule_expression" {
  description = "schedule_expression"
  default     = "rate(5 minutes)"
}

variable "ingress_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [5432, 5439]
}

variable "cidr_blocks" {
  type        = list
  description = "list of cidr_blocks"
}

