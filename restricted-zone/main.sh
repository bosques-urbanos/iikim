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

python3 main.py \
        -m /opt/intel/openvino/deployment_tools/tools/model_downloader/Retail/object_detection/pedestrian/rmnet_ssd/0013/dldt/person-detection-retail-0013.xml \
        -i ${VIDEO_CAPTURE} \
        -l /opt/intel/openvino/inference_engine/lib/intel64/libcpu_extension_sse4.so \
        -d ${DEVICE} \
        -ci ${CAMERA_IDENTIFICATION} \
        -fr 30 \
        -fc XVID \
        -hi ${SINK_HOST_IP} \
        -hp ${SINK_HOST_PORT} \
        -ri ${REPORTING_INTERVAL}
