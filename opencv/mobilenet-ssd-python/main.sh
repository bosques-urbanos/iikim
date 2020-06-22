#!/bin/bash

# =============================================================================
# Variables
# =============================================================================

OPENVINO_INSTALLATION=/opt/intel/openvino/
MODEL="mobilenet-ssd"
MODEL_PATH="/home/user/public/mobilenet-ssd/"

# =============================================================================
# Functions
# =============================================================================

# None

# =============================================================================
# Main
# =============================================================================

cd $HOME

source $OPENVINO_INSTALLATION/bin/setupvars.sh

echo "Host         : " $HOSTNAME
echo "Input        : " $INPUT
echo "Model        : " $MODEL
echo "Model Path   : " $MODEL_PATH
echo "Threshold    : " $THRESHOLD
echo "Label        : " $LABEL
echo "MQTT Server  : " $MQTT_SERVER
echo "Statsd Server: " $STATSD_SERVER

python3 main.py \
        -p $MODEL_PATH/$MODEL.prototxt \
        -m $MODEL_PATH/$MODEL.caffemodel \
        -i ${INPUT} \
        -th $THRESHOLD \
        -l $LABEL
