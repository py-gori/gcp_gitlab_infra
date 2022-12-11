require 'spec_helper'

# dockerインストール関連パッケージの確認
%w[ yum-utils docker-ce docker-ce-cli containerd.io].each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
end

# dockerパッケージ自動起動確認
describe service('docker') do
    it { should be_enabled }
end