require 'spec_helper'

# httpdパッケージ存在及び自動起動確認
describe service('httpd') do
    it { should be_enabled }
end