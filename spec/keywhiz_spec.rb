require 'dockerspec'
require 'dockerspec/serverspec'

describe docker_build('.', tag: 'keywhiz') do
  it { should have_entrypoint '/entrypoint.sh' }
  it { should have_workdir %r{^/opt/keywhiz-} }
  it { should have_expose '4444' }
  it { should have_env 'KEYWHIZ_VERSION' }

  describe docker_run('keywhiz') do
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
        sleep(ENV.key?('CI') ? 120 : 10)
        should be_listening
      end
    end
  end
end
