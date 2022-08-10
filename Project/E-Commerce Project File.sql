

--DAwSQL Session -8 

--E-Commerce Project Solution

CREATE DATABASE e_commerce;
USE e_commerce;


--1. Join all the tables and create a new table called combined_table. (market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)

WITH combined AS 
(
	SELECT	A.Customer_Name, A.Province, A.Region, A.Customer_Segment, 
			B.*, 
			C.Order_Date, C.Order_Priority, 
			D.Product_Category, D.Product_Sub_Category, 
			E.Order_ID, E.Ship_Mode, E.Ship_Date
	FROM	market_fact B
	FULL OUTER JOIN cust_dimen A ON A.Cust_id = B.Cust_id 
	FULL OUTER JOIN	 orders_dimen C ON C.Ord_id = B.Ord_id
	FULL OUTER JOIN prod_dimen D ON D.Prod_id = B.Prod_id
	FULL OUTER JOIN  shipping_dimen E ON E.Ship_id = B.Ship_id
)

SELECT  *
INTO	combined_table
FROM	combined;

SELECT * FROM combined_table;


--2. Find the top 3 customers who have the maximum count of orders.

SELECT TOP 3 Customer_Name, COUNT(Ord_id) AS Ord_Count 
FROM combined_table
GROUP BY Customer_Name 
ORDER BY Ord_Count DESC;


--3.Create a new column at combined_table as DaysTakenForDelivery that contains the date difference of Order_Date and Ship_Date.
--Use "ALTER TABLE", "UPDATE" etc.

ALTER TABLE combined_table
ADD DaysTakenForDelivery INT;

UPDATE combined_table 
SET DaysTakenForDelivery = DATEDIFF(DAY, Order_Date, Ship_Date);

SELECT * FROM combined_table;


--4. Find the customer whose order took the maximum time to get delivered.
--Use "MAX" or "TOP"

SELECT TOP 1 Customer_Name, DaysTakenForDelivery
FROM combined_table 
ORDER BY DaysTakenForDelivery DESC;

SELECT * 
FROM combined_table 
WHERE Customer_Name = 'DEAN PERCER' -- Check


--5. Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011
--You can use date functions and subqueries

-- People who placed orders every month in 2011
SELECT Customer_Name, COUNT(Customer_Name) AS Customer_Count 
FROM combined_table 
WHERE MONTH(Order_Date) = 1 and Customer_Name IN 
	(	SELECT DISTINCT Customer_Name  
		FROM combined_table 
		WHERE MONTH(Order_Date) BETWEEN 1 AND 12 AND YEAR(Order_Date) = 2011  
	)
GROUP BY Customer_Name 
ORDER BY Customer_Count DESC;

-- Number of people who placed orders each month in 2011
SELECT COUNT(DISTINCT Customer_Name) AS Customer_Count  -- Count of the total number of unique customers in January within the specified limit
FROM combined_table 
WHERE MONTH(Order_Date) = 1 and Customer_Name IN 
	(	SELECT DISTINCT Customer_Name  -- Who are came back every month over the entire year in 2011
		FROM combined_table 
		WHERE MONTH(Order_Date) BETWEEN 1 AND 12 AND YEAR(Order_Date) = 2011  
	)
ORDER BY Customer_Count DESC;


--6. write a query to return for each user acording to the time elapsed between the first purchasing and the third purchasing, 
--in ascending order by Customer ID
--Use "MIN" with Window Functions

WITH A AS
	(
		SELECT DISTINCT Customer_Name, Cust_id, FIRST_VALUE(Order_Date)  
		OVER(PARTITION BY Customer_Name ORDER BY Order_Date ASC) First_Date,
		ROW_NUMBER () OVER (PARTITION BY Customer_Name ORDER BY Order_Date ASC) Row_Num, Order_Date
		FROM combined_table
	)
SELECT Cust_id, Customer_Name, First_Date, Order_Date AS Third_Date 
FROM A 
WHERE Row_Num = 3 
ORDER BY Cust_id ASC;


--7. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products purchased by all customers.
--Use CASE Expression, CTE, CAST and/or Aggregate Functions

WITH A AS 
	(
		SELECT Customer_Name, SUM(Order_Quantity) AS Quantity
		FROM combined_table WHERE Prod_id = 'Prod_11' AND  -- Total purchased quantities from Prod_11
		Customer_Name IN
		( 
			SELECT Customer_Name FROM combined_table WHERE Prod_id = 'Prod_11'  
			INTERSECT  -- People purchased from both Prod_11 and Prod_14 
			SELECT Customer_Name FROM combined_table WHERE Prod_id = 'Prod_14' 
		)
		GROUP BY Customer_Name 

		UNION ALL  -- Birleþim

		SELECT Customer_Name, SUM(Order_Quantity) AS Quantity
		FROM combined_table WHERE Prod_id = 'Prod_14' AND  -- Total purchased quantities from Prod_14
		Customer_Name IN
		(
			SELECT Customer_Name FROM combined_table WHERE Prod_id = 'Prod_11'  
			INTERSECT	-- People purchased from both Prod_11 and Prod_14
			SELECT Customer_Name FROM combined_table WHERE Prod_id = 'Prod_14' 
		)
		GROUP BY Customer_Name 
	)

