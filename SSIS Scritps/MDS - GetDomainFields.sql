USE [MDSPOC]
GO
/****** Object:  StoredProcedure [dbo].[GetDomainFields]    Script Date: 9/14/2020 6:03:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[GetDomainFields] 
	@Domain nvarchar(max),
	@Entity nvarchar(max)
AS
BEGIN
    Declare @SourceTable nvarchar(50)
	Declare @SourceEntityID int
	Declare @SourceModelID int
	Declare @script nvarchar(1000)
	SELECT @SourceModelID = ID from [mdm].[tblModel] where [Name] = 'AX' 
	SELECT @SourceEntityID = ID from [mdm].[tblEntity] where Model_ID = @SourceModelID and [Name] = @Domain
	SELECT @SourceTable = EntityTable from [mdm].[tblEntity] where ID = @SourceEntityID
	Set @script = 'Select distinct convert(nvarchar(20),t2.Code), T2.Name, '''+(CASE WHEN ISNULL(@Entity, '') = '' THEN 'ProductType' ELSE @Entity END)+''' as Entity from (Select distinct Code, Name from mdm.'+ (CASE WHEN ISNULL(@SourceTable,'') = '' THEN 'tbl_62_458_EN' ELSE @SourceTable END)+') as t2'
	exec sp_executesql @script
	WITH RESULT SETS
	(
       (
	   Code nvarchar(10),
       Name nvarchar(250),
	   Entity nvarchar(100)
       ) 
	)
END
