resource "google_compute_instance_template" "gitlab" {
  project     = var.gcp_project
  name_prefix = "${var.env}-template-gitlab"

  tags = ["${var.env}-tag-gitlabgce"]

  machine_type = var.gitlab_machine_type

  disk {
    source_image = "projects/${var.gcp_project}/global/images/${var.gitlab_source_image}"
    auto_delete  = true
    boot         = true
    disk_type    = "pd-standard"
    disk_size_gb = var.gitlab_disk_size_gb
    type         = "PERSISTENT"
  }

  metadata_startup_script = data.template_file.metadata_gitlab.rendered

  network_interface {
    network            = google_compute_network.service.name
    subnetwork         = google_compute_subnetwork.private.name
    subnetwork_project = var.gcp_project
  }
  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }
  service_account {
    scopes = ["cloud-platform"]
    email  = google_service_account.gitlab-server.email
  }
  lifecycle {
    create_before_destroy = true #インスタンステンプレートが入れ替わらないので必要
  }
}

data "template_file" "metadata_gitlab" {
  template = "${file("./metadata_gitlab.sh")}"
  vars = {
    env                      = "${var.env}"
    service_name             = "gitlab"
    gitlab_email_from        = "${var.gitlab_email_from}"
    smtp_address             = "${var.smtp_address}"
    smtp_user_name           = "${var.smtp_user_name}"
    smtp_password            = "${var.smtp_password}"
    smtp_domain              = "${var.smtp_domain}"
    gs_access_key_id         = google_storage_hmac_key.key.access_id
    gs_secret_access_key     = google_storage_hmac_key.key.secret
    gs_backup_bucket_name    = "${var.env}-gcs-gitlab-data-bk"
  }
}

resource "google_compute_instance_from_template" "gitlab" {
  project     = var.gcp_project
  name        = "my-gitlab01"
  zone        = var.zone

  source_instance_template = google_compute_instance_template.gitlab.id
  network_interface {
    network            = google_compute_network.service.name
    subnetwork         = google_compute_subnetwork.private.name
    subnetwork_project = var.gcp_project
    access_config {
      nat_ip = google_compute_address.gitlab-nat.address
    }
  }
}

