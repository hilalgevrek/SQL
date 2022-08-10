
CREATE DATABASE ConversionRate;
USE ConversionRate;


-- Create above table (Actions) and insert values

CREATE TABLE Actions
(
	[Visitor_ID] INT IDENTITY(1,1),
	[Adv_Type] VARCHAR(1),
	[Action] VARCHAR(10)
);

INSERT INTO Actions VALUES ('A', 'Left');
INSERT INTO Actions VALUES ('A', 'Order');
INSERT INTO Actions VALUES ('B', 'Left');
INSERT INTO Actions VALUES ('A', 'Order');
INSERT INTO Actions VALUES ('A', 'Review');
INSERT INTO Actions VALUES ('A', 'Left');
INSERT INTO Actions VALUES ('B', 'Left');
INSERT INTO Actions VALUES ('B', 'Order');
INSERT INTO Actions VALUES ('B', 'Review');
INSERT INTO Actions VALUES ('A', 'Review');

SELECT * FROM Actions;


-- Retrieve count of total Actions and Orders for each Advertisement Type

SELECT Adv_Type, 
COUNT(Action) AS Total_Actions 
FROM Actions 
GROUP BY Adv_Type;

SELECT Adv_Type, 
COUNT(Visitor_ID) AS Total_Order 
FROM Actions 
WHERE Action LIKE 'Order' 
GROUP BY Adv_Type;

SELECT A.Adv_Type, A.Total_Actions, B.Total_Order
FROM 
(SELECT Adv_Type, COUNT(Action) AS Total_Actions FROM Actions GROUP BY Adv_Type) AS A, 
(SELECT Adv_Type, COUNT(Visitor_ID) AS Total_Order FROM Actions WHERE Action LIKE 'Order' GROUP BY Adv_Type) AS B
WHERE A.Adv_Type = B.Adv_Type

CREATE VIEW Summary 
AS 
SELECT A.Adv_Type, A.Total_Actions, B.Total_Order
FROM 
(SELECT Adv_Type, COUNT(Action) AS Total_Actions FROM Actions GROUP BY Adv_Type) AS A, 
(SELECT Adv_Type, COUNT(Visitor_ID) AS Total_Order FROM Actions WHERE Action LIKE 'Order' GROUP BY Adv_Type) AS B
WHERE A.Adv_Type = B.Adv_Type

SELECT * FROM Summary


-- Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting as float by multiplying by 1.0

SELECT Adv_Type, ROUND(CAST(Total_Order AS FLOAT)/Total_Actions, 2) AS Conversation_Rate FROM Summary 