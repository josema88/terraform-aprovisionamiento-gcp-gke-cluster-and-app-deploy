data "google_client_config" "provider" {
}

data "google_container_cluster" "my_cluster" {
  project  = split("/", module.project.project_id)[1]
  name     = module.gke-cluster.gke_cluster_id
  location = "us-central1"
  depends_on = [ module.gke-cluster ]
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
  )
}
provider "kubectl" {
  host = "https://${data.google_container_cluster.my_cluster.endpoint}"
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
  )
  token = data.google_client_config.provider.access_token
}