#!/bin/bash

set -exo pipefail

sudo apt-get install \
    make \
    autoconf \
    build-essential \
    curl \
    gettext

sudo adduser --disabled-password --gecos "" nagios

rm -rf build
mkdir -p build
pushd build
PLUGIN_VERSION=2.2.1
PLUGIN_TAR=release-$PLUGIN_VERSION.tar.gz
curl -OL "https://github.com/nagios-plugins/nagios-plugins/archive/$PLUGIN_TAR"
tar -xvf $PLUGIN_TAR

pushd nagios-plugins-release-$PLUGIN_VERSION
./tools/setup
./configure --with-nagios-user=nagios
make -j$(nproc)
sudo make install
popd
popd

rm -rf build

mkdir /home/nagios/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6tnqo9Sxqcr/iHT61yHtNQXVwlT865ZF+WKQhl2FXzm4QjlbslOs5unrLoNuCg8r53Ozno6zIe/a6cGH8pMJeQOkGUsM2LV5AE9QsY/sxZtPj5CFyr6IpSMaVrwAxWwqcGZecL8TnF9trmIiWFeLKWqyFLPSmVzBnFGDa0ir6FhaEAQcIT2tFJgiMmgDvDsrhVDunKzfQgXXC9gvtVYH/7Z64yma7Z2oD3z14mgZy7b7W1hRGjl7kKD68y33TlRzdLT0V7gNzTGBJBOty3Ly5SF0BikLZMyrAOkG125bHh/nlTMOqkeMnQG05j3TG3nHkOkhA4yZPA2imWlDEkSPf root@docker-1" > /home/nagios/.ssh/authorized_keys
chown -R nagios:nagios /home/nagios/.ssh
