# MySQL Cheat Sheet

Quick commands for running MySQL locally and doing common admin/dev tasks.

## Run locally (Docker)

Start a disposable MySQL 8 instance:

```bash
# Start a disposable MySQL 8 container (data lost if container removed)
docker run --name mysql8 -e MYSQL_ROOT_PASSWORD=dev -p 3306:3306 -d mysql:8
```

Persist data:

```bash
# Start MySQL 8 with a named volume for persistence
docker run --name mysql8 -e MYSQL_ROOT_PASSWORD=dev -p 3306:3306 -v mysql8-data:/var/lib/mysql -d mysql:8
```

Connect with the MySQL client:

```bash
# Connect using local mysql client
mysql -h 127.0.0.1 -P 3306 -u root -p
```

Connect from another container (no local client needed):

```bash
# Exec mysql client inside the container (no local mysql client needed)
docker exec -it mysql8 mysql -u root -p
```

Stop/remove:

```bash
# Stop the container
docker stop mysql8

# Remove the container (volume remains unless removed separately)
docker rm mysql8
```

## Basic SQL

```sql
-- List databases
SHOW DATABASES;

-- Create a database
CREATE DATABASE appdb;

-- Select the database for subsequent commands
USE appdb;

-- List tables in the selected database
SHOW TABLES;

-- Show table schema
DESCRIBE my_table;

-- Show server version
SELECT VERSION();

-- Show current server time
SELECT NOW();
```

## Users & privileges

Create a user (local dev example):

```sql
-- Create a user that can connect from anywhere (dev example)
CREATE USER 'app'@'%' IDENTIFIED BY 'app_pw';

-- Grant privileges on one database
GRANT ALL PRIVILEGES ON appdb.* TO 'app'@'%';

-- Reload privilege tables
FLUSH PRIVILEGES;
```

Check users and grants:

```sql
-- List users and auth plugins
SELECT user, host, plugin FROM mysql.user;

-- Show effective grants for a user
SHOW GRANTS FOR 'app'@'%';
```

## Backup & restore

Dump one database:

```bash
# Dump one database to a SQL file
mysqldump -h 127.0.0.1 -u root -p --databases appdb > appdb.sql
```

Dump all databases (admin):

```bash
# Dump all databases to a SQL file
mysqldump -h 127.0.0.1 -u root -p --all-databases > all.sql
```

Restore:

```bash
# Restore a dump file into MySQL
mysql -h 127.0.0.1 -u root -p < appdb.sql
```

Dump/restore via Docker container:

```bash
# Dump from inside the container to a host file
docker exec mysql8 mysqldump -u root -p --databases appdb > appdb.sql

# Restore a host dump file into the container
cat appdb.sql | docker exec -i mysql8 mysql -u root -p
```

## Inspect server state

Connections / running queries:

```sql
-- Show running connections/queries
SHOW PROCESSLIST;
```

Server variables:

```sql
-- Show a specific variable
SHOW VARIABLES LIKE 'max_connections';

-- Show sql_mode
SHOW VARIABLES LIKE 'sql_mode';
```

Storage engines:

```sql
-- List available storage engines
SHOW ENGINES;

-- Show storage engine and stats per table (current database)
SHOW TABLE STATUS;
```

## Import/export tips

Faster imports (session-level, for bulk loads):

```sql
-- Speed up bulk imports in this session (be careful)
SET autocommit=0;

-- Disable unique checks in this session
SET unique_checks=0;

-- Disable foreign key checks in this session
SET foreign_key_checks=0;
```

After import:

```sql
-- Restore safer defaults after import
SET foreign_key_checks=1;

-- Re-enable unique checks
SET unique_checks=1;

-- Commit the transaction
COMMIT;

-- Restore autocommit
SET autocommit=1;
```

## Common patterns

Create table:

```sql
-- Create a basic table with an auto-increment primary key
CREATE TABLE items (id BIGINT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(255) NOT NULL, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP) ENGINE=InnoDB;
```

Upsert (MySQL 8):

```sql
-- Insert or update on primary/unique key conflict
INSERT INTO items(name) VALUES ('a')

-- If the row already exists, update name
ON DUPLICATE KEY UPDATE name=VALUES(name);
```

## Troubleshooting

- Can't connect: confirm listening port and container health: `docker ps`, `docker logs mysql8`.
- Access denied: confirm `user@host` matches how you connect (e.g., `'app'@'localhost'` vs `'app'@'%'`).
- "Public Key Retrieval is not allowed" (some JDBC clients): add `allowPublicKeyRetrieval=true` for dev only, or switch auth plugin/user config.
- Reset dev root password (Docker): easiest is usually `docker rm -f mysql8` and recreate if you don't need the data volume.
