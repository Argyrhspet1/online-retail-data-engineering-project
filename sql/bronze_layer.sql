CREATE DATABASE OnlineRetailDW;
GO

USE OnlineRetailDW;
GO

IF OBJECT_ID('sp_LoadBronzeLayer', 'P') IS NOT NULL
    DROP PROCEDURE sp_LoadBronzeLayer;
GO

CREATE PROCEDURE sp_LoadBronzeLayer
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Each column is VARCHAR so every Input Mistake can be accepted
        IF OBJECT_ID('Bronze_OnlineRetail', 'U') IS NOT NULL
            DROP TABLE Bronze_OnlineRetail;

        CREATE TABLE Bronze_OnlineRetail (
            InvoiceNo VARCHAR(50),
            StockCode VARCHAR(50),
            Description VARCHAR(255),
            Quantity VARCHAR(50),
            InvoiceDate VARCHAR(50),
            UnitPrice VARCHAR(50),
            CustomerID VARCHAR(50),
            Country VARCHAR(100)
        );

        BULK INSERT Bronze_OnlineRetail
        FROM 'C:\Users\argyp\Documents\Online Retail Project\data\online_retail.csv'
        WITH (
            FORMAT = 'CSV',
            FIRSTROW = 2,           -- Avoid first row that has headers
            FIELDTERMINATOR = ',',  -- With what are the columns separated in the csv
            ROWTERMINATOR = '\n',   -- Generate new line
            TABLOCK
        );

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        
    END CATCH
END;
GO


EXEC sp_LoadBronzeLayer;