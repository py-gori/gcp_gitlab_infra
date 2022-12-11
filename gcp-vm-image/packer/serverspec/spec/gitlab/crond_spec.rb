require 'spec_helper'

# backupスクリプト配置ディレクトリ権限設定
describe file("/usr/local/script/gitlab") do
    it { should be_directory }
    it { should be_mode 755 }
end

# backupスクリプト存在確認
describe file("/usr/local/script/gitlab/gitlab_backup.sh") do
    it { should be_file }
    it { should be_mode 755 }
end

# backup cron 設定確認
describe cron do
    it { should have_entry '0 5 * * * /usr/local/script/gitlab/gitlab_backup.sh > /dev/null 2>&1' }
end
