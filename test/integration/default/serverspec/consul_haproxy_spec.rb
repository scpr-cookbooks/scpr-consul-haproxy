require_relative '../../../kitchen/data/spec_helper'

describe 'consul-haproxy' do
  describe service('consul-template') do
    it { should be_running }
  end

  describe file('/etc/haproxy/haproxy.cfg') do
    # this service comes from the kv json we registered
    its(:content) { should include('use_backend scprv4_production_web') }

    # this backend comes from the service we registered
    its(:content) { should include('server default-ubuntu-1204 127.0.0.1:80') }
  end

  describe service('haproxy') do
    it { should be_running }
  end

  describe port(80) do
    it { should be_listening.with('tcp') }
  end

  describe port(1944) do
    it { should be_listening.with('tcp') }
  end

  # Default recipe installs HAProxy 1.4
  describe command('haproxy -v') do
    its(:stdout) { should include('HA-Proxy version 1.5') }
  end
end
