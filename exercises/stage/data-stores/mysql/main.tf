resource "aws_db_instance" "example" {
  identifier_prefix   = "tf-book-club"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t3.micro"
  skip_final_snapshot = true
  db_name             = "example_database"

  username = var.db_username
  password = var.db_password

}
terraform {
  backend "s3" {
    bucket         = "tf-book-club-state"
    key            = "stage/data-stores/mysql/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-book-club-locks"
    encrypt        = true
  }
}
