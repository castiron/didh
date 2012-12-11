# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'socket'

recipes = [ "cic_projects::didh" ]
project = "didh"

Vagrant::Config.run do |config|

  config.vm.box = "lucid32"
  config.vm.host_name = "vagrant-#{project}.#{Socket.gethostname}"
  config.vm.forward_port 80, 8002

  config.vm.provision :chef_client do |chef|

  	# Store the chef node name in a .chef-node file
  	if File.exist?(".chef-node")
	  	file = File.new(".chef-node", "r")
  		node_name = file.gets
	else
		node_name = "didh-#{Time.now.to_i}.vagrant.#{Socket.gethostname}"
		File.open(".chef-node", 'w') {|f| f.write(node_name) }
	end

  	chef.node_name = node_name
    chef.chef_server_url = "http://chef.ciclabs.com:4000"
    chef.validation_key_path = "/etc/chef/validation.pem"
    chef.validation_client_name = "chef-validator"

    # Change this to whatever recipe you need to run
    recipes.each do |recipe|
    	chef.add_recipe recipe
    end

  end

end

module Vagrant
  module Provisioners
    class Base
      def cleanup
      	File.delete(".chef-node")
      end
    end
  end
end
