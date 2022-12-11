require 'spec_helper'

# packerインストール確認
describe command('ls -l /usr/local/bin | grep packer | wc -l' ) do
    its(:stdout) { should match /^1$/ }
end
