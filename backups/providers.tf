provider "aws" {
  version   = "~> 2.2" // provider version cannot be var
  profile   = var.aws_profile
  region    = var.aws_region
}
