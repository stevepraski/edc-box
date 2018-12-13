# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-18.04"

  # config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
  # config.vm.network 'forwarded_port', guest: 3142, host: 3142

  config.vm.synced_folder ".", "/src"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "1024"
    if RUBY_PLATFORM =~ /darwin/
      vb.customize ["modifyvm", :id, '--audio', 'coreaudio', '--audiocontroller', 'hda'] # choices: hda sb16 ac97
    else
      vb.customize ["modifyvm", :id, '--audio', 'alsa', '--audiocontroller', 'ac97']
    end
    vb.customize ["modifyvm", :id, "--audioout", "on"]
  end

  config.vm.provision "shell", inline: <<-SHELL
    # apt-get update
    apt-get install -y software-properties-common # python-software-properties
    apt-add-repository -y --update ppa:ansible/ansible
    apt-get install -y ansible
    ansible-playbook /src/playbook.yml --connection=local
  SHELL
end

### test as vagrant and root user
# aplay -l
# speaker-test
# streamlink --player mplayer --player-args "\-ao alsa {filename} -af volume=10 -cache 1024" https://www.twitch.tv/{NULL} audio_only
