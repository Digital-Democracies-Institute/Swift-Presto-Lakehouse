# Swift-Presto

This is a repository for data warehousing tools.


- [Swift-Presto](#swift-presto)
  - [Getting Started](#getting-started)
    - [1. Install s3cmd](#1-install-s3cmd)
    - [2. Retrieve large library files](#2-retrieve-large-library-files)
    - [3. Install java and mysql](#3-install-java-and-mysql)
    - [4. Set up your environment variables](#4-set-up-your-environment-variables)
    - [5. Configure Presto/Hive/Hadoop with sample S3 and MySQL catalogs](#5-configure-prestohivehadoop-with-sample-s3-and-mysql-catalogs)
    - [6. Start the servers](#6-start-the-servers)
    - [7. Setting up catalogs in Presto](#7-setting-up-catalogs-in-presto)
    - [8. Example of S3 Usage](#8-example-of-s3-usage)
    - [9. Example of mysql usage](#9-example-of-mysql-usage)
  - [Importing CSV files into a partitioned table](#importing-csv-files-into-a-partitioned-table)
    - [1. Importing JSON files into a partitioned table](#1-importing-json-files-into-a-partitioned-table)
    - [2. Importing CSV files into an table with storage in ORC format](#2-importing-csv-files-into-an-table-with-storage-in-orc-format)


## Getting Started

To set up Presto with hive S3,


### 1. Install s3cmd

You need to install and configure s3cmd to retrieve large library files in hadoop-3.3.5 that github would not host.

```
sudo-apt install s3cmd
```

```
s3cmd --configure
```


### 2. Retrieve large library files

Because github won't host large files, we need to manually download them into our directories by running the following commands:

```
cd Swift-Presto-Lakehouse

s3cmd get s3://ddi-git-large-files/hadoop-3.3.5/share/hadoop/tools/lib/aws-java-sdk-bundle-1.12.316.jar hadoop-3.3.5/share/hadoop/tools/lib/

s3cmd get s3://ddi-git-large-files/hadoop-3.3.5/lib/native/libhdfspp.a hadoop-3.3.5/lib/native/

wget https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar
mv mysql-connector-j-8.0.33.jar apache-hive-3.1.3-bin/lib

wget https://repo1.maven.org/maven2/com/facebook/presto/presto-cli/0.279/presto-cli-0.279-executable.jar
mv presto-cli-0.279-executable.jar presto-server-0.279/bin/presto
chmod +x presto-server-0.279/bin/presto
```


### 3. Install java and mysql

Install java 8
```
sudo apt install openjdk-8-jre-headless
```

You also need to install MySQL for the hive metastore database. (The default is debian database but it is not as stable).

```
sudo apt install mysql-server-8.0
```

You can refer to this link[https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-20-04] for instructions on how to configure mysql

### 4. Set up your environment variables

- Add the following environment variables in ~/.bashrc
- Replace [Installed Path to Java], e.g., /usr/lib/jvm/java-8-openjdk-amd64/jre. You can find JAVA_HOME as follows:
```
java -XshowSettings:properties -version 2>&1 > /dev/null | grep 'java.home' 
```
- Replace [Path to Swift-Presto directory] with the directory where you clone the github repository.
  
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

Make sure the new environment variables take effect by sourcing .bashrc
```
source .bashrc
```


### 5. Configure Presto/Hive/Hadoop with sample S3 and MySQL catalogs

You will be prompt a number of questions to retrieve configuration parameters (e.g. S3 Endpoint, S3 Access Key, S3 Secret Key, etc.). This script will then modify the configuration files in presto-server-0.279, hadoop-3.3.5, and apache-hive-3.1.3-bin.

Run the config.sh script:
```
./scripts/config.sh
```

### 6. Start the servers

```
# start the Hadoop Server
start-all.sh

# start the Hive Metastore Service
hive --service metastore &

# start the presto server
launcher start

# run the presto cli
presto --server localhost:8080 --catalog hive_s3

# to run the cli with the 'defaut' schema in debug mode
presto --server localhost:8080 --catalog hive_s3 --schema default --debug
```

To stop the servers

```
# stop the hadoop server
stop-all.sh

# stop the presto server
launcher stop
```

To stop the hive metastore service, you need to find the PID and kill the process.


### 7. Setting up catalogs in Presto

- You can set up different data sources my creating properties files in presto-server-0.279/etc/catalog. The directory contains a couple of sample connectors, one to S3 and one to mysql. For how to set up different connectors, refer to https://prestodb.io/docs/current/connector.html.

### 8. Example of S3 Usage

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

### 9. Example of mysql usage

After setting up a catalog pointing to a MySQL or PostgreSQL server, you can immediately access all the tables in the database. You can also join tables from an S3 catalog and from databases in MySQL or PostgreSQL servers.

#### Example SQL on the 'mysql' catalog pointing to the hive metastore database in a MySQL server
```
SHOW schemas FROM hive_metastore_mysql;
SHOW tables FROM hive_metastore_mysql.hcatalog;
DESCRIBE hive_metastore_mysql.hcatalog.sequence_table;
```
#### Example of select from 'hive_metastore_mysql' catalog
```
SELECT * FROM hive_metastore_mysql.hcatalog.sequence_table;
```

#### Example of joining a table between S3 and MySQL
```
SELECT * FROM ddi_demo.count_posts, hive_metastore_mysql.hcatalog.sequence_table
WHERE CAST(ddi_demo.count_posts.value as BigInt) = hive_metastore_mysql.hcatalog.sequence_table.next_val;
```



# Storing Data in ORC Format for Presto/Hive/S3 Storage
In Presto/Hive, the storage of raw data (in JSON files or CSV files) should be converted to storage in ORC format to optimize performance.

## 1. Importing JSON files into a partitioned table

In Presto/Hive, data can be stored in partitions for optimizing table scanning, and the partitioned data are stored in ORC format (For more on ORC format, see https://cwiki.apache.org/confluence/display/hive/languagemanual+orc). This would optimize the performance for selecting and filtering data from the table.

To convert a text file into ORC format for a partitioned table, the simplest method is to create a table containing the raw data, then use "INSERT/SELECT" statement to import the data into a partitioned table.

E.g., suppose we put the files RC_2023-01-01.json.gz and RC_2023-01-02.json.gz in s3://ddi-techteam-obj-storage/reddit/comments/jan2023/. Then we can create a table of raw data:

```
CREATE TABLE reddit_comments_jan2023_raw (
    json VARCHAR
) WITH (
   format = 'TEXTFILE',
   EXTERNAL_LOCATION = 's3a://ddi-techteam-obj-storage/reddit/comments/jan2023/'
);
```

Then create a table partitioned by dates, with data columns of relevant fields from the json.
```
CREATE TABLE reddit_comments_jan2023 (
    _json VARCHAR,
    _body VARCHAR,
    _author VARCHAR,
    _subreddit VARCHAR,
    _date DATE
) WITH (
   format = 'ORC',
   EXTERNAL_LOCATION = 's3a://ddi-techteam-obj-storage/reddit/comments/jan2023/',
   partitioned_by = ARRAY['_date']
);
```

Then import the data from the raw table into the partitioned table using a INSERT/SELECT statement.

```
INSERT INTO reddit_comments_jan2023
SELECT json,
       CAST(json_extract(json, '$.body') AS VARCHAR),
       CAST(json_extract(json, '$.author') AS VARCHAR),
       CAST(json_extract(json, '$.subreddit') AS VARCHAR),
       DATE(FROM_UNIXTIME(CAST(json_extract(json, '$.created_utc') AS DOUBLE)))
FROM reddit_comments_jan2023_raw;
```

We can then delete the raw table
```
DROP TABLE reddit_comments_jan2023_raw
```
## 2. Importing CSV files into an table with storage in ORC format

The idea is the same as above. We first create a raw table pointing to the CSV file. Then we create a table in ORC format, and move the data from one table to another.

