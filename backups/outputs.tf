output "backup_bucket_kms_key" {
  description = "The kms key for encrypting backup bucket objects"
  value = aws_kms_key.bucket_backup_key
}

output "backup_bucket" {
  description = "The backup bucket"
  value = aws_s3_bucket.workstation_backup_bucket
}

output "backup_user" {
  description = "The backup user"
  value = aws_iam_user.rclone_backup_workstation
}
