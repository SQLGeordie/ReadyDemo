#wait for the SQL Server to come up
sleep 20s

#run the setup script to create the DB and the schema in the DB
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 1234qwerASDF -d master -i db-init.sql
