IMAGE_NAME := localproxy

image:
	docker build . -t ${IMAGE_NAME}

build/localproxy:
	mkdir -p build
	$(eval CONTAINER_ID:=$(shell docker create ${IMAGE_NAME}))
	docker cp ${CONTAINER_ID}:/home/aws-iot-securetunneling-localproxy/localproxy build/localproxy

build: build/localproxy

clean:
	rm -rf build
