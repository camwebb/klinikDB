# The database schema

The file `klinikDB.sql` in this directory is a recent schema of the
klinicDB database.  It can be prepared from the running instance by:

    mysqldump --no-tablespaces -h <host> -u <user> -p<password> klinikDB > tmp.sql
    ./mysqldump2sql tmp.sql > klinikDB.sql  # to remove the copious comments

Documentation for the schema is in [`../doc/schema.md`](../doc/schema.md).

A graphical representation of the schema can be prepared using [schemaspy](https://schemaspy.org/):

    java -jar schemaspy.jar -t mariadb -u <user> -p <password> -host <host> \
      -o schema/ -db klinikDBx -s klinikDBx -dp mariadb-java-client.jar
    mv schema/diagrams/summary/relationships.real.compact.png ../doc/img/schema.png



