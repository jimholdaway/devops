Dockerfile and start script for Pelican static site generator.

An image where python dependencies are install on an Ubuntu 20.04 base to run Pelican in a docker container, available at [docker hub](https://hub.docker.com/repository/docker/jimholdaway/pelican-docker).

Included in this repo is a startup script [pelican-start.sh](https://github.com/jimholdaway/pelican-docker/blob/master/pelican-start.sh).

Running `./pelican-start.sh` from the directory that contains your Pelican website will remove any previous image instance and pull the latestimage, whilst allowing the local Pelican data to persist. It boots into a tty terminal, this is useful for running Pelican specific commands such as [pelican-quickstart](https://docs.getpelican.com/en/stable/quickstart.html)(if one does not exist) or pulling extra Pelican dependencies to the image using pip.

__NOTE:__ Any dependencies chosen for the image will not be persistent unless they are added to the `requirements.txt` file. The `requirements.txt` file can be made from within the container using `pip freeze > requirements.txt`. The repo can be forked and the Dockerfile modified others can have their own chosen Pelican packages in a persistent image.

Using `./pelican-start.sh -d` will host the website continuously at http://localhost.
