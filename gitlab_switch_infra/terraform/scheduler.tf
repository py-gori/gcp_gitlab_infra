resource "google_cloud_scheduler_job" "gce_instance_switch_functions" {
  project   = var.gcp_project
  name      = "${var.env}-scheduler-gce_instance_switch_functions"
  schedule  = "* 2 * * *"
  time_zone = "Asia/Tokyo"

  pubsub_target {
    data       = base64encode("{\"switch\": \"off\", \"zone\": \"asia-northeast1-a\", \"target\": \"my-gitlab01\"}")
    topic_name = google_pubsub_topic.gce_instance_switch_functions.id
  }
}