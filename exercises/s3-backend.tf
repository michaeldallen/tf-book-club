terraform {
  backend "s3" {
    bucket         = "tf-book-club-state"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-book-club-locks"
    encrypt        = true
  }
}
