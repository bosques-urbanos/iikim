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

export MQTT_SERVER=$MQTT_SERVER:1883
export MQTT_CLIENT_ID=parking-lot-counter-cpp

case $TARGET in

     CPU)
         TARGET='-b=2 -t=0'
         FP='FP32'
         ;;

     GPU)
         TARGET='-b=2 -t=1'
         FP='FP16'
         ;;

     MYRIAD)
         TARGET='-b=2 -t=3'
         FP='FP16'
         ;;

esac

if [[ $INPUT ]]; then
   sed -i "4s|.*|\"video\":\"${INPUT}\"|" /home/user/parking-lot-counter-cpp/resources/config.json
fi

echo "Host         : " $HOSTNAME
echo "Input        : " $INPUT
echo "Target       : " $TARGET
echo "MQTT Server  : " $MQTT_SERVER
echo "Statsd Server: " $STATSD_SERVER
echo "Entrance     : " $ENTRANCE

ENTRANCE="$(echo $ENTRANCE | head -c 1)"

cd /home/user/parking-lot-counter-cpp/build/
./monitor \
  -m=/home/user/intel/pedestrian-and-vehicle-detector-adas-0001/${FP}/pedestrian-and-vehicle-detector-adas-0001.bin \
  -c=/home/user/intel/pedestrian-and-vehicle-detector-adas-0001/${FP}/pedestrian-and-vehicle-detector-adas-0001.xml \
  -entrance="$ENTRANCE" \
  $TARGET
