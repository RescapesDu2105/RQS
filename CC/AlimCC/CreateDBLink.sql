--SYS:
GRANT create session TO cb;
GRANT create database link TO cb WITH ADMIN OPTION;
GRANT create any procedure TO cb;
GRANT drop any procedure TO cb;
GRANT execute any procedure TO cb;

--CB :
ALTER SYSTEM SET OPEN_LINKS=6 SCOPE=SPFILE;
CREATE DATABASE LINK orcl@cc1
CONNECT TO cc1 IDENTIFIED BY oracle
USING 'orcl';
Alter system set global_names = true scope=both;

CREATE DATABASE LINK orcl@cc2
CONNECT TO cc2 IDENTIFIED BY oracle
USING 'orcl';
Alter system set global_names = true scope=both;

CREATE DATABASE LINK orcl@cc3
CONNECT TO cc3 IDENTIFIED BY oracle
USING 'orcl';
Alter system set global_names = true scope=both;

CREATE DATABASE LINK orcl@cc4
CONNECT TO cc4 IDENTIFIED BY oracle
USING 'orcl';
Alter system set global_names = true scope=both;

CREATE DATABASE LINK orcl@cc5
CONNECT TO cc5 IDENTIFIED BY oracle
USING 'orcl';
Alter system set global_names = true scope=both;

CREATE DATABASE LINK orcl@cc6
CONNECT TO cc6 IDENTIFIED BY oracle
USING 'orcl';
Alter system set global_names = true scope=both;