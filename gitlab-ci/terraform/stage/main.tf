provider "google" {
  # Версия провайдера
  version = "~>2.15.0"

  # ID проекта
  project = var.project
  region  = var.region
}
# GitLab instance
module "docker-app" {
  instance_count      = 1
  source              = "../modules/instance"
  zone                = var.zone
  environment         = var.environment
  name_prefix         = "gitlab"
  machine_type        = "n1-standard-1"
  instance_disk_image = "docker-base"
  tags                = ["gitlab-server", "branch-proxy"]
  tcp_ports           = ["80", "443", "22", "2222", "5050", "8080"]
  vpc_network_name    = var.vpc_network_name
  use_static_ip       = true
}
