#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJDIR="$(dirname "$DIR")"
cd "$PROJDIR"

go mod download