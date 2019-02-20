#!/bin/bash
source config.sh
MACHINE=$(uname -m)
if [[ $MACHINE =~ armv7.* ]]; then
  ARCH=armhf
elif [[ $MACHINE =~ armv6.* ]]; then
  ARCH=armv6
else
  echo 'Bad MACHINE '$MACHINE >/dev/stderr
  exit 2
fi
TAG=${1:-latest}
BASEIMG=${outputImgs[$ARCH]}$TAG

sed -e 's|{#BASEIMG#}|'$BASEIMG'|' Dockerfile-nfd.in \
| docker build -t nfd -

for CMD in ndnping ndnpingserver ndnsec; do
  sed -e 's|{#BASEIMG#}|'$BASEIMG'|' -e 's|{#CMD#}|'$CMD'|' Dockerfile-cmd.in \
  | docker build -t $CMD -
done
