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
export MQTT_CLIENT_ID=shopper-mood-monitor-cpp

case $TARGET in

     CPU)
         TARGET='-b=2 -t=1'
         FP='FP32'
         ;;

     GPU)
         TARGET='-b=2 -t=2'
         FP='FP16'
         ;;

     VPU)
         TARGET='-b=2 -t=3'
         FP='FP16'
         ;;

esac

INPUT="-i=./face-demographics-walking-and-pause.mp4"

cd /home/user/shopper-mood-monitor-cpp/build/
./monitor \
  -m=/home/user/intel/face-detection-adas-0001/${FP}/face-detection-adas-0001.bin \
  -c=/home/user/intel/face-detection-adas-0001/${FP}/face-detection-adas-0001.xml \
  -sm=/home/user/intel/emotions-recognition-retail-0003/${FP}/emotions-recognition-retail-0003.bin \
  -sc=/home/user/intel/emotions-recognition-retail-0003/${FP}/emotions-recognition-retail-0003.xml \
  $INPUT
