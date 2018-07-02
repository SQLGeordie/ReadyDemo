select @@version

RESTORE DATABASE [ProductCatalog] FROM  URL = N'https://vinsonyublob.blob.core.windows.net/sqlserver/ProductCatalog.bak'
WITH  FILE = 1,
MOVE N'ProductCatalog' TO N'\var\opt\mssql\data\ProductCatalog.mdf',
MOVE N'ProductCatalog_log' TO N'\var\opt\mssql\data\ProductCatalog_log.ldf',
NOUNLOAD,
STATS = 5,
REPLACE
GO
            
USE ProductCatalog
ALTER USER WEBUSER WITH LOGIN = WEBLOGIN


select * from sys.databases where name='ProductCatalog'



