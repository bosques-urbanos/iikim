.PHONY: demo-cpu
demo-cpu:
	docker-compose build --force-rm --build-arg TARGET=CPU --build-arg INPUT=$(INPUT)
	TARGET=CPU docker-compose up --no-start

.PHONY: camera-cpu
camera-cpu:
	docker-compose build --force-rm --build-arg TARGET=CPU --build-arg INPUT=$(INPUT)
	TARGET=CPU docker-compose up --no-start

.PHONY: stream-cpu
stream-cpu:
	docker-compose build --force-rm --build-arg TARGET=CPU --build-arg INPUT=$(INPUT)
	TARGET=CPU docker-compose up --no-start

.PHONY: clean
clean:
	docker-compose down
