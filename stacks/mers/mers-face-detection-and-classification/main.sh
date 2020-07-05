#!/bin/bash

set -x

# =============================================================================
# Variables
# =============================================================================

export GVA_PATH=/home/mers-user/gst-video-analytics
export MODELS_PATH=/home/mers-user/models

# =============================================================================
# Functions
# =============================================================================

# None

# =============================================================================
# Main
# =============================================================================

echo "Host         : " $HOSTNAME
echo "Input        : " $INPUT

cd $HOME
#ls /home/mers-user/common/../gst-video-analytics//samples/model_proc/
ls /home/mers-user/models/Retail/object_attributes/age_gender/dldt/
#ls /opt/intel/openvino/deployment_tools/intel_models
/home/mers-user/mers_face_detection_and_classification.sh $INPUT
