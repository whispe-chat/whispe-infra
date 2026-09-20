output "github_oidc_provider_arn" {
  value = module.github_oidc.arn
}
output "dev_plan_role_arn" {
  value = module.terraform_ci_dev.plan_role_arn
}
output "dev_apply_role_arn" {
  value = module.terraform_ci_dev.apply_role_arn
}
output "prod_plan_role_arn" {
  value = module.terraform_ci_prod.plan_role_arn
}
output "prod_apply_role_arn" {
  value = module.terraform_ci_prod.apply_role_arn
}
