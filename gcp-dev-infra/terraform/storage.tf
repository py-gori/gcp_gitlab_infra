resource "google_storage_bucket" "gitlab_data_backup" {
  project       = var.gcp_project
  name          = "${var.env}-gcs-gitlab-data-bk"
  location      = "ASIA-NORTHEAST1"
  storage_class = "REGIONAL"

  logging {
    log_bucket        = "my-gcs-logging" # data sourceが未対応
    log_object_prefix = "my-gcs-gitlab-data-bk"
  }

  lifecycle_rule {
    condition {
      age = var.gitlab_storage_lifecycle_delete_age
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_storage_bucket_iam_member" "gitlab_data_storage_objectAdmin" {
  bucket = google_storage_bucket.gitlab_data_backup.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.gitlab-server.email}"
}

# gitlab config backup
resource "google_storage_bucket" "gitlab_conf_backup" {
  project       = var.gcp_project
  name          = "${var.env}-gcs-gitlab-conf-bk"
  location      = "ASIA-NORTHEAST1"
  storage_class = "REGIONAL"

  logging {
    log_bucket        = "my-gcs-logging" # data sourceが未対応
    log_object_prefix = "my-gcs-gitlab-conf-bk"
  }
}

resource "google_storage_bucket_iam_member" "gitlab_conf_storage_objectAdmin" {
  bucket = google_storage_bucket.gitlab_conf_backup.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.gitlab-server.email}"
}

resource "google_storage_hmac_key" "key" {
  project               = var.gcp_project
  service_account_email = google_service_account.gitlab-server.email
}

# artifact
resource "google_storage_bucket" "artifact" {
  project       = var.gcp_project
  name          = "my-gcs-artifact"
  location      = "ASIA-NORTHEAST1"
  storage_class = "REGIONAL"

  logging {
    log_bucket        = "my-gcs-logging" # data sourceが未対応
    log_object_prefix = "my-gcs-artifact"
  }
}

resource "google_storage_bucket_iam_member" "artifact_objectAdmin" {
  bucket = google_storage_bucket.artifact.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.gitlab-server.email}"
}
