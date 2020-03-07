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

source /.bashrc 

export MQTT_SERVER=172.17.0.1:1883
export MQTT_CLIENT_ID=restricted-zone-notifier-python
export MODEL=/Retail/object_detection/pedestrian/rmnet_ssd/0013/dldt

case $TARGET in

     CPU)
         TARGET='-d=CPU'
         FP='FP32'
	 EXTENSION=/usr/local/lib/inference-engine/libcpu_extension.so
         ;;

esac

if [[ $INPUT ]]; then
   sed -i "6s|.*|\"video\":\"${INPUT}\"|" /workspace/restricted-zone-notifier-python/resources/config.json
fi

cat /workspace/restricted-zone-notifier-python/resources/config.json

cd /workspace/restricted-zone-notifier-python/application/
python3 restricted_zone_notifier.py \
  -m $MODEL/person-detection-retail-0013.xml \
  -l $EXTENSION
