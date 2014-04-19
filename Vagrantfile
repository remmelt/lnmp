Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.define "lnmp" do |node|
    config.vm.network :private_network, ip: "10.30.50.100"
    node.vm.hostname = "lnmp"

    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
  end

  Dir.mkdir 'src' unless Dir.exists?('src')
  config.vm.synced_folder "src/", "/usr/share/nginx/html", owner: "vagrant", group: "root"

  config.vm.provision :shell, :path => "provision.sh"
end
