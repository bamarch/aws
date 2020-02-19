output "backup_bucket_kms_key" {
  description = "The kms key for encrypting backup bucket objects"
  value = aws_kms_key.bucket_backup_key.arn
}

output "backup_bucket" {
  description = "The backup bucket"
  value = aws_s3_bucket.workstation_backup_bucket.arn
}
