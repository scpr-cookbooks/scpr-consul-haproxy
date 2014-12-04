default.scpr_consul_haproxy.admin_interface = "eth0"
default.scpr_consul_haproxy.config_key      = "haproxy/scpr"

#----------

include_attribute "haproxy"

#----------

include_attribute "consul-template"

default.consul_template.version = "0.3.1"
default.consul_template.checksums = {
  'consul-template_0.3.1_linux_amd64' => "a6cd9ac0880fc3a380b6fe50491797c38b87ec79803d5654d16c40853c6ccbf2"
}

default.consul_template.config = {
  consul: "localhost:8500",
}