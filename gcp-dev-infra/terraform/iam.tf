## gitlab-server
resource "google_project_iam_member" "serviceaccount_gitlab-server_logging" {
  project = var.gcp_project
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gitlab-server.email}"
}

resource "google_project_iam_member" "serviceaccount_gitlab-server_monitoring" {
  project = var.gcp_project
  role    = "roles/monitoring.editor"
  member  = "serviceAccount:${google_service_account.gitlab-server.email}"
}
