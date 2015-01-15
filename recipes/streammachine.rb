#
# Cookbook Name:: scpr-consul-haproxy
# Recipe:: streammachine
#
# Copyright (c) 2014 Southern California Public Radio, All Rights Reserved.

# -- Install HAProxy -- #

include_recipe "haproxy::install_package"

service "haproxy" do
  action :nothing
  supports [:start,:stop,:restart,:reload,:status]
end

# write the defaults file enabling haproxy
cookbook_file "/etc/default/haproxy" do
  cookbook  "haproxy"
  source    "haproxy-default"
  owner     "root"
  group     "root"
  mode      00644
  notifies  :restart, "service[haproxy]"
end

# -- Install / Configure Consul -- #

include_recipe "scpr-consul"

# -- Install consul template -- #

include_recipe "consul-template"

# -- Write out our consul_template template -- #

# find the IP address for our admin interface
admin_ip = node.network.interfaces[ node.scpr_consul_haproxy.admin_interface ].addresses.find { |k,v|
  v.family == "inet"
}.first

template "/etc/haproxy/haproxy.consul" do
  action        :create
  source        "streammachine.erb"
  variables({
    config_key: node.scpr_consul_haproxy.config_key,
    admin_ip:   admin_ip,
  })
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

end
