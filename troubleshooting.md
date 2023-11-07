# Troubleshooting

- [Troubleshooting](#troubleshooting)
  - [Turning on DEBUG Logs](#turning-on-debug-logs)
  - [Check the values of a property](#check-the-values-of-a-property)
  - [Capture networking packets](#capture-networking-packets)
  - [SSL Handshake](#ssl-handshake)
  

## Turning on DEBUG Logs

By default, the logging level for HADOOP, HIVE, and PRESTO are set at INFO.

To troubleshoot, you can change the logging properties in the following files:


### Modify $HADOOP_HOME/etc/hadoop/log4j.properties
```
hadoop.root.logger=DEBUG,console
```

### Modify $HIVE_HOME/conf/hive-log4j2.properties
```
property.hive.log.level = DEBUG
```

```
property.hive.perflogger.log.level = DEBUG
```

```
# This would capture the detailed activities of the Datastore classes
logger.Datastore.name = Datastore
logger.Datastore.level = DEBUG
```

```
# This would capture the detailed activities of the com.amazonaws classes
logger.AmazonAws.name=com.amazonaws
logger.AmazonAws.level = DEBUG`
```

```
# This would capture the detailed activites of the org.apache.http classes
logger.ApacheHttp.name=org.apache.http
logger.ApacheHttp.level = DEBUG
```

### Modify $PRESTO_HOME/etc/log.properties
```
com.facebook.presto=DEBUG
```

## Check the values of a property

Instead of starting the hive as a service, you can enter into command-line mode:
```
/home/4cat$ hive
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/home/lofelix/github/ddi/Swift-Presto-Lakehouse/apache-hive-3.1.3-bin/lib/log4j-slf4j-impl-2.17.1.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/home/lofelix/github/ddi/Swift-Presto-Lakehouse/hadoop-3.3.5/share/hadoop/common/lib/slf4j-reload4j-1.7.36.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [org.apache.logging.slf4j.Log4jLoggerFactory]
Hive Session ID = b5610332-9106-4cc5-aa12-c390313d1a8b

Logging initialized using configuration in file:/home/lofelix/github/ddi/Swift-Presto-Lakehouse/apache-hive-3.1.3-bin/conf/hive-log4j2.properties Async: true
Loading class `com.mysql.jdbc.Driver'. This is deprecated. The new driver class is `com.mysql.cj.jdbc.Driver'. The driver is automatically registered via the SPI and manual loading of the driver class is generally unnecessary.
Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
Hive Session ID = 451e2d53-95e6-4909-9b4e-5fb6f073a6f3

hive>
```

You can then find out the value of a property by calling "set <property_name>"
```
hive> set fs.s3a.ssl.channel.mode;
fs.s3a.ssl.channel.mode=default_jsse

hive>
```

## Capture networking packets

You can use tshark to capture networking packets, such as those between the HADOOP/HIVE services and S3 server as follows:
```
# ens3 is the interface
# -V would show the packet details
# -Y specifiy the filter string
# 206.12.48.146 is the IP address of the server
/home/4cat$ sudo tshark -V -i ens3 -Y "ip.addr==206.12.48.146"
```

## SSL Handshake

HADOOP can only connect to our S3 server, object-arbutus.computecanada.ca, with SSL enabled.

It appears that HADOOP has a default mechanism of removing GSM-related Cipher suites to
speed up the performance. If this removal is not triggered, the SSL handshake would be successful.
If those cipher suites are removed, the handhshake would fail with the settings in
object-arbutus.computecanada.ca.

It is a bit of a mystery when this removal would be triggered. In order to force HADOOP not
to remove these cipher suites, we need to set fs.s3a.ssl.channel.mode=default_jsse_with_gcm.