variable "project_name" {
  type    = string
  default = "whispe"
}
variable "github_org" { type = string }
variable "github_org_id" { type = string }
variable "github_repo" { type = string }
variable "github_repo_id" { type = string }
variable "state_bucket_name" {
  type    = string
  default = "whispe-terraform-state"
}
