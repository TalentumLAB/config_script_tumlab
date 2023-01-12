#!/bin/bash

path_xml="$HOME/.config/syncthing/config.xml"
# path_xml=./config.xml
wget https://github.com/syncthing/syncthing/releases/download/v1.22.2/syncthing-linux-amd64-v1.22.2.tar.gz
tar -xf syncthing-linux-amd64-v1.22.2.tar.gz

example_service_file="./syncthing.service.example"
cat $example_service_file > /lib/systemd/system/syncthing.service

sudo systemctl enable syncthing

sudo systemctl stop syncthing 

xmlstarlet edit --update '/configuration/gui/address' --value '0.0.0.0:8384' "$path_xml" > temp.xml && rm "$path_xml" && cat temp.xml > "$path_xml" && rm temp.xml
(xmlstarlet ed --subnode "/configuration" --type elem -n newsubnode "$path_xml" | xmlstarlet ed --insert //newsubnode --type attr -n id -v VX33MI7-T3QVBVA-HG5ZNMY-R2WZLGB-57CKCL2-PKA3QXB-ODMGGJ4-57UYUA4 | xmlstarlet ed --insert //newsubnode --type attr -n name -v tumlab-cloud | xmlstarlet ed --insert //newsubnode --type attr -n compression -v metadata | xmlstarlet ed --insert //newsubnode --type attr -n introducer -v false | xmlstarlet ed --insert //newsubnode --type attr -n skipIntroductionRemovals -v false | xmlstarlet ed --insert //newsubnode --type attr -n introducedBy -v '' | xmlstarlet ed --subnode "/configuration/newsubnode[@introducedBy='']" --type elem -n address -v "dynamic" | xmlstarlet ed --subnode "/configuration/newsubnode[@introducedBy='']" --type elem -n paused -v "false" | xmlstarlet ed --subnode "/configuration/newsubnode[@introducedBy='']" --type elem -n autoAcceptFolders -v "false" | xmlstarlet ed --subnode "/configuration/newsubnode[@introducedBy='']" --type elem -n maxSendKbps -v "0" | xmlstarlet ed --subnode "/configuration/newsubnode[@introducedBy='']" --type elem -n maxRecvKbps -v "0" | xmlstarlet ed --subnode "/configuration/newsubnode[@introducedBy='']" --type elem -n maxRequestKiB -v "0" | xmlstarlet ed --subnode "/configuration/newsubnode[@introducedBy='']" --type elem -n untrusted -v "false" | xmlstarlet ed -O --subnode "/configuration/newsubnode[@introducedBy='']" --type elem -n remoteGUIPort -v "0" | sed -r 's/newsubnode/device/g') > temp.xml && rm "$path_xml" && cat temp.xml > "$path_xml" && rm temp.xml
cat "$path_xml"

sudo systemctl start syncthing 