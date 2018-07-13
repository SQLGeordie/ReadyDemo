Drop credential [https://vinsonyublob.blob.core.windows.net/sqlserver]
CREATE CREDENTIAL [https://vinsonyublob.blob.core.windows.net/sqlserver] 
WITH IDENTITY='Shared Access Signature', SECRET='st=2017-08-02T17%3A58%3A00Z&se=2018-08-04T17%3A58%3A00Z&sp=rwl&sv=2015-12-11&sr=c&sig=rnJhgicQI4WG5paMOBgJ%2F5YFPsUVkvrhvvL4363BhG8%3D'

select @@version

BACKUP DATABASE ProductCatalog
TO URL = 'https://vinsonyublob.blob.core.windows.net/sqlserver/ProductCatalog.bak'; 
GO  
 

