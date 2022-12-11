# gcp_dev_infra

- gcp-vm-image  
  GitLab インスタンスイメージを GCP に作成します。  
  その他サンプルで、Python イメージ、Wordpress イメージあり。

- gcp-dev-infra  
  GitLab インスタンスイメージを使い、インフラ環境を GCP にデプロイします。

- gitlab_switch_infra  
  費用削減の為、インスタンスを ● 時に停止します。  
  ● 時に起動させたい場合にも使用可能です。

## gcp-dev-infra

infra for terraform

### tech_stack

GCP  
Cloud Build  
Terraform

## gcp-vm-image

vm-image for packer

### tech_stack

GCP  
Cloud Build  
Packer  
Ansible  
ServerSpec

## gitlab_switch_infra

gitlab instance start/stop switch

### tech_stack

GCP  
Cloud Build  
Terraform  
Python
