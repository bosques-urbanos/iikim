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
export MQTT_CLIENT_ID=object-size-detector-cpp

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
   sed -i "4s|.*|\"video\":\"${INPUT}\"|" /home/user/object-size-detector-cpp/resources/config.json
fi

cd /home/user/object-size-detector-cpp/build/
./monitor \
  --max=30000 \
  --min=20000 \
  $TARGET
