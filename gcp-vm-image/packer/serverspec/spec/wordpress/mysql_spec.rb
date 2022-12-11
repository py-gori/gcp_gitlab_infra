require 'spec_helper'

# mysqldパッケージ存在及び自動起動確認
describe service('mysqld') do
    it { should be_enabled }
end