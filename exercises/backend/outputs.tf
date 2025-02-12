
output "s3_bucket_arn" {
  value = aws_s3_bucket.tf-state-bucket.arn
}

output "dynamodb_table_name" {

  value = aws_dynamodb_table.tf-book-club-locks.name

}
