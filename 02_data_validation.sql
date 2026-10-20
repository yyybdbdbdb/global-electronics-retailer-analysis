
-- =========================================================
-- GLOBAL ELECTRONICS RETAILER
-- FILE: 02_data_validation.sql
-- PURPOSE: Validate data quality and consistency
-- NOTE: All queries are READ-ONLY.
-- =========================================================

USE global_electronics;


-- 1. CHECK ROW COUNTS FOR ALL TABLES

SELECT 'sales' AS table_name, COUNT(*) AS total_rows
FROM sales
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'stores', COUNT(*) FROM stores
UNION ALL
SELECT 'exchange_rates', COUNT(*) FROM exchange_rates
UNION ALL
SELECT 'data_dictionary', COUNT(*) FROM data_dictionary;


-- 2. CHECK SALES DATE RANGE

SELECT
    MIN(Order_Date) AS first_order_date,
    MAX(Order_Date) AS last_order_date,
    COUNT(*) AS total_sales_rows,
    COUNT(DISTINCT Order_Number) AS distinct_orders
FROM sales;


-- 3. CHECK MISSING VALUES IN IMPORTANT SALES COLUMNS

SELECT
    SUM(Order_Number IS NULL) AS missing_order_numbers,
    SUM(CustomerKey IS NULL) AS missing_customer_keys,
    SUM(ProductKey IS NULL) AS missing_product_keys,
    SUM(StoreKey IS NULL) AS missing_store_keys,
    SUM(Order_Date IS NULL) AS missing_order_dates,
    SUM(Quantity IS NULL) AS missing_quantities,
    SUM(Revenue_USD IS NULL) AS missing_revenue,
    SUM(Cost_USD IS NULL) AS missing_cost,
    SUM(Profit_USD IS NULL) AS missing_profit
FROM sales;


-- 4. CHECK SALES REFERENCES AGAINST MASTER TABLES

SELECT COUNT(*) AS unmatched_customer_keys
FROM sales s
LEFT JOIN customers c
    ON s.CustomerKey = c.CustomerKey
WHERE c.CustomerKey IS NULL;


SELECT COUNT(*) AS unmatched_product_keys
FROM sales s
LEFT JOIN products p
    ON s.ProductKey = p.Product_Key
WHERE p.Product_Key IS NULL;


SELECT COUNT(*) AS unmatched_store_keys
FROM sales s
LEFT JOIN stores st
    ON s.StoreKey = st.StoreKey
WHERE st.StoreKey IS NULL;


-- 5. CHECK PROFIT CALCULATION

SELECT
    ROUND(SUM(Revenue_USD), 2) AS total_revenue,
    ROUND(SUM(Cost_USD), 2) AS total_cost,
    ROUND(SUM(Profit_USD), 2) AS total_profit,
    ROUND(SUM(Revenue_USD - Cost_USD), 2) AS calculated_profit,
    ROUND(SUM(Profit_USD) - SUM(Revenue_USD- Cost_USD), 2)
        AS profit_difference
FROM sales;


-- 6. CHECK ROWS WHERE PROFIT DOES NOT MATCH REVENUE - COST

SELECT COUNT(*) AS profit_mismatch_rows
FROM sales
WHERE ROUND(Profit_USD, 2) <> ROUND(Revenue_USD- Cost_USD, 2);


-- 7. CHECK INVALID OR UNEXPECTED QUANTITIES

SELECT COUNT(*) AS non_positive_quantity_rows
FROM sales
WHERE Quantity <= 0;


-- 8. CHECK DELIVERY DATE COMPLETENESS

SELECT
    COUNT(*) AS total_sales_rows,
    SUM(Delivery_Date IS NULL) AS missing_delivery_dates,
    SUM(Delivery_Date IS NOT NULL) AS available_delivery_dates
FROM sales;


-- 9. CHECK DELIVERY DATES BEFORE ORDER DATES

SELECT COUNT(*) AS invalid_delivery_date_rows
FROM sales
WHERE Delivery_Date < Order_Date;


-- 10. CHECK CUSTOMER MASTER DATA

SELECT
    COUNT(*) AS total_customers,
    COUNT(DISTINCT CustomerKey) AS distinct_customer_keys,
    SUM(CustomerKey IS NULL) AS missing_customer_keys
FROM customers;


-- 11. CHECK PRODUCT MASTER DATA

SELECT
    COUNT(*) AS total_products,
    COUNT(DISTINCT Product_Key) AS distinct_product_keys,
    SUM(Product_Key IS NULL) AS missing_product_keys
FROM products;


-- 12. CHECK STORE MASTER DATA

SELECT
    COUNT(*) AS total_stores,
    COUNT(DISTINCT StoreKey) AS distinct_store_keys,
    SUM(StoreKey IS NULL) AS missing_store_keys
FROM stores;


-- 13. CHECK DUPLICATE EXCHANGE RATE RECORDS

SELECT
    Date,
    Currency,
    COUNT(*) AS duplicate_count
FROM exchange_rates
GROUP BY Date, Currency
HAVING COUNT(*) > 1;


-- 14. CHECK CUSTOMERS WITHOUT SALES

SELECT COUNT(*) AS customers_without_sales
FROM customers c
LEFT JOIN sales s
    ON c.CustomerKey = s.CustomerKey
WHERE s.CustomerKey IS NULL;


-- =========================================================
-- END OF DATA VALIDATION
-- =========================================================
