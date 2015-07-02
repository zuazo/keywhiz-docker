FROM zuazo/keywhiz

COPY keywhiz-acme.yaml ./
COPY acme_truststore.p12 ./
COPY acme_keystore.p12 ./

# The keystore password in the yaml file. Can also be set at run time.
# You can set this env variable or COPY your own derivation.jceks file.
# This does not work, see docker-entrypoint.sh script for more information.
# ENV KEYSTORE_PASS MyKeystorePass

CMD ["server", "keywhiz-acme.yaml"]
