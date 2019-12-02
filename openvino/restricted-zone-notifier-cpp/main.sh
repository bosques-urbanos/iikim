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
         TARGET='-b=2 -t=0'
         FP='FP32'
         ;;

     GPU)
         TARGET='-b=2 -t=1'
         FP='FP16'
         ;;

     MYRIAD)
         TARGET='-b=2 -t=3'
         FP='FP16'
         ;;
esac

if [[ $INPUT ]]; then
   sed -i "4s|.*|\"video\":\"${INPUT}\"|" /home/user/restricted-zone-notifier-cpp/resources/config.json
fi

cd /home/user/restricted-zone-notifier-cpp/build/
./monitor \
  -m=/opt/intel/openvino/deployment_tools/open_model_zoo/tools/downloader/intel/pedestrian-detection-adas-0002/${FP}/pedestrian-detection-adas-0002.bin \
  -c=/opt/intel/openvino/deployment_tools/open_model_zoo/tools/downloader/intel/pedestrian-detection-adas-0002/${FP}/pedestrian-detection-adas-0002.xml \
  $TARGET
