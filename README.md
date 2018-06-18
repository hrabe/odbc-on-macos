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
1. [MSSQL Server](https://github.com/hrabe/odbc-on-macos/blob/master/docs/mssql.md) - using Microsoft ODBC Driver 17 for SQL Server
1. [MSSQL Server](https://github.com/hrabe/odbc-on-macos/blob/master/docs/freetds.md) - using FreeTDS Driver for Linux & MSSQL
1. [PostgreSQL Server](https://github.com/hrabe/odbc-on-macos/blob/master/docs/postgresql.md)
1. [Oracle Server](https://github.com/hrabe/odbc-on-macos/blob/master/docs/oracle.md)
1. [MySQL Server](https://github.com/hrabe/odbc-on-macos/blob/master/docs/mysql.md)
1. [Firebird Server](https://github.com/hrabe/odbc-on-macos/blob/master/docs/firebird.md)
1. [IBM DB2 Server](https://github.com/hrabe/odbc-on-macos/blob/master/docs/db2.md)
1. [~~SQLite (file based, full scope)~~](https://github.com/hrabe/odbc-on-macos/blob/master/docs/sqlite.md)
1. [~~MS Access (file based, read only)~~](https://github.com/hrabe/odbc-on-macos/blob/master/docs/msaccess.md)


## Automatic Setup - The easy, lazy way

To get all the manual steps automated (including compile of drivers) several ruby rake task will be provided.

### Install pre-requisits

I would suggest to use [rbenv](https://github.com/rbenv/rbenv) ruby version manager. Install it with:
```
brew install rbenv
```

Next you will need to install a working ruby version:
```
rbenv install 2.5.0
rbenv global 2.5.0
``` 

To get the rake tasks working the bundler gem is required and you should update your gems:
```
gem install bundler
bundle install
```

### List all rake tasks available

To get a list of all available rake task run:
```
rake -T
```

You should get such a list:
```
rake clean               # Remove any temporary products
rake clobber             # Remove any generated files
rake install:all         # Install all Server
rake install:db2         # Install IBM_DB2 Server
rake install:firebird    # Install Firebird Server
rake install:freetds     # Install MSSQL_FreeTDS Server
rake install:mssql       # Install MSSQL_Server2017 Server
rake install:mysql       # Install MySQL Server
rake install:oracle      # Install Oracle Server
rake install:postgres    # Install PostgreSQL Server
rake start:all           # Start all Server
rake start:db2           # Start IBM_DB2 Server
rake start:firebird      # Start Firebird Server
rake start:freetds       # Start MSSQL_FreeTDS Server
rake start:mssql         # Start MSSQL_Server2017 Server
rake start:mysql         # Start MySQL Server
rake start:oracle        # Start Oracle Server
rake start:postgres      # Start PostgreSQL Server
rake stop:all            # Stop all Server
rake stop:db2            # Stop IBM_DB2 Server
rake stop:firebird       # Stop Firebird Server
rake stop:freetds        # Stop MSSQL_FreeTDS Server
rake stop:mssql          # Stop MSSQL_Server2017 Server
rake stop:mysql          # Stop MySQL Server
rake stop:oracle         # Stop Oracle Server
rake stop:postgres       # Stop PostgreSQL Server
rake test:all            # Test all Server connections
rake test:db2            # Test IBM_DB2 Server connection
rake test:firebird       # Test Firebird Server connection
rake test:freetds        # Test MSSQL_FreeTDS Server connection
rake test:mssql          # Test MSSQL_Server2017 Server connection
rake test:mysql          # Test MySQL Server connection
rake test:oracle         # Test Oracle Server connection
rake test:postgres       # Test PostgreSQL Server connection
rake uninstall:all       # Uninstall all Server
rake uninstall:db2       # Uninstall IBM_DB2 Server
rake uninstall:firebird  # Uninstall Firebird Server
rake uninstall:freetds   # Uninstall MSSQL_FreeTDS Server
rake uninstall:mssql     # Uninstall MSSQL_Server2017 Server
rake uninstall:mysql     # Uninstall MySQL Server
rake uninstall:oracle    # Uninstall Oracle Server
rake uninstall:postgres  # Uninstall PostgreSQL Server
```

### Install tasks
Each single install task will do following things:

- downloading a docker hub image for the database server
- creating the configured container
- installing the required ODBC driver

### Uninstall tasks
Each single uninstall task will do following things:

- uninstalling the required ODBC driver
- deleting the created container
- deleting the docker hub image for the database server

### Start / Stop tasks
Each single start/stop task will do following things:

- start/stop the the database using the docker container created during install

### Test task
Each single test task will do following things:

- expects that the server was started upfront
- tries `isql` tool connection attempt to ensure proper usage of ODBC driver against database container

### Remarks
Some of the the (un)install tasks may require higher privileges and are executed using `sudo`. 
You may get a password request to proceed with installation in those cases.

### How it works?
Base for the rake tasks is the `setup.yml` file. It defines any aspect of DBMS to be installable.
It can be easy extended to do this with other DBMS too just be adding a definition to the `setup.yml` an put probably required files into `./binaries` structure.

A more detailed description will follow soon.
