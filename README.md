# Dockerized NFD

This repository contains scripts to run [NFD](https://named-data.net/doc/NFD/) in [Docker](https://www.docker.com/) on ARMv7 architecture.

## build.sh

`build.sh` creates the [yoursunny/armhf-nfd](https://hub.docker.com/r/yoursunny/armhf-nfd/) image from ndn-cxx, NFD, and ndn-tools source code.
It is intended to run on [Scaleway](https://www.scaleway.com/) C1 instance.

## deploy.sh

`deploy.sh` pulls the [yoursunny/armhf-nfd](https://hub.docker.com/r/yoursunny/armhf-nfd/) image and derives several images for local use:

* `nfd`
* `ndnping`
* `ndnpingserver`
* `ndnsec`

This script expects one command line argument: a tag name of the base image.
Look at [yoursunny/armhf-nfd tags](https://hub.docker.com/r/yoursunny/armhf-nfd/tags/) to decide.

## demo.sh

`demo.sh` demonstrates how the imges may be used.
