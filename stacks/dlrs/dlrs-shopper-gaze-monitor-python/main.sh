#!/bin/bash

# =============================================================================
# Variables
# =============================================================================

export MQTT_HOST=172.17.0.1
export MQTT_CLIENT_ID=restricted-zone-notifier-python

export MODEL_M=/Transportation/object_detection/face/pruned_mobilenet_reduced_ssd_shared_weights/dldt/
export MODEL_PM=/Transportation/object_attributes/headpose/vanilla_cnn/dldt/

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
   sed -i "6s|.*|\"video\":\"${INPUT}\"|" /workspace/shopper-gaze-monitor-python/resources/config.json
fi

echo "Host         : " $HOSTNAME
echo "Input        : " $INPUT
echo "Target       : " $TARGET
echo "Statsd Server: " $STATSD_SERVER

cd /workspace/shopper-gaze-monitor-python/application/
python3 shopper_gaze_monitor.py \
  -m $MODEL_M/face-detection-adas-0001.xml \
  -p $MODEL_PM/head-pose-estimation-adas-0001.xml
