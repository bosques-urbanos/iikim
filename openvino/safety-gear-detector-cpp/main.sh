#!/bin/bash

set -x

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
export MQTT_CLIENT_ID=safety-gear-detector-cpp

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
   sed -i "5s|.*|\"video\":\"${INPUT}\"|" /home/user/safety-gear-detector-cpp/resources/config.json
fi

cd /home/user/safety-gear-detector-cpp/build/
./safety-gear-detector \
  -m=/opt/intel/openvino/deployment_tools/open_model_zoo/tools/downloader/intel/person-detection-retail-0013/${FP}/person-detection-retail-0013.xml \
  -mh=/home/user/safety-gear-detector-cpp/resources/worker-safety-mobilenet/${FP}/worker_safety_mobilenet.xml \
  $TARGET
