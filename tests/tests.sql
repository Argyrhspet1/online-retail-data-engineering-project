-- TEST LOADING IN BRONZE LAYER

SELECT COUNT(*)
FROM Bronze_OnlineRetail


-- TEST FOR DUPLICATES IN SILVER LAYER


WITH DuplicateRows AS(
    SELECT *,
    ROW_NUMBER() OVER(
            PARTITION BY InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country 
            ORDER BY InvoiceDate) AS RowNum
    FROM Silver_OnlineRetail
)

SELECT
	*
FROM DuplicateRows
WHERE RowNum>1

-- TEST FOR NEGATIVE VALUES IN UNITPRICE

SELECT 
    *
FROM Silver_OnlineRetail
WHERE  UnitPrice<0