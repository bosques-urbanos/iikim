#!/bin/bash

# =============================================================================
# Variables
# =============================================================================

export MQTT_CLIENT_ID=restricted-zone-notifier-python

export MODEL=/Retail/object_detection/pedestrian/rmnet_ssd/0013/dldt

# =============================================================================
# Functions
# =============================================================================

# None

# =============================================================================
# Main
# =============================================================================

case $TARGET in

     CPU)
         TARGET='-d=CPU'
         FP='FP32'
         EXTENSION='-l /usr/local/lib/inference-engine/libcpu_extension.so'
         ;;

esac

if [[ $INPUT ]]; then
   sed -i "6s|.*|\"video\":\"${INPUT}\"|" /workspace/restricted-zone-notifier-python/resources/config.json
fi

echo "Host         : " $HOSTNAME
echo "Input        : " $INPUT
echo "Target       : " $TARGET
echo "MQTT Server  : " $MQTT_SERVER
echo "Statsd Server: " $STATSD_SERVER

cd /workspace/restricted-zone-notifier-python/application/
python3 restricted_zone_notifier.py \
  -m $MODEL/person-detection-retail-0013.xml \
