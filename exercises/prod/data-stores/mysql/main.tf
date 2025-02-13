module "mysql" {
  source = "../../../modules/data-stores/mysql"

  cluster_name = "prod"



  db_username = var.db_username
  db_password = var.db_password

}
