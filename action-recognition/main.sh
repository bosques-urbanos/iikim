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
        --encoder /home/user/intel/driver-action-recognition-adas-0002-encoder/FP32/driver-action-recognition-adas-0002-encoder.xml \
        --decoder /home/user/intel/driver-action-recognition-adas-0002-decoder/FP32/driver-action-recognition-adas-0002-decoder.xml \
        --cpu_extension /opt/intel/openvino/inference_engine/lib/intel64/libcpu_extension_sse4.so \
        --video ${INPUT} \
        --fps 30 \
        --labels /home/user/driver_actions.txt \
        --device ${DEVICE} \
        --identification ${ID} \
        --sink_fps 30 \
        --sink_fourcc MJPG \
        --sink_ip ${SINK_HOST_IP} \
        --sink_port ${SINK_HOST_PORT}
