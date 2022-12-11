resource "google_project_service" "dnsapi" {
  project                    = var.gcp_project
  service                    = "dns.googleapis.com"
  disable_dependent_services = false
}

resource "google_dns_managed_zone" "my-zone" {
  project     = var.gcp_project
  name        = var.my-zone-resource-name
  dns_name    = var.my-dns-name
  description = "my DNS zone"
  visibility  = "public"
  depends_on  = [google_project_service.dnsapi]
}

resource "google_dns_record_set" "gitlab" {
  project      = var.gcp_project
  name         = "${google_dns_managed_zone.my-zone.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.my-zone.name
  rrdatas      = [google_compute_address.gitlab-nat.address]
  depends_on   = [google_project_service.dnsapi]
}