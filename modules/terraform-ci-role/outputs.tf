output "plan_role_arn" {
  description = "The ARN of the IAM role for GitHub Actions to use during terraform plan (Read Only)."
  value       = aws_iam_role.terraform_plan.arn
}

output "apply_role_arn" {
  description = "The ARN of the IAM role for GitHub Actions to use during terraform apply (Read/Write)."
  value       = aws_iam_role.terraform_apply.arn
}
