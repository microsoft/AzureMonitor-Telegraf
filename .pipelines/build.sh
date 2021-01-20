#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJDIR="$(dirname "$DIR")"
cd "$PROJDIR"

if [ -d "$PROJDIR/build" ]; then
  rm -rf $PROJDIR/build
fi

# replace Makefile, scripts folders and logrotate.d/telegraf files
cp -fv "$PROJDIR/.pipelines/Makefile" "$PROJDIR/Makefile"
if [ $? != 0 ]; then
  printf "Error : [%d] when copying Makefile" $?
  exit $?
fi

if [ -d "$PROJDIR/scripts" ]; then
  rm -rf $PROJDIR/scripts
fi
cp -fvr "$PROJDIR/.pipelines/scripts" "$PROJDIR/scripts"
if [ $? != 0 ]; then
  printf "Error : [%d] when copying scripts folder" $?
  exit $?
fi

cp -fvr "$PROJDIR/.pipelines/etc/logrotate.d/telegraf" "$PROJDIR/etc/logrotate.d/telegraf"
if [ $? != 0 ]; then
  printf "Error : [%d] when copying logrotate.d folder" $?
  exit $?
fi

echo "Run makefile to generate packages for all the flavors"
make package