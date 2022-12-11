require 'spec_helper'

# rotate設定ファイル存在確認
describe file("/etc/logrotate.d/gitlab-backuplog") do
    it { should be_file }
    it { should be_mode 644 }
end