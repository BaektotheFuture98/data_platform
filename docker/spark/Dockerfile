ARG SPARK_BASE_IMAGE=apache/spark:4.1.2-scala2.13-java17-python3-ubuntu
FROM ${SPARK_BASE_IMAGE}

ARG ICEBERG_VERSION
ARG SPARK_MAJOR_MINOR
ARG SCALA_BINARY_VERSION
ARG IJAVA_VERSION=1.3.0

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends python3-pip curl unzip \
    && rm -rf /var/lib/apt/lists/*

ADD https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-${SPARK_MAJOR_MINOR}_${SCALA_BINARY_VERSION}/${ICEBERG_VERSION}/iceberg-spark-runtime-${SPARK_MAJOR_MINOR}_${SCALA_BINARY_VERSION}-${ICEBERG_VERSION}.jar /opt/spark/jars/
ADD https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-aws-bundle/${ICEBERG_VERSION}/iceberg-aws-bundle-${ICEBERG_VERSION}.jar /opt/spark/jars/

RUN chmod 0644 /opt/spark/jars/iceberg-*.jar \
    && py4j_zip="$(find /opt/spark/python/lib -maxdepth 1 -name 'py4j-*-src.zip' | head -n 1)" \
    && ln -sf "${py4j_zip}" /opt/spark/python/lib/py4j-src.zip \
    && python3 -m pip install --no-cache-dir jupyterlab pyiceberg[s3fs,pyarrow]

ENV SPARK_HOME=/opt/spark \
    HOME=/home/iceberg \
    PYSPARK_PYTHON=python3 \
    PYSPARK_DRIVER_PYTHON=python3 \
    PYTHONPATH=/opt/spark/python:/opt/spark/python/lib/py4j-src.zip \
    JAVA_TOOL_OPTIONS="-Duser.home=/home/iceberg -Djava.util.prefs.userRoot=/home/iceberg/.java/.userPrefs" \
    PATH=/opt/spark/bin:/opt/spark/sbin:${PATH}

RUN mkdir -p /home/iceberg/notebooks /home/iceberg/scripts /home/iceberg/spark-events /home/iceberg/.java/.userPrefs \
    && chown -R 185:0 /home/iceberg \
    && chmod -R g=u /home/iceberg

# Jupyter Notebook을 위한 IJava 설치(Java 커널)
RUN curl -L -o /tmp/ijava.zip \
      https://github.com/SpencerPark/IJava/releases/download/v${IJAVA_VERSION}/ijava-${IJAVA_VERSION}.zip \
    && unzip /tmp/ijava.zip -d /tmp/ijava \
    && python3 /tmp/ijava/install.py --sys-prefix --classpath '/opt/spark/jars/*.jar' \
    && rm -rf /tmp/ijava /tmp/ijava.zip

COPY docker/spark/start-notebook.sh /usr/local/bin/start-notebook.sh
RUN chmod 0755 /usr/local/bin/start-notebook.sh

USER 185
WORKDIR /home/iceberg

EXPOSE 8888 8080 10000 10001

CMD ["/usr/local/bin/start-notebook.sh"]
