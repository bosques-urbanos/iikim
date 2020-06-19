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

export MQTT_HOST=172.17.0.1
export MQTT_CLIENT_ID=shopper-gaze-monitor-python

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
   sed -i "6s|.*|\"video\":\"${INPUT}\"|" /home/user/shopper-gaze-monitor-python/resources/config.json
fi

cd /home/user/shopper-gaze-monitor-python/application/
python3 shopper_gaze_monitor.py \
  -m=/opt/intel/openvino/deployment_tools/open_model_zoo/tools/downloader/intel/face-detection-adas-0001/${FP}/face-detection-adas-0001.xml \
  -pm=/opt/intel/openvino/deployment_tools/open_model_zoo/tools/downloader/intel/head-pose-estimation-adas-0001/${FP}/head-pose-estimation-adas-0001.xml \
  $TARGET
