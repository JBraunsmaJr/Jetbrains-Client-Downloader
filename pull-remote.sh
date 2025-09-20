#!/bin/bash

OUTPUT_DIR=/home/user/output
DOWNLOAD_DIR=/home/user/clients

cd /home/user/jetbrains-clients-downloader-linux-x86_64-2149/bin

if [ -z "$PRODUCT_CODE" ]; then
    echo "Missing environment variable 'PRODUCT_CODE'"
    exit 1
fi

if [ -z  "$BUILD_NUMBER" ]; then
    echo "Missing environment variable 'BUILD_NUMBER'"
    exit 1
fi

mkdir -p $OUTPUT_DIR
mkdir -p $DOWNLOAD_DIR

./jetbrains-clients-downloader --products-filter $PRODUCT_CODE --build-filter $BUILD_NUMBER --platforms-filter linux-x64,windows-x64 --download-backends "$DOWNLOAD_DIR"
./jetbrains-clients-downloader --products-filter $PRODUCT_CODE --build-filter $BUILD_NUMBER --platforms-filter linux-x64,windows-x64 "$DOWNLOAD_DIR"

cd /home/user

NAME=clients.tar.gz

if [ -n "$FILENAME" ]; then
    NAME="$FILENAME"
fi

echo "Tarballing clients and backends..."
tar -cvf "$OUTPUT_DIR/$NAME" -C "$DOWNLOAD_DIR" .

echo "Cleaning up..."
rm -Rf "$DOWNLOAD_DIR/*"

echo "Done!"