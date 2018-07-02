#!/bin/bash
BASETAG=$1
BASEIMG=yoursunny/armv6-nfd:$BASETAG

sed -e 's|MYBASEIMG|'$BASEIMG'|' Dockerfile-nfd.in \
| docker build -t nfd -

for CMD in ndnping ndnpingserver ndnsec; do
  sed -e 's|MYBASEIMG|'$BASEIMG'|' -e 's|MYCMD|'$CMD'|' Dockerfile-cmd.in \
  | docker build -t $CMD -
done
