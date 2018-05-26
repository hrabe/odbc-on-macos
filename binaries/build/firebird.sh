#!/bin/sh
pushd $1/OdbcJdbc/Builds/Gcc.darwin
# - replace `ODBCMANAGER=iODBC` by `ODBCMANAGER=ODBC`
# - delete 3 occurances of: `--def $(ODBCJDBCDEFFILE)`
make -B -f makefile.darwin all
