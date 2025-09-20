#!/bin/bash

set -e

OUTPUT_DIR=/home/user/output
DOWNLOAD_DIR=/home/user/clients

cd /home/user/jetbrains-clients-downloader-linux-x86_64-2149/bin

PRODUCT_CODE="$1"
BUILD_NUMBER="$2"

mkdir -p $OUTPUT_DIR
mkdir -p $DOWNLOAD_DIR

./jetbrains-clients-downloader --products-filter $PRODUCT_CODE --build-filter $BUILD_NUMBER --platforms-filter linux-x64,windows-x64 --download-backends "$DOWNLOAD_DIR"
./jetbrains-clients-downloader --products-filter $PRODUCT_CODE --build-filter $BUILD_NUMBER --platforms-filter linux-x64,windows-x64 "$DOWNLOAD_DIR"

cd /home/user