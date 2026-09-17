#!/usr/bin/env bash

EXT_NAME=$1

cd ./extensions/$EXT_NAME

make USE_PGXS=1 clean
make USE_PGXS=1
make USE_PGXS=1 install

# make clean
# make
# make install

echo "==== Start install tests ===="
make USE_PGXS=1 installcheck

