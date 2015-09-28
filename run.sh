#!/bin/bash 
SRC_PATH=$PWD/src
docker run -ti -u work -w /src -v $SRC_PATH:/src -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix jimlin95/fsl-yocto
