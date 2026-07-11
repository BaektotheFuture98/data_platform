Project: datalakehouse

Overview
- Docker Compose stack: `docker-compose.yml`
- Object storage: MinIO
- Mountable service configs: `configs/`
- Runtime data: `var/lib/`
- Notebooks and local Spark scripts: `workspace/`

Quick start
1. Copy env file and edit secrets:

```bash
cp .env.example .env
# edit .env and fill passwords/secrets
```

2. Start the local lakehouse stack:

```bash
docker compose up -d
```

3. To customize service settings, edit files under `configs/` and restart the affected container.

```bash
docker compose restart spark-iceberg
docker compose restart iceberg-rest
```

Notes
- Do NOT commit real secrets into `configs/`.
- Spark and Iceberg REST use MinIO through the internal endpoint `http://object-store:9000`.
- `mc` creates the `warehouse` bucket if it does not exist. It does not delete bucket contents on restart.
 
Structure
- `docker-compose.yml`: Spark, Iceberg REST, PostgreSQL, MinIO, MinIO client, and network definitions
- `configs/spark/`: Spark and Iceberg client settings mounted into the Spark container
- `configs/postgres/initdb/`: PostgreSQL initialization SQL
- `configs/minio/minio.env`: mounted MinIO server settings
- `configs/minio/policies/`: MinIO bucket policies used by `mc`
- `configs/mc/`: MinIO client bootstrap scripts
- `workspace/notebooks/`: mounted Jupyter notebooks
- `workspace/scripts/`: mounted local Spark scripts
- `var/lib/postgres/`: PostgreSQL catalog database files
- `var/lib/minio/`: MinIO object data

Security
- Keep secrets in `.env`, local-only config overrides, or Docker secrets; do NOT commit `.env`.
- Use `.env.example` as a template only.
