#!/usr/bin/env bash

EXT_NAME=$1

cd $HOME/postgres/source/debug/extensions/$EXT_NAME

make USE_PGXS=1 clean
make USE_PGXS=1
make USE_PGXS=1 install

# make clean
# make
# make install

echo "==== Start install tests ===="
PGUSER=user make USE_PGXS=1 installcheck

