module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name           = "webservers-stage"
  db_remote_state_bucket = "tfbc-state"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"

}

