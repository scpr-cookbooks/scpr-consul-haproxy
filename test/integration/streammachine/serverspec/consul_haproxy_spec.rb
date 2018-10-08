require_relative '../../../kitchen/data/spec_helper'

describe 'consul-haproxy' do
  describe service('consul-template') do
    it { should be_running }
  end

  describe file('/etc/haproxy/haproxy.cfg') do
    # streammachine has two frontend services
    its(:content) { should include('frontend listeners-in') }
    its(:content) { should include('frontend sources-in') }
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

  # Streammeachine should use HAProxy 1.5
  describe command('haproxy -v') do
    its(:stdout) { should include('HA-Proxy version 1.5') }
  end
end
