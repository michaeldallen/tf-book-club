terraform {
  backend "s3" {
    bucket         = "tfbc-state"
    key            = "prod/services/webserver-cluster/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tfbc-locks"
    encrypt        = true
  }
}
