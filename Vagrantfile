# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

 config.vm.define "coretest"

 config.vm.box = "ubuntu/trusty64"
 config.vm.box_url = "https://atlas.hashicorp.com/ubuntu/boxes/trusty64/versions/20150516.0.0/providers/virtualbox.box"

 config.vm.network "private_network", ip: "192.168.33.22"
 config.vm.network :forwarded_port, guest: 80, host: 8765
 config.vm.hostname = "coretest"

 config.vm.synced_folder ".", "/vagrant", disabled: true
 config.vm.synced_folder ".", "/var/tmp/testcore/", id: "vagrant-root",
   nfs: true

 config.vm.provider :virtualbox do |vb|
   vb.gui = false
   vb.customize ["modifyvm", :id, "--memory", "2048", "--cpus", "2"]

   # change the network card hardware for better performance
   vb.customize ["modifyvm", :id, "--nictype1", "virtio" ]
   vb.customize ["modifyvm", :id, "--nictype2", "virtio" ]

   # suggested fix for slow network performance
   # see https://github.com/mitchellh/vagrant/issues/1807
   vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
   vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
 end



 # http://foo-o-rama.com/vagrant--stdin-is-not-a-tty--fix.html
 config.vm.provision "fix-no-tty", type: "shell" do |s|
    s.privileged = false
    s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
 end

 # add gitlab ssh keys
 # config.vm.provision "file", source: ".ssh/gitlab", destination: "/home/vagrant/.ssh/id_rsa"
 # config.vm.provision "file", source: ".ssh/gitlab.pub", destination: "/home/vagrant/.ssh/id_rsa.pub"
 # config.vm.provision :shell, inline: "chmod 0600 /home/vagrant/.ssh/id_rsa"
 # config.vm.provision :shell, inline: "chmod 0600 /home/vagrant/.ssh/id_rsa.pub"

 # automatically cd to project dir on login
 config.vm.provision :shell, inline: "echo 'cd /var/tmp/testcore/' > /home/vagrant/.bashrc"

 # automatically enable command line xdebug config
 config.vm.provision :shell, inline: "echo 'export XDEBUG_CONFIG=\"idekey=PHPSTORM\"' >> /home/vagrant/.bashrc"
 config.vm.provision :shell, inline: "echo 'alias php=\"php -dxdebug.remote_host=`netstat -rn | grep \"^0.0.0.0 \" | cut -d \" \" -f10`\"' >> /home/vagrant/.bashrc"

 config.vm.provision :ansible do |ansible|
   ansible.raw_arguments = ['--timeout=300']
   ansible.playbook = ".ansible/project.yml"
   ansible.verbose = "vvv"
   ansible.groups = {
     "env-dev:children" => ["app-web"],
     "app-web" => ["coretest"],     
   }
 end

end