FROM ubuntu:focal
MAINTAINER Jim Holdaway

# Install python distro packages for pelican

RUN apt-get update && \
	apt-get -y install --no-install-recommends \
	python3 \
	python3-dev \
	python3-pip \
	python3-setuptools \
	build-essential

# Clean cache

RUN apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy list of python modules from context to container root

COPY requirements.txt requirements.txt

# Install python modules using pip

RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt

WORKDIR /project

