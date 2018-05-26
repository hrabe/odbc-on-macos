# MySQL Server
[MySQL](https://www.mysql.com) is an open-source relational database management system (RDBMS). MySQL was owned and sponsored by a single for-profit firm, the Swedish company MySQL AB, now owned by [Oracle Corporation](https://www.oracle.com/index.html).

## Install ODBC driver
Unfortunately the driver must be compiled from C/C++ sources. This requires the Header and Lib files from MySQL Server.
MySql Server is available at [Homebrew](https://brew.sh/):
```
brew install mysql
```
You will also need [cmake](https://cmake.org) installed. It's available at [Homebrew](https://brew.sh/) as well:
```
brew install cmake
```

[Download Connector/ODBC](https://dev.mysql.com/downloads/connector/odbc/) as Source Code for Generic Linux (Architecture Independent), Compressed TAR Archive in Version 5.3.10 or direct by [mysql-connector-odbc-5.3.10-src.tar.gz](https://dev.mysql.com/get/Downloads/Connector-ODBC/5.3/mysql-connector-odbc-5.3.10-src.tar.gz)

Configure and build the drivers:
```
tar xvzf mysql-connector-odbc-5.3.10-src.tar.gz -C /usr/local/share/odbc_mysql
cd /usr/local/share/odbc_mysql/mysql-connector-odbc-5.3.10-src
mkdir _build
cd _build
cmake -DWITH_UNIXODBC=1 -DODBC_LIB_DIR=/usr/local/Cellar/unixodbc/2.3.6/lib -DODBC_INCLUDES=/usr/local/Cellar/unixodbc/2.3.6/include -DMYSQL_LIBRARIES='mysql_sys;mysql_strings;mysqlclient' -DMYSQL_CONFIG_EXECUTABLE= ..
make myodbc5w
make myodbc5a
```

The MySQL ODBC libraries need to be in the macOS library search path:

```
cd /usr/local/share/odbc_mysql/mysql-connector-odbc-5.3.10-src/_build/lib
ln -s $(pwd)/libmyodbc5w.so /usr/local/lib
ln -s $(pwd)/libmyodbc5a.so /usr/local/lib
```

## Edit ODBC Driver Manager file
Edit the located [odbcinst.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) (eg. `/usr/local/etc/odbcinst.ini`) and append:
```
[Driver_MySQL]
Description= MySQL ODBC Unicode driver for linux
Driver= /usr/local/lib/libmyodbc5w.so
```
This uses the Unicode driver `libmyodbc5w.so` but you can also use an Ansi driver as `libmyodbc5a.so`.

## Edit ODBC Data Source file
You can either use the system [odbc.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) or user [.odbc.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) file. As example edit your user file `~/.odbc.ini` and append:
```
[DSN_MySQL]
Description= MySQL Test Server DSN
Driver= Driver_MySQL
Server= 127.0.0.1
Port= 3306
Database= test
User= root
Password= yourStrong(!)Password
OPTION= 3
```

## Use MySQL Server via Docker Image
Optimized [MySQL Server Docker images](https://hub.docker.com/r/mysql/mysql-server/). Created, maintained and supported by the MySQL team at [Oracle Corporation](https://www.oracle.com/index.html). For detailed description about possible environment variables please read this docker image description.

### Server connect parameter
```
Servername: localhost
Port: 3306
User: root
Password: yourStrong(!)Password
```

### Download Image
```
docker pull mysql/mysql-server:5.7
```

### Create a Test Server Container
```
docker create -e 'MYSQL_DATABASE=test' -e 'MYSQL_ROOT_PASSWORD=yourStrong(!)Password' -e 'MYSQL_USER=mysql' -e 'MYSQL_PASSWORD=yourStrong(!)Password' -e 'MYSQL_ROOT_HOST=%' -e 'no_proxy=*.local, 169.254/16' -p 3306:3306 --name test-server-mysql mysql/mysql-server:5.7
```

### Using the Test Server Container
The Container was created and named **test-server-mysql**. 

#### Start the server
```
docker start test-server-mysql
```

#### Shutdown the server
```
docker stop test-server-mysql
```

#### Destroy the server container
```
docker rm test-server-mysql
```

### Verify ODBC installation using running Server Container
[unixODBC](http://www.unixodbc.org/) comes along with a command line tool to interact with DBMS via ODBC DSN. You can run it using the DNS and Server parameter shown above:

```
isql DSN_MySQL root 'yourStrong(!)Password'
```

You should get on success case:
```
+---------------------------------------+
| Connected!                            |
|                                       |
| sql-statement                         |
| help [tablename]                      |
| quit                                  |
|                                       |
+---------------------------------------+
SQL>
```
