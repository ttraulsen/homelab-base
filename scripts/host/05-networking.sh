#/bin/sh

cp systemd/network/* /etc/systemd/network/
systemctl restart systemd-networkd
