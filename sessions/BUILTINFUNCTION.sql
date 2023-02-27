------ built in functions

-- March 3, 2022


CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)

SELECT * FROM t_date_time

SELECT GETDATE()  -- Þu anýn zamanýný döndürür

INSERT t_date_time VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())  -- t_date_time tablomun deðerlerini girdim

SELECT * FROM t_date_time


INSERT t_date_time (A_time, A_date, A_smalldatetime, A_datetime, A_datetime2, A_datetimeoffset)
VALUES ('12:00:00', '2021-07-17', '2021-07-17','2021-07-17', '2021-07-17', '2021-07-17' )  -- ikinci insert yöntemi. Column sýrasý ve tipine göre girmem kritik.


SELECT * FROM t_date_time

-----------


SELECT CONVERT(VARCHAR, GETDATE(), 7)  -- Sonda yazdýðýmýz sayýlar standartlar tablosundan aldýðýmýz sayýlar. Hangi formatta döndürmesini istiyorsak o sayýyý yazarýz.


SELECT CONVERT(DATE, '25 OCT 21', 6)


SELECT CONVERT(int, 25.65);


------

SELECT	A_date,
		DATENAME(DW, A_date) [DAYS],
		DAY (A_date) [days2]	
FROM	t_date_time




SELECT	A_date,  -- A_date column'u üzerinde iþlem yapýyoruz
		DATENAME(DW, A_date) [DAY],
		DAY (A_date) [DAY2],
		MONTH(A_date),
		YEAR (A_date),
		A_time,  -- A_time column'u üzerinde iþlem yapýyoruz
		DATEPART (NANOSECOND, A_time),  -- Datepart ile belirli bir kýsmýný getirmesini saðladýk
		DATEPART (MONTH, A_date)
FROM	t_date_time  -- Ýþlem yaptýðýmýz tablonun ismi


------- DATEDIFF


SELECT	A_date,	
		A_datetime,A_smalldatetime,
		DATEDIFF (HOUR, A_smalldatetime, A_datetime) Diff_Hour,  -- Saat olarak farkýný verdi
		DATEDIFF (MINUTE, A_smalldatetime, A_datetime) Diff_min  -- Dakika olarak farkýný verdi
FROM	t_date_time

SELECT	A_date,	
		A_datetime,
		DATEDIFF (DAY, A_date, A_datetime) Diff_day
FROM	t_date_time



SELECT	A_date,	
		A_datetime,
		DATEDIFF (DAY, A_date, A_datetime) Diff_day,
		DATEDIFF (MONTH, A_date, A_datetime) Diff_month,
		DATEDIFF (YEAR, A_date, A_datetime) Diff_month,
		DATEDIFF (HOUR, A_smalldatetime, A_datetime) Diff_Hour,
		DATEDIFF (MINUTE, A_smalldatetime, A_datetime) Diff_Hour
FROM	t_date_time


----- 
---- SALE.ORDERS TABLOSUNDAKI ORDER DATE ILE SHIPPED DATE ARASINDAKI FARKI GUN BAZINDA ALALIM

SELECT * FROM [sale].[orders]


SELECT order_date, shipped_date,
		DATEDIFF(DAY, order_date, shipped_date) diff_day
FROM sale.orders


SELECT order_date, shipped_date,
		DATEDIFF(DAY, shipped_date, order_date) diff_day  -- Farkýný aldýðýmýz deðerleri diff_day ismiyle yeni bir column olarak ekledik
FROM sale.orders


--------- DATEADD EOMONTH

SELECT *
FROM [sale].[orders]

SELECT order_date,
		DATEADD (YEAR, 3, order_date) new_year,  -- order_date sütunundaki year'a 3 yýl ekledik.
		DATEADD (DAY, -5, order_date) NEW_DAY
FROM [sale].[orders]


-- EOMONTH

SELECT EOMONTH(order_date) LAST_DAY, order_date  -- EMONTH ile ayýn son gününü öðreniriz.
FROM [sale].[orders]


SELECT EOMONTH(order_date, 2) after_2, order_date  -- order_date'deki tarihten 2 ay sonrasýnda ayýn son gününü gösterir.
FROM [sale].[orders]

------ ISDATE

SELECT ISDATE ('123456')  -- Tarih olmadýðý için 0 döndürdü

SELECT ISDATE ('2022-03-03')  -- Tarih olduðu için 1 döndürdü

------

---- LEN/ CHARINDEX/ PATHINDEX

SELECT LEN (123456)

SELECT LEN ('WeLCOME')


SELECT LEN (WELCOME)


-----

SELECT CHARINDEX('C', 'CHARACTER')  -- Ýlk karþýlaþtýðý C harfinin index'ini verir

SELECT CHARINDEX('C', 'CHARACTER', 2)  -- 2 dediðimiz için 2. karþýlaþtýðý C harfinin index'ini verir

