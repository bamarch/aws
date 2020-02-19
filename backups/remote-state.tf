terraform {
  backend "s3" {
    profile   = "personal"
    region    = "eu-west-1"
    bucket    = "bamarch-terraform-state-eu-west-1--backups"
    key       = "bamarch-terraform-state-eu-west-1--backups/terraform.tfstate"
    encrypt   = true
  }
}
