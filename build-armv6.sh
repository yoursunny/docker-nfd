#!/bin/bash
VERSION=$(date +%Y%m%d)
docker build -t yoursunny/armv6-nfd:$VERSION - < Dockerfile-armv6-base