SELECT Customer_Name, ROUND(SUM(Quantity)/(SELECT SUM(Order_Quantity) FROM combined_table), 6) AS Ratio FROM A GROUP BY Customer_Name ORDER BY Customer_Name;


--CUSTOMER SEGMENTATION



--1. Create a view that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)
--Use such date functions. Don't forget to call up columns you might need later.

CREATE VIEW Customer_Visit
AS
SELECT Customer_Name, Cust_id, YEAR(Order_Date) AS Year,
			CASE MONTH(Order_Date)
				WHEN 1 THEN 'January'
				WHEN 2 THEN 'February'
				WHEN 3 THEN 'March'
				WHEN 4 THEN 'April'
				WHEN 5 THEN 'May'
				WHEN 6 THEN 'June'
				WHEN 7 THEN 'July'
				WHEN 8 THEN 'August'
				WHEN 9 THEN 'September'
				WHEN 10 THEN 'October'
				WHEN 11 THEN 'November'
				WHEN 12 THEN 'December'
			END Month  -- Yeni column'ýn ismi
FROM combined_table;

SELECT * FROM Customer_Visit ORDER BY Year, Month


  --2.Create a “view” that keeps the number of monthly visits by users. (Show separately all months from the beginning  business)
--Don't forget to call up columns you might need later.

CREATE VIEW Num_Visits_Monthly
AS
SELECT Cust_id, Month, COUNT(Month) AS Visit_Count 
FROM Customer_Visit 
GROUP BY Cust_id, Month;

SELECT * FROM Num_Visits_Monthly ORDER BY Month, Visit_Count DESC;


--3. For each visit of customers, create the next month of the visit as a separate column.
--You can order the months using "DENSE_RANK" function.
--then create a new column for each month showing the next month using the order you have made above. (use "LEAD" function.)
--Don't forget to call up columns you might need later.

SELECT Customer_Name, Cust_id, Year, Month, 
LEAD(Month) OVER(PARTITION BY Customer_Name ORDER BY Customer_Name, Year, Month) AS Next_Visit 
FROM Customer_Visit;


--4. Calculate monthly time gap between two consecutive visits by each customer.
--Don't forget to call up columns you might need later.

-- To calculate difference
CREATE VIEW Customer_Visit_With_Num
AS
SELECT Customer_Name, Cust_id, YEAR(Order_Date) AS Year, MONTH(Order_Date) AS Month
FROM combined_table;

SELECT * FROM Customer_Visit_With_Num;

CREATE VIEW Time_Gap
AS
WITH A AS 
	(
		SELECT Customer_Name, Cust_id, Year, Month, 
		LEAD(Month) OVER(PARTITION BY Customer_Name ORDER BY Customer_Name, Year, Month) AS Next_Visit 
		FROM Customer_Visit_With_Num
	)
SELECT *,
	CASE
		WHEN Month <= Next_Visit THEN DATEDIFF(DAY, Month, Next_Visit)
		WHEN Month > Next_Visit THEN DATEDIFF(DAY, -(12 - Month), Next_Visit)
	END AS Time_Gap
FROM A;

SELECT * FROM Time_Gap;

--5.Categorise customers using average time gaps. Choose the most fitted labeling model for you.
--For example: 
--Labeled as “churn” if the customer hasn't made another purchase for the months since they made their first purchase.
--Labeled as “regular” if the customer has made a purchase every month.
--Etc.
	
SELECT *,
	CASE		
		WHEN Time_Gap >= 4 THEN 'Average'
		WHEN Time_Gap < 4 THEN 'Regular'
		ELSE 'Churn'
	END AS Customer_Status
FROM Time_Gap;


--MONTH-WISE RETENTÝON RATE


--Find month-by-month customer retention rate  since the start of the business.


--1. Find the number of customers retained month-wise. (You can use time gaps)
--Use Time Gaps

SELECT DISTINCT Month, SUM(Visit_Count) OVER (PARTITION BY Month) AS Visit FROM Num_Visits_Monthly ORDER BY Visit DESC;


--2. Calculate the month-wise retention rate.

--Basic formula: o	Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Current Month / Total Number of Customers in the Current Month

--It is easier to divide the operations into parts rather than in a single ad-hoc query. It is recommended to use View. 
--You can also use CTE or Subquery if you want.

--You should pay attention to the join type and join columns between your views or tables.


---///////////////////////////////////
--Good luck!