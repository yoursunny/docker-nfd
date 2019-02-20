# Dockerized NFD

This repository contains scripts to run [NFD](https://named-data.net/doc/NFD/) in [Docker](https://www.docker.com/) on ARMv7 and ARMv6 architectures.

## build.sh

`build.sh` creates [yoursunny/armhf-nfd](https://hub.docker.com/r/yoursunny/armhf-nfd/) and [yoursunny/armv6-nfd](https://hub.docker.com/r/yoursunny/armv6-nfd/) images from ndn-cxx, NFD, and ndn-tools source code.
It runs on an x86\_64 host machine, and cross compiles to ARMv7 or ARMv6 binary.

## deploy.sh

`deploy.sh` pulls a base image and derives several images for local use:

* `nfd`
* `ndnping`
* `ndnpingserver`
* `ndnsec`

This script expects one command line argument: a tag name of the base image.
Look at [yoursunny/armhf-nfd tags](https://hub.docker.com/r/yoursunny/armhf-nfd/tags/) or [yoursunny/armv6-nfd tags](https://hub.docker.com/r/yoursunny/armv6-nfd/tags/) to decide.

## demo.sh

`demo.sh` demonstrates how the images may be used.
