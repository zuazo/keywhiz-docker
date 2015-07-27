require_relative '../serverspec_helper'

describe 'Docker image run' do
  before { sleep(120) if ENV.key?('TRAVIS') }

  describe user('keywhiz') do
    it { should exist }
  end

  describe group('keywhiz') do
    it { should exist }
  end

  describe process('java') do
    it { should be_running }
    its(:user) { should eq 'keywhiz' }
    its(:args) { should match /keywhiz-server-shaded\.jar/ }
  end

  describe port(4444) do
    it do
      sleep(10)
      should be_listening
    end
  end
end
