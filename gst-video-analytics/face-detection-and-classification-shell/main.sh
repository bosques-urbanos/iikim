#!/bin/bash

set -x

# =============================================================================
# Variables
# =============================================================================

export MODELS_PATH=/home/mers-user/intel

# =============================================================================
# Functions
# =============================================================================

# None

# =============================================================================
# Main
# =============================================================================

cd $HOME
echo $MODELS_PATH
ls $MODELS_PATH
ls /home/mers-user/intel/face-detection-adas-0001/FP32/

ls /home/mers-user/gst-video-analytics/samples/shell/
/home/mers-user/gst-video-analytics/samples/shell/face_detection_and_classification.sh $INPUT
