.PHONY: demo-cpu
demo-cpu:
	docker-compose build --force-rm --build-arg TARGET=CPU
	TARGET=CPU docker-compose up --no-start

.PHONY: demo-gpu
demo-gpu:
	docker-compose build --force-rm --build-arg TARGET=GPU
	TARGET=GPU docker-compose up --no-start

.PHONY: camera-cpu
camera-cpu:
	docker-compose build --force-rm --build-arg TARGET=CPU --build-arg INPUT=0
	TARGET=CPU docker-compose up --no-start

.PHONY: camera-gpu
camera-gpu:
	docker-compose build --force-rm --build-arg TARGET="GPU" --build-arg INPUT=0
	TARGET=GPU docker-compose up --no-start

.PHONY: stream-cpu
stream-cpu:
	docker-compose build --force-rm --build-arg TARGET=CPU --build-arg INPUT=$(INPUT)
	TARGET=CPU docker-compose up --no-start

.PHONY: stream-gpu
stream-gpu:
	docker-compose build --force-rm --build-arg TARGET=GPU --build-arg INPUT=$(INPUT)
	TARGET=GPU docker-compose up --no-start

.PHONY: clean
clean:
	docker-compose down
