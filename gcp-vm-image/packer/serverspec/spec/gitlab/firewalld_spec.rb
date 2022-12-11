require 'spec_helper'

# firewalld停止確認
describe service('firewalld') do
    it { should_not be_running }
    it { should_not be_enabled }
end