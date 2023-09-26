#!/usr/bin/env bash


echo -n "Enter your Hive Metstore Connection string [jdbc:mysql://localhost/hcatalog?createDatabaseIfNotExist=true]:"
read HIVE_METASTORE_CONNECTION_URL
export HIVE_METASTORE_CONNECTION_URL=${HIVE_METASTORE_CONNECTION_PASSWORD:-'jdbc:mysql://localhost/hcatalog?createDatabaseIfNotExist=true'}

echo -n "Enter your Hive Metstore Connection Username:"
read HIVE_METASTORE_CONNECTION_USERNAME
export HIVE_METASTORE_CONNECTION_USERNAME=${HIVE_METASTORE_CONNECTION_USERNAME}

echo -n "Enter your Hive Metstore Connection Password:"
read -s HIVE_METASTORE_CONNECTION_PASSWORD
echo
export HIVE_METASTORE_CONNECTION_PASSWORD=${HIVE_METASTORE_CONNECTION_PASSWORD}
 
echo -n "Enter your S3 Endpoint [object-arbutus.cloud.computecanada.ca]:"
read FS_S3A_ENDPOINT
export FS_S3A_ENDPOINT=${FS_S3A_ENDPOINT:-object-arbutus.cloud.computercanada.ca}  

echo -n "Enter your S3 Access Key:"
read -s FS_S3A_ACCESS_KEY
echo
export FS_S3A_ACCESS_KEY=${FS_S3A_ACCESS_KEY}

echo -n "Enter your S3 Secret Key:"
read -s FS_S3A_SECRET_KEY
echo
export FS_S3A_SECRET_KEY=${FS_S3A_SECRET_KEY}

echo -n "Enter whether your S3 uses Path Style Access [true]:"
read FS_S3A_PATH_STYLE_ACCESS
export FS_S3A_PATH_STYLE_ACCESS=${FS_S3A_PATH_STYLE_ACCESS:-true}

echo -n "Enter whether your S3 connection is SSL Enabled Path [true]:"
read FS_S3A_CONNECTION_SSL_ENABLED
export FS_S3A_CONNECTION_SSL_ENABLED=${FS_S3A_CONNECTION_SSL_ENABLED:-true}

echo -n "Enter the path for hadoop hdfs namenode [$HADOOP_HOME/hadoopdata/hdfs/namenode]:"
read HADOOP_DFS_NAME_DIR
export HADOOP_DFS_NAME_DIR=${HADOOP_DFS_NAME_DIR:-$HADOOP_HOME/hadoopdata/hdfs/namenode}

echo -n "Enter the path for hadoop hdfs datanode [$HADOOP_HOME/hadoopdata/hdfs/datanode]:"
read HADOOP_DFS_DATA_DIR
export HADOOP_DFS_DATA_DIR=${HADOOP_DFS_DATA_DIR:-$HADOOP_HOME/hadoopdata/hdfs/datanode}

echo -n "Enter the hive URL [thrift://localhost:9083]:"
read HIVE_THRIFT_URL
export HIVE_THRIFT_URL=${HIVE_THRIFT_URL:-thrift://localhost:9083}

echo -n "Enter Presto plugin directory [$PRESTO_HOME/plugin]:"
read PRESTO_NODE_PLUGIN_DIR
export PRESTO_NODE_PLUGIN_DIR=${PRESTO_NODE_PLUGIN_DIR:-$PRESTO_HOME/plugin}

echo -n "Enter Presto data directory [$PRESTO_HOME/data]:"
read PRESTO_NODE_DATA_DIR
export PRESTO_NODE_DATA_DIR=${PRESTO_NODE_DATA_DIR:-$PRESTO_HOME/data}


cd $SWIFT_PRESTO_HOME/scripts

# Set the user variables for the relevant configuration files in Hive
python hive_config.py

# Set the user variables for the relevant configuration files in Hadoop
python hadoop_config.py

# Set the user variables for the relevant configuration files in Presto
./presto_config.sh

cp $SWIFT_PRESTO_HOME/apache-hive-3.1.3-bin/conf/hive-log4j2.properties.template ../apache-hive-3.1.3-bin/conf/hive-log4j2.properties

