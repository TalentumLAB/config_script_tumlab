#!/bin/bash

path_hosts="/etc/hosts"

path_netplan="/etc/netplan/00-installer-config.yaml"
echo "$path_hosts"
name="$(hostname)"

rm "$path_hosts"
cp ./hosts "path_hosts"

rm "$path_netplan"
cp ./00-installer-config.yaml "$path_netplan"

sudo systemctl restart dnsmasq
sudo netplan apply