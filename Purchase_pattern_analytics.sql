use project_purchase_pattern_analysis;
show tables;
select * from mytable;

DESCRIBE mytable;

-- 1. remove rows with nulls
SELECT *
FROM mytable
WHERE BillNo IS NOT NULL
  AND Itemname IS NOT NULL
  AND Quantity IS NOT NULL
  AND Price IS NOT NULL;

-- 2. Replace NULLs dynamically
SELECT
    BillNo,
    COALESCE(Itemname, 'Unknown') AS Itemname,
    COALESCE(Quantity, 0) AS Quantity,
    COALESCE(Price, 0) AS Price,
    CustomerID,
    Present_Date
FROM mytable;

-- 3. Remove Invalid or Negative Values
SELECT *
FROM mytable
WHERE Quantity > 0
  AND Price > 0;

-- 4. Trim Extra Spaces (Data Standardization)
SELECT
    TRIM(Itemname) AS Itemname,
    TRIM(CustomerID) AS CustomerID,
    BillNo,
    Quantity,
    Price,
    Present_Date
FROM mytable;

-- 5. Standardize Date Format
SELECT
    BillNo,
    Itemname,
    Quantity,
    Price,
    CustomerID,
    CAST(Present_Date AS DATE) AS Present_Date
FROM mytable
WHERE Present_Date IS NOT NULL;

-- 6. Create a CLEAN VIEW (Recommended for Large Data)
SELECT DISTINCT Present_Date
FROM mytable
WHERE Present_Date IS NOT NULL
LIMIT 10;

SELECT DISTINCT
    BillNo,
    TRIM(Itemname) AS Itemname,
    Quantity,
    Price,
    CustomerID,
    Present_Date
FROM mytable
WHERE Quantity > 0
  AND Price > 0
  AND Itemname IS NOT NULL
  AND Present_Date IS NOT NULL;
  
  SELECT DISTINCT
    BillNo,
    TRIM(Itemname) AS Itemname,
    Quantity,
    Price,
    CustomerID,
    Present_Date
FROM mytable
WHERE Quantity > 0
  AND Price > 0;
  
  SELECT
    COUNT(*) AS total_rows,
    SUM(BillNo IS NULL) AS billno_nulls,
    SUM(Itemname IS NULL) AS itemname_nulls,
    SUM(Quantity IS NULL) AS quantity_nulls,
    SUM(Price IS NULL) AS price_nulls,
    SUM(CustomerID IS NULL) AS customerid_nulls,
    SUM(Present_Date IS NULL) AS date_nulls
FROM mytable;

-- 7. Final Claned Data
SELECT DISTINCT
    BillNo,
    TRIM(Itemname) AS Itemname,
    Quantity,
    Price,
    CustomerID,
    Country,
    STR_TO_DATE(Present_Date, '%d-%m-%Y %H:%i') AS Present_Date
FROM mytable
WHERE Quantity > 0
  AND Price > 0
  AND Itemname IS NOT NULL
  AND Present_Date IS NOT NULL;

-- 8. Top Revenue Generating Products 
SELECT
    Itemname,
    ROUND(SUM(Quantity) * AVG(Price), 2) AS total_revenue
FROM mytable
WHERE Quantity > 0
  AND Price > 0
GROUP BY Itemname
LIMIT 50;

-- 9. Data Quality Check
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT BillNo) AS total_transactions,
    COUNT(DISTINCT Itemname) AS unique_products
FROM (
    SELECT BillNo, Itemname
    FROM mytable
    LIMIT 100000
) t;

-- 10. Sample-Based Top Products 
SELECT
    Itemname,
    COUNT(*) AS purchase_count
FROM (
    SELECT Itemname
    FROM mytable
    WHERE Itemname IS NOT NULL
    LIMIT 50000
) t
GROUP BY Itemname
ORDER BY purchase_count DESC
LIMIT 20;

-- 11. Sample Revenue Analysis
SELECT
    Itemname,
    SUM(Quantity) * AVG(Price) AS revenue
FROM (
    SELECT Itemname, Quantity, Price
    FROM mytable
    WHERE Quantity > 0 AND Price > 0
    LIMIT 50000
) t
GROUP BY Itemname
LIMIT 20;

-- 12. Basket Size Analysis (MBA-Related, SAFE)
SELECT
    BillNo,
    COUNT(DISTINCT Itemname) AS basket_size
FROM (
    SELECT BillNo, Itemname
    FROM mytable
    LIMIT 50000
) t
GROUP BY BillNo
LIMIT 20;

-- 13. Customer Activity Sample
SELECT
    CustomerID,
    COUNT(*) AS total_purchases
FROM (
    SELECT CustomerID
    FROM mytable
    WHERE CustomerID IS NOT NULL
    LIMIT 50000
) t
GROUP BY CustomerID
LIMIT 20;

-- 14. Peak Transaction Analysis 
SELECT
    COUNT(*) AS total_transactions
FROM (
    SELECT BillNo
    FROM mytable
    WHERE BillNo IS NOT NULL
    LIMIT 100000
) t;

-- 15. Product Diversity in Sample Data
SELECT
    COUNT(DISTINCT Itemname) AS unique_products
FROM (
    SELECT Itemname
    FROM mytable
    WHERE Itemname IS NOT NULL
    LIMIT 100000
) t;

-- 16. Average Quantity per Purchase 
SELECT
    ROUND(AVG(Quantity), 2) AS avg_quantity
FROM (
    SELECT Quantity
    FROM mytable
    WHERE Quantity > 0
    LIMIT 100000
) t;

-- 17. High-Value Transactions 
SELECT
    BillNo,
    Quantity,
    Price
FROM mytable
WHERE Quantity > 3
  AND Price > 100
LIMIT 50;

-- 18. Data Quality Check – Null Analysis
SELECT
    COUNT(*) AS total_rows,
    COUNT(Itemname) AS non_null_items,
    COUNT(CustomerID) AS non_null_customers
FROM (
    SELECT Itemname, CustomerID
    FROM mytable
    LIMIT 100000
) t;
