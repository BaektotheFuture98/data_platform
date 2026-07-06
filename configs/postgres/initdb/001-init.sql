-- PostgreSQL initialization for the Iceberg JDBC catalog database.
CREATE SCHEMA IF NOT EXISTS public;

-- Lightweight smoke-test table. Iceberg creates and manages its own catalog
-- tables when the REST catalog starts using this database.
CREATE TABLE IF NOT EXISTS public._init_dummy (
  id serial PRIMARY KEY
);
