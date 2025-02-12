
output "s3_bucket_arn" {
  value = aws_s3_bucket.tf-state-bucket.arn
}

output "dynamodb_table_name" {

  value = aws_dynamodb_table.tf-book-club-locks.name

}
output "backend_storage" {
  value = var.backend_storage
}

output "backend_lock_table" {
  value = var.backend_lock_table
}
