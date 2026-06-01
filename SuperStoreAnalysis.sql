USE SuperstoreProject

--------Left Join 
SELECT 
    o.*,
    p.[regional manager],
    r.returned
FROM orders o
LEFT JOIN people p
    ON o.region = p.region
LEFT JOIN returns r
    ON o.order_id = r.order_id


SELECT 
    o.*,
    p.[Regional Manager],
    r.returned
INTO superstore_final
FROM orders o
LEFT JOIN people p
    ON o.region = p.region
LEFT JOIN returns r
    ON o.order_id = r.order_id

------

--1) Overview : How we are going in general ? --------------------------------------
SELECT
Sum(sales) as Total_Sales ,
Sum(profit) as Total_Profit ,
ROUND(Sum(profit) / Sum(sales) * 100 ,2) as Profit_Margin ,
SUM(Quantity) as Total_Units_Sold ,
Count(Distinct Order_ID) as Total_Orders ,
Count(DISTINCT CUSTOMER_ID) as Total_Customers ,
ROUND(AVG([Sales]), 2)   AS Avg_Order_Value
FROM superstore_final

--2) Subcategories and Products -----

---2.1) Which sub-categories are losing money?
SELECT Category,Sub_Category,
COUNT(DISTINCT Order_ID)  AS Total_Orders,
ROUND(SUM(Sales), 2)  AS Total_Sales,
ROUND(SUM(Profit), 2)   AS Total_Profit,
ROUND(SUM(Profit) / (SUM(Sales)) * 100, 2)  AS Profit_Margin_Pct,
COUNT(DISTINCT CASE WHEN Profit < 0 THEN [Order_ID] END)  AS Loss_Orders,
ROUND(AVG(Discount) * 100, 2)  AS Avg_Discount_Pct
FROM superstore_final
GROUP BY Category, Sub_Category
ORDER BY Total_Profit ASC

--2.2) Top 10 products losing the most money
SELECT TOP 10 Product_Name,Category,Sub_Category,
COUNT(DISTINCT Order_ID) AS Total_Orders,
ROUND(SUM(Sales), 2) AS Total_Sales,
ROUND(SUM(Profit), 2) AS Total_Profit,
ROUND(AVG(Discount) * 100, 2) AS Avg_Discount_Pct
FROM superstore_final
GROUP BY Product_Name, Category, Sub_Category
ORDER BY Total_Profit ASC

--2.3) Top 10 products by profit--
SELECT TOP 10 product_name, category,sub_category, 
COUNT(DISTINCT Order_ID) AS Total_Orders,
ROUND(SUM(profit), 2) AS Total_profit,
ROUND(SUM(Sales), 2) AS Total_Sales,
ROUND(AVG(Discount) * 100, 2) AS Avg_Discount_Pct
FROM superstore_final
GROUP BY product_name,Category,Sub_Category
ORDER BY Total_profit DESC

---2.4) All worst ordered products by profit--------------------------
SELECT Product_Name, SUM(profit) AS loss
FROM Orders
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY loss

--3 D I S C O U N T ------------------------
SELECT 
ROUND(Discount * 100, 0)AS Discount_Pct,
COUNT(DISTINCT Order_ID)AS Orders,
ROUND(SUM([Profit]), 2)AS Total_Profit,
ROUND(SUM([Sales]), 2) AS Total_Sales,
ROUND(AVG(Profit), 2)AS Avg_Profit,
ROUND(AVG(Sales), 2)AS Avg_Sales
FROM superstore_final
GROUP BY ROUND([Discount] * 100, 0)
ORDER BY Discount_Pct

---4 R E T U R N S ----

--4.1) Returns by category and subcategory---------------------
SELECT Category,Sub_Category,
COUNT(DISTINCT [Order_ID]) AS Total_Orders,
COUNT(DISTINCT CASE WHEN Returned = 'Yes' THEN Order_ID END) AS Returned_Orders,
ROUND(100.0 * COUNT(DISTINCT CASE WHEN Returned = 'Yes' THEN Order_ID END) / (COUNT(DISTINCT Order_ID) ), 2) AS Return_Rate_Pct,
SUM(CASE WHEN Returned = 'Yes' THEN Quantity ELSE 0 END) AS Returned_Quantity,
ROUND(SUM(CASE WHEN Returned = 'Yes' THEN Sales ELSE 0 END), 2) AS Returned_Sales_Value,
ROUND(SUM(CASE WHEN Returned = 'Yes' THEN Profit ELSE 0 END), 2) AS Profit_Lost_From_Returns
FROM superstore_final
GROUP BY Category, Sub_Category
ORDER BY Return_Rate_Pct DESC

--4.2) Returns by customer segment----------------------------
SELECT Segment,
COUNT(DISTINCT Order_ID)  AS Total_Orders,
COUNT(DISTINCT CASE WHEN Returned = 'Yes' THEN Order_ID END) AS Returned_Orders,
ROUND( 100.0 *  COUNT(DISTINCT CASE WHEN Returned = 'Yes' 
THEN Order_ID END) / NULLIF(COUNT(DISTINCT Order_ID), 0), 2)  AS Return_Rate_Pct,
ROUND(SUM(CASE WHEN Returned = 'Yes' THEN Profit ELSE 0 END), 2) AS Profit_Lost
FROM superstore_final
GROUP BY Segment
ORDER BY Return_Rate_Pct DESC

--4.3) Returns by Region and state-----------------
SELECT region,[Regional Manager],
State_Province, COUNT(returned) AS Returned_Orders,
count(distinct Order_ID) as total_orders,
ROUND( 100.0 *  COUNT(DISTINCT CASE WHEN Returned = 'Yes' 
THEN Order_ID END) / NULLIF(COUNT(DISTINCT Order_ID), 0), 2)  AS Return_Rate_Pct,
round(sum(sales),2)as total_sales
FROM superstore_final
GROUP BY region,State_Province,[Regional Manager]
ORDER BY Return_Rate_Pct DESC