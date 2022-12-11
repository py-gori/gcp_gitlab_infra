require 'spec_helper'

# phpバージョン確認
describe command('php -v') do
    its(:stdout) { should match /PHP 8\.0/ }
end