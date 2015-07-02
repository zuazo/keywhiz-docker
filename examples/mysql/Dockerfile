FROM zuazo/keywhiz

ENV MYSQL_ROOT_PASSWORD=my-secret-pw \
    MYSQL_DATABASE=keywhizdb_development \
    MYSQL_USER=keywhizdb \
    MYSQL_PASSWORD=my-keywhizdb-pw \
# db-seed does not work properly with MySQL:
# Exception in thread "main" org.jooq.exception.DataAccessException:
# Table 'PUBLIC.GROUPS' doesn't exist
    KW_POPULATE_DEV_DATA=false

# Copy MySQL configuration file
RUN cp server/target/classes/keywhiz-development.yaml.mysql \
      server/target/classes/keywhiz-development.yaml

# Configure MySQL credentials
RUN sed -i \
      -e "s@url: jdbc:mysql://localhost/.*[?]\(.*\)@url: jdbc:mysql://mysql/$MYSQL_DATABASE?\1\n  password: $MYSQL_PASSWORD@" \
      -e "s@user: root\$@user: $MYSQL_USER@" \
      server/target/classes/keywhiz-development.yaml
# Connect as root:
# RUN sed -i \
#       -e "s@url: jdbc:mysql://localhost/.*[?]\(.*\)@url: jdbc:mysql://mysql/$MYSQL_DATABASE?\1\n  password: $MYSQL_ROOT_PASSWORD@" \
#       server/target/classes/keywhiz-development.yaml

# Wait until database server is ready
ENTRYPOINT sleep 10 && /entrypoint.sh
