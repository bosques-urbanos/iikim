.PHONY: demo-cpu
demo-cpu:
	docker-compose build --force-rm --build-arg TARGET=CPU --build-arg INPUT="~/video.mp4"
	TARGET=CPU INPUT="~/video.mp4" THRESHOLD=.75 docker-compose up --no-start

.PHONY: demo-gpu
demo-gpu:
	docker-compose build --force-rm --build-arg TARGET=GPU--build-arg INPUT="~/video.mp4"
	TARGET=GPU INPUT="~/video.mp4" THRESHOLD=.75 docker-compose up --no-start

.PHONY: camera-cpu
camera-cpu:
	docker-compose build --force-rm --build-arg TARGET=CPU --build-arg INPUT="/dev/video0"
	TARGET=CPU INPUT="/dev/video0" THRESHOLD=.75 docker-compose up --no-start

.PHONY: camera-gpu
camera-gpu:
	docker-compose build --force-rm --build-arg TARGET="GPU" --build-arg INPUT="/dev/video0"
	TARGET=GPU INPUT="/dev/video0" THRESHOLD=.75 docker-compose up --no-start

.PHONY: stream-cpu
stream-cpu:
	docker-compose build --force-rm --build-arg TARGET=CPU --build-arg INPUT="http://172.17.0.1:9081/?action=stream"
	TARGET=CPU INPUT="http://172.17.0.1:9081/?action=stream" THRESHOLD=.75 docker-compose up --no-start

.PHONY: stream-gpu
stream-gpu:
	docker-compose build --force-rm --build-arg TARGET=GPU --build-arg INPUT="http://172.17.0.1:9081/?action=stream"
	TARGET=GPU INPUT="http://172.17.0.1:9081/?action=stream" THRESHOLD=.75 docker-compose up --no-start

.PHONY: clean
clean:
	docker-compose down
