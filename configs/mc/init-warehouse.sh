set -eu

until mc alias set minio http://minio:9000 "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD"; do
  echo "...waiting for minio..."
  sleep 1
done

mc mb --ignore-existing minio/warehouse

if [ -f /etc/minio/policies/warehouse-public-read.json ]; then
  mc anonymous set-json /etc/minio/policies/warehouse-public-read.json minio/warehouse || true
fi

tail -f /dev/null
