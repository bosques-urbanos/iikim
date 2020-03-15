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
         TARGET='-d CPU'
         FP='FP32'
         ;;

     GPU)
         TARGET='-d GPU'
         FP='FP16'
         ;;

     MYRIAD)
         TARGET='-d MYRIAD'
         FP='FP16'
         ;;
esac

if [[ $INPUT ]]; then
   INPUT="$INPUT"
else
   INPUT=/home/user/video.mp4
fi

cd /opt/intel/openvino/deployment_tools/open_model_zoo/demos/python_demos/multi_camera_multi_person_tracking/
python3 multi_camera_multi_person_tracking.py \
  -m ~/intel/person-detection-retail-0013/FP32/person-detection-retail-0013.xml \
  --m_reid ~/intel/person-reidentification-retail-0031/FP32/person-reidentification-retail-0031.xml \
  --config config.py \
  $TARGET \
  -i $INPUT
