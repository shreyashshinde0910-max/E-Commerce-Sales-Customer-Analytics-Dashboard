--Checking records in each table

SELECT COUNT(*) AS total_customers
FROM customers;

SELECT COUNT(*) AS total_products
FROM products;

SELECT COUNT(*) AS total_orders
FROM orders;

--Changing column types to NUMERIC

ALTER TABLE orders
ALTER COLUMN "Sales" TYPE NUMERIC;

ALTER TABLE orders
ALTER COLUMN "Profit" TYPE NUMERIC;

ALTER TABLE orders
ALTER COLUMN "Unit_Price" TYPE NUMERIC;



--Q1. What is the total revenue, total profit, and total number of orders?
SELECT
    ROUND(SUM("Sales"), 2) AS Total_Revenue,
    ROUND(SUM("Profit"), 2) AS Total_Profit,
    COUNT("Order_ID") AS Total_Orders
FROM orders;


--Q2. How has sales changed month by month?
SELECT
    DATE_TRUNC('month', "Order_Date") AS Month,
    ROUND(SUM("Sales"),2) AS Total_Sales
FROM orders
GROUP BY Month
ORDER BY Month;


--Q3. Which product categories generate the highest sales?
SELECT
    "Category",
    ROUND(SUM("Sales"),2) AS Total_Sales
FROM orders
GROUP BY "Category"
ORDER BY Total_Sales DESC;


--Q4. Which products generate the highest revenue?
SELECT
    "Product_Name",
    ROUND(SUM("Sales"),2) AS Revenue
FROM orders
GROUP BY "Product_Name"
ORDER BY Revenue DESC
LIMIT 10;


--Q5. Which customers spend the most?
SELECT
    "Customer_ID",
    ROUND(SUM("Sales"),2) AS Total_Spent
FROM orders
GROUP BY "Customer_ID"
ORDER BY Total_Spent DESC
LIMIT 10;


--Q6. Which states contribute the highest revenue?
SELECT
    "State",
    ROUND(SUM("Sales"),2) AS Revenue
FROM orders
GROUP BY "State"
ORDER BY Revenue DESC;


--Q7. Which payment methods are most frequently used by customers?
SELECT
    "Payment_Method",
    COUNT(*) AS Total_Orders
FROM orders
GROUP BY "Payment_Method"
ORDER BY Total_Orders DESC;


--Q8. Which shipping mode is used most frequently for customer orders?
SELECT
    "Shipping_Mode",
    COUNT(*) AS Total_Orders
FROM orders
GROUP BY "Shipping_Mode"
ORDER BY Total_Orders DESC;


--Q9. Which products generate the highest profit?
SELECT
    "Product_Name",
    ROUND(SUM("Profit"),2) AS Total_Profit
FROM orders
GROUP BY "Product_Name"
ORDER BY Total_Profit DESC
LIMIT 10;


--Q10. How do products rank based on total sales revenue?
SELECT
    "Product_Name",
    ROUND(SUM("Sales"),2) AS Revenue,
    RANK() OVER(
        ORDER BY SUM("Sales") DESC
    ) AS Sales_Rank
FROM orders
GROUP BY "Product_Name";


--Q11. Which product generates the highest sales revenue within each product category?
WITH ProductSales AS (
    SELECT
        "Category",
        "Product_Name",
        SUM("Sales") AS Total_Sales,
        RANK() OVER (
            PARTITION BY "Category"
            ORDER BY SUM("Sales") DESC
        ) AS Rank_No
    FROM orders
    GROUP BY "Category", "Product_Name"
)
SELECT
    "Category",
    "Product_Name",
    ROUND(Total_Sales,2) AS Total_Sales
FROM ProductSales
WHERE Rank_No = 1;


--Q12. What percentage of total revenue comes from each category?
SELECT
    "Category",
    ROUND(SUM("Sales"),2) AS Total_Sales,
    ROUND(
        SUM("Sales") * 100.0 /
        (SELECT SUM("Sales") FROM orders),
        2
    ) AS Revenue_Percentage
FROM orders
GROUP BY "Category"
ORDER BY Revenue_Percentage DESC;