SELECT CHARINDEX('CT', 'CHARACTER')  -- 6. index'ten itibaren 'CT' birlikte göründüðü için 6 döndürür

-----

SELECT PATINDEX('%R', 'CHARACTER')  -- R ile bitenin indexi (R'den önceki tüm deðerleri alýr)


SELECT PATINDEX('R%', 'CHARACTER')  -- R ile baþlayanýn indexi. R ile baþlayan bir þey olmadýðý için 0 döndürdü.


SELECT PATINDEX('R%', 'RASDK')  -- R ile baþlayan var 1 olarak döndürdü


SELECT PATINDEX('___R%', 'CHARACTER')  -- Baþa üç altçizgi koyduk

-----

---- LEFT - RIGHT- SUBSTRING

SELECT LEFT('CHARACTER', 3)

SELECT LEFT(' CHARACTER', 3) -- Boþluðu da bir karakter olarak sayar.


SELECT RIGHT('CHARACTER', 3)

SELECT RIGHT('CHARACTER ', 3)



SELECT SUBSTRING('CHARACTER', 3, 5)  -- 3. index ile birlikte 5 karakter getir dedik

SELECT SUBSTRING('CHARACTER', -1, 5)  -- -1. index ile birlikte 5 karakter getir dedik. -1. ve 0. index'i boþluk olarak sayar çünkü indexler 1'den baþlýyor.

 ---- LOWER - UPPER -STRING-SPLIT

 SELECT LOWER('CHARACTER')

 SELECT UPPER('character')

 ----How to grow the first character of the 'character' word.
 ---- CIKTI: Character

 SELECT UPPER(LEFT('character',1)) + LOWER(RIGHT('character',8))

 SELECT UPPER(LEFT('character',1)) + LOWER (RIGHT('character', LEN ('character')-1))

 SELECT 'A'+'B'


 SELECT * FROM STRING_SPLIT ('John, Jeremy, Jack, George', ',')  -- Aralarýnda virgül olan deðerleri ayýrdýk (split ettik)


 ----- ltrim/ rtrim/ trim

 SELECT TRIM('     CHARACTER')

 SELECT TRIM('     CHARACTER     ')


 SELECT TRIM('     CHAR  ACTER     ')  -- Sadece sað ve soldaki boþuklarý sileceði için ortadaki boþluk kalýr.


 SELECT TRIM('?, ' FROM '    ?SQL Server,    ') AS TrimmedString;  -- Ýstemediðimiz deðerleri belirttik ve onlarý silmesini istedik


 SELECT LTRIM('     CHARACTER     ')  -- Aþaðýdaki character yazýsýný outputtan kopyaladýk. Taradýðýmda saðdaki boþluðun silinmediðini görürüm

 CHARACTER     


 SELECT RTRIM('     CHARACTER     ')

      CHARACTER

---- REPLACE & str

SELECT  REPLACE('CHARACTER STRING', ' ', '/')


SELECT STR(5454)  -- Default'u 10'du o yüzden boþluk da getirdi

SELECT STR(123456789)

SELECT STR (5454, 10, 5)  -- Toplamda 10 karakter, virgülden sonra 5 karakter dönsün dedik

SELECT STR (133215.654645, 11, 3)

SELECT STR (5454, 6, 5)  

---- CAST/ CONVERT/ COALESCE/ NULLIF/ ROUND


SELECT CAST (456123 AS CHAR)  -- Veri tipini CHAR yaptýk

SELECT CAST (456.123 AS INT)  -- Veri tipini INT yaptýk

SELECT CAST (30.60 AS INT)



SELECT CONVERT (INT , 30.60)  -- Bu da üstteki mantýkta. 30.60'ý INT yaptýk

SELECT CONVERT (VARCHAR(10), '2020-10-10')



SELECT COALESCE (NULL, NULL ,'Hi', 'Hello', NULL) result;  -- Ýlk Null olmayan deðeri getirir



SELECT NULLIF (10,10)  --Her ikisi de ayný deðer ise NULL, deðilse ilk deðeri getirir

SELECT NULLIF('Hello', 'Hi') result;



SELECT ROUND (432.368, 2, 0)  -- Virgülden sonraki 2 deðeri alýr, diðerlerini yukarý yuvarlar (0 yukarý yuvarla demek).Default'u 0'dýr.

SELECT ROUND (432.368, 1, 0)  -- Virgülden sonraki 1 deðeri alýr, diðerlerini yukarý yuvarlar (1 aþaðý yuvarla demek). 

SELECT ROUND (432.368, 2, 1)  -- Virgülden sonraki 2 deðeri alýr, diðerlerini aþaðý yuvarlar (1 aþaðý yuvarla demek).

SELECT ROUND (432.368, 2) -- ROUND mantýðýný tam anlamadým
