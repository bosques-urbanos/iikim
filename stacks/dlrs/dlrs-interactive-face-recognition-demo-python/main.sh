#!/bin/bash

# =============================================================================
# Variables
# =============================================================================

export MQTT_SERVER=172.17.0.1:1883
export MQTT_CLIENT_ID=dlrs-face-recognition-demo-python

export MODEL_FACE_DETECTION=/Retail/object_detection/face/sqnet1.0modif-ssd/0004/dldt/
export MODEL_FACIAL_LANDMARKS_REGRESSION=/Retail/object_attributes/landmarks_regression/0009/dldt/
export MODEL_FACE_REIDENTIFICATION=/Retail/object_reidentification/face/mobilenet_based/dldt/

export FACES=/workspace/media/faces/

# =============================================================================
# Functions
# =============================================================================

# None

# =============================================================================
# Main
# =============================================================================

source /.bashrc 

case $TARGET in

     CPU)
         TARGET='-d_fd CPU -d_lm CPU -d_reid CPU'
         FP='FP32'
         EXTENSION='-l /usr/local/lib/inference-engine/libcpu_extension.so'
         ;;

esac

if [[ $INPUT ]]; then
   INPUT="$INPUT"
else
   INPUT=/workspace/video.mp4
fi

cd /workspace/open_model_zoo/demos/python_demos/face_recognition_demo/

python3 ./face_recognition_demo.py \
  -m_fd $MODEL_FACE_DETECTION/face-detection-retail-0004.xml \
  -m_lm $MODEL_FACIAL_LANDMARKS_REGRESSION/landmarks-regression-retail-0009.xml \
  -m_reid $MODEL_FACE_REIDENTIFICATION/face-reidentification-retail-0095.xml \
  $EXTENSION \
  -fg $FACES \
  -i $INPUT
