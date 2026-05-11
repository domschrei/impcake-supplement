#!/bin/bash

# This script assumes that the repo has been cloned RECURSIVELY.

set -e

tstart=$(date +%s)

# First, build the Mallob artifact image
cd mallob/artifact

# Dummy folder
mkdir -p benchmarks

docker build --progress=plain -f ../Dockerfile -t mallob-cav26 .

cd ../..

# Build ours on top of it
docker build --progress=plain -f ./Dockerfile -t impcake-fmcad26 .

docker save impcake-fmcad26 | gzip -9 > impcake-fmcad26-img.tar.gz

rm -rf impcake-fmcad26

zip -r impcake-fmcad26-artifact.zip impcake-fmcad26-img.tar.gz experimental-data LICENSE README.md

tend=$(date +%s)

echo "Whole procedure took $(($tend - $tstart))s"
