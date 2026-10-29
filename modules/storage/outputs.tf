output "bucket_name" { value = aws_s3_bucket.media.bucket }
output "bucket_arn" { value = aws_s3_bucket.media.arn }
output "mongodb_secret_arn" { value = aws_secretsmanager_secret.mongodb_uri.arn }
output "jwt_access_secret_arn" { value = aws_secretsmanager_secret.jwt_access_secret.arn }
output "jwt_refresh_secret_arn" { value = aws_secretsmanager_secret.jwt_refresh_secret.arn }
output "encryption_key_secret_arn" { value = aws_secretsmanager_secret.encryption_key.arn }
