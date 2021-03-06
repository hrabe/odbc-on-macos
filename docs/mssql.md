# MSSQL Server
[Microsoft SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-2017) is a relational database management system developed by Microsoft.

## Install ODBC driver 
MSSQL Server can be accessed using the [Microsoft ODBC Driver 17 for SQL Server](https://docs.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server?view=sql-server-2017) driver available as tap for [Homebrew](https://brew.sh/):
```
brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release
brew update
brew install --no-sandbox msodbcsql17 mssql-tools
```

## Edit ODBC Driver Manager file
Edit the located [odbcinst.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) (eg. `/usr/local/etc/odbcinst.ini`) and append:
```
[Driver_MSSQL_Server2017]
Description     = Microsoft ODBC Driver 17 for SQL Server
Driver          = /usr/local/lib/libmsodbcsql.17.dylib
Setup           = 
UsageCount      = 1
```

## Edit ODBC Data Source file
You can either use the system [odbc.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) or user [.odbc.ini](https://github.com/hrabe/odbc-on-macos#locate-your-odbc-driver-and-data-source-config-files) file. As example edit your user file `~/.odbc.ini` and append:
```
[DSN_MSSQL_Server2017]
Description            = Test Server MSSQL_Server2017
Driver                 = Driver_MSSQL_Server2017
Server                 = 127.0.0.1
UID                    = sa
PWD                    = yourStrong(!)Password
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
isql DSN_MSSQL_Server2017 sa 'yourStrong(!)Password'
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
