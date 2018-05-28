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

## Manual Setup - the complete, hard way
1. [MSSQL Server](https://github.com/hrabe/odbc-on-macos/blob/master/docs/mssql.md)
1. [PostgreSQL Server](https://github.com/hrabe/odbc-on-macos/blob/master/docs/postgresql.md)
1. [Oracle Server](https://github.com/hrabe/odbc-on-macos/blob/master/docs/oracle.md)
1. [MySQL Server](https://github.com/hrabe/odbc-on-macos/blob/master/docs/mysql.md)
1. [Firebird Server](https://github.com/hrabe/odbc-on-macos/blob/master/docs/firebird.md)
1. [IBM DB2 Server](https://github.com/hrabe/odbc-on-macos/blob/master/docs/db2.md)
1. [~~SQLite (file based, full scope)~~](https://github.com/hrabe/odbc-on-macos/blob/master/docs/sqlite.md)
1. [~~MS Access (file based, read only)~~](https://github.com/hrabe/odbc-on-macos/blob/master/docs/msaccess.md)


## Automatic Setup - The easy, lazy way

- tbd.
