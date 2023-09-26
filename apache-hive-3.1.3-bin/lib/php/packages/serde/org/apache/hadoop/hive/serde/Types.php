<?php
namespace org\apache\hadoop\hive\serde;

/**
 * Autogenerated by Thrift Compiler (0.9.3)
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated
 */
use Thrift\Base\TBase;
use Thrift\Type\TType;
use Thrift\Type\TMessageType;
use Thrift\Exception\TException;
use Thrift\Exception\TProtocolException;
use Thrift\Protocol\TProtocol;
use Thrift\Protocol\TBinaryProtocolAccelerated;
use Thrift\Exception\TApplicationException;


final class Constant extends \Thrift\Type\TConstant {
  static protected $SERIALIZATION_LIB;
  static protected $SERIALIZATION_CLASS;
  static protected $SERIALIZATION_FORMAT;
  static protected $SERIALIZATION_DDL;
  static protected $SERIALIZATION_NULL_FORMAT;
  static protected $SERIALIZATION_ESCAPE_CRLF;
  static protected $SERIALIZATION_LAST_COLUMN_TAKES_REST;
  static protected $SERIALIZATION_SORT_ORDER;
  static protected $SERIALIZATION_NULL_SORT_ORDER;
  static protected $SERIALIZATION_USE_JSON_OBJECTS;
  static protected $SERIALIZATION_ENCODING;
  static protected $FIELD_DELIM;
  static protected $COLLECTION_DELIM;
  static protected $LINE_DELIM;
  static protected $MAPKEY_DELIM;
  static protected $QUOTE_CHAR;
  static protected $ESCAPE_CHAR;
  static protected $HEADER_COUNT;
  static protected $FOOTER_COUNT;
  static protected $VOID_TYPE_NAME;
  static protected $BOOLEAN_TYPE_NAME;
  static protected $TINYINT_TYPE_NAME;
  static protected $SMALLINT_TYPE_NAME;
  static protected $INT_TYPE_NAME;
  static protected $BIGINT_TYPE_NAME;
  static protected $FLOAT_TYPE_NAME;
  static protected $DOUBLE_TYPE_NAME;
  static protected $STRING_TYPE_NAME;
  static protected $CHAR_TYPE_NAME;
  static protected $VARCHAR_TYPE_NAME;
  static protected $DATE_TYPE_NAME;
  static protected $DATETIME_TYPE_NAME;
  static protected $TIMESTAMP_TYPE_NAME;
  static protected $DECIMAL_TYPE_NAME;
  static protected $BINARY_TYPE_NAME;
  static protected $INTERVAL_YEAR_MONTH_TYPE_NAME;
  static protected $INTERVAL_DAY_TIME_TYPE_NAME;
  static protected $TIMESTAMPLOCALTZ_TYPE_NAME;
  static protected $LIST_TYPE_NAME;
  static protected $MAP_TYPE_NAME;
  static protected $STRUCT_TYPE_NAME;
  static protected $UNION_TYPE_NAME;
  static protected $LIST_COLUMNS;
  static protected $LIST_COLUMN_TYPES;
  static protected $TIMESTAMP_FORMATS;
  static protected $COLUMN_NAME_DELIMITER;
  static protected $PrimitiveTypes;
  static protected $CollectionTypes;
  static protected $IntegralTypes;

  static protected function init_SERIALIZATION_LIB() {
    return "serialization.lib";
  }

  static protected function init_SERIALIZATION_CLASS() {
    return "serialization.class";
  }

  static protected function init_SERIALIZATION_FORMAT() {
    return "serialization.format";
  }

  static protected function init_SERIALIZATION_DDL() {
    return "serialization.ddl";
  }

  static protected function init_SERIALIZATION_NULL_FORMAT() {
    return "serialization.null.format";
  }

  static protected function init_SERIALIZATION_ESCAPE_CRLF() {
    return "serialization.escape.crlf";
  }

  static protected function init_SERIALIZATION_LAST_COLUMN_TAKES_REST() {
    return "serialization.last.column.takes.rest";
  }

  static protected function init_SERIALIZATION_SORT_ORDER() {
    return "serialization.sort.order";
  }

  static protected function init_SERIALIZATION_NULL_SORT_ORDER() {
    return "serialization.sort.order.null";
  }

