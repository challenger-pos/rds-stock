terraform {
  backend "s3" {
    bucket         = "tf-state-challenge-bucket"
    key            = "v4/rds-stock/production/terraform.tfstate"
    region         = "us-east-2"
  }
}
