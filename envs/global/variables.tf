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
variable "domain_name" {
  type    = string
  default = "whispe.me"
}
variable "github_backend_repo" {
  type        = string
  description = "The repository that builds and pushes container images"
  default     = "whispe-backend"
}

variable "github_backend_repo_id" {
  type        = string
  description = "The numeric GitHub repository ID of whispe-backend"
  default     = "919861952"
}
