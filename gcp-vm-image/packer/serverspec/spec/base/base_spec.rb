require 'spec_helper'

# osバージョンの確認
# only serverspec
# 変わったことを認識できるために入れておく
describe file('/etc/redhat-release') do
  its(:content) { should match %r{^CentOS Linux release 7.9.2009*} }
end

# gcloudコマンド存在確認
# only serverspec
describe command('which gcloud') do
    its(:exit_status) { should eq 0 }
end

# google-fluentdパッケージ存在確認
# only serverspec
describe service('google-fluentd') do
    it { should_not be_enabled }
end

# stackdriver ログ転送ファイル配置(syslog)の確認
describe file("/etc/google-fluentd/config.d/service-syslog.conf") do
  it { should be_file }
  it { should be_mode 640 }
end

# 運用管理に必要なパッケージの確認
%w[ jq zip unzip bind-utils telnet tcpdump sysstat traceroute dstat iotop lsof wget yum-plugin-changelog].each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

# ロケールの確認
describe command('localectl status') do
  its(:stdout) { should match /System Locale: LANG=ja_JP.utf8/ }
end

# タイムゾーンの確認
describe command('timedatectl') do
  its(:stdout) { should contain('JST') }
end

# 名前解決設定の確認
# only serverspec
describe file('/etc/resolv.conf') do
  its(:content) { should match %r{^nameserver 169\.254\.169\.254} }
end

# sudo脆弱性の確認(CVE-2021-3156対応) https://security.sios.com/vulnerability/sudo-security-vulnerability-20210127.html
describe command('sudoedit -s /') do
  its(:stderr) { should match /usage:.*/ }
end

# 正常性確認ツール配置用scriptディレクトリ権限設定
describe file("/usr/local/script") do
    it { should be_directory }
    it { should be_mode 755 }
end

# OS上の操作ログ取得のためのディレクトリ権限設定
describe file("/var/log") do
  it { should be_directory }
  it { should be_mode 755 }
end

describe file("/var/log/operation") do
  it { should be_directory }
  it { should be_mode 777 }
end

# OS上の操作ログ転送ファイル配置確認
describe file("/etc/google-fluentd/config.d/service-operation.conf") do
  it { should be_file }
  it { should be_mode 640 }
end

# OS上の操作ログ取得スクリプトの設置確認
describe file("/etc/profile.d/operation.sh") do
  it { should be_file }
  it { should be_mode 744 }
end

# OS上の操作ログ削除のcron設定確認
describe file('/etc/cron.d/rotate-opelog') do
  it { should be_file }
  it { should be_mode 600 }
  its(:content) { should match %r{^00 5 * * * root find /var/log/operation -mtime +3 -name "*.log" | xargs rm -f$} }
end
