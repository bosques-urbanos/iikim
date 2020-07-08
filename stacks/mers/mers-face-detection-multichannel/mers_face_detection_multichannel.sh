#!/bin/bash
# ==============================================================================
# Copyright (C) 2018-2020 Intel Corporation
#
# SPDX-License-Identifier: MIT
# ==============================================================================

set -e

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
  echo "ERROR input is not set"
  echo "Usage: ./face_detection_multichannel.sh <your input>"
  exit
fi

INPUT=${1}
CHANNELS_COUNT=${2:-1}
DEVICE=CPU
PRE_PROC=ie
#PRE_PROC=opencv

if [[ $INPUT == "/dev/video"* ]]; then
  SOURCE_ELEMENT="v4l2src device=${INPUT}"
elif [[ $INPUT == "rtsp://"* ]]; then
  SOURCE_ELEMENT="urisourcebin uri=${INPUT}"
elif [[ $INPUT == "http://"* ]]; then
  SOURCE_ELEMENT="souphttpsrc location=${INPUT}"
else
  SOURCE_ELEMENT="filesrc location=${INPUT}"
fi

MODEL=face-detection-retail-0004

DETECT_MODEL_PATH=$(GET_MODEL_PATH $MODEL )

PIPELINE_STR=" ${SOURCE_ELEMENT} ! \
             decodebin ! video/x-raw ! videoconvert ! \
             gvadetect inference-id=inf0 model=$DETECT_MODEL_PATH device=$DEVICE pre-proc=$PRE_PROC batch-size=1 nireq=5 ! queue ! \
             gvawatermark ! \
             videoconvert ! autovideosink sync=false"

FINAL_PIPELINE_STR=""

echo Running sample with the following parameters:
echo GST_PLUGIN_PATH=${GST_PLUGIN_PATH}
echo LD_LIBRARY_PATH=${LD_LIBRARY_PATH}

for (( CURRENT_CHANNELS_COUNT=0; CURRENT_CHANNELS_COUNT < $CHANNELS_COUNT; ++CURRENT_CHANNELS_COUNT ))
do
  FINAL_PIPELINE_STR+=$PIPELINE_STR
done

gst-launch-1.0 \
  --gst-plugin-path ${GST_PLUGIN_PATH} \
  ${FINAL_PIPELINE_STR}
