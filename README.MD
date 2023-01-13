# SCRIPTS CONFIG TUMLAB

## Contents
  * [Description](#Description)
    -   [config_tumlab_param.sh](#config_tumlab_param.sh)
    -   [config_service_suncthing.sh](#config_service_suncthing.sh)
  * [Prerequisites](#Prerequisites)
  * [How to use](#How-to-use)

## Description
This script was created to parameterize the TUMLAB information in a json file and to configure their name, which is used to identify each device. Additionally, it also downloads, parameterizes and runs the Syncthing software, which is used to synchronize the information of a tumlab folder
### config_tumlab_param.sh
-   This script parameterizes the tumlab data and configures its name to be able to be identified

### config_service_suncthing.sh
-   This sctipt downloads and installs syncthing as a linux service
## Prerequisites
-   xmlstarlet v1.6.1 or later
-   jq v1.6
-   internet connection
-   tar v1.30
-   wget 1.20.1

    ### Only ensures the script works on ubuntu 20.04 and some debian distributions
## How to use
-   Clone this repo in apps folder "/tumlab/apps":
```
cd /tumlab/apps/

git clone https://github.com/TalentumLAB/config_script_tumlab.git
```

- Open project folder:
```
cd config_script_tumlab
```
- Execute sctipts.
```
./config_tumlab_param.sh
```
When executing this script we must enter the parameters of the TUMLAB.
```
sudo ./config_service_syncthing.sh
```
