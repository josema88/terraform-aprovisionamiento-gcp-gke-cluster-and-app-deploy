module "project" {
  source = "git::https://github.com/jaestrada40/terraform-aprovisionamiento-gcp-gke-cluster-and-app-deploy.git//1-terraform-gcp-project"
  sandbox_id = var.sandbox_id
  org_id = "24851311546" 
  billing_account = "014413-D964D8-7A33D2"
  google_api_services = ["compute.googleapis.com", "container.googleapis.com", "certificatemanager.googleapis.com"]
}
output "project" {
  value = module.project.project_id
}
module "gke-cluster" {
  source = "git::https://github.com/josema88/terraform-aprovisionamiento-gcp-gke-cluster-and-app-deploy.git//2-terraform-gcp-gke"
  project = split("/",module.project.project_id)[1]
  location = var.location
  gh_api_config_channel = var.gh_api_config_channel
  gke_node_config = {
      machine_type = "e2-standard-2"
      disk_size_gb = 50
    }
  sandbox_id = var.sandbox_id
  depends_on = [ module.project ]
}

resource "kubectl_manifest" "test" {
  for_each = {
    db-deployment = "k8s-specifications/db-deployment.yaml"
    db-service = "k8s-specifications/db-service.yaml"
    redis-deployment = "k8s-specifications/redis-deployment.yaml"
    redis-service = "k8s-specifications/redis-service.yaml"
    result-deployment = "k8s-specifications/result-deployment.yaml"
    result-service = "k8s-specifications/result-service.yaml"
    vote-deployment = "k8s-specifications/vote-deployment.yaml"
    vote-service = "k8s-specifications/vote-service.yaml"
    worker-deployment = "k8s-specifications/worker-deployment.yaml"
  }
  yaml_body = file("${path.module}/${each.value}")
  depends_on = [ module.gke-cluster ]
}