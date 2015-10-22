# Keywhiz Docker Container
[![Source Code](https://img.shields.io/badge/source-GitHub-blue.svg?style=flat)](https://github.com/zuazo/keywhiz-docker) [![Docker Repository on Quay.io](https://quay.io/repository/zuazo/keywhiz/status "Docker Repository on Quay.io")](https://quay.io/repository/zuazo/keywhiz) [![Build Status](http://img.shields.io/travis/zuazo/keywhiz-docker.svg?style=flat)](https://travis-ci.org/zuazo/keywhiz-docker)

A [Docker](https://www.docker.com/) image with [Keywhiz](http://square.github.io/keywhiz/).

## Supported Tags and Respective `Dockerfile` Links

* `0.7.7`, `0.7`, `latest` ([*/Dockerfile*](https://github.com/zuazo/keywhiz-docker/tree/master/Dockerfile))
* `0.7.6` ([*/Dockerfile*](https://github.com/zuazo/keywhiz-docker/blob/729125127cc4d59a3b52e519f805bf3c5a944511/Dockerfile))

## What Is Keywhiz?

From [its own website](http://square.github.io/keywhiz/):

*Keywhiz is a system for managing and distributing secrets. It can fit well with a service oriented architecture (SOA).*
*[...]*

*Keywhiz makes managing secrets easier and more secure. Keywhiz servers in a cluster centrally store secrets encrypted in a database. Clients use mutually authenticated TLS (mTLS) to retrieve secrets they have access to. Authenticated users administer Keywhiz via CLI or web app UI. To enable workflows, Keywhiz has automation APIs over mTLS and support for simple secret generation plugins.*

*Keywhiz should be considered alpha at this point. Upcoming changes may break API backward compatibility. See our [roadmap](http://square.github.io/keywhiz/#roadmap).*

## How to Use This Image

### Download the Image

    $ docker pull zuazo/keywhiz

### Run a Keywhiz Server With Development Data

    $ docker run -d -p 4444:4444 zuazo/keywhiz

You can now open [https://127.0.0.1:4444/](https://127.0.0.1:4444/) to navigate the Keywhiz server. The development data provides a `keywhizAdmin:adminPass` account.

See the [*examples/*](https://github.com/zuazo/keywhiz-docker/tree/master/examples) directory for more examples.

### Configuration

This image starts Keywhiz with the development data by default. All the `CMD` calls will have the Keywhiz JAR file as entrypoint (`java -jar [...]/keywhiz-server-shaded.jar`).

If you don't want to use development data, you should generate at least the following data:

* A new CA (and the *truststore.p12* file).
* Client certificates.
* A server certificate (and the *keystore.p12* file).

The following image generates the following data in the entrypoint script:

* A base derivation key using `gen-aes` in *derivation.jceks* (*temporary disabled*).
* Random cookie key in *server/target/classes/cookiekey.base64*.

You can use them directly from your YAML configuration file or generate your own.

See how to generate all this data in the [Keywhiz development key material generation documentation](https://github.com/square/keywhiz/wiki/Development-and-test-key-material).

## Build from Sources

Instead of installing the image from Docker Hub, you can build the image from sources if you prefer:

    $ git clone https://github.com/zuazo/keywhiz-docker keywhiz
    $ cd keywhiz
    $ docker build -t zuazo/keywhiz .

## Exposed TCP/IP Ports

* `4444`: Keywhiz application HTTPS port.

## Environment Variables Used at Runtime by the Entrypoint Script

* `COOKIEKEY_PATH`: Randomly generated cookie key path (`server/target/classes/cookiekey.base64`).
* `KEYSTORE_PASS`: Password used to generate the derivation key (randomly generated).
* `JAVA_ARGS`: Some java arguments.

You can change them using `docker run -e [...]` or in your *Dockerfile*, using the `ENV` instruction.

## Read-only Environment Variables Used at Build Time

* `KEYWHIZ_VERSION`: Keywhiz version to install (`0.7.6`).
* `KEYWHIZ_PREFIX`: Keywhiz parent directory (`/opt`).
* `JAR`: Keywhiz JAR file path (`server/target/keywhiz-server-shaded.jar`).
* `ENTRYPOINT`: Entrypoint, used to run the Keywhiz binary (`java -jar server/target/keywhiz-server-shaded.jar`). You can use it to call the Keywhiz application with some arguments: `RUN $ENTRYPOINT check`, `RUN $ENTRYPOINT migrate`, `RUN $ENTRYPOINT db-seed`, ...

The docker working directory is set to the main Keywhiz directory (`/opt/keywhiz-VERSION`).

# License and Author

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Author:**          | [Xabier de Zuazo](https://github.com/zuazo) (xabier@zuazo.org)
| **Copyright:**       | Copyright (c) 2015
| **License:**         | Apache License, Version 2.0

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