  static protected function init_SERIALIZATION_USE_JSON_OBJECTS() {
    return "serialization.use.json.object";
  }

  static protected function init_SERIALIZATION_ENCODING() {
    return "serialization.encoding";
  }

  static protected function init_FIELD_DELIM() {
    return "field.delim";
  }

  static protected function init_COLLECTION_DELIM() {
    return "collection.delim";
  }

  static protected function init_LINE_DELIM() {
    return "line.delim";
  }

  static protected function init_MAPKEY_DELIM() {
    return "mapkey.delim";
  }

  static protected function init_QUOTE_CHAR() {
    return "quote.delim";
  }

  static protected function init_ESCAPE_CHAR() {
    return "escape.delim";
  }

  static protected function init_HEADER_COUNT() {
    return "skip.header.line.count";
  }

  static protected function init_FOOTER_COUNT() {
    return "skip.footer.line.count";
  }

  static protected function init_VOID_TYPE_NAME() {
    return "void";
  }

  static protected function init_BOOLEAN_TYPE_NAME() {
    return "boolean";
  }

  static protected function init_TINYINT_TYPE_NAME() {
    return "tinyint";
  }

  static protected function init_SMALLINT_TYPE_NAME() {
    return "smallint";
  }

  static protected function init_INT_TYPE_NAME() {
    return "int";
  }

  static protected function init_BIGINT_TYPE_NAME() {
    return "bigint";
  }

  static protected function init_FLOAT_TYPE_NAME() {
    return "float";
  }

  static protected function init_DOUBLE_TYPE_NAME() {
    return "double";
  }

  static protected function init_STRING_TYPE_NAME() {
    return "string";
  }

  static protected function init_CHAR_TYPE_NAME() {
    return "char";
  }

  static protected function init_VARCHAR_TYPE_NAME() {
    return "varchar";
  }

  static protected function init_DATE_TYPE_NAME() {
    return "date";
  }

  static protected function init_DATETIME_TYPE_NAME() {
    return "datetime";
  }

  static protected function init_TIMESTAMP_TYPE_NAME() {
    return "timestamp";
  }

  static protected function init_DECIMAL_TYPE_NAME() {
    return "decimal";
  }

  static protected function init_BINARY_TYPE_NAME() {
    return "binary";
  }

  static protected function init_INTERVAL_YEAR_MONTH_TYPE_NAME() {
    return "interval_year_month";
  }

  static protected function init_INTERVAL_DAY_TIME_TYPE_NAME() {
    return "interval_day_time";
  }

  static protected function init_TIMESTAMPLOCALTZ_TYPE_NAME() {
    return "timestamp with local time zone";
  }

  static protected function init_LIST_TYPE_NAME() {
    return "array";
  }

  static protected function init_MAP_TYPE_NAME() {
    return "map";
  }

  static protected function init_STRUCT_TYPE_NAME() {
    return "struct";
  }

  static protected function init_UNION_TYPE_NAME() {
    return "uniontype";
  }

  static protected function init_LIST_COLUMNS() {
    return "columns";
  }

  static protected function init_LIST_COLUMN_TYPES() {
    return "columns.types";
  }

  static protected function init_TIMESTAMP_FORMATS() {
    return "timestamp.formats";
  }

  static protected function init_COLUMN_NAME_DELIMITER() {
    return "column.name.delimiter";
  }

  static protected function init_PrimitiveTypes() {
    return array(
      "void" => true,
      "boolean" => true,
      "tinyint" => true,
      "smallint" => true,
      "int" => true,
      "bigint" => true,
      "float" => true,
      "double" => true,
      "string" => true,
      "varchar" => true,
      "char" => true,
      "date" => true,
      "datetime" => true,
      "timestamp" => true,
      "interval_year_month" => true,
      "interval_day_time" => true,
      "decimal" => true,
      "binary" => true,
      "timestamp with local time zone" => true,
    );
  }

  static protected function init_CollectionTypes() {
    return array(
      "array" => true,
      "map" => true,
    );
  }

  static protected function init_IntegralTypes() {
    return array(
      "tinyint" => true,
      "smallint" => true,
      "int" => true,
      "bigint" => true,
    );
  }
}


