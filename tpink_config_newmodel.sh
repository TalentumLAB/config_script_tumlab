#!/bin/bash

driver_dir="/tumlab/scripts/rtl8812au"
echo "$driver_dir"

git clone https://github.com/aircrack-ng/rtl8812au.git "$driver_dir"

interfaces_before=$(ip link show > /tmp/interfaces_before.txt)
echo "$interfaces_before"

apt-get update
apt install dkms -y

apt install build-essential libelf-dev linux-headers-"$(uname -r)" -y

cd "$driver_dir" || exit

make dkms_install

printf '\n'
printf '\n'
printf '\n'
echo "======================================================================================================="
printf '\n'
printf '\n'
printf '\n'
read -p "Desconecte y vuelva a conectar la tarjeta TPLINK, despues presione enter o cualquier otra tecla"
printf '\n'
printf '\n'
printf '\n'
echo "========================================================================================================"
printf '\n'
printf '\n'
printf '\n'


interfaces_after=$(ip link show > /tmp/interfaces_after.txt)

echo "$interfaces_after"

new_interface=$(diff /tmp/interfaces_before.txt /tmp/interfaces_after.txt | grep '^>' | awk -F ':' '{print $2}' | tr -d ' ' | sed -n 1p)

echo "El nombre de la tarjeta de red USB es: $new_interface"

# Verificar si se proporcionó el nuevo nombre de la interfaz
if [ -z "$new_interface" ]; then
    echo "Error: Debe proporcionar el nuevo nombre de la interfaz como argumento."
    exit 1
fi


# Ruta de los archivos de configuracion
HP_CONFIG_FILE="/etc/hostapd/hostapd.conf"
DNS_CONFIG_FILE="/etc/dnsmasq.conf"
NETPLAN_CONFIG_FILE="/etc/netplan/00-installer-config-wifi.yaml"

# Hacer una copia de seguridad del archivo original de hostapd
cp "$HP_CONFIG_FILE" "$HP_CONFIG_FILE.bak"

# Hacer una copia de seguridad del archivo original de dnsmasq
cp "$DNS_CONFIG_FILE" "$DNS_CONFIG_FILE.bak"

# Hacer una copia de seguridad del archivo original de netplan
cp "$NETPLAN_CONFIG_FILE" "$NETPLAN_CONFIG_FILE.bak"


# Editar el archivo de configuración de hostapd
sed -i "s/^interface=.*$/interface=$new_interface/" "$HP_CONFIG_FILE"

# Editar el archivo de configuración de hostapd
sed -i "s/^interface=.*$/interface=$new_interface/" "$DNS_CONFIG_FILE"

# Editar el archivo de configuración de netplan
sed -i "s/wlp4s0:/$new_interface:/g" "$NETPLAN_CONFIG_FILE"

# Verificar si la edición fue exitosa hostapd
# Verificar si la edición fue exitosa en los archivos
if grep -q "^interface=$new_interface$" "$HP_CONFIG_FILE" && grep -q "^interface=$new_interface$" "$DNS_CONFIG_FILE" && grep -q "$new_interface:" "$NETPLAN_CONFIG_FILE"; then
    echo "Los archivos $HP_CONFIG_FILE, $DNS_CONFIG_FILE y $NETPLAN_CONFIG_FILE fueron editados correctamente con la nueva interfaz $new_interface."
    printf '\n'
    printf '\n'
    # Reiniciar los servicios hostapd y dnsmasq
    systemctl restart hostapd
    systemctl restart dnsmasq
    
    # Aplicar los cambios de netplan
    netplan apply
    
    echo "Los servicios hostapd y dnsmasq se reiniciaron correctamente, y los cambios de netplan se aplicaron."
else
    echo "Error: No se pudo editar los archivos de configuración."
    exit 1
fi