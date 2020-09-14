USE [MDSPOC]
GO
/****** Object:  StoredProcedure [dbo].[InsertDomainBasedFieldsFinal]    Script Date: 9/14/2020 6:04:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Jorge Solano>
-- Create date: <7/7/2020>
-- Description:	<SP to update the ProductCode and MasterCode of AX product all based on PSOT information, MDS script>
-- =============================================
ALTER PROCEDURE [dbo].[InsertDomainBasedFieldsFinal]
	@StagingTable nvarchar(100),
	@BatchTag nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
-- =============================================
--Inserts on MDS
-- =============================================
--Insert on MDS Table
Declare @Script nvarchar(max)

Set @Script = 'exec [stg].[udp_'+@StagingTable+'_Leaf] @VersionName=N''VERSION_1'',@LogFlag=1, @BatchTag = '''+@BatchTag+''''
	
	   
--Insert on MDS Table after [InsertDomainBasedFields] finished
exec sp_executesql @Script
WITH RESULT SETS NONE;


END


