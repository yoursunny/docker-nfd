#!/bin/bash
VERSION=$(date +%Y%m%d)
docker build -t nfd-compile:$VERSION .
