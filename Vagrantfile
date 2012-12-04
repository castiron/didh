# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "lucid32"

  config.vm.forward_port 3000, 80

  config.vm.provision :chef_client do |chef|
    chef.chef_server_url = "http://chef.ciclabs.com:4000"
    chef.validation_key_path = "/etc/chef/validation.pem"
    chef.validation_client_name = "chef-validator"

    chef.json = {
      :cic_rails => {
        :project => 'didh',
        :environment => 'development',
        :domain => 'pericles.local',
        :hostname => 'localhost'
      }
    }

    chef.add_recipe "cic_rails"

  end

end
