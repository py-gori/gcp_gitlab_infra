resource "google_cloudfunctions_function" "gce_instance_switch_functions" {
  project               = var.gcp_project
  name                  = "${var.env}-cloudfunctions-gce_instance_switch_functions"
  runtime               = "python37"
  available_memory_mb   = "256"
  event_trigger {
    event_type          = "google.pubsub.topic.publish"
    resource            = google_pubsub_topic.gce_instance_switch_functions.name
  }
  source_archive_bucket = data.google_storage_bucket_object.gce_instance_switch_functions.bucket
  source_archive_object = data.google_storage_bucket_object.gce_instance_switch_functions.name
  entry_point           = "gce_instance_switch"
  ingress_settings      = "ALLOW_INTERNAL_ONLY"
}