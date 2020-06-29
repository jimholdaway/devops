#!/bin/bash

if	[[ $1 = "-d" ]]; then
	docker rm -f jimholdaway/pelican-docker
	docker run \
		--rm \
		--name pelican-devserver \
		-p 80:8000 \
		-v $(pwd):/project \
		-it \
		jimholdaway/pelican-docker:devel \
		make devserver
else
	docker rm -f jimholdaway/pelican-docker
        docker run \
                --rm \
                --name pelican-devserver \
                -p 80:8000 \
                -v $(pwd):/project \
                -it \
                jimholdaway/pelican-docker:devel
fi
