# Notebook Guide

이 디렉터리는 로컬 Spark–Iceberg Lakehouse의 설계, 변환, 검증 과정을
재현 가능한 노트북으로 설명합니다.

## Recommended Reading Order

1. `experiments/spark-catalog-smoke-test.ipynb`
   - Spark와 Iceberg REST Catalog 연결 확인
2. `admin/namespace_admin.ipynb`
   - Bronze/Silver/Gold 네임스페이스 관리
3. `pipelines/medallion.ipynb`
   - 일봉·1분봉 Bronze 테이블과 Silver `MERGE INTO`
4. `experiments/minute_price_quality_checks.ipynb`
   - 업무 키, OHLC, Bronze/Silver 정합성, Iceberg 스냅샷 검사
5. `experiments/supabase_source_validation.ipynb`
   - 외부 PostgreSQL 원천을 Bronze 스키마으로 옮기기 전 프로파일링

## Architecture

```text
External source
  → Bronze Iceberg: append-only collection history
  → Silver Iceberg: latest valid state by business key
  → Gold Iceberg: analytics marts (future work)

Spark
  → Iceberg REST Catalog
      → PostgreSQL catalog metadata
  → MinIO
      → Parquet data and Iceberg metadata files
```

## Run

프로젝트 루트에서 스택을 시작합니다.

```bash
docker compose up -d
```

그다음 `http://localhost:8888`에서 JupyterLab을 엽니다.

모든 시각 데이터는 UTC 기준으로 처리합니다. 외부 데이터베이스 접속 정보는
환경변수로만 전달하며 노트북에 자격 증명을 저장하지 않습니다.

## Safety

- `admin/namespace_admin.ipynb`의 삭제 셀은 기본적으로 비활성화되어 있습니다.
- `pipelines/medallion.ipynb`는 테이블 생성과 `MERGE INTO`를 실행합니다.
- `experiments/minute_price_quality_checks.ipynb`는 읽기 전용입니다.
- `tutorials/iceberg/`는 외부 Iceberg 학습 자료를 정리한 공간이며,
  프로젝트 고유 파이프라인과 분리되어 있습니다.
