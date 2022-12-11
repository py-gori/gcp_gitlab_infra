require 'spec_helper'

# gitlabインストール関連パッケージの確認
%w[ curl policycoreutils-python openssh-server gitlab-ee].each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
end

# gitlabバージョン確認
describe command('sudo gitlab-rake gitlab:env:info | grep Version:') do
    its(:stdout) { should match /13\.7\.4-ee/ }
end

# コンフィグ追加1行目と追加最終行を確認
describe file('/etc/gitlab/gitlab.rb') do
    its(:content) { should match %r{ANSIBLE MANAGED BLOCK} }
    its(:content) { should match %r{gitlab_rails\[\'smtp_enable_starttls_auto\'\] = true} }
end

# dataディレクトリ権限設定
describe file("/data") do
    it { should be_directory }
    it { should be_mode 755 }
end

# sslディレクトリ権限設定
describe file("/etc/gitlab/ssl") do
    it { should be_directory }
    it { should be_mode 700 }
end

# backupログディレクトリ権限設定
describe file("/var/log/middle") do
    it { should be_directory }
    it { should be_mode 755 }
end

# gitlabログ転送ファイル配置確認
describe file("/etc/google-fluentd/config.d/gitlab-nginx.conf") do
    it { should be_file }
    it { should be_mode 640 }
end

describe file("/etc/google-fluentd/config.d/gitlab-backup.conf") do
    it { should be_file }
    it { should be_mode 640 }
end