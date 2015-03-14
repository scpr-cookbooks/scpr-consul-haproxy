require_relative '../../../kitchen/data/spec_helper'

describe "consul-haproxy" do
  describe service("consul-template") do
    it { should be_running }
  end

  describe file("/etc/haproxy/haproxy.cfg") do
    it { should contain("use_backend scprv4_production_web") }
  end
end