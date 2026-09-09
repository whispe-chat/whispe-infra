resource "random_id" "bucket_suffix" { byte_length = 4 }

resource "aws_s3_bucket" "media" {
  bucket = "${var.project_name}-${var.environment}-media-${random_id.bucket_suffix.hex}"
}

resource "aws_s3_bucket_public_access_block" "media" {
  bucket                  = aws_s3_bucket.media.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "media" {
  bucket = aws_s3_bucket.media.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_secretsmanager_secret" "mongodb_uri" {
  name                    = "${var.project_name}/${var.environment}/mongodb_uri"
  recovery_window_in_days = var.secret_recovery_window
}
resource "aws_secretsmanager_secret_version" "mongodb_uri" {
  secret_id     = aws_secretsmanager_secret.mongodb_uri.id
  secret_string = "REPLACE_ME"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "jwt_secret" {
  name                    = "${var.project_name}/${var.environment}/jwt_secret"
  recovery_window_in_days = var.secret_recovery_window
}
resource "aws_secretsmanager_secret_version" "jwt_secret" {
  secret_id     = aws_secretsmanager_secret.jwt_secret.id
  secret_string = "REPLACE_ME"
  lifecycle { ignore_changes = [secret_string] }
}
