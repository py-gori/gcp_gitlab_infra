terraform {
  backend "gcs" {
    prefix = "gce_instance_switch_infra"
    # ファイル名はworkspace名.tfstateで生成される。
  }
}
