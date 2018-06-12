#!/bin/sh
pushd $1/clidriver/lib/ > /dev/null
sudo install_name_tool -change mac64/libcilkrts.5.dylib /usr/local/lib/libcilkrts.5.dylib libdb2.dylib
popd > /dev/null
