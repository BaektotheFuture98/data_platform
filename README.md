# datalakehouse

Local study environment for a small lakehouse stack:

- Spark as the query and compute engine
- Apache Iceberg as the open table format
- Iceberg REST Catalog backed by PostgreSQL
- MinIO as S3-compatible object storage

This repository is intentionally file-mounted so the service settings can be
edited directly while learning how the pieces fit together.

## Stack

| Component | Service | Purpose |
| --- | --- | --- |
| Spark | `spark-iceberg` | Runs Spark SQL, PySpark, Spark shell, and notebooks |
| Iceberg REST Catalog | `iceberg-rest` | Catalog API used by Spark |
| PostgreSQL | `postgres` | Stores Iceberg catalog metadata |
| MinIO | `minio` | Stores Iceberg table data and metadata files |
| MinIO Client | `mc` | Creates the `warehouse` bucket on startup |

## Quick Start

Create a local environment file:

```bash
cp .env.example .env
```

Start the stack:

```bash
docker compose up -d
```

Check status:

```bash
docker compose ps
```

Stop the stack:

```bash
docker compose down
```

## Service URLs

| Service | URL |
| --- | --- |
| Jupyter | http://localhost:8888 |
| Spark UI | http://localhost:8080 |
| Iceberg REST Catalog | http://localhost:8181 |
| MinIO API | http://localhost:9000 |
| MinIO Console | http://localhost:9001 |
| PostgreSQL | `localhost:5432` |

Default local credentials are defined in `.env.example`.

## Repository Layout

```text
.
├── docker-compose.yml
├── .env.example
├── configs/
│   ├── spark/
│   ├── iceberg-rest/
│   ├── postgres/
│   ├── minio/
│   └── mc/
├── workspace/
│   ├── notebooks/
│   └── scripts/
├── var/
│   └── lib/
└── docs/
```

## Config Files

- `docker-compose.yml`: service wiring, ports, mounts, and container environment
- `configs/spark/spark-defaults.conf`: Spark catalog and MinIO/S3 settings
- `configs/spark/log4j2.properties`: Spark and Iceberg logging settings
- `configs/iceberg-rest/catalog.properties`: reference catalog settings for the REST catalog
- `configs/postgres/initdb/001-init.sql`: first-run PostgreSQL initialization SQL
- `configs/minio/minio.env`: mounted non-secret MinIO server settings
- `configs/minio/policies/warehouse-public-read.json`: optional MinIO bucket policy
- `configs/mc/init-warehouse.sh`: creates the MinIO `warehouse` bucket

Runtime data is stored under `var/lib/` and ignored by git.

## Learning Notes

In this setup, Spark talks to Iceberg through the REST Catalog:

```text
Spark -> Iceberg REST Catalog -> PostgreSQL
Spark -> MinIO
```

PostgreSQL stores catalog metadata. MinIO stores the actual Iceberg table files,
including Parquet data files and Iceberg metadata files.

The internal S3 endpoint used by Spark and Iceberg REST is:

```text
http://object-store:9000
```

`object-store` is a Docker network alias for the MinIO container.

## Safety

- Do not commit `.env`.
- Do not commit files under `var/lib/`.
- Treat credentials in `.env.example` as local-only defaults for study.
