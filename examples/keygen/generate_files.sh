#!/bin/sh

#
# Script used to generate all the certificate files used in this example.
#
# Requirements:
#
# * openssl
# * keytool (Java JDK 1.8.0+)
# * certstrap (https://github.com/square/certstrap)
#
# See https://github.com/square/keywhiz/wiki/Development-and-test-key-material
#

# Generate a new CA
certstrap init --key-bits 2048 --years 30 --common-name "Keywhiz ACME CA"
keytool -import -file out/Keywhiz_ACME_CA.crt -alias ca -storetype pkcs12 -storepass unicorns -keystore out/Keywhiz_ACME_CA.p12
cp out/Keywhiz_ACME_CA.p12 acme_truststore.p12

# Create client certificates
certstrap request-cert --common-name client
certstrap sign --years 30 --CA "Keywhiz ACME CA" client
certstrap request-cert --common-name noSecretsClient
certstrap sign --years 30 --CA "Keywhiz ACME CA" noSecretsClient
# ...

# Genrate pem file for curl
openssl pkcs12 -export -in out/client.crt -inkey out/client.key -out out/client.p12
openssl pkcs12 -in out/client.p12 -nodes -out out/client.pem
openssl pkcs12 -export -in out/noSecretsClient.crt -inkey out/noSecretsClient.key -out out/noSecretsClient.p12
openssl pkcs12 -in out/noSecretsClient.p12 -nodes -out out/noSecretsClient.pem

# Create a server certificate
certstrap request-cert --domain localhost --ip 127.0.0.1 --organizational-unit server
certstrap sign --years 30 --CA "Keywhiz ACME CA" localhost
keytool -import -file out/localhost.crt -storetype pkcs12 -storepass unicorns -keystore out/localhost.p12
# openssl pkcs12 -aes128 -in out/localhost.crt -inkey out/localhost.key -out out/localhost.p12
cp out/localhost.p12 acme_keystore.p12
