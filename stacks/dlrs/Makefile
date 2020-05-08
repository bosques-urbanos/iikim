.PHONY: demo-cpu
demo-cpu:
	docker-compose build --force-rm --build-arg TARGET=CPU --build-arg INPUT="/workspace/video.mp4"
	TARGET=CPU INPUT="/workspace/video.mp4" docker-compose up --no-start

.PHONY: camera-cpu
camera-cpu:
	docker-compose build --force-rm --build-arg TARGET=CPU --build-arg INPUT="/dev/video0"
	TARGET=CPU INPUT="/dev/video0" docker-compose up --no-start

.PHONY: stream-cpu
stream-cpu:
	docker-compose build --force-rm --build-arg TARGET=CPU --build-arg INPUT="http://172.17.0.1:9081/?action=stream"
	TARGET=CPU INPUT="http://172.17.0.1:9081/?action=stream" docker-compose up --no-start

.PHONY: clean
clean:
	docker-compose down
