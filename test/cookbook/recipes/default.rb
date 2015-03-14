# make sure consul has been installed
include_recipe "scpr-consul"

# Install curl to make life easier
package "curl"

# set up our key
config = {
  services: [
    {
      ip:       "10.4.4.4",
      hostname: "www.scpr.org",
      service:  "scprv4_production_web",
    }
  ]
}

execute "install-haproxy-key" do
  action :run
  command "curl -XPUT http://localhost:8500/v1/kv/haproxy/scpr -d '#{ config.to_json() }'"
end

# Add a local service

service_config = {
  Name:     "scprv4_production_web",
  Address:  "127.0.0.1",
}

execute "add-test-service" do
  action :run
  command "curl -XPUT http://localhost:8500/v1/agent/service/register -d '#{ service_config.to_json() }'"
end