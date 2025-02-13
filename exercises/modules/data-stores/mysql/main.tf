resource "aws_db_instance" "example" {
  identifier_prefix   = "${var.cluster_name}-"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t3.micro"
  skip_final_snapshot = true
  db_name             = "${var.cluster_name}mysql"

  username = var.db_username
  password = var.db_password

}
