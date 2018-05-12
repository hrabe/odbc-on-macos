# MSSQL Server

## Install ODBC driver 
MSSQL Server (and also Sybase) can be accessed using the FreeTDS driver available at [Homebrew](https://brew.sh/):
```
brew install freetds --with-unixodbc
```

## Edit FreeTDS configuration file
Check the location of **freetds.conf** by run `tsql -C`. Should get as example:
```
Compile-time settings (established with the "configure" script)
                            Version: freetds v1.00.91
             freetds.conf directory: /usr/local/etc
     MS db-lib source compatibility: no
        Sybase binary compatibility: no
                      Thread safety: yes
                      iconv library: yes
                        TDS version: 7.3
                              iODBC: no
                           unixodbc: yes
              SSPI "trusted" logins: no
                           Kerberos: no
                            OpenSSL: yes
                             GnuTLS: no
                               MARS: no
```

Now edit `/usr/local/etc/freetds.conf` and append:
```
[MSSQLServer]
host = localhost
port = 1433
tds version = 7.3
```

## Edit ODBC Driver Manager file
Edit the located [odbcinst.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) (eg. `/usr/local/etc/odbcinst.ini`) and append:
```
[FreeTDS]
Description     = FreeTDS Driver for Linux & MSSQL
Driver          = /usr/local/lib/libtdsodbc.so
Setup           = /usr/local/lib/libtdsodbc.so
UsageCount      = 1
```

## Edit ODBC Data Source file
You can either use the system [odbc.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) or user [.odbc.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) file. As example edit your user file `~/.odbc.ini` and append:
```
[DSN_MSSQL]
Description            = Test Server MSSQL
Driver                 = FreeTDS
Servername             = MSSQLServer
```

## Use MSSQL Server via Docker Image
Microsoft provides [official images for Microsoft SQL Server on Linux for Docker Engine](https://hub.docker.com/r/microsoft/mssql-server-linux/). For detailed description about possible environment variables please read this docker image description.

### Server connect parameter
```
Host    : localhost
Port    : 1433
User    : sa
Password: yourStrong(!)Password
```

### Download Image
```
docker pull microsoft/mssql-server-linux:latest
```

### Create a Test Server Container
```
docker create -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=yourStrong(!)Password' -e 'MSSQL_PID=Developer' -e 'no_proxy=*.local, 169.254/16' -p 1433:1433 --name test-db-mssql -d microsoft/mssql-server-linux:latest
```

### Using the Test Server Container
The Container created is named **test-db-mssql**. You can start the server by run `docker start test-db-mssql`, shutdown the server by run `docker stop test-db-mssql` and destroy the server container by run `docker rm test-db-mssql`.

### Verify ODBC installation using running Server Container
[unixODBC](http://www.unixodbc.org/) comes with a command line tool to interact with DBMS via ODBC DSN. You can run it using the Server parameter shown above:

```
isql DSN_MSSQL sa 'yourStrong(!)Password'
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