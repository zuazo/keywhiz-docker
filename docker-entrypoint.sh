#!/bin/bash

# Exit the script in case of errors
set -e

# Some constants
DEV_KW_CONFIG='server/target/classes/keywhiz-development.yaml'
DEFAULT_COOKIEKEY_PATH='server/target/classes/dev_and_test_cookiekey.base64'

# Some runtime useful variables
COOKIEKEY_PATH="${COOKIEKEY_PATH:-server/target/classes/cookiekey.base64}"
KEYSTORE_PASS="${KEYSTORE_PASS:-$(pwgen -s 12 1)}"
KW_POPULATE_DEV_DATA="${KW_POPULATE_DEV_DATA:-true}"

# Generate base derivation key in derivation.jceks
# FIXME: Does not work properly (a possible bug?)
# javax.crypto.AEADBadTagException: mac check in GCM failed
# echo 'Generating derivation key in derivation.jceks.'
# rm server/target/classes/derivation.jceks
# $ENTRYPOINT gen-aes --storepass "${KEYSTORE_PASS}"
# sed -i "s/password: CHANGE$/password: ${KEYSTORE_PASS}/" "${DEV_KW_CONFIG}"*
# echo 'Derivation key generated.'

# Generata key used to encrypt cookie content in cookiekey.base64
if ! [ -e "${COOKIEKEY_PATH}" ]
then
  echo "Generating random cookie key in ${COOKIEKEY_PATH}."
  head -c 32 /dev/random | base64 > "${COOKIEKEY_PATH}"
  sed -i "s@${DEFAULT_COOKIEKEY_PATH}@${COOKIEKEY_PATH}@" "${DEV_KW_CONFIG}"*
  echo 'Cookie key generated.'
fi

if [ x"${*}" = x ]
then
  # Test mode
  echo 'Initializing the DB.'
  $ENTRYPOINT migrate "${DEV_KW_CONFIG}"
  if [ x"${KW_POPULATE_DEV_DATA}" = x'true' ]
  then
    echo 'Populating database with development data.'
    $ENTRYPOINT db-seed "${DEV_KW_CONFIG}"
  fi
  echo 'Starting server.'
  exec $ENTRYPOINT server "${DEV_KW_CONFIG}"
else
  if [ x"${1}" = x'server' ]
  then
    echo 'Initializing the DB.'
    java $JAVA_ARGS -jar $JAR migrate "${2}"
  fi
  exec java $JAVA_ARGS -jar $JAR "${@}"
fi
