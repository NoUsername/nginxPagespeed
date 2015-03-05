#!/bin/bash

# remove build-only dependencies
apt-get -y remove build-essential zlib1g-dev libpcre3-dev libbz2-dev libssl-dev tar unzip wget  

rm -r $BUILDDIR

