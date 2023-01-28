FROM ubuntu:20.04

ARG OPENSSL_CONFIG

ENV DEBIAN_FRONTEND=noninteractive

# Install Prerequisites

RUN apt update && apt install -y \
	git \
	build-essential \
	wget \
	curl \ 
	unzip \ 
	cmake \
	libssl-dev \
	libpython-all-dev \
	python

# Install Dependencies

RUN mkdir /home/dependencies
WORKDIR /home/dependencies

RUN wget https://www.zlib.net/zlib-1.2.13.tar.gz -O /tmp/zlib-1.2.13.tar.gz && \
	tar xzvf /tmp/zlib-1.2.13.tar.gz && \
	cd zlib-1.2.13 && \
	./configure && \
	make && \
	make install && \
	cd /home/dependencies

RUN wget https://boostorg.jfrog.io/artifactory/main/release/1.79.0/source/boost_1_79_0.tar.gz -O /tmp/boost.tar.gz && \
	tar xzvf /tmp/boost.tar.gz && \
	cd boost_1_79_0 && \
	./bootstrap.sh && \
	./b2 install link=static && \
	cd /home/dependencies

RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v3.17.3/protobuf-all-3.17.3.tar.gz -O /tmp/protobuf-all-3.17.3.tar.gz && \
	tar xzvf /tmp/protobuf-all-3.17.3.tar.gz && \
	cd protobuf-3.17.3 && \
	mkdir build && \
	cd build && \
	cmake ../cmake && \
	make && \
	make install && \
	cd /home/dependencies

RUN git clone --branch v2.13.6 https://github.com/catchorg/Catch2.git && \
	cd Catch2 && \
	mkdir build && \
	cd build && \
	cmake ../ && \
	make && \
	make install && \
	cd /home/dependencies

RUN git clone https://github.com/aws-samples/aws-iot-securetunneling-localproxy && \
	cd aws-iot-securetunneling-localproxy && \
	mkdir build && \
	cd build && \
	cmake ../ && \
	make

RUN mkdir -p /home/aws-iot-securetunneling-localproxy && \
	cd /home/aws-iot-securetunneling-localproxy && \
	cp /home/dependencies/aws-iot-securetunneling-localproxy/build/bin/* /home/aws-iot-securetunneling-localproxy/

RUN rm -rf /home/dependencies

WORKDIR /home/aws-iot-securetunneling-localproxy/
