#!/bin/bash
source config.sh
ARCH=$1
BALENAIMG=${balenaImgs[$ARCH]}
OUTPUTIMG=${outputImgs[$ARCH]}

if [[ -z $BALENAIMG ]] || [[ -z $OUTPUTIMG ]]; then
  echo 'Bad ARCH '$ARCH >/dev/stderr
  exit 2
fi

VERSION=$(date +%Y%m%d)
JOBS=$(lscpu | grep '^CPU(s):' | awk '{print $2}')
if [[ $JOBS -gt 1 ]]; then
  JOBS=$((JOBS-1))
fi

sed -e 's|{#BALENAIMG#}|'$BALENAIMG'|g' -e 's|{#JOBS#}|'$JOBS'|g' Dockerfile-build.in \
| docker build -t $OUTPUTIMG$VERSION -t $OUTPUTIMG'latest' -
