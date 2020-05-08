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
         TARGET='-d_fd CPU -d_lm CPU -d_reid CPU'
         FP='FP32'
         ;;

     GPU)
         TARGET='-d_fd GPU -d_lm GPU -d_reid GPU'
         FP='FP16'
         ;;

     MYRIAD)
         TARGET='-d_fd MYRIAD -d_lm MYRIAD -d_reid MYRIAD'
         FP='FP16'
         ;;
esac

echo "Input        : " $INPUT
echo "Target       : " $TARGET
echo "Statsd Server: " $STATSD_SERVER

cd /home/user/open_model_zoo/demos/python_demos/face_recognition_demo

python3 ./face_recognition_demo.py \
  -m_fd /home/user/intel/face-detection-retail-0004/${FP}/face-detection-retail-0004.xml \
  -m_lm /home/user/intel/landmarks-regression-retail-0009/${FP}/landmarks-regression-retail-0009.xml \
  -m_reid /home/user/intel/face-reidentification-retail-0095/${FP}/face-reidentification-retail-0095.xml \
  -fg /tmp/demo/ \
  $TARGET \
  -i $INPUT
