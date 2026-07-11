ARG ICEBERG_REST_IMAGE=apache/iceberg-rest-fixture:latest
FROM ${ICEBERG_REST_IMAGE}

ARG POSTGRESQL_JDBC_VERSION=42.7.13

ADD https://repo1.maven.org/maven2/org/postgresql/postgresql/${POSTGRESQL_JDBC_VERSION}/postgresql-${POSTGRESQL_JDBC_VERSION}.jar /usr/lib/iceberg-rest/postgresql.jar
USER root
RUN chmod 0644 /usr/lib/iceberg-rest/postgresql.jar
USER iceberg

CMD ["java", "-cp", "/usr/lib/iceberg-rest/iceberg-rest-adapter.jar:/usr/lib/iceberg-rest/postgresql.jar", "org.apache.iceberg.rest.RESTCatalogServer"]
