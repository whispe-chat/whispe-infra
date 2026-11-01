output "alb_dns_name" { value = module.alb.alb_dns_name }
output "api_url" { value = "https://${var.api_subdomain}" }
output "s3_bucket" { value = module.storage.bucket_name }
output "ecs_cluster" { value = module.ecs.cluster_name }
output "ecs_service" { value = module.ecs.service_name }
