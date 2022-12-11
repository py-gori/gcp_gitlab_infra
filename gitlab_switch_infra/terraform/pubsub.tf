resource "google_pubsub_topic" "gce_instance_switch_functions" {
  project = var.gcp_project
  name    = "${var.env}-pubsubtopic-gce_instance_switch_functions"
}