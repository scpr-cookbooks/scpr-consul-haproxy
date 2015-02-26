# -- Install HAProxy -- #

include_recipe "apt"

apt_repository 'haproxy-1.5' do
  action        node.scpr_consul_haproxy.use_1_5 ? :add : :remove
  uri           "http://ppa.launchpad.net/vbernat/haproxy-1.5/ubuntu"
  distribution  node.lsb.codename
  components    ['main']
  keyserver     "keyserver.ubuntu.com"
  key           "1C61B9CD"
end

#include_recipe "haproxy::install_package"

package "haproxy" do
  action  :install
  version node.scpr_consul_haproxy.use_1_5 ? "1.5.11-1ppa1~precise" : "1.4.18-0ubuntu1.2"
  options '-o Dpkg::Options::="--force-confold"'
end

service "haproxy" do
  action :nothing
  supports [:start,:stop,:restart,:reload,:status]
end

# write the defaults file enabling haproxy (only required for 1.4)
cookbook_file "/etc/default/haproxy" do
  source "haproxy-default"
  owner "root"
  group "root"
  mode 00644
  notifies :restart, "service[haproxy]"
end if !node.scpr_consul_haproxy.use_1_5

# -- Install / Configure Consul -- #

include_recipe "scpr-consul"

# -- Install consul template -- #

include_recipe "consul-template"