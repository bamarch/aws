resource "aws_kms_key" "bucket_backup_key" {
  description             = "This key is used to encrypt backup bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "workstation_backup_bucket" {
  bucket = "bamarch-workstation-backups"
  acl    = "private"

  versioning {
    enabled = false
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

resource "aws_s3_bucket_public_access_block" "workstation_backup_bucket" {
  bucket = aws_s3_bucket.workstation_backup_bucket.id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_iam_access_key" "rclone_backup_workstation" {
  user = aws_iam_user.rclone_backup_workstation.name
  pgp_key = "keybase:bamarch"
}

resource "aws_iam_user" "rclone_backup_workstation" {
  name = "rclone_backup_workstation"
  path = "/system/"
}

resource "aws_iam_user_group_membership" "rclone_backup_workstation" {
  user = aws_iam_user.rclone_backup_workstation.name

  groups = [
    aws_iam_group.rclone_backup_workstation.name
  ]
}

resource "aws_iam_group" "rclone_backup_workstation" {
  name = "rclone_backup_workstation"
  path = "/system/"
}

resource "aws_iam_group_policy" "rclone_backup_workstation" {
  name = "rclone_backup_workstation"
  group = aws_iam_group.rclone_backup_workstation.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:DeleteObject",
                "s3:GetObject",
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": [
              "${aws_s3_bucket.workstation_backup_bucket.arn}/*",
              "${aws_s3_bucket.workstation_backup_bucket.arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "arn:aws:s3:::*"
        }	
    ]
}
EOF
}
