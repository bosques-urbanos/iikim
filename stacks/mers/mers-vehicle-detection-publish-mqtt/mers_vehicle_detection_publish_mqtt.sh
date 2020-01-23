#!/bin/bash
# ==============================================================================
# Copyright (C) 2018-2019 Intel Corporation
#
# SPDX-License-Identifier: MIT
# ==============================================================================

set -x

BASEDIR=$(dirname "$0")
if [ -n ${GST_SAMPLES_DIR} ]
then
    source $BASEDIR/common/setup_env.sh
fi
source $BASEDIR/common/setlocale.sh

#import GET_MODEL_PATH
source $BASEDIR/common/path_extractor.sh

if [ -z ${1} ]; then
  echo "ERROR set path to video"
  echo "Usage: ./vehicle_detection_publish_mqtt.sh <your/input>"
  exit
fi

INPUT=${1}

if [[ $INPUT == "/dev/video"* ]]; then
  SOURCE_ELEMENT="v4l2src device=${INPUT}"
elif [[ $INPUT == "rtsp://"* ]]; then
  SOURCE_ELEMENT="urisourcebin uri=${INPUT}"
elif [[ $INPUT == "http://"* ]]; then
  SOURCE_ELEMENT="souphttpsrc location=${INPUT}"
else
  SOURCE_ELEMENT="filesrc location=${INPUT}"
fi

echo Running sample with the following parameters:
echo GST_PLUGIN_PATH=${GST_PLUGIN_PATH}
echo LD_LIBRARY_PATH=${LD_LIBRARY_PATH}

MODEL=vehicle-license-plate-detection-barrier-0106

DEVICE=CPU
PRE_PROC=opencv

DETECT_MODEL_PATH=$(GET_MODEL_PATH $MODEL )

# Note that two pipelines create instances of singleton element 'inf0', so we can specify parameters only in first instance
gst-launch-1.0 --gst-plugin-path ${GST_PLUGIN_PATH} \
                ${SOURCE_ELEMENT} ! decodebin ! video/x-raw ! videoconvert ! \
                gvadetect inference-id=inf0 model=$DETECT_MODEL_PATH device=$DEVICE pre-proc=$PRE_PROC every-nth-frame=1 batch-size=1 ! queue ! \
                gvawatermark ! videoconvert ! fakesink \
                ${SOURCE_ELEMENT} ! decodebin ! video/x-raw ! videoconvert ! gvadetect inference-id=inf0 ! \
                gvametaconvert converter=json method=all ! \
                gvametapublish method=mqtt address=172.17.0.1:1883 clientid=clientIdValue topic="MQTTExamples" timeout=1000 ! \
                queue ! gvawatermark ! videoconvert ! autovideosink sync=false
