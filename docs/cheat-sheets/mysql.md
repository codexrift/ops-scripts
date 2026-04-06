# MySQL Cheat Sheet

Quick commands for running MySQL locally and doing common admin/dev tasks.

## Run locally (Docker)

Start a disposable MySQL 8 instance:

```bash
docker run --name mysql8 -e MYSQL_ROOT_PASSWORD=dev -p 3306:3306 -d mysql:8
```

Persist data:

```bash
docker run --name mysql8 ^
  -e MYSQL_ROOT_PASSWORD=dev ^
  -p 3306:3306 ^
  -v mysql8-data:/var/lib/mysql ^
  -d mysql:8
```

Connect with the MySQL client:

```bash
mysql -h 127.0.0.1 -P 3306 -u root -p
```

Connect from another container (no local client needed):

```bash
docker exec -it mysql8 mysql -u root -p
```

Stop/remove:

```bash
docker stop mysql8
docker rm mysql8
```

## Basic SQL

```sql
SHOW DATABASES;
CREATE DATABASE appdb;
USE appdb;

SHOW TABLES;
DESCRIBE my_table;

SELECT VERSION();
SELECT NOW();
```

## Users & privileges

Create a user (local dev example):

```sql
CREATE USER 'app'@'%' IDENTIFIED BY 'app_pw';
GRANT ALL PRIVILEGES ON appdb.* TO 'app'@'%';
FLUSH PRIVILEGES;
```

Check users and grants:

```sql
SELECT user, host, plugin FROM mysql.user;
SHOW GRANTS FOR 'app'@'%';
```

## Backup & restore

Dump one database:

```bash
mysqldump -h 127.0.0.1 -u root -p --databases appdb > appdb.sql
```

Dump all databases (admin):

```bash
mysqldump -h 127.0.0.1 -u root -p --all-databases > all.sql
```

Restore:

```bash
mysql -h 127.0.0.1 -u root -p < appdb.sql
```

Dump/restore via Docker container:

```bash
docker exec mysql8 mysqldump -u root -p --databases appdb > appdb.sql
type appdb.sql | docker exec -i mysql8 mysql -u root -p
```

## Inspect server state

Connections / running queries:

```sql
SHOW PROCESSLIST;
```

Server variables:

```sql
SHOW VARIABLES LIKE 'max_connections';
SHOW VARIABLES LIKE 'sql_mode';
```

Storage engines:

```sql
SHOW ENGINES;
SHOW TABLE STATUS;
```

## Import/export tips

Faster imports (session-level, for bulk loads):

```sql
SET autocommit=0;
SET unique_checks=0;
SET foreign_key_checks=0;
```

After import:

```sql
SET foreign_key_checks=1;
SET unique_checks=1;
COMMIT;
SET autocommit=1;
```

## Common patterns

Create table:

```sql
CREATE TABLE items (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
```

Upsert (MySQL 8):

```sql
INSERT INTO items(name) VALUES ('a')
ON DUPLICATE KEY UPDATE name=VALUES(name);
```

## Troubleshooting

- Can’t connect: confirm listening port and container health: `docker ps`, `docker logs mysql8`.
- Access denied: confirm `user@host` matches how you connect (e.g., `'app'@'localhost'` vs `'app'@'%'`).
- “Public Key Retrieval is not allowed” (some JDBC clients): add `allowPublicKeyRetrieval=true` for dev only, or switch auth plugin/user config.
- Reset dev root password (Docker): easiest is usually `docker rm -f mysql8` and recreate if you don’t need the data volume.
