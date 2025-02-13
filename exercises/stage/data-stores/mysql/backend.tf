terraform {
  backend "s3" {
    bucket         = "tfbc-state"
    key            = "stage/data-stores/mysql/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tfbc-locks"
    encrypt        = true
  }
}
