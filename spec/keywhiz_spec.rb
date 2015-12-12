require 'dockerspec'
require 'dockerspec/serverspec'

describe docker_build('.', tag: 'keywhiz') do
  it { should have_entrypoint '/entrypoint.sh' }
  it { should have_workdir %r{^/opt/keywhiz-} }
  it { should have_expose '4444' }
  it { should have_env 'KEYWHIZ_VERSION' }

  describe docker_build(File.dirname(__FILE__), tag: 'keywhiz_test') do
    describe docker_run('keywhiz_test') do
      describe user('keywhiz') do
        it { should exist }
      end

      describe group('keywhiz') do
        it { should exist }
      end

      describe process('java') do
        it { should be_running }
        its(:user) { should eq 'keywhiz' }
        its(:args) { should match(/keywhiz-server-shaded\.jar/) }
      end

      # Check if TCP port 4444 is listening
      describe command('nc -z 127.0.0.1 4444') do
        its(:exit_status) do
          sleep(ENV.key?('CIRCLECI') ? 60 : 10)
          should eq 0
        end
      end

      # Does not work on CircleCI
      # describe port(4444), if: !ENV.key?('CIRCLECI') do
      #   it do
      #     sleep(10)
      #     should be_listening
      #   end
      # end
    end
  end
end
