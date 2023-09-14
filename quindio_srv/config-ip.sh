#!/bin/bash

path_hosts="/etc/hosts"

path_netplan="/etc/netplan/00-installer-config.yaml"
echo "$path_hosts"
name="$(hostname)"
echo "Digite la direccion IP reservada: "
read -r ip

echo "Digite el CIDR o el tamaño de la mascara"
read -r CIDR

echo "Digite el gateway"
read -r gateway

echo "IP: $ip"
echo "Mascara: /$CIDR"
echo "Gateway: $gateway"

sed -i "2,11d" "$path_hosts"

{
echo "$ip"   integratic.aulasquindio.local
echo "$ip"   lms.aulasquindio.local 
echo "$ip"   si.aulasquindio.local
echo "$ip"   agau.aulasquindio.local
echo "$ip"   maps.aulasquindio.local
echo "$ip"   videos.aulasquindio.local
echo "$ip"   content.aulasquindio.local
echo "$ip"   integratic.aulasquindio.local
echo "$ip"   integratic.aulasquindio.local
echo "$ip"   "$name"
} >> "$path_hosts"

sudo sed -i.bak "12 s/      dhcp4: true/      dhcp4: false/" "$path_netplan" 
sed -i "13d" "$path_netplan"
echo "            addresses:" >> "$path_netplan"
echo "              - "$ip"/$CIDR" >> "$path_netplan"
echo "            gateway4: $gateway" >> "$path_netplan"
echo "            nameservers:" >> "$path_netplan"
echo "              addresses:" >> "$path_netplan"
echo "              - 8.8.8.8" >> "$path_netplan"

sudo netplan apply