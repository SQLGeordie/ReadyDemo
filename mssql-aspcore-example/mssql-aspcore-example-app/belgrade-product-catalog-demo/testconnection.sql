Select * from sys.dm_os_volume_stats

select @@version

create database ProductCatalog

select * from sys.databases


DROP LOGIN WebLogin
CREATE LOGIN WebLogin WITH PASSWORD = 'SQLPass1234!'
GO

DROP USER IF EXISTS WebUser
CREATE USER WebUser FROM LOGIN WebLogin
GO

DROP ROLE IF EXISTS WebUserRole
CREATE ROLE WebUserRole
GO

GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE TO WebUserRole
EXEC sp_addrolemember N'WebUserRole', N'WebUser' 
GO

--create credential for backup and restore
Drop credential [https://vinsonyublob.blob.core.windows.net/sqlserver]
CREATE CREDENTIAL [https://vinsonyublob.blob.core.windows.net/sqlserver] 
WITH IDENTITY='Shared Access Signature', SECRET='st=2017-08-02T17%3A58%3A00Z&se=2018-08-04T17%3A58%3A00Z&sp=rwl&sv=2015-12-11&sr=c&sig=rnJhgicQI4WG5paMOBgJ%2F5YFPsUVkvrhvvL4363BhG8%3D'



--kill all connections to a database and drop 
DECLARE @kill varchar(8000) = '';  
SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), session_id) + ';'  
FROM sys.dm_exec_sessions
WHERE database_id  = db_id('ProductCatalog')

EXEC(@kill);

drop database ProductCatalog
