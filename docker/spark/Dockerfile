ARG SPARK_BASE_IMAGE=apache/spark:3.5.6-scala2.12-java17-python3-ubuntu
FROM ${SPARK_BASE_IMAGE}

ARG ICEBERG_VERSION=1.9.2
ARG SPARK_MAJOR_MINOR=3.5
ARG SCALA_BINARY_VERSION=2.12

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends python3-pip \
    && rm -rf /var/lib/apt/lists/*

ADD https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-${SPARK_MAJOR_MINOR}_${SCALA_BINARY_VERSION}/${ICEBERG_VERSION}/iceberg-spark-runtime-${SPARK_MAJOR_MINOR}_${SCALA_BINARY_VERSION}-${ICEBERG_VERSION}.jar /opt/spark/jars/
ADD https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-aws-bundle/${ICEBERG_VERSION}/iceberg-aws-bundle-${ICEBERG_VERSION}.jar /opt/spark/jars/

RUN chmod 0644 /opt/spark/jars/iceberg-*.jar \
    && python3 -m pip install --no-cache-dir jupyterlab pyiceberg[s3fs,pyarrow]

ENV SPARK_HOME=/opt/spark \
    HOME=/home/iceberg \
    PYSPARK_PYTHON=python3 \
    PYSPARK_DRIVER_PYTHON=python3 \
    PYTHONPATH=/opt/spark/python:/opt/spark/python/lib/py4j-0.10.9.7-src.zip \
    PATH=/opt/spark/bin:/opt/spark/sbin:${PATH}

RUN mkdir -p /home/iceberg/notebooks /home/iceberg/scripts /home/iceberg/spark-events \
    && chown -R 185:0 /home/iceberg \
    && chmod -R g=u /home/iceberg

COPY docker/spark/start-notebook.sh /usr/local/bin/start-notebook.sh
RUN chmod 0755 /usr/local/bin/start-notebook.sh

USER 185
WORKDIR /home/iceberg

EXPOSE 8888 8080 10000 10001

CMD ["/usr/local/bin/start-notebook.sh"]
