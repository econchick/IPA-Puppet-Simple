# -*- mode: ruby -*-
# vi: set ft=ruby :

$SERVER_SCRIPT = <<EOF
yum install -y puppet vim
puppet module install puppetlabs/stdlib --verbose ;\
cp /vagrant/server/params.pp /etc/puppet/modules/ipa/manifests/params.pp ;\
puppet apply --verbose /etc/puppet/modules/ipa/manifests/init.pp -e 'include ipa'
EOF

$CLIENT_SCRIPT = <<EOF
yum install -y puppet vim
puppet module install puppetlabs/stdlib --verbose ;\
cp /vagrant/client/params.pp /etc/puppet/modules/ipa/manifests/params.pp ;\
puppet apply --verbose /etc/puppet/modules/ipa/manifests/init.pp -e 'include ipa'
EOF

Vagrant.configure("2") do |config|
  config.vm.define :server do |server|
    server.vm.box = "Fedora-18"
    server.vm.network :forwarded_port, guest: 80, host: 5050
    server.vm.network :forwarded_port, guest: 443, host: 4040
    server.vm.network :forwarded_port, guest: 53, host: 3030
    server.vm.network :private_network, ip: "192.168.25.10"
    server.vm.hostname = "master.rootcloud.com"
    server.vm.synced_folder "server/", "/vagrant/server/"
    server.vm.synced_folder "modules/", "/etc/puppet/modules/"
    server.vm.provision :shell, :inline => $SERVER_SCRIPT
  end

  config.vm.define :client do |client|
    client.vm.box = "Fedora-18"
    client.vm.network :forwarded_port, guest: 80, host: 5055
    client.vm.network :forwarded_port, guest: 443, host: 4044
    client.vm.network :forwarded_port, guest: 53, host: 3033
    client.vm.network :private_network, ip: "192.168.25.15"
    client.vm.hostname = "client.rootcloud.com"
    client.vm.synced_folder "client/", "/vagrant/client/"
    client.vm.synced_folder "modules/", "/etc/puppet/modules/"
    client.vm.provision :shell, :inline => $CLIENT_SCRIPT
  end
end
