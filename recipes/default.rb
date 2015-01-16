#
# Cookbook Name:: scpr-consul-haproxy
# Recipe:: default
#
# Copyright (c) 2014 Southern California Public Radio, All Rights Reserved.

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
  action :install
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

# -- Write out our consul_template template -- #

# find the IP address for our admin interface
admin_ip = node.network.interfaces[ node.scpr_consul_haproxy.admin_interface ].addresses.find { |k,v|
  v.family == "inet"
}.first

# TODO: Where should we discover these from?
# TODO: Need to deprovision as well

template "/etc/haproxy/consul.stage1" do
  action :create
  variables({
    config_key: node.scpr_consul_haproxy.config_key,
    admin_ip:   admin_ip,
  })
end

# We have a funky two-step process here... Because we need to
# query for what services to run, and then query for the service
# nodes themselves, we have to run two consul-template services.

# This will be simplified if the nesting issue gets resolved:
# https://github.com/hashicorp/consul-template/issues/64

file "/etc/haproxy/consul.stage2" do
  action :touch
  not_if { ::File.exists?("/etc/haproxy/consul.stage2") }
end

execute "consul-template-stage1" do
  action :run
  command "consul-template -template '/etc/haproxy/consul.stage1:/etc/haproxy/consul.stage2:service consul-template restart' -once"
end

# Set up our consul template config
consul_template_config "haproxy" do
  action :create
  templates([
    {
      source:       "/etc/haproxy/consul.stage2",
      destination:  "/etc/haproxy/haproxy.cfg",
      command:      "service haproxy reload",
    }
  ])

end
