#!/bin/bash

# =============================================================================
# Variables
# =============================================================================

OPENVINO_INSTALLATION=/opt/intel/openvino/

# =============================================================================
# Functions
# =============================================================================

# None

# =============================================================================
# Main
# =============================================================================

cd $HOME

source $OPENVINO_INSTALLATION/bin/setupvars.sh

export MQTT_SERVER=172.17.0.1:1883
export MQTT_CLIENT_ID=restricted-zone-notifier-cpp

case $TARGET in

     CPU)
         TARGET='-d=CPU'
         FP='FP32'
         ;;

     GPU)
         TARGET='-d=GPU'
         FP='FP16'
         ;;

     MYRIAD)
         TARGET='-d=MYRIAD'
         FP='FP16'
         ;;
esac

if [[ $INPUT ]]; then
   sed -i "6s|.*|\"video\":\"${INPUT}\"|" /home/user/restricted-zone-notifier-python/resources/config.json
fi

cd /home/user/restricted-zone-notifier-python/application/
python3 restricted_zone_notifier.py \
  -m=/opt/intel/openvino/deployment_tools/open_model_zoo/tools/downloader/intel/person-detection-retail-0013/${FP}/person-detection-retail-0013.xml \
  $TARGET
#  -m=/opt/intel/openvino/deployment_tools/open_model_zoo/tools/downloader/intel/pedestrian-detection-adas-0002/${FP}/pedestrian-detection-adas-0002.bin \
#  -c=/opt/intel/openvino/deployment_tools/open_model_zoo/tools/downloader/intel/pedestrian-detection-adas-0002/${FP}/pedestrian-detection-adas-0002.xml \
#  $TARGET
