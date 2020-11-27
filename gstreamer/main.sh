#!/bin/bash

set -x

# =============================================================================
# Variables
# =============================================================================

export OPENVINO_INSTALLATION=/opt/intel/openvino/
#export OPENCV_FFMPEG_CAPTURE_OPTIONS = "-hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -hwaccel_output_format vaapi"
export OPENCV_FFMPEG_CAPTURE_OPTIONS = "rtsp_transport;udp"

# =============================================================================
# Functions
# =============================================================================

# None

# =============================================================================
# Main
# =============================================================================

cd $HOME

source $OPENVINO_INSTALLATION/bin/setupvars.sh

ip a

python3 main.py \
        -i ${VIDEO_CAPTURE} \
        -ci ${CAMERA_IDENTIFICATION} \
        -fr 30 \
        -fc MJPG \
        -hi ${SINK_HOST_IP} \
        -hp ${SINK_HOST_PORT}
