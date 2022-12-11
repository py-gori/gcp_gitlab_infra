resource "google_compute_address" "gitlab-nat" {
  project = var.gcp_project
  name   = "my-nat-ip"
  region = google_compute_subnetwork.private.region
}

