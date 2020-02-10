# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

	config.vm.define :router do |node|
		node.vm.hostname = "router"
		node.vm.network "private_network", ip: "192.0.2.254", virtualbox__intnet: "public"
		node.vm.network "private_network", ip: "10.0.0.254", virtualbox__intnet: "internal"
		node.vm.provision "shell", path: "./provision/router.sh"
	end

	config.vm.define :web_sv do |node|
		node.vm.hostname = "websv"
		node.vm.network "private_network", ip: "10.0.0.80", virtualbox__intnet: "internal"
		node.vm.provision "shell", path: "./provision/web_sv.sh"
	end

	config.vm.define :internal_user do |node|
		node.vm.hostname = "internaluser"
		node.vm.network "private_network", ip: '10.0.0.1', virtualbox__intnet: "internal"
		node.vm.provision "shell", path: "./provision/internal_user.sh"
	end

	config.vm.define :pub_user do |node|
		node.vm.hostname = "pubuser"
		node.vm.network "private_network", ip: "192.0.2.1", virtualbox__intnet: "public"
		node.vm.provision "shell", path: "./provision/pub_user.sh"
	end

	config.vm.define :dns_sv do |node|
		node.vm.hostname = "dnssv"
		node.vm.network "private_network", ip: "192.0.2.53", virtualbox__intnet: "public"
		node.vm.provision "shell", path: "./provision/dns_sv.sh"
	end

end
