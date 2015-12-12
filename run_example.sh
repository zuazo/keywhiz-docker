#!/bin/sh

docker run \
  -ti \
  --rm \
  zuazo/keywhiz "${@}"
