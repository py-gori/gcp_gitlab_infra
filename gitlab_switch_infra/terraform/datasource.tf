data "google_storage_bucket_object" "gce_instance_switch_functions" {
  name   = var.gce_instance_switch_script
  bucket = var.gce_instance_switch_script_bucket
}