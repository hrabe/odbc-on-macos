# MSSQL Server
[Microsoft SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-2017) is a relational database management system developed by Microsoft.

## Install ODBC driver 
MSSQL Server (and also Sybase) can be accessed using the [FreeTDS](http://www.freetds.org/) driver available at [Homebrew](https://brew.sh/):
```
brew install freetds --with-unixodbc --with-odbc-wide --with-msdblib
```

## Edit FreeTDS configuration file
Check the location of [freetds.conf](http://www.freetds.org/userguide/freetdsconf.htm) by run `tsql -C`. Should get as example:
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

Now edit `/usr/local/etc/freetds.conf` or the user specific `~/.freetds.conf` and append:
```
[Server_MSSQL]
host = localhost
port = 1433
tds version = 7.3
```

## Edit ODBC Driver Manager file
Edit the located [odbcinst.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) (eg. `/usr/local/etc/odbcinst.ini`) and append:
```
[Driver_MSSQL]
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
Driver                 = Driver_MSSQL
Servername             = Server_MSSQL
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
docker pull microsoft/mssql-server-linux:2017-latest
```

### Create a Test Server Container
```
docker create -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=yourStrong(!)Password' -e 'MSSQL_PID=Developer' -e 'no_proxy=*.local, 169.254/16' -p 1433:1433 --name test-server-mssql microsoft/mssql-server-linux:2017-latest
```

### Using the Test Server Container
The Container was created and named **test-server-mssql**. 

#### Start the server
```
docker start test-server-mssql
```

#### Shutdown the server
```
docker stop test-server-mssql
```

#### Destroy the server container
```
docker rm test-server-mssql
```

### Verify ODBC installation using running Server Container
[unixODBC](http://www.unixodbc.org/) comes along with a command line tool to interact with DBMS via ODBC DSN. You can run it using the DNS and Server parameter shown above:

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
