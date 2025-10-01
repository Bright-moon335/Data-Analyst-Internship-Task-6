create database Online_sales;
use Online_sales;
create table online_sales (
  InvoiceNo VARCHAR(50),
  StockCode VARCHAR(50),
  Description TEXT,
  Quantity INT,
  InvoiceDate DATETIME,
  UnitPrice DECIMAL(12,4),
  CustomerID VARCHAR(50),
  Country VARCHAR(50),
  Discount DECIMAL(12,4),
  PaymentMethod VARCHAR(50),
  ShippingCost DECIMAL(12,4),
  Category VARCHAR(100),
  SalesChannel VARCHAR(100),
  ReturnStatus VARCHAR(50),
  ShipmentProvider VARCHAR(100),
  WarehouseLocation VARCHAR(100),
  OrderPriority VARCHAR(20)
);
LOAD DATA LOCAL INFILE 'C:/Users/aliya/OneDrive/Desktop/Customer Personality/Task 6/online_sales_dataset.csv'
INTO TABLE online_sales
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country, Discount, PaymentMethod, ShippingCost, Category, SalesChannel, ReturnStatus, ShipmentProvider, WarehouseLocation, OrderPriority);


SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

select user()

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/online_sales_dataset.csv'
INTO TABLE online_sales
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(InvoiceNo, StockCode, Description, Quantity, @InvoiceDate, UnitPrice, CustomerID, Country, Discount, PaymentMethod, @ShippingCost, Category, SalesChannel, ReturnStatus, ShipmentProvider, WarehouseLocation, OrderPriority)
SET 
    InvoiceDate = STR_TO_DATE(@InvoiceDate, '%Y-%m-%d %H:%i:%s'),
    ShippingCost = NULLIF(@ShippingCost, '');
show warnings;

select count(*) from online_sales;

-- monthly revenue and order volume
SELECT 
    YEAR(InvoiceDate) AS year,
    MONTH(InvoiceDate) AS month,
    SUM(UnitPrice * Quantity) AS total_revenue,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM online_sales
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY year, month;

-- for specific time period
SELECT 
    YEAR(InvoiceDate) AS year,
    MONTH(InvoiceDate) AS month,
    SUM(UnitPrice * Quantity) AS total_revenue,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM online_sales
WHERE YEAR(InvoiceDate) = 2020
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY month;

-- Average Order Value
SELECT 
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS month,
    SUM(UnitPrice * Quantity) AS total_revenue,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    (SUM(UnitPrice * Quantity) / COUNT(DISTINCT InvoiceNo)) AS avg_order_value
FROM online_sales
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
ORDER BY month;

