.PHONY: demo-cpu
demo-cpu:
	docker-compose build --force-rm --build-arg TARGET=CPU --build-arg INPUT="~/video.mp4"
	CURRENT_UID=$(id -u):$(id -g) TARGET=CPU INPUT="~/video.mp4" THRESHOLD=.75 docker-compose up --no-start

.PHONY: demo-gpu
demo-gpu:
	docker-compose build --force-rm --build-arg TARGET=GPU--build-arg INPUT="~/video.mp4"
	CURRENT_UID=$(id -u):$(id -g) TARGET=GPU INPUT="~/video.mp4" THRESHOLD=.75 docker-compose up --no-start

.PHONY: camera-cpu
camera-cpu:
	docker-compose build --force-rm --build-arg TARGET=CPU --build-arg INPUT="/dev/video0"
	CURRENT_UID=$(id -u):$(id -g) TARGET=CPU INPUT="/dev/video0" THRESHOLD=.75 docker-compose up --no-start

.PHONY: camera-gpu
camera-gpu:
	docker-compose build --force-rm --build-arg TARGET="GPU" --build-arg INPUT="/dev/video0"
	CURRENT_UID=$(id -u):$(id -g) TARGET=GPU INPUT="/dev/video0" THRESHOLD=.75 docker-compose up --no-start

.PHONY: stream-cpu
stream-cpu:
	docker-compose build --force-rm --build-arg TARGET=CPU --build-arg INPUT="rtsp://admin:mav2aten@192.168.1.252:554/Streaming/channels/901"
	CURRENT_UID=$(id -u):$(id -g) TARGET=CPU INPUT="rtsp://admin:mav2aten@192.168.1.252:554/Streaming/channels/901" THRESHOLD=.90 docker-compose up --no-start

.PHONY: stream-gpu
stream-gpu:
	docker-compose build --force-rm --build-arg TARGET=GPU --build-arg INPUT="rtsp://admin:mav2aten@192.168.1.252:554/Streaming/channels/902"
	CURRENT_UID=$(id -u):$(id -g) TARGET=GPU INPUT="rtsp://admin:mav2aten@192.168.1.252:554/Streaming/channels/902" THRESHOLD=.85 docker-compose up --no-start

.PHONY: clean
clean:
	docker-compose down
