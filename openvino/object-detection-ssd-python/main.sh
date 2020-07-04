#!/usr/bin/env bash

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
export MQTT_CLIENT_ID=object-detection-ssd-python

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

echo "Host         : " $HOSTNAME
echo "Input        : " $INPUT
echo "Target       : " $TARGET
echo "Statsd Server: " $STATSD_SERVER

cd /home/user/open_model_zoo/demos/python_demos/object_detection_demo_ssd_async
python3 object_detection_demo_ssd_async.py \
  -m /home/user/mobilenet-ssd.xml \
  -i $INPUT
