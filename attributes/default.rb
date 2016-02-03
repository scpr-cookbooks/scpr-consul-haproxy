default.scpr_consul_haproxy.admin_interface = "eth0"
default.scpr_consul_haproxy.config_key      = "haproxy/scpr"
default.scpr_consul_haproxy.max_sessions    = 10000
default.scpr_consul_haproxy.timeout_client  = "5m"
default.scpr_consul_haproxy.timeout_connect = "10s"
default.scpr_consul_haproxy.timeout_server  = "30s"

default.scpr_consul_haproxy.template        = "haproxy.consul.erb"
default.scpr_consul_haproxy.template_cookbook = "scpr-consul-haproxy"

default.scpr_consul_haproxy.streammachine_svc_listener = "slave"
default.scpr_consul_haproxy.streammachine_svc_source = "master"

