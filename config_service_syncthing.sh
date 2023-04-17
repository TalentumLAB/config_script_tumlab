#!/bin/bash

path_xml="/home/nexum/.config/syncthing/config.xml"
name_label=$(hostname)

exist_xml_file=$(checkExitsFile $path_xml)

if [[ $exist_xml_file == 'true' ]]; then
    sudo rm -r /home/nexum/.config/syncthing
    sudo systemctl stop syncthing.service
    sudo rm /lib/systemd/system/syncthing.service
fi

checkExitsFile() {
    file="$1"
    retval=""
    if [[ -f "$file" ]]; then
        retval="true"
    else
        retval="false"
    fi
    echo $retval
}
exist_file=$(checkExitsFile syncthing-linux-amd64-v1.22.2/syncthing)
if [[ $exist_file == 'false' ]]; then
    wget https://github.com/syncthing/syncthing/releases/download/v1.22.2/syncthing-linux-amd64-v1.22.2.tar.gz
    tar -xf syncthing-linux-amd64-v1.22.2.tar.gz
    rm syncthing-linux-amd64-v1.22.2.tar.gz
fi

example_service_file="./syncthing.service.example"
cat $example_service_file > /lib/systemd/system/syncthing.service

sudo systemctl enable syncthing

sudo systemctl start syncthing 

sleep 3
id_tumlab=$(xmlstarlet sel -t -c "/configuration/folder/device[1]" "$path_xml" |grep id | awk -F '"' '{print $2}')

echo "Digite el numero del municipio. Balboa=1, Miranda=2, Cajibio=3, B/Aires=4, sipi=5, patia=6, p/leguizamo=7, valle=8 "
read -r id_municipio

case "${id_municipio}" in
1)
    id_server="77M2ZQO-B3BIAV5-DPDVVSL-5XWWWIC-IWZHVGW-N5RQ6XP-UJN445X-EZKSDAZ"
    ;;
2)
    id_server="6PEY5Y2-YMQWHI5-AMII2NP-DO6LFTU-77KAJVS-NKPE5CP-B52UCAM-ZXN2IAF"
    ;;
3)
    id_server="726VG2X-B7CECSS-JWHJITX-IQMO6FD-YFMW6VW-UNVLW4R-R5BVHMO-Q5R6UAT"
    ;;
4)
    id_server="B27ZIO6-42QREVU-TPDK756-6PETO76-TQHEF5G-JLQKX7B-DBJCVQI-WVDKYAN"
    ;;
5)
    id_server="YP3TXCL-5KECCHI-FUB2EAT-XFC7FRT-CDU32EU-O3JEDTR-RTJTSM7-XR33AA5"
    ;;
6)
    id_server="NYOMHPF-6O5LJZW-Q3KOL2A-QVAOGRS-XTXRZEG-CVQWYXJ-UZJ6KKY-NARXWA4"
    ;;
7)
    id_server="QCISH6N-KPI524N-SM7G43S-MJ4T7QK-BGGHYV4-PCLNL2N-HLAIBSV-ABFH5AL"
    ;;
8)
    id_server="PC4H5G3-GLV2AYL-FEOJ6YE-BLIR5SF-YKTWOWC-MZXQC3I-7BSJLFJ-NYLLMQC"
    ;;
*)
    echo "Valor ingresado incorrecto"
    rm /lib/systemd/system/syncthing.service
    exit 1
    ;;
esac

