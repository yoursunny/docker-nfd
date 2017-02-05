#!/bin/bash
VERSION=$1

docker push yoursunny/armhf-nfd-compile:$VERSION
docker push yoursunny/armhf-nfd-install:$VERSION
