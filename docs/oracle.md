# Oracle Server

[Oracle Database](https://www.oracle.com/database/index.html) (commonly referred to as Oracle RDBMS or simply as Oracle) is a multi-model database management system produced and marketed by [Oracle Corporation](https://www.oracle.com/index.html).

## Install ODBC driver 
Download the Oracle 12.2 Instant Client Basic and ODBC packages from [Instant Client Downloads for macOS (Intel x86)](http://www.oracle.com/technetwork/topics/intel-macsoft-096467.html).

Unzip both files:

```
unzip instantclient-basic-macos.x64-12.2.0.1.0-2.zip -d /usr/local/odbc_oracle
unzip instantclient-odbc-macos.x64-12.2.0.1.0-2.zip -d /usr/local/odbc_oracle
```

The Oracle Instant Client libraries need to be in the macOS library search path:

```
cd /usr/local/odbc_oracle/instantclient_12_2
ln -s $(pwd)/libclntsh.dylib.12.1 /usr/local/lib
ln -s $(pwd)/libclntshcore.dylib.12.1 /usr/local/lib
ln -s $(pwd)/libsqora.dylib.12.1 /usr/local/lib
```

## Edit ODBC Driver Manager file
Edit the located [odbcinst.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) (eg. `/usr/local/etc/odbcinst.ini`) and append:
```
[Driver_Oracle]
Description= Oracle ODBC driver for Oracle 12c
Driver= /usr/local/lib/libsqora.dylib.12.1
Setup= 
FileUsage= 
CPTimeout= 
CPReuse= 
```

## Edit ODBC Data Source file
You can either use the system [odbc.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) or user [.odbc.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) file. As example edit your user file `~/.odbc.ini` and append:
```
[DSN_Oracle]
Description= Oracle Test Server DSN
Driver= Driver_Oracle
ServerName= localhost:1521/XE
User= system
Password= oracle
Application Attributes= T
Attributes= W
BatchAutocommitMode= IfAllSuccessful
BindAsFLOAT= F
CloseCursor= F
DisableDPM= F
DisableMTS= T
EXECSchemaOpt= 
EXECSyntax= T
Failover= T
FailoverDelay= 10
FailoverRetryCount= 10
FetchBufferSize= 64000
ForceWCHAR= F
Lobs= T
Longs= T
MaxLargeData= 0
MetadataIdDefault= F
QueryTimeout= T
ResultSets= T
SQLGetData extensions= F
Translation DLL= 
Translation Option= 0
DisableRULEHint= T
UserID= 
StatementCache= F
CacheBufferSize= 20
UseOCIDescribeAny= F
SQLTranslateErrors= F
MaxTokenSize= 8192
AggregateSQLType= FLOAT
```

## Use Oracle Server via Docker Image
Unfortunately Oracle doesn't support (proper working) docker images. I used the image [wnameless/oracle-xe-11g](https://hub.docker.com/r/wnameless/oracle-xe-11g/) For detailed description about possible environment variables please read this docker image description.

### Server connect parameter
```
Servername: localhost
Port: 1521
User: system
Password: oracle
```

### Download Image
```
docker pull wnameless/oracle-xe-11g:18.04
```

### Create a Test Server Container
```
docker create -e 'ORACLE_ALLOW_REMOTE=true' -e 'ORACLE_ENABLE_XDB=true' -e 'no_proxy=*.local, 169.254/16' -p 1521:1521 --name test-server-oracle wnameless/oracle-xe-11g:18.04
```

### Using the Test Server Container
The Container was created and named **test-server-oracle**. 

#### Start the server
```
docker start test-server-oracle
```

#### Shutdown the server
```
docker stop test-server-oracle
```

#### Destroy the server container
```
docker rm test-server-oracle
```

### Verify ODBC installation using running Server Container
[unixODBC](http://www.unixodbc.org/) comes along with a command line tool to interact with DBMS via ODBC DSN. You can run it using the DNS and Server parameter shown above:

```
isql DSN_Oracle system oracle
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
