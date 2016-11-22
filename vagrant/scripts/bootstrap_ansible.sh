#!/bin/bash
apt-get install --yes python-apt
rm -rf /usr/share/ansible || true

cat > /root/.ansible.cfg <<EOF
[defaults]
remote_tmp = /vagrant/ansible/tmp
log_path = /vagrant/ansible/ansible.log
EOF

cat > /home/vagrant/.ansible.cfg <<EOF
[defaults]
remote_tmp = /vagrant/ansible/tmp
log_path = /vagrant/ansible/ansible.log
EOF
