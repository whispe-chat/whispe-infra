environment         = "dev"
api_subdomain       = "dev.whispe.me"
vpc_cidr            = "10.21.0.0/16"
public_subnet_cidrs = ["10.21.1.0/24", "10.21.2.0/24"]
availability_zones  = ["us-east-1a", "us-east-1b"]

container_image = "public.ecr.aws/nginx/nginx:latest"

github_org     = "whispe-chat"
github_org_id  = "323445357"
github_repo    = "whispe-backend"
github_repo_id = "919861952"

github_oidc_provider_arn = "arn:aws:iam::064713309555:oidc-provider/token.actions.githubusercontent.com"
