#!/bin/bash
# ==============================================================================
# Copyright (C) 2018-2019 Intel Corporation
#
# SPDX-License-Identifier: MIT
# ==============================================================================

set -x

BASEDIR=$(dirname "$0")/gst-video-analytics
if [ -n ${GST_SAMPLES_DIR} ]
then
    source $BASEDIR/scripts/setup_env.sh
fi
source $BASEDIR/scripts/setlocale.sh

#import GET_MODEL_PATH
source $BASEDIR/scripts/path_extractor.sh

unset GST_VAAPI_ALL_DRIVERS

if [ -z ${1} ]; then
  echo "ERROR set path to video"
  echo "Usage: ./face_detection_multichannel.sh <path/to/your/video/sample>"
  exit
fi

INPUT=${1}
CHANNELS_COUNT=${2:-2}
DEVICE=CPU
PRE_PROC=opencv

MODEL=face-detection-retail-0004

DETECT_MODEL_PATH=$(GET_MODEL_PATH $MODEL )

if [[ $INPUT == "/dev/video"* ]]; then
  SOURCE_ELEMENT="v4l2src device=${INPUT}"
elif [[ $INPUT == "rtsp://"* ]]; then
  SOURCE_ELEMENT="urisourcebin uri=${INPUT}"
elif [[ $INPUT == "http://"* ]]; then
  SOURCE_ELEMENT="souphttpsrc location=${INPUT}"
else
  SOURCE_ELEMENT="filesrc location=${INPUT}"
fi

#PIPELINE_STR=" videotestsrc is-live=true ! decodebin ! video/x-raw ! videoconvert ! \
PIPELINE_STR=" ${SOURCE_ELEMENT} ! decodebin ! video/x-raw ! videoconvert ! \
             gvadetect inference-id=inf0 model=$DETECT_MODEL_PATH device=$DEVICE pre-proc=$PRE_PROC batch-size=1 nireq=5 ! queue ! \
             gvawatermark ! \
             videoconvert ! autovideosink sync=false"
             #videoconvert ! x264enc noise-reduction=10000 tune=zerolatency byte-stream=true threads=4 key-int-max=15 intra-refresh=true ! mpegtsmux ! tcpserversink port=5001 host=172.17.0.1 recover-policy=keyframe sync-method=latest-keyframe"

             # Working but medium quality
             # videoconvert ! x264enc noise-reduction=10000 speed-preset=fast tune=zerolatency byte-stream=true threads=4 key-int-max=15 intra-refresh=true  ! rtph264pay pt=96 ! udpsink host=172.17.0.1 port=5001"
             # gst-launch-1.0 -ve udpsrc port=5001 ! application/x-rtp, media=video, clock-rate=90000, encoding-name=H264, payload=96 ! rtph264depay ! h264parse ! avdec_h264 ! videoconvert ! ximagesink sync=false

             # Not Working
             # videoconvert ! x264enc noise-reduction=10000 tune=zerolatency byte-stream=true threads=4 key-int-max=15 intra-refresh=true ! mpegtsmux ! udpsink host=172.17.0.1 port=5001"
             # gst-launch-1.0 -ve udpsrc port=5001 ! tsparse ! tsdemux ! h264parse ! avdec_h264 ! videoconvert ! ximagesink sync=false

             # Working but medium quality
             # videoconvert ! avenc_mpeg4 ! rtpmp4vpay config-interval=3 ! udpsink host=127.0.0.1 port=5001"
             # gst-launch-1.0 udpsrc port=5001 ! "application/x-rtp, clock-rate=90000,payload=96" ! rtpmp4vdepay ! mpeg4videoparse ! avdec_mpeg4 ! fpsdisplaysink sync=false

             # videoconvert ! tcpserversink port=5001 host=0.0.0.0 recover-policy=keyframe sync-method=latest-keyframe"
             # videoconvert ! autovideosink sync=false"
             # videoconvert ! fpsdisplaysink video-sink=ximagesink sync=false"
             # videoconvert ! fpsdisplaysink video-sink=fakesink sync=false async-handling=true"

FINAL_PIPELINE_STR=""

for (( CURRENT_CHANNELS_COUNT=0; CURRENT_CHANNELS_COUNT < $CHANNELS_COUNT; ++CURRENT_CHANNELS_COUNT ))
do
  FINAL_PIPELINE_STR+=$PIPELINE_STR
done

gst-launch-1.0 --gst-plugin-path ${GST_PLUGIN_PATH} ${FINAL_PIPELINE_STR}
#gst-launch-1.0 -v videotestsrc is-live=true ! video/x-raw,width=640,width=480,framerate=30/1 ! queue ! videoconvert ! x264enc ! h264parse ! queue ! matroskamux ! queue leaky=2 ! tcpserversink port=5001 host=0.0.0.0 recover-policy=keyframe sync-method=latest-keyframe
