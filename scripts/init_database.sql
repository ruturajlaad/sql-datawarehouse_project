-- ============================================================
-- init_database.sql
-- Database initialization script for Datawarehouse
-- This script creates the Datawarehouse database and schemas
-- ============================================================

-- Create database (run this only if database does not exist)
-- Note: If you already created it manually in pgAdmin, you can skip this
CREATE DATABASE Datawarehouse;

-- Connect to the database
\c Datawarehouse;

-- Create schemas
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;

-- Verification step (optional, uncomment to check)
-- \dn
