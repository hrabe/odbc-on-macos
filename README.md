# odbc-on-macos
How to use databases from different vendors by ODBC drivers on MacOS

## What is ODBC?
In computing, Open Database Connectivity ([ODBC](https://en.wikipedia.org/wiki/Open_Database_Connectivity)) is a standard application programming interface (API)
for accessing database management systems ([DBMS](https://en.wikipedia.org/wiki/Database)). 
The designers of ODBC aimed to make it independent of database systems and operating systems.
An application written using ODBC can be ported to other platforms, both on the client and server side,
with few changes to the data access code.

### Implementation as _iODBC_

[iODBC](http://www.iodbc.org/) is an open source initiative managed by OpenLink Software. 
It is a platform-independent ODBC SDK and runtime offering that enables the development of ODBC-compliant 
applications and drivers outside the Windows platform. ([History](https://en.wikipedia.org/wiki/IODBC#History))

### Implementation as _unixODBC_

[unixODBC](http://www.unixodbc.org/) is an open source project that implements the ODBC API. 
The code is provided under the GNU GPL/LGPL and can be built and used on many different operating systems,
including most versions of Unix, Linux, Mac OS X, IBM OS/2 and Microsoft's Interix. ([History](https://en.wikipedia.org/wiki/UnixODBC#History))

