resource "google_container_cluster" "primary" {
  project  = var.project
  name     = "${var.sandbox_id}-cluster-v1"
  location = var.location

  deletion_protection = false

  remove_default_node_pool = false
  initial_node_count       = 1
  gateway_api_config {
    channel = var.gh_api_config_channel
  }
  node_config {
    machine_type = var.gke_node_config.machine_type
    disk_size_gb = var.gke_node_config.disk_size_gb
  }
}
output "gke_cluster_id" {
  value = google_container_cluster.primary.name
}