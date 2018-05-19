# Firebird Server

- tbd.


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
