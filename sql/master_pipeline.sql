USE OnlineRetailDW
GO


IF OBJECT_ID('sp_RunMasterPipeline','P') IS NOT NULL
	DROP PROCEDURE sp_RunMasterPipeline
GO

CREATE PROCEDURE sp_RunMasterPipeline
AS
BEGIN
	DECLARE @StartTime DATETIME= GETDATE()

	PRINT 'The ELT Pipeline begun at: '+ CONVERT(VARCHAR,@StartTime,120)
	BEGIN TRY
		PRINT 'Execute Bronze Layer(Raw Ingestion).'

		EXEC sp_LoadBronzeLayer

		PRINT 'Bronze Layer loaded successfully.'

		PRINT 'Execute Silver Layer (Cleaning/Typing).'

		EXEC sp_LoadSilverLayer

		PRINT 'Silver Layer loaded successfully.'

		PRINT 'Execute Gold Layer(Star Schema).'

		EXEC sp_LoadGoldLayer

		PRINT 'Gold Layer loaded successfully.'

		DECLARE @EndTime DATETIME= GETDATE()
		

		PRINT 'Pipeline completed in: '+ CAST(DATEDIFF(second,@StartTime,@EndTime) AS VARCHAR)+' seconds.'
	END TRY
	BEGIN CATCH
		PRINT 'Pipeline Failed.'
		PRINT ERROR_MESSAGE()
	END CATCH
END;
GO

EXEC sp_RunMasterPipeline