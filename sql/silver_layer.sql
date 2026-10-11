USE OnlineRetailDW;
GO

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
GO

INSERT INTO Silver_OnlineRetail(
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
    InvoiceNO,
    StockCode,
    Description,
    TRY_CAST(Quantity AS INT) AS Quantity,
    TRY_CAST(InvoiceDate AS DATETIME) AS InvoiceDate,
    TRY_CAST(UnitPrice AS DECIMAL(10,2)) AS UnitPrice,
    CustomerID,
    Country
FROM Bronze_OnlineRetail;
GO

SELECT *
FROM Silver_OnlineRetail