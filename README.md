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

## Exposed Ports

Docker Compose maps the following container ports to the same ports on the host.

| Port | Service | Address | Purpose |
| --- | --- | --- | --- |
| `8888` | JupyterLab | http://localhost:8888 | Run and browse PySpark, Spark SQL, and Java notebooks. |
| `8080` | Spark UI | http://localhost:8080 | Inspect Spark applications, jobs, stages, executors, and SQL queries. Available while a Spark application is running. |
| `10000` | Spark Thrift Server | `localhost:10000` | JDBC/ODBC endpoint for SQL clients in binary transport mode. The port is mapped, but the Thrift Server is not started by the default Compose command. |
| `10001` | Spark Thrift Server | `localhost:10001` | HTTP transport endpoint for the Spark Thrift Server. The port is mapped, but the Thrift Server is not started by the default Compose command. |
| `8181` | Iceberg REST Catalog | http://localhost:8181 | REST API that Spark uses to read and manage Iceberg catalog metadata. |
| `5432` | PostgreSQL | `localhost:5432` | Database used by the Iceberg REST Catalog to persist catalog metadata. |
| `9000` | MinIO API | http://localhost:9000 | S3-compatible object storage API for Iceberg data and metadata files. |
| `9001` | MinIO Console | http://localhost:9001 | Web console for managing MinIO buckets, objects, and access settings. |

Services communicate with each other over the internal Docker network. For example,
Spark reaches the catalog at `http://iceberg-rest:8181` and MinIO at
`http://object-store:9000`; the host port mappings are primarily for local access.

Default local credentials are defined in `.env.example`.

## Repository Layout

```text
.
├── docker-compose.yml
├── .env.example
├── configs/
│   ├── spark/
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
- `configs/postgres/initdb/001-init.sql`: first-run PostgreSQL initialization SQL
- `configs/minio/minio.env`: mounted non-secret MinIO server settings
- `configs/minio/policies/warehouse-public-read.json`: optional MinIO bucket policy
- `configs/mc/init-warehouse.sh`: creates the MinIO `warehouse` bucket

Runtime data is stored under `var/lib/` and ignored by git.
Jupyter notebooks are stored under `workspace/notebooks/`.

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
