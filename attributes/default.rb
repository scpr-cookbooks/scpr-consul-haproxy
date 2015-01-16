default.scpr_consul_haproxy.admin_interface = "eth0"
default.scpr_consul_haproxy.config_key      = "haproxy/scpr"
default.scpr_consul_haproxy.max_sessions    = 10000
default.scpr_consul_haproxy.timeout_client  = "5m"
default.scpr_consul_haproxy.timeout_connect = "10s"
default.scpr_consul_haproxy.timeout_server  = "30s"

default.scpr_consul_haproxy.use_1_5         = false

#----------


#----------

include_attribute "consul-template"

default.consul_template.version = "0.3.1"
default.consul_template.checksums = {
  'consul-template_0.3.1_linux_amd64' => "a6cd9ac0880fc3a380b6fe50491797c38b87ec79803d5654d16c40853c6ccbf2"
}

default.consul_template.config = {
  consul: "localhost:8500",
}