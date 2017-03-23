#
# Cookbook Name:: scpr-consul-haproxy
# Recipe:: default
#
# Copyright (c) 2014-2015 Southern California Public Radio

include_recipe "scpr-consul-haproxy::_install"

# -- Write out our consul_template template -- #

# find the IP address for our admin interface
admin_ip = node.network.interfaces[ node.scpr_consul_haproxy.admin_interface ].addresses.find { |k,v|
  v.family == "inet"
}.first

# Install SSL certificates from databag if they exist
if certs = node.ssl.certificates rescue nil
  certs.each do |certificate|
    if cert = data_bag_item(node.ssl.databag,certificate) rescue nil
      file "#{node.ssl.path}/#{certificate}.pem" do
        action  :create
        mode    0644
        content [cert['cert'],cert['chain'],cert['key']].join("\n")
      end
    end
  end
end

# TODO: Need to deprovision as well

template "/etc/haproxy/haproxy.consul" do
  action    :create
  source    node.scpr_consul_haproxy.template
  cookbook  node.scpr_consul_haproxy.template_cookbook
  variables({
    config_key: node.scpr_consul_haproxy.config_key,
    admin_ip:   admin_ip,
  })
  notifies  :reload, "service[consul-template]"
  notifies  :reload, "service[haproxy]"
end

# Set up our consul template config
consul_template_config "haproxy" do
  action :create
  templates([
    {
      source:       "/etc/haproxy/haproxy.consul",
      destination:  "/etc/haproxy/haproxy.cfg",
      command:      "service haproxy reload",
    }
  ])
  notifies :restart, "service[consul-template]"
end
