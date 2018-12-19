#!/bin/bash
set -e
apt-add-repository -y --update ppa:ansible/ansible
apt-get update
apt-get install -y software-properties-common curl
apt-get install -y ansible
mkdir -p /opt/eco-docker-bootstrap
cd /opt/eco-docker-bootstrap
curl -L https://api.github.com/repos/stevepraski/edc-box/tarball | tar -xzf - --strip-components=1
cat << EOF > eco-docker-playbook.yml
---
- hosts: 127.0.0.1
  become: yes
  roles:
    - docker
    - eco-docker
EOF

ansible-playbook /opt/eco-docker-bootstrap/eco-docker-playbook.yml --connection=local
