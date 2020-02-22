from imutils.video import VideoStream
from imutils.video import FPS

import numpy as np
import argparse
import imutils
import time
import cv2

import paho.mqtt.client as mqtt
from argparse import ArgumentParser

def build_argparser():
    parser = ArgumentParser()
    parser.add_argument("-i", "--input", required=True, type=str,
                         help="Path to video file or image.")
    parser.add_argument("-id", "--identification", default="camera-01", type=str,
                         help="Identification")
    parser.add_argument("-p", "--prototxt", required=True, type=str,
                         help="Path to an .xml file with a trained model.")
    parser.add_argument("-m", "--model", required=True, type=str,
                         help="Path to an .bin file with a trained model.")
    return parser

args = build_argparser().parse_args()

prototxt = args.prototxt
model = args.model

conf = 0.5
font = cv2.FONT_HERSHEY_SIMPLEX
freq = cv2.getTickFrequency()
frame_rate_calc = 1

broker_address="172.17.0.1"
client = mqtt.Client("smartcam")
client.connect(broker_address)

LABELS = ["background", "aeroplane", "bicycle", "bird", "boat",
	"bottle", "bus", "car", "cat", "chair", "cow", "diningtable",
	"dog", "horse", "motorbike", "person", "pottedplant", "sheep",
	"sofa", "train", "tvmonitor"]

COLORS = np.random.uniform(0, 255, size=(len(LABELS), 3))

net = cv2.dnn.readNet(prototxt, model)
#net.setPreferableTarget(cv2.dnn.DNN_TARGET_VPU)

vs = VideoStream(src=args.input).start()
time.sleep(2.0)
fps = FPS().start()

while True:
    frame = vs.read()
    frame = imutils.resize(frame, width=400)
    t1 = cv2.getTickCount()

    (h, w) = frame.shape[:2]
    blob = cv2.dnn.blobFromImage(frame, 0.007843, (h, w), 127.5)

    net.setInput(blob)
    detections = net.forward()

    for i in np.arange(0, detections.shape[2]):
        confidence = detections[0, 0, i, 2]

        if confidence > conf:
            idx = int(detections[0, 0, i, 1])
            box = detections[0, 0, i, 3:7] * np.array([w, h, w, h])
            (startX, startY, endX, endY) = box.astype("int")
            label = LABELS[idx]
            print(label)
            cv2.rectangle(frame, (startX, startY), (endX, endY),
            COLORS[idx], 2)
            y = startY - 15 if startY - 15 > 15 else startY + 15

            if label == 'bus' or label == 'car':
                client.publish('iikim/mobilenet-ssd/python',label)
            else:
                client.publish('iikim/mobilenet-ssd/python',"none")

            cv2.putText(frame, label, (startX, y),font, 0.5, COLORS[idx], 2)
            cv2.putText(frame,"FPS: {0:.2f}".format(frame_rate_calc),(30,50),font,1,(255,255,0),2,cv2.LINE_AA)

    cv2.imshow("Frame", frame)
    key = cv2.waitKey(1) & 0xFF

    t2 = cv2.getTickCount()
    time1 = (t2-t1)/freq
    frame_rate_calc = 1/time1

    if key == ord("q"):
        break
    fps.update()

cv2.destroyAllWindows()
vs.stop()
