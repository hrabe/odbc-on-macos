# odbc-on-macos
How to use databases from different vendors by ODBC drivers on MacOS

## What is ODBC?
In computing, Open Database Connectivity ([ODBC](https://en.wikipedia.org/wiki/Open_Database_Connectivity)) is a standard application programming interface (API)
for accessing database management systems ([DBMS](https://en.wikipedia.org/wiki/Database)). 
The designers of ODBC aimed to make it independent of database systems and operating systems.
An application written using ODBC can be ported to other platforms, both on the client and server side,
with few changes to the data access code.

### Implementation as _iODBC_
[iODBC](http://www.iodbc.org/) is an open source initiative managed by OpenLink Software. 
It is a platform-independent ODBC SDK and runtime offering that enables the development of ODBC-compliant 
applications and drivers outside the Windows platform. ([History](https://en.wikipedia.org/wiki/IODBC#History))

### Implementation as _unixODBC_
[unixODBC](http://www.unixodbc.org/) is an open source project that implements the ODBC API. 
The code is provided under the GNU GPL/LGPL and can be built and used on many different operating systems,
including most versions of Unix, Linux, Mac OS X, IBM OS/2 and Microsoft's Interix. ([History](https://en.wikipedia.org/wiki/UnixODBC#History))

## Choosen for this project: unixODBC

There are 2 simple reason against _iODBC_.

> The tool is included in OS X v10.5 and earlier; users of later versions of OS X need to download and install it manually.

With this statement from Apple you have to install one of the ODBC SDK's in any way, it's not longer pre-installed.

Second: iODBC is **not** available for Microsoft Windows, so you are not able to create real cross platform code bases.

## Prerequisites

### Install Docker Community Edition
To test the ODBC drivers against databases we will use docker images/container to start/stop the required database servers.
Please download [Docker for Mac](https://docs.docker.com/docker-for-mac/install/) and install it.

### Install Homebrew

Install [Homebrew](https://brew.sh/):
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
 
### Install unixODBC
Install [unixODBC](http://www.unixodbc.org/) for MacOS using [Homebrew](https://brew.sh/):
```
brew install unixodbc
```

### Locate your ODBC Driver and Data Source config files
We need the location for later modification to setup ODBC driver and Test DSN entries. Run `odbcinst -j` to get the location of the **odbcinst.ini** and **odbc.ini** files. You should get as example:
```
unixODBC 2.3.6
DRIVERS............: /usr/local/etc/odbcinst.ini
SYSTEM DATA SOURCES: /usr/local/etc/odbc.ini
FILE DATA SOURCES..: /usr/local/etc/ODBCDataSources
USER DATA SOURCES..: /Users/heikorabe/.odbc.ini
SQLULEN Size.......: 8
SQLLEN Size........: 8
SQLSETPOSIROW Size.: 8
```


## Supported DBMS
1. [MSSQL Server](https://github.com/hrabe/odbc-on-macos#mssql-server)
1. [PostgreSQL Server](https://github.com/hrabe/odbc-on-macos#postgresql-server)
1. [Oracle Server](https://github.com/hrabe/odbc-on-macos#oracle-server)
1. [MySQL Server](https://github.com/hrabe/odbc-on-macos#mysql-server)
1. [Firebird Server](https://github.com/hrabe/odbc-on-macos#firebird-server)
1. [SQLite (file based, full scope)](https://github.com/hrabe/odbc-on-macos#sqlite-file-based-full-scope)
1. [MS Access (file based, read only)](https://github.com/hrabe/odbc-on-macos#ms-access-file-based-read-only)

## MSSQL Server

### Install ODBC driver 
MSSQL Server (and also Sybase) can be accessed using the FreeTDS driver available at [Homebrew](https://brew.sh/):
```
brew install freetds --with-unixodbc
```

### Edit FreeTDS configuration file
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

### Edit ODBC Driver Manager file
Edit the located [odbcinst.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) (eg. `/usr/local/etc/odbcinst.ini`) and append:
```
[FreeTDS]
Description     = FreeTDS Driver for Linux & MSSQL
Driver          = /usr/local/lib/libtdsodbc.so
Setup           = /usr/local/lib/libtdsodbc.so
UsageCount      = 1
```

### Edit ODBC Data Source file
You can either use the system [odbc.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) or user [.odbc.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) file. As example edit your user file `~/.odbc.ini` and append:
```
[DSN_MSSQL]
Description            = Test Server MSSQL
Driver                 = FreeTDS
Servername             = MSSQLServer
```

### Use MSSQL Server via Docker Image
Microsoft provides [official images for Microsoft SQL Server on Linux for Docker Engine](https://hub.docker.com/r/microsoft/mssql-server-linux/). For detailed description about possible environment variables please read this docker image description.

#### Server connect parameter
```
Host    : localhost
Port    : 1433
User    : sa
Password: yourStrong(!)Password
```

#### Download Image
```
docker pull microsoft/mssql-server-linux:latest
```

#### Create a Test Server Container
```
docker create -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=yourStrong(!)Password' -e 'MSSQL_PID=Developer' -e 'no_proxy=*.local, 169.254/16' -p 1433:1433 --name test-db-mssql -d microsoft/mssql-server-linux:latest
```

#### Using the Test Server Container
The Container created is named **test-db-mssql**. You can start the server by run `docker start test-db-mssql`, shutdown the server by run `docker stop test-db-mssql` and destroy the server container by run `docker rm test-db-mssql`.

#### Verify ODBC installation using running Server Container
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


## PostgreSQL Server

## Oracle Server

## MySQL Server

## Firebird Server

## SQLite (file based, full scope)

## MS Access (file based, read only)


