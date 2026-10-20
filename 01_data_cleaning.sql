CREATE DATABASE global_electronics;

USE global_electronics;

SELECT DATABASE();

select count(*) as total_rows from sales;
select * from sales
limit 5;

describe sales;

select `Order Date` as original_order_date, STR_TO_DATE(`Order Date`, '%d-%m-%Y') as converted_order_date, `Delivery Date` as original_delivery_date,
STR_TO_DATE(NULLIF(`Delivery Date`, ''), '%d-%m-%Y') as converted_delivery_date from sales
limit 10;

Update sales
SET `Order Date` = DATE_FORMAT(STR_TO_DATE(`Order Date`, '%d-%m-%Y'),'%Y-%m-%d'), `Delivery Date` = CASE WHEN `Delivery Date` IS NULL OR `Delivery Date` = ''
        THEN NULL
        ELSE DATE_FORMAT(
            STR_TO_DATE(`Delivery Date`, '%d-%m-%Y'),
            '%Y-%m-%d'
        )
    END;
    
    
ALTER TABLE sales
    MODIFY COLUMN `Order Date` DATE NULL,
    MODIFY COLUMN `Delivery Date` DATE NULL;
    
    
DESCRIBE sales;

SELECT COUNT(*) AS total_rows,
    SUM(`Order Date` IS NULL) AS missing_order_dates,
    SUM(`Delivery Date` IS NULL) AS missing_delivery_dates
FROM sales;

SELECT
    `Birthday`,
    STR_TO_DATE(`Birthday`, '%d-%m-%Y') AS converted_birthday,
    `Open Date`,
    STR_TO_DATE(`Open Date`, '%d-%m-%Y') AS converted_open_date,
    `Delivery Days`,
    NULLIF(`Square Meters`, '') AS square_meters_value
FROM sales
LIMIT 10;

ALTER TABLE sales
    MODIFY COLUMN `Birthday` DATE NULL,
    MODIFY COLUMN `Open Date` DATE NULL,
    MODIFY COLUMN `Delivery Days` INT NULL,
    MODIFY COLUMN `Square Meters` INT NULL;
    
UPDATE sales
SET `Delivery Days` = NULL
WHERE TRIM(`Delivery Days`) = '';

UPDATE sales
SET `Square Meters` = NULL
WHERE TRIM(`Square Meters`) = '';


UPDATE sales
SET
    `Birthday` = DATE_FORMAT(
        STR_TO_DATE(NULLIF(TRIM(`Birthday`), ''), '%d-%m-%Y'),
        '%Y-%m-%d'
    ),
    `Open Date` = DATE_FORMAT(
        STR_TO_DATE(NULLIF(TRIM(`Open Date`), ''), '%d-%m-%Y'),
        '%Y-%m-%d'
    );
    
ALTER TABLE sales
MODIFY COLUMN `Birthday` DATE NULL,
MODIFY COLUMN `Open Date` DATE NULL,
MODIFY COLUMN `Delivery Days` INT NULL,
MODIFY COLUMN `Square Meters` INT NULL;

DESCRIBE sales;

SELECT COUNT(*) AS total_rows, SUM(`Delivery Days` IS NULL) AS missing_delivery_days, SUM(`Square Meters` IS NULL) AS missing_square_meters FROM sales;

ALTER TABLE sales
RENAME COLUMN `Order Number` TO `Order_Number`;

ALTER TABLE sales
    RENAME COLUMN `Line Item` TO Line_Item,
    RENAME COLUMN `Order Date` TO Order_Date,
    RENAME COLUMN `Delivery Date` TO Delivery_Date,
    RENAME COLUMN `Currency Code` TO Currency_Code,
    RENAME COLUMN `Unit Cost USD` TO Unit_Cost_USD,
    RENAME COLUMN `Unit Price USD` TO Unit_Price_USD,
    RENAME COLUMN `Revenue USD` TO Revenue_USD,
    RENAME COLUMN `Cost USD` TO Cost_USD,
    RENAME COLUMN `Profit USD` TO Profit_USD,
    RENAME COLUMN `Profit Margin %` TO Profit_Margin_Pct,
    RENAME COLUMN `Delivery Days` TO Delivery_Days,
    RENAME COLUMN `Customer Age` TO Customer_Age,
    RENAME COLUMN `Customer Age Group` TO Customer_Age_Group,
    RENAME COLUMN `Open Date` TO Open_Date,
    RENAME COLUMN `Square Meters` TO Square_Meters,
    RENAME COLUMN `Store Age` TO Store_Age,
    RENAME COLUMN `Store Age Group` TO Store_Age_Group;

Select Count(*) AS total_products From products;

DESCRIBE products;

