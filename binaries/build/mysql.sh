#!/bin/sh
pushd $1/mysql-connector-odbc-5.3.10-src > /dev/null
mkdir Release_x86_64
cd Release_x86_64

cmake \
  -DWITH_UNIXODBC=1 \
  -DODBC_LIB_DIR=/usr/local/Cellar/unixodbc/2.3.6/lib \
  -DODBC_INCLUDES=/usr/local/Cellar/unixodbc/2.3.6/include \
  -DMYSQL_LIB_DIR=/usr/local/opt/mysql@5.7/lib \
  -DMYSQL_INCLUDE_DIR=/usr/local/opt/mysql@5.7/include/mysql \
  -DMYSQL_LIBRARIES='mysql_sys;mysql_strings;mysqlclient' \
  -DMYSQL_CONFIG_EXECUTABLE= ..
make myodbc5a
make myodbc5w
popd > /dev/null
