#!/bin/sh

docker run \
  -ti \
  -P \
  --rm \
  zuazo/keywhiz "${@}"
