FROM maven:3.3-jdk-8
MAINTAINER Xabier de Zuazo "xabier@zuazo.org"

ENV KEYWHIZ_VERSION=0.7.10 \
    KEYWHIZ_PREFIX=/opt \
    JAR="server/target/keywhiz-server-shaded.jar"
ENV ENTRYPOINT="java -jar $JAR"

RUN wget -nv -O- \
    https://github.com/square/keywhiz/archive/v$KEYWHIZ_VERSION.tar.gz \
    | tar -xz -C $KEYWHIZ_PREFIX
WORKDIR $KEYWHIZ_PREFIX/keywhiz-$KEYWHIZ_VERSION
RUN mvn package -q -am -pl server -P h2 && \
    ln server/target/keywhiz-server-$KEYWHIZ_VERSION-shaded.jar \
      server/target/keywhiz-server-shaded.jar

# pwgen: Tool used to generate a random password for the derivation key
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends --no-upgrade \
      pwgen && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# Copy ENTRYPOINT script
ADD docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Run as unprivileged user
RUN groupadd -r keywhiz && useradd -r -g keywhiz keywhiz && \
    chown -R keywhiz:keywhiz . /tmp/h2_data
USER keywhiz

# Application connector
EXPOSE 4444
# Admin connector
# EXPOSE 8085

ENTRYPOINT ["/entrypoint.sh"]
