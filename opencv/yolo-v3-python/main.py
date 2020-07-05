from imutils.video import VideoStream
from imutils.video import FPS

import numpy as np
import argparse
import imutils
import time
import cv2
import os

import paho.mqtt.client as mqtt
from argparse import ArgumentParser

def load_yolo():
	net = cv2.dnn.readNet("yolov3.weights", "yolov3.cfg")
	classes = []
	with open("coco.names", "r") as f:
		classes = [line.strip() for line in f.readlines()]

	layers_names = net.getLayerNames()
	output_layers = [layers_names[i[0]-1] for i in net.getUnconnectedOutLayers()]
	colors = np.random.uniform(0, 255, size=(len(classes), 3))
	return net, classes, colors, output_layers

def get_box_dimensions(outputs, height, width):
	boxes = []
	confs = []
	class_ids = []
	for output in outputs:
		for detect in output:
			scores = detect[5:]
			class_id = np.argmax(scores)
			conf = scores[class_id]
			if conf > 0.3:
				center_x = int(detect[0] * width)
				center_y = int(detect[1] * height)
				w = int(detect[2] * width)
				h = int(detect[3] * height)
				x = int(center_x - w/2)
				y = int(center_y - h / 2)
				boxes.append([x, y, w, h])
				confs.append(float(conf))
				class_ids.append(class_id)
	return boxes, confs, class_ids

def draw_labels(boxes, confs, colors, class_ids, classes, img):
	indexes = cv2.dnn.NMSBoxes(boxes, confs, 0.5, 0.4)
	font = cv2.FONT_HERSHEY_PLAIN
	for i in range(len(boxes)):
		if i in indexes:
			x, y, w, h = boxes[i]
			label = str(classes[class_ids[i]])
			color = colors[i]
			cv2.rectangle(img, (x,y), (x+w, y+h), color, 2)
			cv2.putText(img, label, (x, y - 5), font, 1, color, 1)
	cv2.imshow("Image", img)

def build_argparser():
    parser = ArgumentParser()
    parser.add_argument("-i", "--input", required=True, type=str,
                         help="Path to video file or image.")
    parser.add_argument("-th", "--threshold", default="0.5", type=float,
                         help="Threshold")
    parser.add_argument("-p", "--prototxt", required=True, type=str,
                         help="Path to an .xml file with a trained model.")
    parser.add_argument("-m", "--model", required=True, type=str,
                         help="Path to an .bin file with a trained model.")
    parser.add_argument("-l", "--label", required=True, type=str,
                         help="Label")
    return parser

args = build_argparser().parse_args()

prototxt = args.prototxt
model = args.model
conf = args.threshold
this_label = args.label

font = cv2.FONT_HERSHEY_SIMPLEX
freq = cv2.getTickFrequency()
frame_rate_calc = 1

broker_address = os.getenv('MQTT_SERVER')
mqtt_topic = "mobilenet-ssd-python"
mqtt_message = "{\"label\" : True }"
client = mqtt.Client("mobilenet-ssd-python")
client.connect(broker_address)


LABELS = ["background", "aeroplane", "bicycle", "bird", "boat",
	"bottle", "bus", "car", "cat", "chair", "cow", "diningtable",
	"dog", "horse", "motorbike", "person", "pottedplant", "sheep",
	"sofa", "train", "tvmonitor"]

COLORS = np.random.uniform(0, 255, size=(len(LABELS), 3))

net = cv2.dnn.readNet(prototxt, model)
net.setPreferableBackend(cv2.dnn.DNN_BACKEND_INFERENCE_ENGINE)
net.setPreferableTarget(cv2.dnn.DNN_TARGET_CPU)

model, classes, colors, output_layers = load_yolo()

vs = VideoStream(src=args.input).start()
time.sleep(2.0)
fps = FPS().start()

while True:
    frame = vs.read()
    #frame = imutils.resize(frame)
    t1 = cv2.getTickCount()

    height, width, channels = frame.shape

    blob = cv2.dnn.blobFromImage(frame, 0.007843, (height, width), 127.5)
    net.setInput(blob)
    detections = net.forward(output_layers)

    boxes, confs, class_ids = get_box_dimensions(detections, height, width)
    draw_labels(boxes, confs, colors, class_ids, classes, frame)

    key = cv2.waitKey(1) & 0xFF

    t2 = cv2.getTickCount()
    time1 = (t2-t1)/freq
    frame_rate_calc = 1/time1

    if key == ord("q"):
        break
    fps.update()
    print(fps)

cv2.destroyAllWindows()
vs.stop()
