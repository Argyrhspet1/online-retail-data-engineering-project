USE OnlineRetailDW;
GO

IF OBJECT_ID('Gold_DimCustomer','U') IS NOT NULL DROP TABLE Gold_DimCustomer;
GO

CREATE TABLE Gold_DimCustomer(
		--Create a Surrogate key that starts from 1 and increases by 1
		CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
		CustomerID VARCHAR(50) UNIQUE,
		Country VARCHAR(100)
);
GO

INSERT INTO Gold_DimCustomer (CustomerID, Country)
SELECT 
    CustomerID,
    MAX(Country) AS Country
FROM Silver_OnlineRetail
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID;
GO



IF OBJECT_ID('Gold_DimProduct', 'U') IS NOT NULL  DROP TABLE GoldDimProduct;
GO

CREATE TABLE Gold_DimProduct(
	ProductKey INT IDENTITY(1,1) PRIMARY KEY,
	StockCode VARCHAR(50) UNIQUE,
	Description NVARCHAR(255)
);

INSERT INTO Gold_DimProduct(StockCode, Description)
SELECT 
	StockCode,
	MAX(Description) AS Description
FROM Silver_OnlineRetail
WHERE StockCode IS NOT NULL
GROUP BY StockCode;
GO


IF OBJECT_ID('Gold_FactSales', 'U') IS NOT NULL DROP TABLE Gold_FactSales;
GO

CREATE TABLE Gold_FactSales(
	SalesKey INT IDENTITY(1,1) PRIMARY KEY,
	CustomerKey INT FOREIGN KEY REFERENCES Gold_DimCustomer(CustomerKey),
	ProductKey INT FOREIGN KEY REFERENCES Gold_DimProduct(ProductKey),
	InvoiceNo VARCHAR(50),
	Quantity INT,
	InvoiceDate DATETIME,
	UnitPrice DECIMAL(10,2)
);
GO

INSERT INTO Gold_FactSales(CustomerKey,ProductKey,InvoiceNo,Quantity,InvoiceDate,UnitPrice)
SELECT
	dc.CustomerKey,
	dp.ProductKey,
	s.InvoiceNo,
	s.Quantity,
	s.InvoiceDate,
	s.UnitPrice
FROM Silver_OnlineRetail AS s
INNER JOIN Gold_DimCustomer AS dc ON dc.CustomerID=s.CustomerID
INNER JOIN Gold_DimProduct AS dp ON dp.StockCode=s.StockCode
WHERE s.CustomerID IS NOT NULL AND s.StockCode IS NOT NULL;
GO


