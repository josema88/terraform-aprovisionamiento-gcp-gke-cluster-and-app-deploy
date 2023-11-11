resource "random_integer" "project-id" {
  min = 200
  max = 300
}

resource "google_project" "my_project" {
  name            = var.sandbox_id
  project_id      = "${var.sandbox_id}-${random_integer.project-id.result}"
  org_id          = var.org_id
  billing_account = var.billing_account
}

resource "google_project_service" "enable-api" {
  for_each = toset(var.google_apis)
  project                    = google_project.my_project.id
  service                    = each.value
  disable_dependent_services = true
}
output "project_id" {
  value = google_project.my_project.id
}