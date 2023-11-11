variable "project" {
  default = "sandbox-local-264"
}
variable "sandbox_id" {
  
}
variable "location" {
  default = "us-central1"
}
variable "gh_api_config_channel" {
  default = "CHANNEL_STANDARD"
}
variable "gke_node_config" {
  type = object({
    machine_type = string
    disk_size_gb = number
  })
  default = {
      machine_type = "e2-standard-2"
      disk_size_gb = 50
    }
}