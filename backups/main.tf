resource "aws_kms_key" "bucket_backup_key" {
  description             = "This key is used to encrypt backup bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "workstation_backup_bucket" {
  bucket = "bamarch-workstation-backups"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_backup_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

