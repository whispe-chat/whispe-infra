variable "project_name" { type = string }
variable "environment" { type = string }
variable "secret_recovery_window" {
  type    = number
  default = 30
}
