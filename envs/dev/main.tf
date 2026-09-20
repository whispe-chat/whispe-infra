terraform {
  required_version = ">= 1.15.0"

  required_providers {
    aws    = { source = "hashicorp/aws", version = "~> 6.0" }
    random = { source = "hashicorp/random", version = "~> 3.9" }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = { Project = var.project_name, Environment = var.environment, ManagedBy = "terraform" }
  }
}

data "aws_route53_zone" "primary" {
  name         = "${var.domain_name}."
  private_zone = false
}

module "network" {
  source              = "../../modules/network"
  project_name        = var.project_name
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones  = var.availability_zones
  container_port      = var.container_port
}

module "certificate" {
  source      = "../../modules/certificate"
  domain_name = var.api_subdomain
  zone_id     = data.aws_route53_zone.primary.zone_id
}

module "alb" {
  source                = "../../modules/alb"
  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.network.alb_security_group_id
  container_port        = var.container_port
  health_check_path     = var.health_check_path
  certificate_arn       = module.certificate.certificate_arn
}

module "dns" {
  source       = "../../modules/dns"
  zone_id      = data.aws_route53_zone.primary.zone_id
  record_name  = var.api_subdomain
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

module "ecr" {
  source       = "../../modules/ecr"
  project_name = var.project_name
  environment  = var.environment
}

module "storage" {
  source                 = "../../modules/storage"
  project_name           = var.project_name
  environment            = var.environment
  secret_recovery_window = 0
}

module "iam" {
  source                   = "../../modules/iam"
  project_name             = var.project_name
  environment              = var.environment
  github_oidc_provider_arn = var.github_oidc_provider_arn
  github_org               = var.github_org
  github_org_id            = var.github_org_id
  github_repo              = var.github_repo
  github_repo_id           = var.github_repo_id
  s3_bucket_arn            = module.storage.bucket_arn
  mongodb_secret_arn       = module.storage.mongodb_secret_arn
  jwt_secret_arn           = module.storage.jwt_secret_arn
}

module "ecs" {
  source                = "../../modules/ecs"
  project_name          = var.project_name
  environment           = var.environment
  aws_region            = var.aws_region
  public_subnet_ids     = module.network.public_subnet_ids
  ecs_security_group_id = module.network.ecs_security_group_id
  target_group_arn      = module.alb.target_group_arn
  container_port        = var.container_port
  container_image       = var.container_image
  fargate_cpu           = var.fargate_cpu
  fargate_memory        = var.fargate_memory
  desired_count         = var.desired_count
  execution_role_arn    = module.iam.execution_role_arn
  task_role_arn         = module.iam.task_role_arn
  s3_bucket_name        = module.storage.bucket_name
  mongodb_secret_arn    = module.storage.mongodb_secret_arn
  jwt_secret_arn        = module.storage.jwt_secret_arn
  log_retention_days    = var.log_retention_days

  depends_on = [module.alb]
}
