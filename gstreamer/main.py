#!/usr/bin/env python3

import cv2
import gc
import os
import sys
import time

from argparse import ArgumentParser

parser = ArgumentParser()
parser.add_argument("-i", "--input",
                    help="Path to video file or image. Use 'cam' for "
                         "capturing video stream from camera",
                    required=True, type=str)
parser.add_argument('-ci', '--cameraidentification', default="camera-01", type=str,
                    help="Camera Identification")
parser.add_argument('-fr', '--framerate', default="30", type=int,
                    help="Framerate")
parser.add_argument('-fc', '--fourcc', default="MJPG", type=str,
                    help="FOURCC")
parser.add_argument('-hi', '--hostip', default="172.17.0.1", type=str,
                    help="Sink Host IP")
parser.add_argument('-hp', '--hostport', default=5000, type=int,
                    help="Sink Host Port")

args = parser.parse_args()

#os.environ["OPENCV_FFMPEG_CAPTURE_OPTIONS"] = "-hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -hwaccel_output_format vaapi"

cap = cv2.VideoCapture(args.input, cv2.CAP_FFMPEG)
#cap = cv2.VideoCapture(args.input)
fps = int(cap.get(cv2.CAP_PROP_FPS))
frame_width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
frame_height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
buffer = int(cap.get(cv2.CAP_PROP_BUFFERSIZE))

#gst_str_rtp = "appsrc ! videoconvert ! videoscale ! videorate ! video/x-raw,width=960,height=480,framerate=30/1 ! matroskamux streamable=true ! tcpserversink host=" + args.hostip + " port=" + str(args.hostport) + " sync=false sync-method=2"
#output_fourcc = cv2.VideoWriter_fourcc(*args.fourcc)
#out = cv2.VideoWriter(gst_str_rtp, output_fourcc, fps, (frame_width, frame_height))

while(True):

    stime = time.time()
    ret, frame = cap.read()
    #banner = 'FPS {:.1f}'.format(1 / (time.time() - stime))
    #cv2.putText(frame, banner, (10,30), cv2.FONT_HERSHEY_SIMPLEX, 1, (255,177,1), 3)
    cv2.imshow("Epsilon", frame)
    #out.write(frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

#out.release()
cap.release()
