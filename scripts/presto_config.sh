#!/usr/bin/env bash

FILE_PRESTO_CATALOG_HIVES3=${PRESTO_HOME}/etc/catalog/hive_s3.properties
FILE_PRESTO_CATALOG_MYSQL=${PRESTO_HOME}/etc/catalog/hive_metastore_mysql.properties
FILE_PRESTO_NODE=${PRESTO_HOME}/etc/node.properties

# Create catalog directory if not exist
mkdir -p ${PRESTO_HOME}/etc/catalog

# Rewrite node.properties file
echo "node.environment=production" > $FILE_PRESTO_NODE
echo "node.id=ffffffff-ffff-ffff-ffff-ffffffffffff" >> $FILE_PRESTO_NODE
echo "node.data-dir="$PRESTO_NODE_DATA_DIR >> $FILE_PRESTO_NODE
echo "plugin.dir="$PRESTO_NODE_PLUGIN_DIR >> $FILE_PRESTO_NODE

# Generate Hive S3 Catalog
echo "connector.name=hive-hadoop2" > $FILE_PRESTO_CATALOG_HIVES3
echo "hive.metastore.uri="$HIVE_THRIFT_URL >> $FILE_PRESTO_CATALOG_HIVES3
echo "hive.s3.path-style-access="$FS_S3A_PATH_STYLE_ACCESS >> $FILE_PRESTO_CATALOG_HIVES3
echo "hive.s3.endpoint="$FS_S3A_ENDPOINT >> $FILE_PRESTO_CATALOG_HIVES3
echo "hive.s3.aws-access-key="$FS_S3A_ACCESS_KEY >> $FILE_PRESTO_CATALOG_HIVES3
echo "hive.s3.aws-secret-key="$FS_S3A_SECRET_KEY >> $FILE_PRESTO_CATALOG_HIVES3
echo "hive.non-managed-table-writes-enabled=true" >> $FILE_PRESTO_CATALOG_HIVES3
echo "hive.respect-table-format=false" >> $FILE_PRESTO_CATALOG_HIVES3
echo "hive.create-empty-bucket-files=false" >> $FILE_PRESTO_CATALOG_HIVES3
echo "hive.s3select-pushdown.enabled=false" >> $FILE_PRESTO_CATALOG_HIVES3

# Generate Hive Metastore MYSQL Catalog
echo "connector.name=mysql" > $FILE_PRESTO_CATALOG_MYSQL
echo "connection-url=jdbc:mysql://localhost:3306" >> $FILE_PRESTO_CATALOG_MYSQL
echo "connection-user="$HIVE_METASTORE_CONNECTION_USERNAME >> $FILE_PRESTO_CATALOG_MYSQL
echo "connection-password="$HIVE_METASTORE_CONNECTION_PASSWORD >> $FILE_PRESTO_CATALOG_MYSQL
echo "case-insensitive-name-matching=true" >> $FILE_PRESTO_CATALOG_MYSQL
