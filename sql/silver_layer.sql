USE OnlineRetailDW;
GO

IF OBJECT_ID('sp_LoadSilverLayer', 'P') IS NOT NULL
    DROP PROCEDURE sp_LoadSilverLayer
GO

CREATE PROCEDURE sp_LoadSilverLayer
AS
BEGIN
    BEGIN TRANSACTION
        BEGIN TRY
            
            IF OBJECT_ID('Silver_OnlineRetail','U') IS NOT NULL 
                DROP TABLE Silver_OnlineRetail

            CREATE TABLE Silver_OnlineRetail(
	            InvoiceNo VARCHAR(50),
                StockCode VARCHAR(50),
                Description VARCHAR(255),
                Quantity INT,
                InvoiceDate DATETIME,
                UnitPrice DECIMAL(10, 2),
                CustomerID VARCHAR(50),
                Country VARCHAR(100)
            );
            

            WITH RankedData AS (
            SELECT
                InvoiceNo,
                StockCode,
                Description,
                TRY_CAST(Quantity AS INT) AS Quantity,
                TRY_CAST(InvoiceDate AS DATETIME) AS InvoiceDate,
                TRY_CAST(UnitPrice AS DECIMAL(10,2)) AS UnitPrice,
                CustomerID,
                Country,
                ROW_NUMBER() OVER (
                    PARTITION BY InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country 
                    ORDER BY (SELECT NULL)
                ) AS RowNum
            FROM Bronze_OnlineRetail
        )
        INSERT INTO Silver_OnlineRetail (
            InvoiceNo,
            StockCode,
            Description,
            Quantity,
            InvoiceDate,
            UnitPrice,
            CustomerID,
            Country
        )
        SELECT
            InvoiceNo,
            StockCode,
            Description,
            Quantity,
            InvoiceDate,
            UnitPrice,
            CustomerID,
            Country
        FROM RankedData
        WHERE RowNum = 1;
            
            COMMIT
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION

        END CATCH
END
GO

EXEC sp_LoadSilverLayer



