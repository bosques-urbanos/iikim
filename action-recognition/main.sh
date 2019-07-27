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
        --encoder /home/user/Transportation/action_recognition/driver_monitoring/mobilenetv2/encoder/dldt/driver-action-recognition-adas-0002-encoder.xml \
        --decoder /home/user/Transportation/action_recognition/driver_monitoring/mobilenetv2/decoder/dldt/driver-action-recognition-adas-0002-decoder.xml \
        --cpu_extension /opt/intel/openvino/inference_engine/lib/intel64/libcpu_extension_sse4.so \
        --video ${VIDEO} \
        --fps 30 \
        --labels /home/user/driver_actions.txt \
        --device ${DEVICE} \
        --identification "${ID}" \
        --sink_fps 30 \
        --sink_fourcc MJPG \
        --sink_ip ${SINK_IP} \
        --sink_port ${SINK_PORT}
