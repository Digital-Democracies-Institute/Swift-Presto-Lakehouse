import os
from xml_utils import modify_xml_config

# Get S3 parameters
FS_S3A_ENDPOINT = os.environ.get('FS_S3A_ENDPOINT')
FS_S3A_ACCESS_KEY = os.environ.get('FS_S3A_ACCESS_KEY')
FS_S3A_SECRET_KEY = os.environ.get('FS_S3A_SECRET_KEY')
FS_S3A_PATH_STYLE_ACCESS = os.environ.get('FS_S3A_PATH_STYLE_ACCESS')
FS_S3A_CONNECTION_SSL_ENABLED = os.environ.get('FS_S3A_CONNECTION_SSL_ENABLED')

# Get Hive Metastore Database connection parameters
HIVE_METASTORE_CONNECTION_URL = os.environ.get('HIVE_METASTORE_CONNECTION_URL')
HIVE_METASTORE_CONNECTION_USERNAME = os.environ.get('HIVE_METASTORE_CONNECTION_USERNAME')
HIVE_METASTORE_CONNECTION_PASSWORD = os.environ.get('HIVE_METASTORE_CONNECTION_PASSWORD')


template_file = '../apache-hive-3.1.3-bin/conf/hive-default.xml.template'
output_file = '../apache-hive-3.1.3-bin/conf/hive-site.xml'

modifications = {
    "property[name='javax.jdo.option.ConnectionURL']/value" : HIVE_METASTORE_CONNECTION_URL,
    "property[name='javax.jdo.option.ConnectionUserName']/value" : HIVE_METASTORE_CONNECTION_USERNAME,
    "property[name='javax.jdo.option.ConnectionPassword']/value" : HIVE_METASTORE_CONNECTION_PASSWORD,
    "property[name='javax.jdo.option.ConnectionDriverName']/value": 'com.mysql.jdbc.Driver',

    "property[name='fs.s3a.path.style.access']/value": FS_S3A_PATH_STYLE_ACCESS,
    "property[name='fs.s3a.connection.ssl.enabled']/value": FS_S3A_CONNECTION_SSL_ENABLED,
    "property[name='fs.s3a.access.key']/value": FS_S3A_ACCESS_KEY,
    "property[name='fs.s3a.secret.key']/value": FS_S3A_SECRET_KEY,
    "property[name='fs.s3a.awsAccessKeyId']/value": FS_S3A_ACCESS_KEY,
    "property[name='fs.s3a.awsSecretAccessKey']/value": FS_S3A_SECRET_KEY,
    "property[name='fs.s3a.endpoint']/value": FS_S3A_ENDPOINT
}

modify_xml_config(template_file, output_file, modifications)


