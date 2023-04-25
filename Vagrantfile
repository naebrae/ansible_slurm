
NODE_COUNT = 2

Vagrant.configure(2) do |config|

  config.ssh.insert_key = false

  nodelist = []
  (1..NODE_COUNT).each do |i|
    nodelist.push "slcn#{i}"
    config.vm.define "slcn#{i}" do |slcn_config|
      slcn_config.vm.box = "almalinux/9"
      slcn_config.vm.network "private_network", ip: "172.16.2.#{100+i}"
      slcn_config.vm.provider "virtualbox" do |slcn_vb|
        slcn_vb.name = "slcn#{i}"
        slcn_vb.memory = 2048
        slcn_vb.cpus = 2
      end
    end
  end

  config.vm.define "slhn", primary: true do |slhn_config|
    slhn_config.vm.box = "almalinux/9"
    slhn_config.vm.network "private_network", ip: "172.16.1.100"
    slhn_config.vm.network "private_network", ip: "172.16.2.100"

    slhn_config.vm.provider "virtualbox" do |slhn_vb|
      slhn_vb.name = "slhn"
    end

    slhn_config.vm.provision "ansible" do |slhn_ansible|
      slhn_ansible.playbook = "keyscan.yml"
      slhn_ansible.limit = "all"
      slhn_ansible.groups = {
        "headnodes" => ["slhn"],
        "headnodes:vars" => {"host_domain" => "lab.home"},
        "computenodes" => nodelist,
        "computenodes:vars" => {"noderange" => "slcn[1-#{NODE_COUNT}]", "headnode" => "slhn", "headnodeip" => "172.16.2.100", "host_domain" => "lab.home"}
      }
    end
    slhn_config.vm.provision "ansible" do |slhn_ansible|
      slhn_ansible.playbook = "startautofs.yml"
      slhn_ansible.limit = "computenodes"
      slhn_ansible.groups = {
        "headnodes" => ["slhn"],
        "headnodes:vars" => {"host_domain" => "lab.home"},
        "computenodes" => nodelist,
        "computenodes:vars" => {"noderange" => "slcn[1-#{NODE_COUNT}]", "headnode" => "slhn", "headnodeip" => "172.16.2.100", "host_domain" => "lab.home"}
      }
    end 
  end

  config.vm.provision "shell", inline: <<-SHELL
    echo "172.16.2.100    slhn.lab.home   slhn" >> /etc/hosts
  SHELL
  (1..NODE_COUNT).each do |i|
    config.vm.provision "shell", inline: <<-SHELL
      echo "172.16.2.#{100+i}    slcn#{i}.lab.home  slcn#{i}" >> /etc/hosts
    SHELL
  end
  
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.groups = {
      "headnodes" => ["slhn"],
      "headnodes:vars" => {"host_domain" => "lab.home"},
      "computenodes" => nodelist,
      "computenodes:vars" => {"noderange" => "slcn[1-#{NODE_COUNT}]", "headnode" => "slhn", "headnodeip" => "172.16.2.100", "host_domain" => "lab.home"}
    }
  end
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "openmpi.yml"
    ansible.groups = {
      "headnodes" => ["slhn"],
      "headnodes:vars" => {"host_domain" => "lab.home"},
      "computenodes" => nodelist,
      "computenodes:vars" => {"noderange" => "slcn[1-#{NODE_COUNT}]", "headnode" => "slhn", "headnodeip" => "172.16.2.100", "host_domain" => "lab.home", "link_net" => "172.16.2.0/24"}
    }
  end

  config.vm.synced_folder ".", "/home/vagrant/sync", type: "rsync", disabled: true
  config.vm.synced_folder ".", "/vagrant", disabled: true
end
