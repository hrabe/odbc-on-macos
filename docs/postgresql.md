# PostgreSQL Server

[PostgreSQL](https://www.postgresql.org), often simply Postgres, is an object-relational database management system (ORDBMS) with an emphasis on extensibility and standards compliance.

## Install ODBC driver 
PostgreSQL ODBC driver is available at [Homebrew](https://brew.sh/):
```
brew install psqlodbc
```

## Edit ODBC Driver Manager file
Edit the located [odbcinst.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) (eg. `/usr/local/etc/odbcinst.ini`) and append:
```
[Driver_PostgreSQL]
Description= PostgreSQL driver for Linux
Driver= /usr/local/lib/psqlodbcw.so
```

## Edit ODBC Data Source file
You can either use the system [odbc.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) or user [.odbc.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) file. As example edit your user file `~/.odbc.ini` and append:
```
[DSN_PostgreSQL]
Description= PostgreSQL Test Server DSN
Driver= Driver_PostgreSQL
Servername= localhost
Port= 5432
User= postgre
Password= yourStrong(!)Password
```

## Use MSSQL Server via Docker Image
[PostgreSql.org](https://www.postgresql.org) provides [official images for Docker Engine](https://store.docker.com/images/postgres). For detailed description about possible environment variables please read this docker image description.

### Server connect parameter
```
Servername: localhost
Port: 5432
User: postgre
Password: yourStrong(!)Password
```

### Download Image
```
docker pull postgres:10.3
```

### Create a Test Server Container
```
docker create -e 'LANG=en_US.utf8' -e 'POSTGRES_PASSWORD=yourStrong(!)Password' -e 'no_proxy=*.local, 169.254/16' -p 5432:5432 --name test-server-postgre postgres:10.3
```

### Using the Test Server Container
The Container was created and named **test-server-postgre**. 

#### Start the server
```
docker start test-server-postgre
```

#### Shutdown the server
```
docker stop test-server-postgre
```

#### Destroy the server container
```
docker rm test-server-postgre
```

### Verify ODBC installation using running Server Container
[unixODBC](http://www.unixodbc.org/) comes along with a command line tool to interact with DBMS via ODBC DSN. You can run it using the DNS and Server parameter shown above:

```
isql DSN_PostgreSQL sa 'yourStrong(!)Password'
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
