#!/bin/bash

RET=$1
BLDENV=$2
TARGET_PATH=$3

TIMESTAMP=$(date +"%Y%m%d%H%M%S")
. /usr/local/share/buildinfo/scripts/buildinfo_base.sh

[ -z "$BLDENV" ] && BLDENV=$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2)
[ -z "$BLDENV" ] && exit $RET

[ -z "$TARGET_PATH" ] && TARGET_PATH=./target

VERSION_BUILD_PATH=$TARGET_PATH/versions/build
VERSION_SLAVE_PATH=$VERSION_BUILD_PATH/build-sonic-slave-${BLDENV}
LOG_VERSION_PATH=$VERSION_BUILD_PATH/log-${TIMESTAMP}

sudo chmod -R a+rw $BUILDINFO_PATH
collect_version_files $LOG_VERSION_PATH
([ -d $BUILD_VERSION_PATH ] && [ ! -z "$(ls $BUILD_VERSION_PATH/)" ]) && cp -rf $BUILD_VERSION_PATH/* $LOG_VERSION_PATH/
mkdir -p $VERSION_SLAVE_PATH

scripts/versions_manager.py merge -t $VERSION_SLAVE_PATH -b $LOG_VERSION_PATH -e $POST_VERSION_PATH

## Metadata file
if [ -f ./build_metadata.yaml ]; then
    sudo cp ./build_metadata.yaml $VERSION_SLAVE_PATH
fi

rm -rf $BUILD_VERSION_PATH/*

exit $RET
