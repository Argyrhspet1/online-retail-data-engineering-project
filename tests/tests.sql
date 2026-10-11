-- TEST FOR DUPLICATES


WITH DuplicateRows AS(
    SELECT *,
    ROW_NUMBER() OVER(
            PARTITION BY InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country 
            ORDER BY InvoiceDate) AS RowNum
    FROM Silver_OnlgitineRetail
)




SELECT
	*
FROM DuplicateRows
WHERE RowNum>1