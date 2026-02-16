terraform {
  backend "s3" {
    bucket         = "tf-state-challenge-bucket"
    key            = "rds-stock/homologation/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
