#!/bin/sh
pushd $1/OdbcJdbc/Builds/Gcc.darwin > /dev/null
sed -i '' 's/ODBCMANAGER=iODBC/ODBCMANAGER=ODBC/' makefile.darwin
sed  -i '' 's/--def $(ODBCJDBCDEFFILE)/ /' makefile.darwin
make -B -f makefile.darwin all
popd > /dev/null
