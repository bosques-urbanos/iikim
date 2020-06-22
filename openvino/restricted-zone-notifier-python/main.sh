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

export MQTT_CLIENT_ID=restricted-zone-notifier-python

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
   sed -i "6s|.*|\"video\":\"${INPUT}\"|" /home/user/restricted-zone-notifier-python/resources/config.json
fi

case $MODEL in

      person-detection-retail-0013)
          MODEL_ROOT_PATH=/opt/intel/openvino/deployment_tools/open_model_zoo/tools/downloader/intel
          MODEL_PATH=$MODEL_ROOT_PATH/$MODEL/${FP}/$MODEL.xml
          ;;

      pedestrian-detection-adas-0002)
          MODEL_ROOT_PATH=/home/user/intel
          MODEL_PATH=$MODEL_ROOT_PATH/$MODEL/${FP}/$MODEL.xml
          ;;

      pedestrian-detection-adas-binary-0001)
          MODEL_ROOT_PATH=/home/user/intel
          MODEL_PATH=$MODEL_ROOT_PATH/$MODEL/FP32-INT1/$MODEL.xml
          ;;

esac

echo "Host         : " $HOSTNAME
echo "Input        : " $INPUT
echo "Target       : " $TARGET
echo "Model        : " $MODEL
echo "Model Path   : " $MODEL_PATH
echo "Threshold    : " $THRESHOLD
echo "MQTT Server  : " $MQTT_SERVER
echo "Statsd Server: " $STATSD_SERVER

cd /home/user/restricted-zone-notifier-python/application/
python3 restricted_zone_notifier.py \
  -m=$MODEL_PATH \
  $TARGET \
  -th $THRESHOLD
