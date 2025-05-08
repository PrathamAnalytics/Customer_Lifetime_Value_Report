CREATE TABLE Customers (
    transaction_id     BIGINT,
    customer_id        BIGINT,
    name               TEXT,
    phone              BIGINT,
    city               TEXT,
    state              TEXT,
    country            TEXT,
    age                INT,
    age_gap TEXT CHECK (age_gap IN ('Young', 'Adult', 'Old')),
    gender             VARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other')),
    income             TEXT,
    customer_segment   TEXT,
    date               TEXT,
    year               INT,
    month              TEXT,
    time               TEXT,
    total_purchases    INT,
    amount             NUMERIC(10, 2),
    total_amount       NUMERIC(10, 2),
    product_category   TEXT,
    product_brand      TEXT,
    product_type       TEXT,
    feedback           TEXT,
    shipping_method    TEXT,
    payment_method     TEXT,
    order_status       TEXT,
    ratings            NUMERIC(2, 1),
    products           TEXT
);

/*==================================================================
                         Advanced Analysis 
==================================================================*/

-- 1. Top 5 Cities by Total Revenue.

SELECT 
	City, 
	SUM(Total_Amount) AS Total_Revenue
FROM Customers
GROUP BY City
ORDER BY Total_Revenue DESC
LIMIT 5;

-- 2. Number of Customers per Country.

SELECT 
	Country, 
	COUNT(DISTINCT Customer_ID) AS Total_Customers
FROM Customers
GROUP BY Country
ORDER BY Total_Customers DESC;

-- 3. Average Order Value per Gender.

SELECT 
	Gender, 
	ROUND(AVG(Total_Amount), 2) AS Avg_Order_Value
FROM Customers
GROUP BY Gender;

-- 4. Total Orders by Payment Method.

SELECT 
	Payment_Method, 
	COUNT(*) AS Order_Count
FROM Customers
GROUP BY Payment_Method
ORDER BY Order_Count DESC;

-- 5. Top 5 Product Categories by Sales.

SELECT 
	Product_Category, 
	SUM(Total_Amount) AS Revenue
FROM Customers
GROUP BY Product_Category
ORDER BY Revenue DESC
LIMIT 5;

-- 6. Average Ratings per Product Category.

SELECT 
	Product_Category, 
	ROUND(AVG(Ratings), 2) AS Avg_Rating
FROM Customers
GROUP BY Product_Category;

-- 7. Revenue per Shipping Method.

SELECT 
	Shipping_Method, 
	SUM(Total_Amount) AS Revenue
FROM Customers
GROUP BY Shipping_Method
ORDER BY Revenue DESC;

-- 8. Most Common Order Status. 

SELECT 
	Order_Status, 
	COUNT(*) AS Total_Orders
FROM Customers
GROUP BY Order_Status
ORDER BY Total_Orders DESC;

-- 9. Total Purchases by Customer Segment.

SELECT 
	Customer_Segment, 
	SUM(Total_Purchases) AS Total_Purchases
FROM Customers
GROUP BY Customer_Segment;

-- 10. Total Customers by Age Group.

SELECT 
	Age_Gap, 
	COUNT(DISTINCT Customer_ID) AS Total_Customers
FROM Customers
GROUP BY Age_Gap;

-- 11. Number of Orders per Year.

SELECT 
	Year, 
	COUNT(*) AS Total_Orders
FROM Customers
GROUP BY Year
ORDER BY Year;

-- 12. Average Age of Customers.

SELECT 
	ROUND(AVG(Age), 1) AS Avg_Age
FROM Customers;

-- 13. Revenue per Month.

SELECT 
	Month, 
	SUM(Total_Amount) AS Monthly_Revenue
FROM Customers
GROUP BY Month;

-- 14. Most Frequent Customers.

SELECT 
	Customer_ID, 
	COUNT(*) AS Purchase_Count
FROM Customers
GROUP BY Customer_ID
ORDER BY Purchase_Count DESC
LIMIT 10;

-- 15. Top Brands by Revenue.

SELECT 
	Product_Brand, 
	SUM(Total_Amount) AS Revenue
FROM Customers
GROUP BY Product_Brand
ORDER BY Revenue DESC
LIMIT 10;

-- 16. Customer Retention (Returning Customers).

SELECT 
	Customer_ID, 
	COUNT(DISTINCT Date) AS Visit_Count
FROM Customers
GROUP BY Customer_ID
HAVING COUNT(DISTINCT Date) > 1;

-- 17. Average Monthly Spend by Country.

SELECT 
	Country, 
	ROUND(AVG(Total_Amount), 2) AS Avg_Monthly_Spend
FROM Customers
GROUP BY Country
ORDER BY Avg_Monthly_Spend DESC;

