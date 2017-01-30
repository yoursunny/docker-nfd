#!/bin/bash
VERSION=$(date +%Y%m%d)

docker build -t nfd-compile:$VERSION -f Dockerfile-compile .
docker run --name nfd-install-$VERSION -v $PWD/nfd-install:/target nfd-compile:$VERSION bash -c "
  cd ndn-cxx && ./waf install --destdir=/target && cd ..;
  cd NFD && ./waf install --destdir=/target && cd ..;
  cd ndn-tools && ./waf install --destdir=/target && cd .."
docker rm nfd-install-$VERSION
docker build -t nfd-install:$VERSION -f Dockerfile-install .
sudo rm -rf nfd-install
