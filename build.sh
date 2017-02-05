#!/bin/bash
VERSION=$(date +%Y%m%d)
sudo rm -rf $PWD/nfd-install

docker build -t yoursunny/armhf-nfd-compile:$VERSION -f Dockerfile-compile .

docker run --name nfd-install-$VERSION -v $PWD/nfd-install:/target yoursunny/armhf-nfd-compile:$VERSION bash -c "
  cd ndn-cxx && ./waf install --destdir=/target && cd ..;
  cd NFD && ./waf install --destdir=/target && cd ..;
  cd ndn-tools && ./waf install --destdir=/target && cd ..;
  find /target -type f | xargs ldd 2>/dev/null | grep /lib/ | awk '{ print \$3 }' | sort -u | xargs dpkg -S | cut -d: -f1 | sort -u > /target/deps.txt
"
docker rm nfd-install-$VERSION

(
  echo FROM armv7/armhf-ubuntu_core
  echo 'RUN apt-get update && apt-get install -qq '$(cat nfd-install/deps.txt)' && apt-get clean'
  sudo rm nfd-install/deps.txt
  echo COPY nfd-install /
) > Dockerfile-install
docker build -t yoursunny/armhf-nfd-install:$VERSION -f Dockerfile-install .
sudo rm -rf $PWD/nfd-install
