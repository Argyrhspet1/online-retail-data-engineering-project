CREATE DATABASE OnlineRetailDW
GO

USE OnlineRetailDW
GO;

-- Each column is VARCHAR so every Input Mistake can be accepted
CREATE TABLE Bronze_OnlineRetail(
	InvoiceNo VARCHAR(50),
	StockCode VARCHAR(50),
	Description VARCHAR(255),
	Quantity VARCHAR(50),
	InvoiceDate VARCHAR(50),
	UnitPrice VARCHAR(50),
	CustomerID VARCHAR(50),
	Country VARCHAR(100),
);
GO


BULK INSERT Bronze_OnlineRetail
FROM 'C:\Users\argyp\Documents\Online Retail Project\data\online_retail.csv'
WITH (
	FORMAT='CSV',
	FIRSTROW=2, -- Avoid first row that has headers
	FIELDTERMINATOR =',', -- With what are the columns seperated in the csv
	ROWTERMINATOR= '\n', -- Generate new line
	TABLOCK
);
GO


