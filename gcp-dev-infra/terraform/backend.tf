terraform {
  backend "gcs" {
    prefix = "gcp-dev-infra"
    # ファイル名はworkspace名.tfstateで生成される。
  }
}
