# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "osb2admin2" , primary: true do |osb2admin2|

    osb2admin2.vm.box = "centos-6.6-x86_64"
    osb2admin2.vm.box_url = "https://dl.dropboxusercontent.com/s/ijt3ppej789liyp/centos-6.6-x86_64.box"

    osb2admin2.vm.provider :vmware_fusion do |v, override|
      override.vm.box = "centos-6.6-x86_64-vmware"
      override.vm.box_url = "https://dl.dropboxusercontent.com/s/7ytmqgghoo1ymlp/centos-6.6-x86_64-vmware.box"
    end

    osb2admin2.vm.hostname = "osb2admin2.example.com"
    osb2admin2.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]
    osb2admin2.vm.synced_folder "/Users/edwin/software", "/software"

    osb2admin2.vm.network :private_network, ip: "10.10.10.21"

    osb2admin2.vm.provider :vmware_fusion do |vb|
      vb.vmx["numvcpus"] = "2"
      vb.vmx["memsize"] = "2548"
    end

    osb2admin2.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2548"]
      vb.customize ["modifyvm", :id, "--name"  , "osb2admin2"]
      vb.customize ["modifyvm", :id, "--cpus"  , 2]
    end

    osb2admin2.vm.provision :shell, :inline => "ln -sf /vagrant/puppet/hiera.yaml /etc/puppet/hiera.yaml;rm -rf /etc/puppet/modules;ln -sf /vagrant/puppet/modules /etc/puppet/modules"

    osb2admin2.vm.provision :puppet do |puppet|
      puppet.manifests_path    = "puppet/manifests"
      puppet.module_path       = "puppet/modules"
      puppet.manifest_file     = "site.pp"
      puppet.options           = "--verbose --hiera_config /vagrant/puppet/hiera.yaml"

      puppet.facter = {
        "environment"    => "development",
        "vm_type"        => "vagrant",
      }

    end

  end

  config.vm.define "osbdb" , primary: true do |osbdb|

    osbdb.vm.box = "centos-6.6-x86_64"
    osbdb.vm.box_url = "https://dl.dropboxusercontent.com/s/ijt3ppej789liyp/centos-6.6-x86_64.box"

    osbdb.vm.provider :vmware_fusion do |v, override|
      override.vm.box = "centos-6.6-x86_64-vmware"
      override.vm.box_url = "https://dl.dropboxusercontent.com/s/7ytmqgghoo1ymlp/centos-6.6-x86_64-vmware.box"
    end

    osbdb.vm.hostname = "osbdb.example.com"
    osbdb.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]
    osbdb.vm.synced_folder "/Users/edwin/software", "/software"

    osbdb.vm.network :private_network, ip: "10.10.10.5"

    osbdb.vm.provider :vmware_fusion do |vb|
      vb.vmx["numvcpus"] = "2"
      vb.vmx["memsize"] = "2548"
    end

    osbdb.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm"     , :id, "--memory", "2548"]
      vb.customize ["modifyvm"     , :id, "--name"  , "osbdb"]
      vb.customize ["modifyvm"     , :id, "--cpus"  , 2]
    end


    osbdb.vm.provision :shell, :inline => "ln -sf /vagrant/puppet/hiera.yaml /etc/puppet/hiera.yaml;rm -rf /etc/puppet/modules;ln -sf /vagrant/puppet/modules /etc/puppet/modules"

    osbdb.vm.provision :puppet do |puppet|
      puppet.manifests_path    = "puppet/manifests"
      puppet.module_path       = "puppet/modules"
      puppet.manifest_file     = "db.pp"
      puppet.options           = "--verbose --hiera_config /vagrant/puppet/hiera.yaml"

      puppet.facter = {
        "environment" => "development",
        "vm_type"     => "vagrant",
      }

    end

  end

end
