---
title: "crunchy-postgres"
date: 
draft: false
weight: 150
---

PostgreSQL (pronounced "post-gress-Q-L") is an open source, ACID compliant, relational database management system (RDBMS) developed by a worldwide team of volunteers. The crunchy-postgres container image is unmodified, open source PostgreSQL packaged and maintained by professionals.

## Features

The following features are supported by the `crunchy-postgres` container:

* Kubernetes and OpenShift secrets
* Backup and restoration from various tools: `pgbackrest`, `pg_basebackup` and `pg_dump`/`pg_restore`.
* Custom mounted configuration files (see below)
* Async and Sync Replication

## Packages

The crunchy-postgres Docker image contains the following packages (versions vary depending on PostgreSQL version):

* PostgreSQL (11.1, 10.6, 9.6.11 and 9.5.15)
* [pgBackRest](https://pgbackrest.org/) (2.x)
* CentOS7 - publicly available
* RHEL7 - customers only

## Environment Variables

### Required
**Name**|**Default**|**Description**
:-----|:-----|:-----
**PG_DATABASE**|None|Set this value to create an initial database
**PG_PRIMARY_PORT**|None|Set this value to configure the primary PostgreSQL port.  It is recommended to use 5432.
**PG_MODE**|None|Set to `primary`, `replica` or `set` to specify the mode of the database
**PG_USER**|None|Set this value to specify the username of the general user account
**PG_PASSWORD**|None|Set this value to specify the password of the user role
**PG_PRIMARY_USER**|None|Set this value to specify the username of the replication user
**PG_PRIMARY_PASSWORD**|None|Set this value to specify the password of the replication user
**PG_ROOT_PASSWORD**|None|Set this value to specify the password of the superuser role

### Optional
**Name**|**Default**|**Description**
:-----|:-----|:-----
**ARCHIVE_MODE**|Off|Set this value to `on` to enable continuous WAL archiving
**ARCHIVE_TIMEOUT**|60|Set to a number (in seconds) to configure `archive_timeout` in `postgresql.conf`
**CHECKSUMS**|true|Enables `data-checksums` during initialization of the database.  Can only be set during initial database creation.  Set to `false` to disable data checksums.
**CRUNCHY_DEBUG**|FALSE|Set this to true to enable debugging in logs. Note: this mode can reveal secrets in logs.
**LOG_STATEMENT**|none|Sets the `log_statement` value in `postgresql.conf`
**LOG_MIN_DURATION_STATEMENT**|60000|Sets the `log_min_duration_statement` value in `postgresql.conf`
**MAX_CONNECTIONS**|100|Sets the `max_connections` value in `postgresql.conf`
**MAX_WAL_SENDERS**|6|Set this value to configure the max number of WAL senders (replication)
**PG_LOCALE**|UTF-8|Set the locale of the database
**PG_PRIMARY_HOST**|None|Set this value to specify primary host.  Note: only used when `PG_MODE != primary`
**PG_REPLICA_HOST**|None|Set this value to specify the replica host label.  Note; used when `PG_MODE` is `set`
**PGAUDIT_ANALYZE**|None|Set this to enable `pgaudit_analyze`
**PGBOUNCER_PASSWORD**|None|Set this to enable `pgBouncer` support by creating a special `pgbouncer` user for authentication through the connection pooler.
**PGMONITOR_PASSWORD**|None|Set this to enable `pgMonitor` support by creating a special `ccp_monitoring` user for collecting metrics from PostgreSQL servers.  Required for the `crunchy-collect` container.
**PGDATA_PATH_OVERRIDE**|None|Set this value to override the `/pgdata` directory name.  By default `/pgdata` uses `hostname` of the container.  In some cases it may be required to override this with a custom name (such as in a Statefulset)
**SHARED_BUFFERS**|128MB|Set this value to configure `shared_buffers` in `postgresql.conf`
**SYNC_REPLICA**|None|Set this value to specify the names of replicas that should use synchronized replication
**TEMP_BUFFERS**|8MB|Set this value to configure `temp_buffers` in `postgresql.conf`
**WORK_MEM**|4MB|Set this value to configure `work_mem` in `postgresql.conf`
**XLOGDIR**|None| Set this value to configure PostgreSQL to send WAL to the `/pgwal` volume (by default WAL is stored in `/pgdata`)
**PGBACKREST**|false| Set this value to `true` in order to enable and initialize pgBackRest in the container
**BACKREST_SKIP_CREATE_STANZA**|false| Set this value to `true` in order to skip the configuration check and the automatic creation of a stanza while initializing pgBackRest in the container

## Volumes

**Name**|**Description**
:-----|:-----
**/backrestrepo**|Volume used by the `pgbackrest` backup tool to store physical backups.
**/backup**|Volume used by the `pg_basebackup` backup tool to store physical backups.
**/pgconf**|Volume used to store custom configuration files mounted to the container.
**/pgdata**|Volume used to store the data directory contents for the PostgreSQL database.
**/pgwal**|Volume used to store Write Ahead Log (WAL) when `XLOGDIR` environment variable is set to `true.`
**/recover**|Volume used for Point In Time Recovery (PITR) during startup of the PostgreSQL database.

## Custom Configuration

The following configuration files can be mounted to the `/pgconf` volume in the `crunchy-postgres` container to customize the runtime:

**Name**|**Description**
:-----|:-----
`ca.crt`| Certificate of the CA used by the server when using SSL authentication
`ca.crl`| Revocation list of the CA used by the server when using SSL authentication
`pg_hba.conf`| Client authentication rules for the database
`pg_ident.conf`| Mapping of external users (such as SSL certs, GSSAPI, LDAP) to database users
`postgresql.conf`| PostgreSQL settings
`server.key`| Key used by the server when using SSL authentication
`server.crt`| Certificate used by the server when using SSL authentication
`setup.sql`|Custom SQL to execute against the database.  Note: only run during the first startup (initialization)
