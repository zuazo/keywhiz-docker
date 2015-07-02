# Keywhiz Keygen Example

Example to run Keywhiz with non-development certificates.

See [Development and test key material documentation](https://github.com/square/keywhiz/wiki/Development-and-test-key-material) for more information on how to generate the keys and the certificates.

## Build

    $ docker build -t keywhiz-keygen-example .

## Run

    $ docker run -d -p 4444:4444 keywhiz-keygen-example
