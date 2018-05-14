#!/bin/bash
VOLROOT=$(mktemp -d)
NDNSECVOL=$VOLROOT/ndnsec
RUNVOL=$VOLROOT/run
NFDCONTAINER=nfd$RANDOM
PINGSERVERCONTAINER=pingserver$RANDOM

docker run --rm \
  -v $NDNSECVOL:/root/.ndn \
  ndnsec key-gen -te /localhost/operator

docker run --rm -d --name $NFDCONTAINER \
  -v $NDNSECVOL:/root/.ndn \
  -v $RUNVOL:/run \
  -p 6363:6363/udp -p 6363:6363/tcp -p 9696:9696/tcp \
  nfd

docker run --rm -d --name $PINGSERVERCONTAINER \
  --volumes-from $NFDCONTAINER \
  ndnpingserver /demo

docker run --rm \
  --volumes-from $NFDCONTAINER \
  ndnping -c 10 /demo

docker stop $PINGSERVERCONTAINER

docker exec $NFDCONTAINER nfdc face create udp4://hobo.cs.arizona.edu:6363
docker exec $NFDCONTAINER nfdc route add / udp4://hobo.cs.arizona.edu:6363

docker run --rm \
  --volumes-from $NFDCONTAINER \
  ndnping -c 10 /ndn/edu/arizona

docker stop $NFDCONTAINER

sudo rm -rf $VOLROOT
