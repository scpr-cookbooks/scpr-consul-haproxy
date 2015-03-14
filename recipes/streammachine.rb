#
# Cookbook Name:: scpr-consul-haproxy
# Recipe:: streammachine
#
# Copyright (c) 2014 Southern California Public Radio, All Rights Reserved.

# streammachine recipe is now just default with a different template
node.set['scpr_consul_haproxy']['template'] = "streammachine.erb"
node.set['scpr_consul_haproxy']['use_1_5']  = true

include_recipe "scpr-consul-haproxy"