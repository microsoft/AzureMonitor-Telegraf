#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJDIR="$(dirname "$DIR")"

if [ -d "$PROJDIR/build" ]; then
  rm -rf $PROJDIR/build
fi

echo "Run makefile to generate packages for all the flavors"
make package