echo "$id_tumlab"
echo "$id_server"
(xmlstarlet ed --subnode "/configuration" --type elem -n newsubnode "$path_xml" | xmlstarlet ed --insert //newsubnode --type attr -n id -v "$id_tumlab" | xmlstarlet ed --insert //newsubnode --type attr -n label -v "$name_label" | xmlstarlet ed --insert //newsubnode --type attr -n path -v /tumlab/syncthing/ | xmlstarlet ed --insert //newsubnode --type attr -n type -v sendreceive | xmlstarlet ed --insert //newsubnode --type attr -n rescanIntervalS -v 3600 | xmlstarlet ed --insert //newsubnode --type attr -n fsWatcherEnabled -v true | xmlstarlet ed --insert //newsubnode --type attr -n fsWatcherDelayS -v 10 | xmlstarlet ed --insert //newsubnode --type attr -n ignorePerms -v false | xmlstarlet ed --insert //newsubnode --type attr -n autoNormalize -v true | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n filesystemType -v "basic" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n device -v "" | xmlstarlet ed --insert //newsubnode/device --type attr -n id -v JUPCPPO-ROYV4PB-PSSU7WS-5JSJ57H-GFTECV5-KG45DBU-HQDGY66-6UA5MAQ | xmlstarlet ed --insert //newsubnode/device --type attr -n introducedBy -v '' | xmlstarlet ed --subnode "/configuration/newsubnode/device[@introducedBy='']" --type elem -n encryptionPassword -v "" | xmlstarlet ed --subnode "/configuration/newsubnode[@ignorePerms='false']" --type elem -n devices -v "" | xmlstarlet ed --insert //newsubnode/devices --type attr -n id -v "$id_server" | xmlstarlet ed --insert //newsubnode/devices --type attr -n introducedBy -v '' | xmlstarlet ed --subnode "/configuration/newsubnode/devices[@introducedBy='']" --type elem -n encryptionPassword -v "" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n minDiskFree -v "1" | xmlstarlet ed --insert //newsubnode/minDiskFree --type attr -n unit -v '%' | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n versioning -v "" | xmlstarlet ed --subnode "/configuration/newsubnode/versioning" --type elem -n cleanupIntervalS -v "3600" | xmlstarlet ed --subnode "/configuration/newsubnode/versioning" --type elem -n fsPath -v "" | xmlstarlet ed --subnode "/configuration/newsubnode/versioning" --type elem -n fsType -v "basic" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n versioning -v "" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n copiers -v "0" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n pullerMaxPendingKiB -v "0" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n hashers -v "0" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n order -v "random" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n ignoreDelete -v "false" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n scanProgressIntervalS -v "0" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n pullerPauseS -v "0" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n maxConflicts -v "10" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n disableSparseFiles -v "false" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n disableTempIndexes -v "false" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n paused -v "false" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n weakHashThresholdPct -v "25" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n markerName -v ".stfolder" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n copyOwnershipFromParent -v "false" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n modTimeWindowS -v "0" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n maxConcurrentWrites -v "2" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n disableFsync -v "false" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n blockPullOrder -v "standard" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n copyRangeMethod -v "standard" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n caseSensitiveFS -v "false" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n junctionsAsDirs -v "false" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n syncOwnership -v "false" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n sendOwnership -v "false" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n syncXattrs -v "false" | xmlstarlet ed --subnode "/configuration/newsubnode[@autoNormalize='true']" --type elem -n xattrFilter -v "" | xmlstarlet ed --subnode "/configuration/newsubnode/xattrFilter" --type elem -n maxSingleEntrySize -v "1024" | xmlstarlet ed --subnode "/configuration/newsubnode/xattrFilter" --type elem -n maxTotalSize -v "4096" | sed -r 's/newsubnode/folder/g' | sed -r 's/devices/device/g') > temp.xml && rm "$path_xml" && cat temp.xml > "$path_xml" && rm temp.xml
xmlstarlet edit --update '/configuration/gui/address' --value '0.0.0.0:8384' "$path_xml" > temp.xml && rm "$path_xml" && cat temp.xml > "$path_xml" && rm temp.xml
(xmlstarlet ed --subnode "/configuration" --type elem -n newsubnode "$path_xml" | xmlstarlet ed --insert //newsubnode --type attr -n id -v "$id_server" | xmlstarlet ed --insert //newsubnode --type attr -n name -v tumlab-cloud | xmlstarlet ed --insert //newsubnode --type attr -n compression -v metadata | xmlstarlet ed --insert //newsubnode --type attr -n introducer -v false | xmlstarlet ed --insert //newsubnode --type attr -n skipIntroductionRemovals -v false | xmlstarlet ed --insert //newsubnode --type attr -n introducedBy -v '' | xmlstarlet ed --subnode "/configuration/newsubnode[@introducedBy='']" --type elem -n address -v "dynamic" | xmlstarlet ed --subnode "/configuration/newsubnode[@introducedBy='']" --type elem -n paused -v "false" | xmlstarlet ed --subnode "/configuration/newsubnode[@introducedBy='']" --type elem -n autoAcceptFolders -v "false" | xmlstarlet ed --subnode "/configuration/newsubnode[@introducedBy='']" --type elem -n maxSendKbps -v "0" | xmlstarlet ed --subnode "/configuration/newsubnode[@introducedBy='']" --type elem -n maxRecvKbps -v "0" | xmlstarlet ed --subnode "/configuration/newsubnode[@introducedBy='']" --type elem -n maxRequestKiB -v "0" | xmlstarlet ed --subnode "/configuration/newsubnode[@introducedBy='']" --type elem -n untrusted -v "false" | xmlstarlet ed -O --subnode "/configuration/newsubnode[@introducedBy='']" --type elem -n remoteGUIPort -v "0" | sed -r 's/newsubnode/device/g') > temp.xml && rm "$path_xml" && cat temp.xml > "$path_xml" && rm temp.xml
cat "$path_xml"

sudo systemctl restart syncthing 