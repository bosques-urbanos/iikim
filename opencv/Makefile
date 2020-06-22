.PHONY: demo-cpu
demo-cpu:
	docker-compose build --force-rm
	TARGET=CPU INPUT="~/video.mp4" THRESHOLD=.75 docker-compose up --no-start

.PHONY: camera-cpu
camera-cpu:
	docker-compose build --force-rm
	TARGET=CPU INPUT="/dev/video0" THRESHOLD=.75 docker-compose up --no-start

.PHONY: stream-cpu
stream-cpu:
	docker-compose build --force-rm
	TARGET=CPU INPUT="http://172.17.0.1:9081/?action=stream" THRESHOLD=.75 docker-compose up --no-start

.PHONY: clean
clean:
	docker-compose down
