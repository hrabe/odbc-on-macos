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

## Scope: Source
- install sources
- patch files if necessary
- build binaries from sources
- link libraries
- unlink binaries
- uninstall sources

## Scope: Test
- isql DSN_MSSQL sa 'yourStrong(!)Password' -v -b < /dev/null
- isql DSN_PostgreSQL postgres 'yourStrong(!)Password' -v -b < /dev/null
- isql DSN_Oracle system oracle -v -b < /dev/null
- isql DSN_MySQL root 'yourStrong(!)Password' -v -b < /dev/null
- isql DSN_Firebird sysdba sysdba_passwd -v -b < /dev/null
- all tests by `ruby-odbc`:
  - create table
  - create index
  - insert
  - update
  - delete
  - drop index
  - drop table
