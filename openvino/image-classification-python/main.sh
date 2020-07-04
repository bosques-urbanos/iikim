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
export MQTT_CLIENT_ID=image-classification-python

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

case $MODEL in

    ResNet50)
         MODEL_PATH=/home/user/resnet-50.xml
         MODEL_LABELS=/home/user/synset_words.txt
         ;;
    SqueezeNetV1.1)
         MODEL_PATH=/home/user/squeezenet1.1.xml
         MODEL_LABELS=/home/user/synset_words.txt
         ;;
    GoogleNetV3)
         MODEL_PATH=/home/user/inception_v3_2016_08_28_frozen.xml
         MODEL_LABELS=/home/user/public/googlenet-v3/imagenet_slim_labels.txt
         ;;
esac

echo "Host         : " $HOSTNAME
echo "Input        : " $INPUT
echo "Target       : " $TARGET
echo "Model        : " $MODEL
echo "Statsd Server: " $STATSD_SERVER

cd /home/user/
python3 main.py \
  -m $MODEL_PATH \
  $TARGET \
  -i $INPUT \
