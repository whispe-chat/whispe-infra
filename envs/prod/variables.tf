variable "project_name" {
  type    = string
  default = "whispe"
}
variable "environment" {
  type    = string
  default = "prod"
}
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "domain_name" {
  type    = string
  default = "whispe.me"
}
variable "api_subdomain" { type = string }

variable "vpc_cidr" { type = string }
variable "public_subnet_cidrs" { type = list(string) }
variable "availability_zones" { type = list(string) }

variable "container_port" {
  type    = number
  default = 7000
}
variable "container_image" { type = string }
variable "fargate_cpu" {
  type    = number
  default = 256
}
variable "fargate_memory" {
  type    = number
  default = 512
}
variable "desired_count" {
  type    = number
  default = 1
}
variable "health_check_path" {
  type    = string
  default = "/health"
}
variable "log_retention_days" {
  type    = number
  default = 14
}

variable "github_org" { type = string }
variable "github_org_id" { type = string }
variable "github_repo" { type = string }
variable "github_repo_id" { type = string }
variable "github_oidc_provider_arn" { type = string }
