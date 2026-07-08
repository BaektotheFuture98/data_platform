#!/usr/bin/env bash
set -euo pipefail

py4j_zip="$(find "${SPARK_HOME}/python/lib" -maxdepth 1 -name 'py4j-*-src.zip' | head -n 1)"
export PYTHONPATH="${SPARK_HOME}/python:${py4j_zip}:${PYTHONPATH:-}"

exec python3 -m jupyter lab \
  --ip=0.0.0.0 \
  --port=8888 \
  --no-browser \
  --ServerApp.token='' \
  --ServerApp.password='' \
  --ServerApp.allow_origin='*' \
  --notebook-dir=/home/iceberg/notebooks
