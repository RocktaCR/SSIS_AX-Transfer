USE [ICADev4]
GO
/****** Object:  StoredProcedure [dbo].[getAxFields]    Script Date: 9/14/2020 2:59:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Christofer Rodriguez
-- Create date: 09/14/2020
-- Description:	Get fields based on temporal table 
-- =============================================
ALTER PROCEDURE [dbo].[getAxFields]
	@ColumnName nvarchar(max) 
AS
BEGIN
	 Declare @script  nvarchar(500)
	 IF @ColumnName = 'Bit'
	 BEGIN
	 SET @script = 'SELECT 0 as RowNum, ''False'' as Name 
					UNION SELECT 1 as RowNum,  ''True'' as Name'
	 END
	 ElSE if @ColumnName = 'Unit'
	 set @script = 'Select Row_Number() OVER (ORDER BY t2.Name ASC) AS RowNum,t2.* from ( Select distinct ' + (CASE WHEN isnull(@ColumnName,'') = '' THEN 'ProductType' ELSE @ColumnName END )+ ' as Name From Query where ' + (CASE WHEN isnull(@ColumnName,'') = '' THEN 'ProductType' ELSE @ColumnName END )+ ' is not null union all Select ''BX'' as Name union all Select ''BOX'' as Name) as t2 where t2.Name <> '''' and t2.Name <> ''NULL'''
	 Else
	 set @script = 'Select Row_Number() OVER (ORDER BY t2.Name ASC) AS RowNum,t2.* from ( Select distinct ' + (CASE WHEN isnull(@ColumnName,'') = '' THEN 'ProductType' ELSE @ColumnName END )+ ' as Name From Query where ' + (CASE WHEN isnull(@ColumnName,'') = '' THEN 'ProductType' ELSE @ColumnName END )+ ' is not null) as t2 where t2.Name <> '''' and t2.Name <> ''NULL'''
	 print @script
	 exec sp_executesql @script

END