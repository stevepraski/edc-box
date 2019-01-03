# -*- mode: ruby -*-
# vi: set ft=ruby :
# rubocop:disable LineLength
# rubocop:disable BlockLength

Vagrant.configure('2') do |config|
  FileUtils.mkdir_p './apt-cache'

  config.vm.box = 'bento/ubuntu-18.04'

  config.vm.synced_folder '.', '/src'
  config.vm.synced_folder './apt-cache', '/var/cache/apt-cacher-ng',
                          owner: 'root',
                          group: 'vagrant',
                          mount_options: ['dmode=2775']

  config.vm.network 'forwarded_port', guest: 3142, host: 2413, protocol: 'tcp'

  config.vm.provider 'virtualbox' do |vb|
    vb.gui = false
    vb.memory = '2000'
    # choices: hda sb16 ac97
    if RUBY_PLATFORM =~ /darwin/
      vb.customize ['modifyvm', :id, '--audio', 'coreaudio', '--audiocontroller', 'hda']
    else
      vb.customize ['modifyvm', :id, '--audio', 'alsa', '--audiocontroller', 'ac97']
    end
    vb.customize ['modifyvm', :id, '--audioout', 'on']
  end

  config.vm.provision 'shell', inline: <<-SHELL
    #!/bin/sh
    set -e
    if ! command id -u apt-cacher-ng >/dev/null 2>&1 || true; then
      touch /etc/systemd/system/apt-cacher-ng.service
      apt-get install -y apt-cacher-ng
      usermod -a -G vagrant apt-cacher-ng
      rm /etc/systemd/system/apt-cacher-ng.service
      service apt-cacher-ng start
      echo -e "Acquire::http::Proxy \\\"http://localhost:3142\\\";" > /etc/apt/apt.conf.d/00aptproxy
      apt-get update
    else
      echo "Skipping apt-cacher-ng installation"
    fi
  SHELL

  config.vm.provision 'shell', inline: <<-SHELL
    #!/bin/bash
    set -e
    if ! command -v ansible-playbook >/dev/null 2>&1; then
      apt-add-repository -y --update ppa:ansible/ansible
      apt-get update
      apt-get install -y software-properties-common curl
      apt-get install -y ansible
    else
      echo "Skipping Ansible installation"
    fi
  SHELL

  config.vm.provision 'shell', run: 'always', inline: <<-SHELL
    ansible-playbook /src/playbook.yml --connection=local
  SHELL
end

### test as vagrant user
# aplay -l
# speaker-test
# streamlink --player mplayer --player-args "\-ao alsa {filename} -af volume=10 -cache 1024" https://www.twitch.tv/{NULL} audio_only
