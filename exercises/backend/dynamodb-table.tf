resource "aws_dynamodb_table" "tf-book-club-locks" {
  name         = "tf-book-club-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

