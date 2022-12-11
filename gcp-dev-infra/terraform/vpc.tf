resource "google_compute_network" "service" {
  project                 = var.gcp_project
  name                    = "${var.env}-vpc-service"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "private" {
  project       = var.gcp_project
  name          = "${var.env}-subnet-private"
  network       = google_compute_network.service.name
  ip_cidr_range = "10.10.0.0/24"
  region        = var.region
  private_ip_google_access = true
  log_config {
      aggregation_interval = "INTERVAL_10_MIN"
  }
}

resource "google_compute_firewall" "ssh" {
  provider      = google-beta
  project       = var.gcp_project
  name          = "${var.env}-firewall-any-to-gce-allow-for-ssh"
  network       = google_compute_network.service.self_link
  source_ranges = [var.gcp_iap_cidr]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  direction      = "INGRESS"
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "http" {
  provider      = google-beta
  project       = var.gcp_project
  name          = "${var.env}-firewall-global-to-gce-allow-for-app"
  network       = google_compute_network.service.self_link
  source_ranges = var.my_global_ip
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  direction      = "INGRESS"
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}