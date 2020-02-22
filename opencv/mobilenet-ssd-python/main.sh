#!/bin/bash

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
        -p /home/user/public/mobilenet-ssd/mobilenet-ssd.prototxt \
        -m /home/user/public/mobilenet-ssd/mobilenet-ssd.caffemodel \
        -i ${INPUT} \
        -id ${ID}