-- 18. Revenue by Product Type for Each State.

SELECT 
	State, 
	Product_Type, 
	SUM(Total_Amount) AS Revenue
FROM Customers
GROUP BY 
	State, 
	Product_Type;

-- 19. Revenue Comparison of ‘Young’ vs ‘Old’ Customers.

SELECT 
	Age_Gap, 
	SUM(Total_Amount) AS Revenue
FROM Customers
WHERE Age_Gap IN ('Young', 'Old')
GROUP BY Age_Gap;

-- 20. Sales by Gender and Country.

SELECT 
	Gender, 
	Country, 
	SUM(Total_Amount) AS Sales
FROM Customers
GROUP BY 
	Gender, 
	Country;

-- 21. Customer Segments with Above-Average Purchase Value.

SELECT 
	Customer_Segment, 
	ROUND(AVG(Total_Amount), 2) AS Avg_Value
FROM Customers
GROUP BY Customer_Segment
HAVING AVG(Total_Amount) > (
  SELECT AVG(Total_Amount) FROM Customers
);

-- 22. Customers Who Have Bought More Than 5 Times.

SELECT 
	Customer_ID, 
	COUNT(*) AS Purchase_Frequency
FROM Customers
GROUP BY Customer_ID
HAVING COUNT(*) > 5;

-- 23. Product Revenue by Payment Method.

SELECT 
	Payment_Method, 
	Product_Category, 
	SUM(Total_Amount) AS Revenue
FROM Customers
GROUP BY 
	Payment_Method, 
	Product_Category;

-- 24. Average Rating by Feedback Category.

SELECT 
	Feedback, 
	ROUND(AVG(Ratings),2) AS Avg_Rating
FROM Customers
GROUP BY Feedback;

-- 25. Brand Preference by Gender.

SELECT 
	Gender, 
	Product_Brand, 
	COUNT(*) AS Purchase_Count
FROM Customers
GROUP BY 
	Gender, 
	Product_Brand
ORDER BY 
	Gender, 
	Purchase_Count DESC;

-- 26. List Top States for Electronics Sales.

SELECT 
	State, 
	SUM(Total_Amount) AS Revenue
FROM Customers
WHERE Product_Category = 'Electronics'
GROUP BY State
ORDER BY Revenue DESC;

-- 27. Monthly Revenue Growth for 2023.

SELECT 
	Month, 
	SUM(Total_Amount) AS Revenue
FROM Customers
WHERE Year = 2023
GROUP BY Month
ORDER BY Month;

-- 28. Purchase Count by Order Status.

SELECT 
	Order_Status, 
	COUNT(*) AS Purchase_Count
FROM Customers
GROUP BY Order_Status;

-- 29. Customer Ranking Based on Total Spend.

SELECT 
	Customer_ID, 
	SUM(Total_Amount) AS Total_Spend,
    RANK() OVER (ORDER BY SUM(Total_Amount) DESC) AS Spend_Rank
FROM Customers
GROUP BY Customer_ID;

-- 30. Repeat Rate Per Customer.

SELECT 
	Customer_ID,
    COUNT(*) AS Total_Orders,
    COUNT(DISTINCT Date) AS Visit_Days,
    CASE 
		WHEN COUNT(*) > 1 THEN 'Repeat' 
		ELSE 'One-time' 
	END AS Status
FROM Customers
GROUP BY Customer_ID;

-- 31. Top 10% Customers Contributing to Revenue.

WITH customer_spend AS (
  SELECT 
  	Customer_ID, 
	SUM(Total_Amount) AS Spend
  FROM Customers
  GROUP BY Customer_ID
),
ranked AS (
  SELECT 
  	*, 
	NTILE(10) OVER (ORDER BY Spend DESC) AS decile
  FROM customer_spend
)
SELECT 
	COUNT(*) AS Top_Customers, 
	SUM(Spend) AS Top_Revenue
FROM ranked
WHERE decile = 1;

-- 32. Feedback vs Revenue.

SELECT 
	Feedback, 
	ROUND(AVG(Total_Amount), 2) AS Avg_Revenue
FROM Customers
GROUP BY Feedback
ORDER BY Avg_Revenue DESC;

-- 33. Which customer segments are most profitable?

SELECT 
    customer_segment, 
    ROUND(SUM(total_amount), 2) AS segment_revenue
FROM Customers
GROUP BY customer_segment
ORDER BY segment_revenue DESC;

-- 34. What product categories are most purchased by each customer segment?

SELECT 
    customer_segment, 
    product_category, 
    COUNT(*) AS purchase_count
FROM Customers
GROUP BY customer_segment, product_category
ORDER BY customer_segment, purchase_count DESC;





