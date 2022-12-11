#! /bin/bash
echo ${env}
echo ${service_name}

# # replace '/' to '\/' 
# gs_secret_access_key=$(echo ${gs_secret_access_key} | sed -e "s/\//\\\\\//g")
# smtp_password=$(echo ${smtp_password} | sed -e "s/\//\\\\\//g")

echo ${gs_secret_access_key}
echo ${smtp_password}

# fluentd
## replace tag
sed -i -e "s/replace_service_name/${service_name}/g" /etc/google-fluentd/config.d/service-syslog.conf
sed -i -e "s/replace_service_name/${service_name}/g" /etc/google-fluentd/config.d/service-operation.conf

mv -i /etc/google-fluentd/config.d/service-syslog.conf /etc/google-fluentd/config.d/${service_name}-syslog.conf
mv -i /etc/google-fluentd/config.d/service-operation.conf /etc/google-fluentd/config.d/${service_name}-operation.conf

systemctl restart google-fluentd

# disk attachment
# gcloud compute instances attach-disk `hostname` --disk ${env}-disk-gitlab --disk-scope="regional" --zone=`hostname --fqdn | awk -F. '{print $2}'` --force-attach

# sudo mount -o discard,defaults /dev/sdb /data
# sleep 5

sudo cp -p /etc/gitlab/gitlab.rb /etc/gitlab/gitlab.rb_org

sudo mkdir /etc/gitlab/ssl

# gitlab.rb replace
## external_url config replace
sed -i -e "s/external_url 'http:\/\/gitlab.example.com'/external_url 'https:\/\/[DOMAIN]\/gitlab'/g" /etc/gitlab/gitlab.rb
## time_zone config replace
sed -i -e "s/# gitlab_rails\['time_zone'\] = 'UTC'/gitlab_rails\['time_zone'\] = 'Asia\/Tokyo'/g" /etc/gitlab/gitlab.rb
## letsencrypt config replace
sed -i -e "s/# letsencrypt\['enable'\] = nil/letsencrypt\['enable'\] = false/g" /etc/gitlab/gitlab.rb
## ssl config
sed -i -e "s/# nginx\['ssl_certificate'\] = \"\/etc\/gitlab\/ssl\/#{node\['fqdn'\]}.crt\"/nginx\['ssl_certificate'\] = \"\/etc\/gitlab\/ssl\/[DOMAIN].crt\"/g" /etc/gitlab/gitlab.rb
sed -i -e "s/# nginx\['ssl_certificate_key'\] = \"\/etc\/gitlab\/ssl\/#{node\['fqdn'\]}.key\"/nginx\['ssl_certificate_key'\] = \"\/etc\/gitlab\/ssl\/[DOMAIN].key\"/g" /etc/gitlab/gitlab.rb

## replace_value_name replace
sed -i -e "s/  'google_storage_access_key_id' => 'replace_value_name',/  'google_storage_access_key_id' => '${gs_access_key_id}',/g" /etc/gitlab/gitlab.rb
sed -i -e "s#  'google_storage_secret_access_key' => 'replace_value_name',#  'google_storage_secret_access_key' => '${gs_secret_access_key}',#g" /etc/gitlab/gitlab.rb
sed -i -e "s/gitlab_rails\['backup_upload_remote_directory'\] = 'replace_value_name'/gitlab_rails\['backup_upload_remote_directory'\] = '${gs_backup_bucket_name}'/g" /etc/gitlab/gitlab.rb

sed -i -e "s/gitlab_rails\['gitlab_email_from'\] = 'replace_value_name'/gitlab_rails\['gitlab_email_from'\] = '${gitlab_email_from}'/g" /etc/gitlab/gitlab.rb
sed -i -e "s/gitlab_rails\['gitlab_email_display_name'\] = 'replace_value_name'/gitlab_rails\['gitlab_email_display_name'\] = '${gitlab_email_from}'/g" /etc/gitlab/gitlab.rb
sed -i -e "s/gitlab_rails\['gitlab_email_reply_to'\] = 'replace_value_name'/gitlab_rails\['gitlab_email_reply_to'\] = '${gitlab_email_from}'/g" /etc/gitlab/gitlab.rb
sed -i -e "s/gitlab_rails\['smtp_address'\] = 'replace_value_name'/gitlab_rails\['smtp_address'\] = '${smtp_address}'/g" /etc/gitlab/gitlab.rb
sed -i -e "s/gitlab_rails\['smtp_user_name'\] = 'replace_value_name'/gitlab_rails\['smtp_user_name'\] = '${smtp_user_name}'/g" /etc/gitlab/gitlab.rb
sed -i -e "s#gitlab_rails\['smtp_password'\] = 'replace_value_name'#gitlab_rails\['smtp_password'\] = '${smtp_password}'#g" /etc/gitlab/gitlab.rb
sed -i -e "s/gitlab_rails\['smtp_domain'\] = 'replace_value_name'/gitlab_rails\['smtp_domain'\] = '${smtp_domain}'/g" /etc/gitlab/gitlab.rb

sudo gitlab-ctl reconfigure

# Google Container Registry設定
curl -fsSL "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v2.0.0/docker-credential-gcr_linux_amd64-2.0.0.tar.gz" | tar xz --to-stdout ./docker-credential-gcr > /usr/local/bin/docker-credential-gcr && chmod +x /usr/local/bin/docker-credential-gcr
/usr/loca/bin/docker-credential-gcr configure-docker
