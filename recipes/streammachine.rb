#
# Cookbook Name:: scpr-consul-haproxy
# Recipe:: streammachine
#
# Copyright (c) 2014 Southern California Public Radio, All Rights Reserved.

# streammachine recipe is now just default with a different template
node.set['scpr_consul_haproxy']['template'] = "streammachine.erb"

include_recipe "scpr-consul-haproxy"