ALTER TABLE products
    RENAME COLUMN `ProductKey` TO Product_Key,
    RENAME COLUMN `Product Name` TO Product_Name,
    RENAME COLUMN `Unit Cost USD` TO Unit_Cost_USD,
    RENAME COLUMN `Unit Price USD` TO Unit_Price_USD,
    RENAME COLUMN `SubcategoryKey` TO Subcategory_Key,
    RENAME COLUMN `CategoryKey` TO Category_Key;

SELECT COUNT(*) AS total_products,
    SUM(Unit_Cost_USD IS NULL) AS missing_costs,
    SUM(Unit_Price_USD IS NULL) AS missing_prices,
    SUM(Unit_Cost_USD <= 0) AS nonpositive_costs,
    SUM(Unit_Price_USD <= 0) AS nonpositive_prices FROM products;
    
    

SELECT COUNT(*) AS total_stores FROM stores;

SELECT * FROM stores;

DESCRIBE stores;

SELECT COUNT(*) AS total_stores,
    COUNT(DISTINCT StoreKey) AS unique_stores,
    SUM(`Square Meters` IS NULL) AS missing_square_meters
FROM stores;

SELECT *
FROM stores
WHERE TRIM(`Square Meters`) = ''
   OR `Square Meters` IS NULL;
   
UPDATE stores
SET `Square Meters` = NULL
WHERE TRIM(`Square Meters`) = '';

UPDATE stores
SET `Open Date` = DATE_FORMAT(
    STR_TO_DATE(TRIM(`Open Date`), '%d-%m-%Y'),
    '%Y-%m-%d'
)
WHERE TRIM(`Open Date`) <> '';

ALTER TABLE stores
    MODIFY COLUMN `Square Meters` INT NULL,
    MODIFY COLUMN `Open Date` DATE NULL;

ALTER TABLE stores 
RENAME COLUMN `Square Meters` TO Square_meters ,
RENAME COLUMN `Open Date` TO  Open_date;

SELECT COUNT(*) AS total_rows
FROM exchange_rates;

DESCRIBE exchange_rates;

SELECT * FROM exchange_rates
LIMIT 10;

UPDATE exchange_rates
SET `Date` = DATE_FORMAT(
    STR_TO_DATE(TRIM(`Date`), '%d-%m-%Y'),
    '%Y-%m-%d'
)
WHERE TRIM(`Date`) <> '';

ALTER TABLE exchange_rates
    MODIFY COLUMN `Date` DATE NULL,
    MODIFY COLUMN `Currency` VARCHAR(10) NULL,
    MODIFY COLUMN `Exchange` DECIMAL(12,6) NULL;
    
SELECT
    COUNT(*) AS total_rows,
    SUM(`Date` IS NULL) AS missing_dates,
    SUM(`Currency` IS NULL OR TRIM(`Currency`) = '') AS missing_currencies,
    SUM(`Exchange` IS NULL) AS missing_exchange_rates,
    COUNT(DISTINCT CONCAT(`Date`, '|', `Currency`)) AS unique_date_currency_pairs
FROM exchange_rates;


SELECT COUNT(*) AS total_rows FROM data_dictionary;

DESCRIBE data_dictionary;

SELECT * FROM data_dictionary
LIMIT 10;


SELECT COUNT(*) AS total_rows FROM customers;

DESCRIBE customers;

ALTER TABLE customers
RENAME COLUMN `State Code` TO State_Code ,
RENAME COLUMN `Zip Code`   TO Zip_Code;

Select * from customers;

SELECT Birthday, STR_TO_DATE(`Birthday`, '%d-%m-%Y') AS converted_birthday from customers;

UPDATE customers
SET Birthday = DATE_FORMAT(STR_TO_DATE(NULLIF(TRIM(`Birthday`), ''), '%d-%m-%Y'),'%Y-%m-%d')

ALTER TABLE customers
MODIFY COLUMN Birthday DATE NULL;

Select Count(*) as Total_rows , Count(distinct CustomerKey) as Unique_customers , Sum(CustomerKey is NULL ) as missing_customer_keys from customers;




SELECT 'sales' AS table_name, COUNT(*) AS total_rows FROM sales
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
    
DESCRIBE sales;
DESCRIBE products;
DESCRIBE stores;

SELECT
    COUNT(*) AS total_sales,
    SUM(CASE
        WHEN c.CustomerKey IS NULL THEN 1
        ELSE 0
    END) AS unmatched_customers,
    SUM(CASE
        WHEN p.Product_Key IS NULL THEN 1
        ELSE 0
    END) AS unmatched_products,
    SUM(CASE
        WHEN st.StoreKey IS NULL THEN 1
        ELSE 0
    END) AS unmatched_stores
FROM sales AS s
LEFT JOIN customers AS c
    ON s.CustomerKey = c.CustomerKey
LEFT JOIN products AS p
    ON s.ProductKey = p.Product_Key
LEFT JOIN stores AS st
    ON s.StoreKey = st.StoreKey;