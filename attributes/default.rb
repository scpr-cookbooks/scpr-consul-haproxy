default.scpr_consul_haproxy.admin_interface = "eth0"
default.scpr_consul_haproxy.config_key      = "haproxy/scpr"
default.scpr_consul_haproxy.max_sessions    = 10000
default.scpr_consul_haproxy.timeout_client  = "5m"
default.scpr_consul_haproxy.timeout_connect = "10s"
default.scpr_consul_haproxy.timeout_server  = "30s"

default.scpr_consul_haproxy.template        = "haproxy.consul.erb"

#----------


#----------

include_attribute "consul-template"

default.consul_template.version = "0.7.0"
default.consul_template.checksums = {
  'consul-template_0.7.0_linux_amd64' => '7b8fb97caef72f9e67bbb9069042b8e01f7efed3acd2a32f560a8fe60146d874',
}

default.consul_template.config = {
  consul: "localhost:8500",
}