# IBM DB2 Server
[IBM Db2](https://www.ibm.com/analytics/us/en/db2/) contains database-server products developed by [IBM](https://www.ibm.com/us-en/). These products all support the relational model, but in recent years, some products have been extended to support object-relational features and non-relational structures like JSON and XML

## Install ODBC driver 
Download the IBM DB2 ODBC Client files at [/ibmdl/export/pub/software/data/db2/drivers/odbc_cli](http://public.dhe.ibm.com/ibmdl/export/pub/software/data/db2/drivers/odbc_cli/macos64_odbc_cli.tar.gz).

Extract file:

```
tar xvzf macos64_odbc_cli.tar.gz -C /usr/local/share/odbc_db2
```

The IBM DB2 Client libraries need to be in the macOS library search path:

```
cd /usr/local/share/odbc_db2/clidriver/lib/libdb2.dylib
ln -s $(pwd)/libdb2.dylib /usr/local/lib
```

## Edit ODBC Driver Manager file
Edit the located [odbcinst.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) (eg. `/usr/local/etc/odbcinst.ini`) and append:
```
[Driver_IBM_DB2]
Description= IBM DB2 ODBC driver
Driver= /usr/local/lib/libdb2.dylib
Dontdlclose= 1
```

## Edit ODBC Data Source file
Unfortunately the ODBC DSN entry only works, if a well defined **db2cli.ini** file exists at the drivers config dir.
Please create the file `/usr/local/share/odbc_db2/clidriver/cfg/db2cli.ini` with this content:
```
[DSN_IBM_DB2]
Database= testerdb
Protocol= TCPIP
Hostname= localhost
ServiceName= 50000
uid= db2inst1
pwd= yourStrong(!)Password
```

You can either use the system [odbc.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) or user [.odbc.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) file. As example edit your user file `~/.odbc.ini` and append:
```
[[DSN_IBM_DB2]
Description= IBM DB2 Test Server DSN
Driver= Driver_IBM_DB2
Protocol= tcpip
Hostname= localhost
Port= 50000
Database= testerdb
User= db2inst1
Password= yourStrong(!)Password
UID= db2inst1
PWD= yourStrong(!)Password
DMEnvAttr= SQL_ATTR_UNIXODBC_ENVATTR={DB2_CLI_DRIVER_INSTALL_PATH=/usr/local/share/odbc_db2/clidriver}
```

## Use IBM DB2 Server via Docker Image
Unfortunately IBM doesn't support (proper working) docker images. I used the image [cwds/db2:latest](https://hub.docker.com/r/cwds/db2/) For detailed description about possible environment variables please read this docker image description.

### Server connect parameter
```
Servername: localhost
Port: 50000
User: db2inst1
Password: yourStrong(!)Password
```

### Download Image
```
docker pull cwds/db2:latest
```

### Create a Test Server Container
```
docker create --privileged -e 'NOTVISIBLE="in users profile"' -e 'LICENSE=accept' -e 'DB2INST1_PASSWORD=yourStrong(!)Password' -e 'DB2NAME=testerdb' -e 'no_proxy=*.local, 169.254/16' -p 50000:50000 --name test-server-db2 cwds/db2:latest
```

### Using the Test Server Container
The Container was created and named **test-server-db2**. 

#### Start the server
```
docker start test-server-db2
```

#### Shutdown the server
```
docker stop test-server-db2
```

#### Destroy the server container
```
docker rm test-server-db2
```

### Verify ODBC installation using running Server Container
[unixODBC](http://www.unixodbc.org/) comes along with a command line tool to interact with DBMS via ODBC DSN. You can run it using the DNS and Server parameter shown above:

```
isql DSN_IBM_DB2 db2inst1 yourStrong(!)Password
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
