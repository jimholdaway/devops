#!/bin/bash

podman pod stop \
	pelican-server

podman pod rm \
	pelican-server

podman pod create \
	--name pelican-server \
	-p 8080:8000

if	[[ $1 = "-d" ]]; then
	podman run \
		--pod pelican-server \
		--name pelican-dev \
		-v $(pwd):/project \
		-it \
		quay.io/jimholdaway/pelican_test:latest \
		make devserver
else
	podman run \
                --pod pelican-server \
                --name pelican-shell \
                -v $(pwd):/project \
                -it \
                quay.io/jimholdaway/pelican_test:latest
fi
