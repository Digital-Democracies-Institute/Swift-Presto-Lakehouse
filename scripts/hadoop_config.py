import os
from xml_utils import modify_xml_config

FS_S3A_ENDPOINT = os.environ.get('FS_S3A_ENDPOINT')
FS_S3A_ACCESS_KEY = os.environ.get('FS_S3A_ACCESS_KEY')
FS_S3A_SECRET_KEY = os.environ.get('FS_S3A_SECRET_KEY')
FS_S3A_PATH_STYLE_ACCESS = os.environ.get('FS_S3A_PATH_STYLE_ACCESS')
FS_S3A_CONNECTION_SSL_ENABLED = os.environ.get('FS_S3A_CONNECTION_SSL_ENABLED')

HADOOP_HOME_DIR = os.environ.get('HADOOP_HOME')
DFS_NAME_DIR = os.environ.get('HADOOP_DFS_NAME_DIR') 
DFS_DATA_DIR = os.environ.get('HADOOP_DFS_DATA_DIR')

template_file = HADOOP_HOME_DIR + '/etc/hadoop/core-site.xml.template'
output_file = HADOOP_HOME_DIR + '/etc/hadoop/core-site.xml'

modifications_coresite = {
    "property[name='fs.s3a.path.style.access']/value": FS_S3A_PATH_STYLE_ACCESS,
    "property[name='fs.s3a.connection.ssl.enabled']/value": FS_S3A_CONNECTION_SSL_ENABLED,
    "property[name='fs.s3a.access.key']/value": FS_S3A_ACCESS_KEY,
    "property[name='fs.s3a.secret.key']/value": FS_S3A_SECRET_KEY,
    "property[name='fs.s3a.awsAccessKeyId']/value": FS_S3A_ACCESS_KEY,
    "property[name='fs.s3a.awsSecretAccessKey']/value": FS_S3A_SECRET_KEY,
    "property[name='fs.s3a.endpoint']/value": FS_S3A_ENDPOINT
}

modify_xml_config(template_file, output_file, modifications_coresite)


template_file = HADOOP_HOME_DIR + '/etc/hadoop/hdfs-site.xml.template'
output_file = HADOOP_HOME_DIR + '/etc/hadoop/hdfs-site.xml'

modifications_hdfs = {
    "property[name='dfs.name.dir']/value": DFS_NAME_DIR,
    "property[name='dfs.data.dir']/value": DFS_DATA_DIR,

    "property[name='fs.s3a.path.style.access']/value": FS_S3A_PATH_STYLE_ACCESS,
    "property[name='fs.s3a.connection.ssl.enabled']/value": FS_S3A_CONNECTION_SSL_ENABLED,
    "property[name='fs.s3a.access.key']/value": FS_S3A_ACCESS_KEY,
    "property[name='fs.s3a.secret.key']/value": FS_S3A_SECRET_KEY,
    "property[name='fs.s3a.awsAccessKeyId']/value": FS_S3A_ACCESS_KEY,
    "property[name='fs.s3a.awsSecretAccessKey']/value": FS_S3A_SECRET_KEY,
    "property[name='fs.s3a.endpoint']/value": FS_S3A_ENDPOINT
}

modify_xml_config(template_file, output_file, modifications_hdfs)

