#!/bin/bash

#docker login

docker build -t loginservice -f Dockerfile.dev .
docker tag loginservice blacksph3re/loginservice:dev
#docker push blacksph3re/alastair:dev