# Swift-Presto

This is a repository for data warehousing tools.

To set up Presto with hive S3,


## 1) Install s3cmd

You need to install and configure s3cmd to retrieve large library files in hadoop-3.3.5 that github would not host.

## 2) Retrieve large library files for hadoop-3.3.5 from our S3 server.

Run the following command

```
s3cmd get s3://ddi-git-large-files/hadoop-3.3.5/share/hadoop/tools/lib/aws-java-sdk-bundle-1.12.316.jar hadoop-3.3.5/share/hadoop/tools/lib/

s3cmd get s3://ddi-git-large-files/hadoop-3.3.5/lib/native/libhdfspp.a hadoop-3.3.5/lib/native/
```

## 3) Install mysql

You need to install MySQL for the hive metastore database. (The default is debian database but it is not as stable).

## 4) Set up your environment variables

- Add the following environment variables in ~/.bashrc
- Replace [Path to Swift-Presto directory] with the directory where you clone the github repository.
- Replace [Installed Path to Java], e.g., /usr/lib/jvm/java-8-openjdk-amd64. You can find out your the path by running 'which java' on the command prompt.

```
# Environment variables for JAVA
export JAVA_HOME=[installed path for Java]
export PATH=$JAVA_HOME/bin:$PATH

# Environment variables for Swift-Presto
export SWIFT_PRESTO_HOME=[Path to Swift-Presto directory]

# Environment variables for Hadoop
export HADOOP_HOME=$SWIFT_PRESTO_HOME/hadoop-3.3.5
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:$HADOOP_HOME/share/hadoop/tools/lib/

# Environment variables for Hive
export HIVE_HOME=$SWIFT_PRESTO_HOME/apache-hive-3.1.3-bin
export PATH=$PATH:$HIVE_HOME/bin
export HIVE_AUX_JARS_PATH=$HADOOP_HOME/share/hadoop/tools/lib/

# Environment variables for Presto
export PRESTO_HOME=$SWIFT_PRESTO_HOME/presto-server-0.279
export PATH=$PATH:$PRESTO_HOME/bin
```

## 5) Configure Presto/Hive/Hadoop with sample S3 and MySQL catalogs

You will be prompt a number of questions to retrieve configuration parameters (e.g. S3 Endpoint, S3 Access Key, S3 Secret Key, etc.). This script will then modify the configuration files in presto-server-0.279, hadoop-3.3.5, and apache-hive-3.1.3-bin.

```
Run ./scripts/config.sh
```

## 6) Start the servers

```
# start the Hadoop Server
start-all.sh

# start the Hive Metastore Service
hive --service metastore &

# start the presto server
launcher start

# run the presto cli
presto --server localhost:8080 --catalog hive

# to run the cli with the 'defaut' schema in debug mode
presto --server localhost:8080 --catalog hive --schema default --debug
```

To stop the servers

```
# stop the hadoop server
stop-all.sh

# stop the presto server
launcher stop
```

To stop the hive metastore service, you need to find the PID and kill the process.


## 7) Setting up catalogs in Presto

- You can set up different data sources my creating properties files in presto-server-0.279/etc/catalog. The directory contains a couple of sample connectors, one to S3 and one to mysql. For how to set up different connectors, refer to https://prestodb.io/docs/current/connector.html.

## 8) Example of S3 Usage

The following is an example of accessing S3 Data through Presto, using some demo data currently set up in our S3 server.


#### Create Database Schema
```
CREATE SCHEMA ddi_demo;
USE ddi_demo;
```

#### Create Tables mapping to the S3 Storage
```
CREATE TABLE count_posts (
       datestr varchar,
       item varchar,
       value varchar
) WITH (
     format = 'CSV',
     EXTERNAL_LOCATION = 's3a://ddi-techteam-obj-storage/count-posts'
);

CREATE TABLE queryresults (
       query_type varchar,
       query varchar,
       id varchar,
       thread_id varchar,
       subject varchar,
       body varchar,
       author varchar,
       author_id varchar,
       time_stamp varchar,
       url varchar,
       views varchar,
       length varchar,
       thumbnail_image varchar,
       unix_timestamp varchar
) WITH (  
  format = 'CSV',
  EXTERNAL_LOCATION = 's3a://ddi-techteam-obj-storage/queryresults'
); 

CREATE TABLE twitter_json (
    json VARCHAR
) WITH (
   format = 'TEXTFILE',
   EXTERNAL_LOCATION = 's3a://ddi-techteam-obj-storage/twitter-json'
);
```

#### Example SQL
```
SELECT * FROM count_posts;

SELECT * FROM queryresults;

SELECT * from count_posts_5 WHERE value='1';

SELECT json_extract(json, '$.core.user_results.result.legacy.entities') from twitter_json;

INSERT INTO count_posts VALUES ('2023-09', 'actvity', '1');
```

## 9) Example of mysql usage

After setting up a catalog pointing to a MySQL or PostgreSQL server, you can immediately access all the tables in the database. You can also join tables from an S3 catalog and from databases in MySQL or PostgreSQL servers.

#### Example SQL on the 'mysql' catalog pointing to the hive metastore database in a MySQL server
```
SHOW schemas FROM mysql;
SHOW tables FROM mysql.hcatalog;
DESCRIBE mysql.hcatalog.sequence_table;
```
#### Example of select from 'mysql' catalog
```
SELECT * FROM mysql.hcatalog.sequence_table;
```

#### Example of joining a table between S3 and MySQL
```
SELECT * FROM ddi_demo.count_posts, mysql.hcatalog.sequence_table
WHERE CAST(ddi_demo.count_posts.value as BigInt) = mysql.hcatalog.sequence_table.next_val;
```
