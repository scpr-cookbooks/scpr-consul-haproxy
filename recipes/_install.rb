# -- Install HAProxy -- #

include_recipe 'apt'

apt_repository 'haproxy-1.5' do
  action        :add
  uri           'http://ppa.launchpad.net/vbernat/haproxy-1.5/ubuntu'
  distribution  node.lsb.codename
  components    ['main']
  keyserver     'keyserver.ubuntu.com'
  key           '1C61B9CD'
end

package 'haproxy' do
  action  :install
  options '-o Dpkg::Options::="--force-confold"'
end

service 'haproxy' do
  action :nothing
  supports [:start, :stop, :restart, :reload, :status]
end

# -- Install / Configure Consul -- #

include_recipe 'scpr-consul'
include_recipe 'scpr-consul::consul-template'
