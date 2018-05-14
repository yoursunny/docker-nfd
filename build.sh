#!/bin/bash
VERSION=$(date +%Y%m%d)
docker build -t yoursunny/armhf-nfd:$VERSION - < Dockerfile-base
