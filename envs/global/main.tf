terraform {
  required_version = ">= 1.15.0"

  required_providers {
    aws = {
      source = "hashicorp/aws", version = "~> 6.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = "us-east-1"
}

module "github_oidc" {
  source = "../../modules/github-oidc"
}

module "terraform_ci_dev" {
  source                   = "../../modules/terraform-ci-role"
  project_name             = var.project_name
  environment              = "dev"
  github_oidc_provider_arn = module.github_oidc.arn
  github_org               = var.github_org
  github_org_id            = var.github_org_id
  github_repo              = var.github_repo
  github_repo_id           = var.github_repo_id
  state_bucket_name        = var.state_bucket_name
}

module "terraform_ci_prod" {
  source                   = "../../modules/terraform-ci-role"
  project_name             = var.project_name
  environment              = "prod"
  github_oidc_provider_arn = module.github_oidc.arn
  github_org               = var.github_org
  github_org_id            = var.github_org_id
  github_repo              = var.github_repo
  github_repo_id           = var.github_repo_id
  state_bucket_name        = var.state_bucket_name
}
