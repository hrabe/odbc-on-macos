# Firebird Server
[Firebird](https://firebirdsql.org) is an open source SQL relational database management system that "runs on Linux, Microsoft Windows, and several Unix platforms". The database forked from Borland's open source edition of [InterBase](https://www.embarcadero.com/products/interbase) in 2000, but since Firebird 1.5 the code has been largely rewritten.

## Install ODBC driver
Unfortunately the driver must be compiled from C/C++ sources. This requires the Header and Lib files from Firebird Server.
Download now from [Firebird 2.5.8 page](https://www.firebirdsql.org/en/firebird-2-5-8/) the package file [Mac OS X 64-bit Classic, Superclassic & Embedded (Intel)](https://github.com/FirebirdSQL/firebird/releases/download/R2_5_8/FirebirdCS-2.5.8-27089-1-x86_64.pkg) and install it.

Unfortunately the Firebird server will be running as daemon already after installation and should be shutdown/unloaded by:
```
sudo launchctl unload -w /Library/LaunchDaemons/org.firebird.gds.plist
```
Download now from [Firebird ODBC Drivers](https://github.com/FirebirdSQL/firebird-odbc-driver) the sources of [OdbcJdbc-src-2.0.5.156.tar.gz](https://sourceforge.net/projects/firebird/files/firebird-ODBC-driver/2.0.5-Release/OdbcJdbc-src-2.0.5.156.tar.gz/download)
```
tar xvzf OdbcJdbc-src-2.0.5.156.tar.gz -C /usr/local/share/odbc_firebird
cd /usr/local/share/odbc_firebird/OdbcJdbc/Builds/Gcc.darwin
```

You have to edit the file **makefile.darwin** and do following changes:
- replace `ODBCMANAGER=iODBC` by `ODBCMANAGER=ODBC`
- delete 3 occurances of: `--def $(ODBCJDBCDEFFILE)`
```
make -B -f makefile.darwin all
```
The Firebird ODBC libraries need to be in the macOS library search path:

```
cd /usr/local/share/odbc_firebird/OdbcJdbc/Builds/Gcc.darwin/Release_x86_64
ln -s $(pwd)/libOdbcFb.dylib /usr/local/lib
```

## Edit ODBC Driver Manager file
Edit the located [odbcinst.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) (eg. `/usr/local/etc/odbcinst.ini`) and append:
```
[Driver_Firebird]
Description= Firebird ODBC driver
Driver= /usr/local/lib/libOdbcFb.dylib
```

## Edit ODBC Data Source file
You can either use the system [odbc.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) or user [.odbc.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) file. As example edit your user file `~/.odbc.ini` and append:
```
[[DSN_Firebird]
Description= Firebird Test Server DSN
Driver= Driver_Firebird
Dbname= 127.0.0.1/3050:/opt/firebird/bin/test
User= sysdba
Password= sysdba_passwd
Role= 
Client= 
CharacterSet= NONE
ReadOnly= false
NoWait= false
Dialect= 3
QuotedIdentifier= true
SensitiveIdentifier= false
AutoQuotedIdentifier= false
```

**TODO**: Describe Database creation.

## Use Firebird Server via Docker Image
Unfortunately [Firebird Foundation](https://firebirdsql.org) doesn't support (proper working) docker images. I used the image [Firebird Sql Server 2.0 & 2.5 (Super Server)](https://hub.docker.com/r/ihsahn/firebird-docker/). For detailed description about possible environment variables please read this docker image description.

### Server connect parameter
```
Servername: localhost
Port: 3050
User: sysdba
Password: sysdba_passwd
```

### Download Image
```
docker pull ihsahn/firebird-docker:2.5
```

### Create a Test Server Container
```
docker create -e 'DEBIAN_FRONTEND=noninteractive' -e 'FIREBIRD_PASSWORD=sysdba_passwd' -e 'no_proxy=*.local, 169.254/16' -p 3050:3050 --name test-server-firebird ihsahn/firebird-docker:2.5
```

### Using the Test Server Container
The Container was created and named **test-server-firebird**. 

#### Start the server
```
docker start test-server-firebird
```

#### Shutdown the server
```
docker stop test-server-firebird
```

#### Destroy the server container
```
docker rm test-server-firebird
```

### Verify ODBC installation using running Server Container
[unixODBC](http://www.unixodbc.org/) comes along with a command line tool to interact with DBMS via ODBC DSN. You can run it using the DNS and Server parameter shown above:

```
isql DSN_Firebird sysdba sysdba_passwd
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
