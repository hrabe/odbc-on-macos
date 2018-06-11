# Not yet implemented
The install / uninstall rake tasks do not fully work for all servers right now.

## Scope: App
- install Mac App (*.pkg)
- execute install shell scripts if avail
- uninstall Mac App (mostly by just delete or uninstall shell script)

## Scope: Docker
- how to create automatted the required databases?

## Scope: Brew
- install brew formula
- uninstall brew formula
- support more than one formula + options

## Scope: Source
- install sources
- patch files if necessary
- build binaries from sources
- link libraries
- unlink binaries
- uninstall sources

## Scope: ODBC
- generate Driver names
- generate DSN names

## Scope: Test
- `isql DSN_MSSQL sa 'yourStrong(!)Password' -v -b < /dev/null`
- `isql DSN_PostgreSQL postgres 'yourStrong(!)Password' -v -b < /dev/null`
- `isql DSN_Oracle system oracle -v -b < /dev/null`
- `isql DSN_MySQL root 'yourStrong(!)Password' -v -b < /dev/null`
- `isql DSN_Firebird sysdba sysdba_passwd -v -b < /dev/null`
- all tests by `ruby-odbc`:
  - create table
  - create index
  - insert
  - update
  - delete
  - drop index
  - drop table

## Scope: MSSQL Server
- https://docs.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server?view=sql-server-2017
- https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-2017#os-x-1011-el-capitan-macos-1012-sierra-and-macos-1013-high-sierra
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release
brew update
brew install --no-sandbox msodbcsql17 mssql-tools
```

## Scope: IBM DB2 Database
- http://www.unixodbc.org/doc/db2.html
- http://public.dhe.ibm.com/ibmdl/export/pub/software/data/db2/drivers/odbc_cli/macos64_odbc_cli.tar.gz
- https://github.com/ibmdb/ruby-ibmdb/issues/25
- http://matthew-brett.github.io/docosx/mac_runtime_link.html
- http://cilkplus.github.io
- https://www.cilkplus.org/download#cilk-plus-llvm
- `sudo install_name_tool -change mac64/libcilkrts.5.dylib /usr/local/lib/libcilkrts.5.dylib libdb2.dylib`
- https://www.ibm.com/support/knowledgecenter/en/SSEPGG_11.1.0/com.ibm.db2.luw.apdv.cli.doc/doc/r0000584.html

## Scope: Resource Links

### Docker Images
- https://hub.docker.com/r/library/postgres/
- https://hub.docker.com/r/microsoft/mssql-server-linux/
- https://hub.docker.com/r/wnameless/oracle-xe-11g/
- https://hub.docker.com/r/mysql/mysql-server/
- https://hub.docker.com/r/ihsahn/firebird-docker/

### ODBC Driver
- https://github.com/mkleehammer/pyodbc/wiki/Connecting-to-SQL-Server-from-Mac-OSX
- https://db.rstudio.com/best-practices/drivers/
- https://blogs.oracle.com/opal/installing-the-oracle-odbc-driver-on-macos
- https://dev.mysql.com/downloads/connector/odbc/
- https://dev.mysql.com/doc/connector-odbc/en/connector-odbc-installation-binary-osx.html
- https://dev.mysql.com/doc/connector-odbc/en/connector-odbc-installation-source-unix-osx.html
- https://www.firebirdsql.org/en/firebird-2-5-8/
- https://github.com/FirebirdSQL/firebird/releases/download/R2_5_8/FirebirdCS-2.5.8-27089-1-x86_64.pkg
- https://github.com/FirebirdSQL/firebird-odbc-driver
- https://sourceforge.net/projects/firebird/files/firebird-ODBC-driver/2.0.5-Release/OdbcJdbc-src-2.0.5.156.tar.gz/download

### Ruby Gems
Ruby Gems:

- [http://www.ch-werner.de/rubyodbc/](http://www.ch-werner.de/rubyodbc/)
- [~~https://bitbucket.org/ged/ruby-pg/wiki/Home~~](https://bitbucket.org/ged/ruby-pg/wiki/Home)
- [~~https://github.com/rails-sqlserver/tiny_tds~~~](https://github.com/rails-sqlserver/tiny_tds)
- [~~https://www.rubydoc.info/github/kubo/ruby-oci8~~~](https://www.rubydoc.info/github/kubo/ruby-oci8)

### Tooling
- http://www.launchd.info/
- https://shekhargulati.com/2018/01/13/using-wait-for-it-with-oracle-database-docker-image/
- https://github.com/vishnubob/wait-for-it
- http://www.freetds.org/userguide/freetdsconf.htm
- https://superuser.com/questions/592921/mac-osx-users-vs-dscl-command-to-list-user/621055
- https://superuser.com/questions/36567/how-do-i-uninstall-any-apple-pkg-package-file
- https://apple.stackexchange.com/questions/113489/unattended-installation-of-pkg-file
- http://www.unixodbc.org/odbcinst.html

### Unsorted
- https://puredata.info/downloads/gem/documentation/faq/getdlldependencies
- https://dev.mysql.com/doc/connector-odbc/en/connector-odbc-configuration-dsn-unix.html
- https://www.firebirdsql.org/pdfmanual/html/qsg10-creating.html
- https://stackoverflow.com/questions/1601947/how-do-i-create-a-new-firebird-database-from-the-command-line
- https://github.com/Homebrew/homebrew-core/blob/e0e86e6155f0fe4f501b2003ba76fbf1fda491bb/Formula/mdbtools.rb
- https://github.com/brianb/mdbtools
- https://github.com/brianb/mdbtools/archive/0.7.1.tar.gz
- https://github.com/mkleehammer/pyodbc/wiki/Connecting-to-SQL-Server-from-Mac-OSX
- https://stackoverflow.com/questions/1601947/how-do-i-create-a-new-firebird-database-from-the-command-line
- http://mysql.localhost.net.ar/doc/refman/5.0/fr/myodbc-mac-os-x.html
- https://www.systutorials.com/docs/linux/man/1-isql/
- https://blogs.oracle.com/opal/installing-the-oracle-odbc-driver-on-macos
- https://db.rstudio.com/best-practices/drivers/
- https://github.com/mkleehammer/pyodbc/wiki/Connecting-to-SQL-Server-from-Mac-OSX
- https://www.microsoft.com/en-us/sql-server/developer-get-started/ruby/mac/
- 
