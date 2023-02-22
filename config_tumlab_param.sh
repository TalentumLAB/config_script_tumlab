#!/bin/bash 

echo "------------Parametrizacion de informacion del tumlab------------ "

path_json="/tumlab/syncthing/agent.config"
echo "$path_json"
path_config_promtail="/tumlab/apps/promtail/config-promtail.yml"

# ramdom_licence_number=$(echo $RANDOM | md5sum | head -c 8)
# echo "ramdom_licece_number= $ramdom_licence_number"

check_number(){
    value="$1"
    retval=""
    if [[ $value -lt 0 ]]; then
        retval="false"
    else
        retval="true"
    fi
    echo "$retval"
}

add_parameters(){
    parameter_name="$1"
    parameter="$2"
    array_position="$3"
    jq '.tumlab.information['"$array_position"'].'"$parameter_name"''' ='"$parameter"'' $path_json > tmp.json && rm $path_json && jq '.' tmp.json > $path_json && rm tmp.json
    
}

echo "Digite el numero de lote: "
read -r id_batch
if_value_is_avaiable=$(check_number "$id_batch")
if [[ $if_value_is_avaiable == 'true' ]]; then
    add_parameters id_batch "$id_batch" 0
else
    echo "wrong entered value: $id_batch "  
fi

echo "Digite el numero del projecto: "
read -r id_project
if_value_is_avaiable=$(check_number "$id_project")
if [[ $if_value_is_avaiable == 'true' ]]; then
    add_parameters id_project "$id_project" 1
else
    echo "wrong entered value: $id_project"
fi

echo "Digite el numero del departamento: "
read -r id_deparment
if_value_is_avaiable=$(check_number "$id_deparment")
if [[ $if_value_is_avaiable == 'true' ]]; then
    add_parameters id_deparment "$id_deparment" 2
else
    echo "wrong entered value: $id_deparment"
fi

echo "Digite el numero de la ciudad: "
read -r id_town
if_value_is_avaiable=$(check_number "$id_town")
if [[ $if_value_is_avaiable == 'true' ]]; then
    add_parameters id_town "$id_town" 3
else
    echo "wrong entered value: $id_town"
fi

echo "Digite el numero de la institucion: "
read -r id_institution
if_value_is_avaiable=$(check_number "$id_institution")
if [[ $if_value_is_avaiable == 'true' ]]; then
    add_parameters id_institution "$id_institution" 4
else
    echo "wrong entered value: $id_institution"
fi

echo "Digite el numero de la sucursal: "
read -r id_branch
if_value_is_avaiable=$(check_number "$id_branch")
if [[ $if_value_is_avaiable == 'true' ]]; then
    add_parameters id_branch "$id_branch" 5
else
    echo "wrong entered value: $id_branch"
fi

interface="$(ls /sys/class/net/ | grep wl)"
mac_address="$(cat /sys/class/net/"$interface"/address)"
name="$(echo "$mac_address" | tr -d ':')"
add_parameters mac_address "\"$name\"" 6

# licence_number="bt""$id_batch""p""$id_project""d""$id_deparment""t""$id_town""i""$id_institution""b""$id_branch""-""$name""-""$ramdom_licence_number"""
# echo "licence_number= $licence_number"
# jq '.tumlab.'"information"' += [{"license":"'"$licence_number"'"}]' $path_json > tmp.json && rm $path_json && jq '.' tmp.json > $path_json && rm tmp.json

echo "Digite el numero de la licencia del Tumlab: "
read -r license_sync
add_parameters license_sync "$license_sync" 7

echo "Digite el numero de la licencia del LMS: "
read -r license_perpetual_lms
add_parameters license_perpetual_lms "$license_perpetual_lms" 8

cat "$path_json"
echo "------------Fin de parametrizacion de informacion del tumlab------------ "echo ""
echo ""
echo "------------Parametrizacion de nombre tumlab------------ "
echo "Tumlab name: $name"
hostnamectl set-hostname "$name"
old_line="$(sed '16q;d' $path_config_promtail)"
sed -i.bak "16 s/$old_line/          mac_address: $name/" $path_config_promtail
echo "------------Fin de parametrizacion de nombre tumlab------------ "
