FROM zuazo/keywhiz

ENV POSTGRES_USER=keywhizdb \
    POSTGRES_PASSWORD=my-keywhizdb-pw \
# db-seed does not work properly with PostgreSQL:
# ERROR: relation "PUBLIC.GROUPS" does not exist
    KW_POPULATE_DEV_DATA=false

# Copy PostgreSQL configuration file
RUN cp server/target/classes/keywhiz-development.yaml.postgres \
      server/target/classes/keywhiz-development.yaml

# Configure PostgreSQL credentials
RUN sed -i \
      -e "s@url: jdbc:postgresql://localhost/.*@url: jdbc:postgresql://postgres/$POSTGRES_USER\n  user: $POSTGRES_USER\n  password: $POSTGRES_PASSWORD@" \
      server/target/classes/keywhiz-development.yaml

# Wait until database server is ready
ENTRYPOINT sleep 10 && /entrypoint.sh
