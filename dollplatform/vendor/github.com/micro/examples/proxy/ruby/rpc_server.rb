require './sidecar'
require 'rjr/nodes/web'

$service = {
  "name" => "go.micro.srv.greeter",
  "nodes" => [{
    "id" => "go.micro.srv.greeter-" + SecureRandom.uuid,
    "address" => "localhost",
    "port" => 4000
  }]
}

trap 'INT' do
  deregister($service)
  exit
end

# create server
server = RJR::Nodes::Web.new :node_id => 'server', :host => 'localhost', :port => 4000
# serve method Say.Hello
server.dispatcher.handle("Say.Hello") { |args|
  "Hello #{args['name']}!"
}

# register service
register($service)

# start the server and block
server.listen
server.join
