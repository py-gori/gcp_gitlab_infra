require 'spec_helper'

# python3コマンド存在確認
# only serverspec
describe command('which python3') do
    its(:exit_status) { should eq 0 }
end