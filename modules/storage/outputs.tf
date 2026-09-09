output "bucket_name" { value = aws_s3_bucket.media.bucket }
output "bucket_arn" { value = aws_s3_bucket.media.arn }
output "mongodb_secret_arn" { value = aws_secretsmanager_secret.mongodb_uri.arn }
output "jwt_secret_arn" { value = aws_secretsmanager_secret.jwt_secret.arn }
