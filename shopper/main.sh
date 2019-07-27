#!/bin/bash

set -x

# =============================================================================
# Variables
# =============================================================================

OPENVINO_INSTALLATION=/opt/intel/openvino

# =============================================================================
# Functions
# =============================================================================

# None

# =============================================================================
# Main
# =============================================================================

cd $HOME

source $OPENVINO_INSTALLATION/bin/setupvars.sh

python3 main.py \
        -m /opt/intel/openvino/deployment_tools/tools/model_downloader/Transportation/object_detection/face/pruned_mobilenet_reduced_ssd_shared_weights/dldt/face-detection-adas-0001.xml \
        -pm /opt/intel/openvino/deployment_tools/tools/model_downloader/Transportation/object_attributes/headpose/vanilla_cnn/dldt/head-pose-estimation-adas-0001.xml \
        -i ${VIDEO_CAPTURE} \
        -l /opt/intel/openvino/inference_engine/lib/intel64/libcpu_extension_sse4.so \
        -d ${DEVICE} \
        -c ${CONFIDENCE} \
        -ci ${CAMERA_IDENTIFICATION} \
        -fr 30 \
        -fc MJPG \
        -hi ${SINK_HOST_IP} \
        -hp ${SINK_HOST_PORT} \
        -ri ${REPORTING_INTERVAL}
