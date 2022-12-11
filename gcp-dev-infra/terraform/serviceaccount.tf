## gitlab-server
resource "google_service_account" "gitlab-server" {
  project      = var.gcp_project
  account_id   = "${var.env}-sa-gitlab-server-gce"
  display_name = "${var.env}-sa-gitlab-server-gce"
}
