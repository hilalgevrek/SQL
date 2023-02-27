----- MARCH 9, 2022

--Write a query that returns the net price paid by the customer for each order. (Don't neglect discounts and quantities)


--bir sipari?in toplam net tutar?n? getiriniz. (mü?terinin sipari? için ödedi?i tutar)
--discount' ? ve quantity' yi ihmal etmeyiniz.






---------- ROLLUP ---------
--Generate different grouping variations that can be produced with the brand and category columns using 'ROLLUP'.
-- Calculate sum total_sales_price

--brand, category, model_year sütunlar? için Rollup kullanarak total sales hesaplamas? yap?n.
--üç sütun için 4 farkl? gruplama varyasyonu üretiyor


SELECT Brand, Category, Model_Year, SUM(total_sales_price) TOTAL 
FROM sale.sales_summary
GROUP BY 
	ROLLUP (Brand, Category, Model_Year)
ORDER BY Model_Year, Category

----- CUBE

SELECT Brand, Category, Model_Year, SUM(total_sales_price)
FROM sale.sales_summary
GROUP BY
	CUBE (Brand, Category, Model_Year)
ORDER BY Brand, Category


----- pivot table


--Write a query that returns total sales amount by categories

SELECT Category, total_sales_price
FROM sale.sales_summary

SELECT *  -- Alttaki sorgumuzu subquery haline getirdik ve altaki sorgu için tüm deðeleri getir dedik
FROM 
(
SELECT Category, total_sales_price  
FROM sale.sales_summary
) B
PIVOT
(
		SUM(total_sales_price)
		FOR Category  -- Hedef sütun. Biz burada iþlem yapmasýný istiyoruz.
		IN  -- Her bir veri (Category sütunundaki)
		([Audio & Video Accessories]
		,[Bluetooth]
		,[Car Electronics]
		,[Computer Accessories]
		,[Earbud]
		,[gps]
		,[Hi-Fi Systems]
		,[Home Theater]
		,[mp4 player]
		,[Receivers Amplifiers]
		,[Speakers]
		,[Televisions & Accessories]
		)
) AS PIVOT_TABLE  -- Ýsim verdik


----- SET OPERATORS

-- UNION-UNIONALL

---- 
--List Customer's last names in Charlotte and Aurora

SELECT last_name
FROM sale.customer 
WHERE city = 'Charlotte'
UNION ALL
SELECT last_name
FROM sale.customer 
WHERE city = 'Aurora'


SELECT last_name
FROM sale.customer 
WHERE city = 'Charlotte'
UNION
SELECT last_name
FROM sale.customer 
WHERE city = 'Aurora'


SELECT last_name
FROM sale.customer 
WHERE city IN ('Charlotte', 'Aurora') --- UNION ALL GIBI BUTUN VERILER GELIR


--Write a query that returns customers who name is ‘Thomas’ or surname is ‘Thomas’. (Don't use 'OR')


SELECT first_name, last_name
FROM sale.customer
WHERE first_name = 'Thomas'
UNION ALL  -- Buradaki OR mantýðýný saðlayan þey UNION ALL
SELECT first_name, last_name
FROM sale.customer
WHERE last_name = 'Thomas'



------ --Even if the contents of to be unified columns are different, the data type must be the same.

SELECT *  -- Ýçerik farklý olsa bile data tipleri ayný ve column sayýlarý ayný o yüzden UNION iþlemini yaptý. 
FROM product.brand 
UNION 
SELECT *
FROM product.category

SELECT *  -- Üstteki ile ayný sonucu verir
FROM product.brand 
UNION ALL
SELECT *
FROM product.category


--- COLUMN SAYISI FARKLI OLMA DURUMU 


SELECT city, 'CLEAN' AS STREET  -- Column sayýlarý farklý olduðu için hata verir
FROM sale.store
UNION ALL
SELECT city
FROM sale.store


---- INTERSECT

-- Write a query that returns brands that have products for both 2018 and 2019.

SELECT *
FROM product.brand
WHERE brand_id IN
(
SELECT brand_id
FROM product.product
WHERE model_year = 2018
INTERSECT  -- Kesiþimlerini verir
SELECT brand_id
FROM product.product
WHERE model_year = 2019
) ;



------- Write a query that returns customers who have orders for both 2018, 2019, and 2020

SELECT first_name, last_name 
FROM sale.customer  -- Subquery'deki  durumu saðlayan tüm verilerin sale.customer tablosundaki first_name ve last_name deðerlerini döndür dedik.
WHERE customer_id IN
(
SELECT customer_id
FROM sale.orders
WHERE order_date BETWEEN '2018-01-01' AND '2018-12-31' 
INTERSECT
SELECT customer_id
FROM sale.orders
WHERE order_date BETWEEN '2019-01-01' AND '2019-12-31' 
INTERSECT 
SELECT customer_id
FROM sale.orders
WHERE order_date BETWEEN '2020-01-01' AND '2020-12-31' 
)


----- EXCEPT 

-- Write a query that returns brands that have a 2018 model product but not a 2019 model product.

SELECT * 
FROM product.brand
WHERE brand_id IN 
(
SELECT brand_id
FROM product.product
WHERE model_year = 2018
EXCEPT  -- 2018'de olup 20119'da olmayanlarý getirir
SELECT brand_id
FROM product.product
WHERE model_year = 2019
)



--- CASE EXPRESSION  -- Python'daki if else mantýðýnda çalýþýr


--- SIMPLE CASE EXPRESSION 


-- Generate a new column containing what the mean of the values in the Order_Status column.

-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed

SELECT order_id, order_status
FROM sale.orders


SELECT order_id, order_status,
		CASE order_status  -- CASE'den sonra hangi column üzerinde çalýþacaðýmýzý yazarýz
					WHEN 1 THEN 'Pending'  -- 1 deðeri geldiðinde 'Pending' yazdýrsýn dedik
					WHEN 2 THEN 'Processing'
					WHEN 3 THEN 'Rejected'
					WHEN 4 THEN 'Completed'
		END ORDER_STATUS_DESC  -- Yeni column'a isim verdik
FROM sale.orders


-- Add a column to the sales.staffs table containing the store names of the employees.

SELECT first_name, last_name, store_id,
		CASE store_id
			WHEN 1 THEN 'Davi techno Retail'
			WHEN 2 THEN 'The BFLO Store'
			ELSE 'Burkes Outlet'  -- Sadece 3 olasýlýðý kaldýðý için direkt ELSE dedik
		END STORE_NAME 
FROM sale.staff



---- SEARCHED CASE EXPRESSION

-- Generate a new column containing what the mean of the values in the Order_Status column. (use searched case ex.)
-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed

SELECT order_id, order_status,
			CASE -- CASE'den sonra column ismi vermiyoruz. WHEN'de column ismini belirterek iþlem yaparýz. (Simple Case'den farký)
				WHEN order_status = 1 THEN 'Pending'
				WHEN order_status = 2 THEN 'Processing'
				WHEN order_status = 3 THEN 'Rejected'
				WHEN order_status = 4 THEN 'Completed'
			END ORDER_STATUS_NEW
FROM sale.orders


-- Create a new column containing the labels of the customers' email service providers ( "Gmail", "Hotmail", "Yahoo" or "Other" )

SELECT first_name, last_name, email
FROM sale.customer



SELECT first_name, last_name, email,
			CASE
				WHEN email LIKE '%@gmail.%' THEN 'GMAIL'
				WHEN email LIKE '%@hotmail.%' THEN 'HOTMAIL'
				WHEN email LIKE '%@yahoo.%' THEN 'YAHOO'
				WHEN email IS NOT NULL THEN 'OTHER'
				ELSE NULL 
			END EMAIL_SERVICE_PROVIDER  -- Yeni column'ýn ismi
FROM sale.customer