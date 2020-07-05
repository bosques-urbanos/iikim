#!/bin/bash

# =============================================================================
# Variables
# =============================================================================

OPENVINO_INSTALLATION=/opt/intel/openvino/
MODEL="yolov3"
MODEL_PATH="/home/user/"

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
        -p $MODEL_PATH/$MODEL.weights \
        -m $MODEL_PATH/$MODEL.cfg \
        -i ${INPUT} \
        -th $THRESHOLD \
        -l $LABEL
