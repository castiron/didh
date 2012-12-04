# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'socket'

Vagrant::Config.run do |config|

  config.vm.box = "lucid32"
  config.vm.host_name = "vagrant-#{rand(1..999999999)}.#{Socket.gethostname}"
  config.vm.forward_port 80, 8001

  config.vm.provision :chef_client do |chef|
    chef.chef_server_url = "http://chef.ciclabs.com:4000"
    chef.validation_key_path = "/etc/chef/validation.pem"
    chef.validation_client_name = "chef-validator"

    chef.add_recipe("vagrant_rails")

  end

end
