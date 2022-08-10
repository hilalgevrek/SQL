
/*
This is a discount effect trial for a database which has not real data. In this study, 
the effects of the discount on sales were examined on the basis of product id 
by examining the sales before the discount versus the sales after the discount. 
In line with the results obtained, inferences can also be made on the basis of discount rate.
*/

CREATE DATABASE DiscountEffect;
USE DiscountEffect;


CREATE TABLE Products
(
	[Product_ID] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Discount_Rate] FLOAT NULL,
	[Discount_Date] DATETIME NOT NULL
);

INSERT INTO Products VALUES (0.40, '2022-02-13');
INSERT INTO Products VALUES (0.10, '2022-02-12');
INSERT INTO Products VALUES (0.50, '2022-02-14');
INSERT INTO Products VALUES (0.5, '2022-02-10');
INSERT INTO Products VALUES (0.15, '2022-02-15');

SELECT * FROM Products;


CREATE TABLE Orders
(
	[Product_ID] INT FOREIGN KEY REFERENCES Products NOT NULL,
	[Selling_Quantity] INT NOT NULL,
	[Selling_Date] DATETIME NOT NULL,
	[Order_ID] INT PRIMARY KEY IDENTITY(1,1) NOT NULL
)

SET IDENTITY_INSERT Products ON
INSERT INTO Orders
    (Product_ID, Selling_Quantity, Selling_Date)
VALUES 
    (1, 2, '2022-1-16'),
	(1, 2, '2022-2-14'),
	(2, 1, '2022-1-18'),
	(2, 1, '2022-2-10'),
	(3, 2, '2022-1-20'),
	(3, 1, '2022-2-13'),
	(4, 3, '2022-1-25'),
	(4, 2, '2022-1-30'),
	(4, 2, '2022-1-19'),
	(5, 2, '2022-2-2'),
	(5, 2, '2022-2-5'),
	(5, 1, '2022-2-8'),
	(1, 3, '2022-2-16'),
	(1, 3, '2022-2-18'),
	(1, 3, '2022-2-19'),
	(2, 1, '2022-2-21'),
	(2, 1, '2022-2-22'),
	(3, 2, '2022-2-28'),
	(3, 3, '2022-2-25'),
	(3, 3, '2022-2-25'),
	(4, 2, '2022-3-8'),
	(4, 1, '2022-3-10'),
	(5, 3, '2022-3-13'),
	(5, 2, '2022-3-14')
SET IDENTITY_INSERT Products OFF

SELECT * FROM Orders


CREATE VIEW Order_Status
AS
SELECT Order_ID, Discount_Date, Selling_Date
FROM Products
LEFT JOIN Orders ON  Products.Product_ID = Orders.Product_ID;

SELECT * FROM Order_Status ORDER BY Order_ID;


SELECT Order_ID, Discount_Date, Selling_Date,
			CASE 
				WHEN Selling_Date < Discount_Date THEN 'Before Discount'
				WHEN Selling_Date >= Discount_Date THEN 'After Discount'
			END Ord_Status
INTO Info
FROM Order_Status;

SELECT * FROM Info ORDER BY Order_ID;


SELECT A.Order_ID, B.Product_ID, C.Ord_Status, A.Selling_Quantity
INTO Summary 
FROM Orders A, Products B, Info C
WHERE A.Product_ID = B.Product_ID AND A.Order_ID = C.Order_ID;

SELECT * FROM Summary;


SELECT A.Product_ID, A.Before_Total, B.After_Total
INTO Discount_Effects
FROM (SELECT Product_ID, SUM(Selling_Quantity) AS Before_Total FROM Summary WHERE Ord_Status = 'Before Discount'  GROUP BY Product_ID) AS A,  
(SELECT Product_ID, SUM(Selling_Quantity) AS After_Total FROM Summary WHERE Ord_Status = 'After Discount'  GROUP BY Product_ID) AS B
WHERE A.Product_ID = B.Product_ID;

SELECT * FROM Discount_Effects;


CREATE VIEW Effects
AS
SELECT Product_ID,
		CASE 
			WHEN Before_Total > After_Total THEN 'Negative'
			WHEN Before_Total = After_Total THEN 'Neutral'
			WHEN Before_Total < After_Total THEN 'Positive'
		END Discount_Effect  
FROM Discount_Effects;

SELECT * FROM Effects;