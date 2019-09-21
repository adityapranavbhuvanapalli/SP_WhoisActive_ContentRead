DECLARE @s VARCHAR(MAX)

EXEC sp_WhoIsActive 
    @output_column_list = '[dd%][session_id][sql_text]', 
    @schema = @s OUTPUT
    @return_schema = 1, 
	--O/P form of the above : CREATE TABLE <table_name> (...)
SET @s = REPLACE(@s, '<table_name>', 'dbo.WhoIsActiveTable')
EXEC(@s)
EXEC sp_WhoIsActive @output_column_list = '[dd%][session_id][sql_text]', @destination_table = 'dbo.WhoIsActiveTable'

DECLARE @AlertRecords TABLE
(
	[dd hh:mm:ss.mss] varchar(8000) NULL,
	[session_id] smallint NOT NULL,
	[sql_text] xml NULL
)
INSERT @AlertRecords
SELECT * FROM dbo.WhoIsActiveTable where CAST(REPLACE(REPLACE(LEFT([dd hh:mm:ss.mss],LEN([dd hh:mm:ss.mss])-7),' ',''),':','') AS INT)>5

--SELECT SUBSTRING('01 02:03:04.567',0, CHARINDEX(' ', '01 02:03:04.567'))

--SELECT LEFT([dd hh:mm:ss.mss],LEN([dd hh:mm:ss.mss]-7))

--SELECT CAST(REPLACE(REPLACE(LEFT('01 02:03:04.567',LEN('01 02:03:04.567')-7),' ',''),':','') AS INT)


SELECT * FROM @AlertRecords

DROP TABLE dbo.WhoIsActiveTable

