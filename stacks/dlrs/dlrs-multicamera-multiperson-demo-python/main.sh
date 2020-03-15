#!/bin/bash

# =============================================================================
# Variables
# =============================================================================

export MQTT_SERVER=172.17.0.1:1883
export MQTT_CLIENT_ID=dlrs-multicamera-multiperson-demo-python

export MODEL_PERSON_DETECTION=/Retail/object_detection/pedestrian/rmnet_ssd/0013/dldt/
export MODEL_PERSON_REIDENTIFICATION=/Retail/object_reidentification/pedestrian/rmnet_based/0031/dldt/

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
         TARGET='-d=CPU'
         FP='FP32'
	 EXTENSION='-l /usr/local/lib/inference-engine/libcpu_extension.so'
         ;;

esac

cd /workspace/open_model_zoo/demos/python_demos/multi_camera_multi_person_tracking/

python3 multi_camera_multi_person_tracking.py \
  -m $MODEL_PERSON_DETECTION/person-detection-retail-0013.xml \
  --m_reid $MODEL_PERSON_REIDENTIFICATION/person-reidentification-retail-0031.xml \
  $EXTENSION \
  --config config.py \
  -i $INPUT
