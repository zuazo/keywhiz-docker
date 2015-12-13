require 'dockerspec'
require 'dockerspec/serverspec'
require 'json'

describe docker_build('.', tag: 'keywhiz') do
  it { should have_entrypoint '/entrypoint.sh' }
  it { should have_workdir %r{^/opt/keywhiz-} }
  it { should have_expose '4444' }
  it { should have_env 'KEYWHIZ_VERSION' }

  describe docker_build(File.dirname(__FILE__), tag: 'keywhiz_test') do
    describe docker_run('keywhiz_test') do
      before(:all) { sleep(10) }

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

      describe port(4444), if: !ENV.key?('CIRCLECI') do
        it { should be_listening }
      end

      describe port(8085), if: !ENV.key?('CIRCLECI') do
        it { should be_listening }
      end

      describe command('wget -O- 127.0.0.1:8085/ping') do
        its(:stdout) { should match /^pong/ }
      end

      describe command('wget -O- 127.0.0.1:8085/healthcheck') do
        let(:json) { JSON.parse(subject.stdout) }

        it 'returns a valid JSON' do
          json
        end

        %w(db-read-write-health db-readonly-health deadlocks).each do |field|
          it "#{field} is healthy" do
            expect(json[field]['healthy']).to be true
          end
        end
      end
    end
  end
end
