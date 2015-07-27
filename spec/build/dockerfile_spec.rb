require_relative '../spec_helper'

describe 'Dockerfile build' do
  it 'creates image' do
    expect(image).not_to be_nil
  end

  it 'runs entrypoint script in foreground' do
    expect(image_config['Entrypoint']).to include '/entrypoint.sh'
  end

  it 'has the keywhiz path as workdir' do
    expect(image_config['WorkingDir']).to match Regexp.new('^/opt/keywhiz-')
  end

  it 'exposes the port 4444' do
    expect(image_config['ExposedPorts']).to include '4444/tcp'
  end

  context 'on environment' do
    let(:env_keys) { image_config['Env'].map { |x| x.split('=', 2)[0] } }

    it 'sets keywhiz version' do
      expect(env_keys).to include('KEYWHIZ_VERSION')
    end
  end
end
