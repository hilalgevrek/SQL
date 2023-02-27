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

SELECT GETDATE()  -- �u an�n zaman�n� d�nd�r�r

INSERT t_date_time VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())  -- t_date_time tablomun de�erlerini girdim

SELECT * FROM t_date_time


INSERT t_date_time (A_time, A_date, A_smalldatetime, A_datetime, A_datetime2, A_datetimeoffset)
VALUES ('12:00:00', '2021-07-17', '2021-07-17','2021-07-17', '2021-07-17', '2021-07-17' )  -- ikinci insert y�ntemi. Column s�ras� ve tipine g�re girmem kritik.


SELECT * FROM t_date_time

-----------


SELECT CONVERT(VARCHAR, GETDATE(), 7)  -- Sonda yazd���m�z say�lar standartlar tablosundan ald���m�z say�lar. Hangi formatta d�nd�rmesini istiyorsak o say�y� yazar�z.


SELECT CONVERT(DATE, '25 OCT 21', 6)


SELECT CONVERT(int, 25.65);


------

SELECT	A_date,
		DATENAME(DW, A_date) [DAYS],
		DAY (A_date) [days2]	
FROM	t_date_time




SELECT	A_date,  -- A_date column'u �zerinde i�lem yap�yoruz
		DATENAME(DW, A_date) [DAY],
		DAY (A_date) [DAY2],
		MONTH(A_date),
		YEAR (A_date),
		A_time,  -- A_time column'u �zerinde i�lem yap�yoruz
		DATEPART (NANOSECOND, A_time),  -- Datepart ile belirli bir k�sm�n� getirmesini sa�lad�k
		DATEPART (MONTH, A_date)
FROM	t_date_time  -- ��lem yapt���m�z tablonun ismi


------- DATEDIFF


SELECT	A_date,	
		A_datetime,A_smalldatetime,
		DATEDIFF (HOUR, A_smalldatetime, A_datetime) Diff_Hour,  -- Saat olarak fark�n� verdi
		DATEDIFF (MINUTE, A_smalldatetime, A_datetime) Diff_min  -- Dakika olarak fark�n� verdi
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
		DATEDIFF(DAY, shipped_date, order_date) diff_day  -- Fark�n� ald���m�z de�erleri diff_day ismiyle yeni bir column olarak ekledik
FROM sale.orders


--------- DATEADD EOMONTH

SELECT *
FROM [sale].[orders]

SELECT order_date,
		DATEADD (YEAR, 3, order_date) new_year,  -- order_date s�tunundaki year'a 3 y�l ekledik.
		DATEADD (DAY, -5, order_date) NEW_DAY
FROM [sale].[orders]


-- EOMONTH

SELECT EOMONTH(order_date) LAST_DAY, order_date  -- EMONTH ile ay�n son g�n�n� ��reniriz.
FROM [sale].[orders]


SELECT EOMONTH(order_date, 2) after_2, order_date  -- order_date'deki tarihten 2 ay sonras�nda ay�n son g�n�n� g�sterir.
FROM [sale].[orders]

------ ISDATE

SELECT ISDATE ('123456')  -- Tarih olmad��� i�in 0 d�nd�rd�

SELECT ISDATE ('2022-03-03')  -- Tarih oldu�u i�in 1 d�nd�rd�

------

---- LEN/ CHARINDEX/ PATHINDEX

SELECT LEN (123456)

SELECT LEN ('WeLCOME')


SELECT LEN (WELCOME)


-----

SELECT CHARINDEX('C', 'CHARACTER')  -- �lk kar��la�t��� C harfinin index'ini verir

SELECT CHARINDEX('C', 'CHARACTER', 2)  -- 2 dedi�imiz i�in 2. kar��la�t��� C harfinin index'ini verir

SELECT CHARINDEX('CT', 'CHARACTER')  -- 6. index'ten itibaren 'CT' birlikte g�r�nd��� i�in 6 d�nd�r�r

-----

SELECT PATINDEX('%R', 'CHARACTER')  -- R ile bitenin indexi (R'den �nceki t�m de�erleri al�r)


SELECT PATINDEX('R%', 'CHARACTER')  -- R ile ba�layan�n indexi. R ile ba�layan bir �ey olmad��� i�in 0 d�nd�rd�.


SELECT PATINDEX('R%', 'RASDK')  -- R ile ba�layan var 1 olarak d�nd�rd�


SELECT PATINDEX('___R%', 'CHARACTER')  -- Ba�a �� alt�izgi koyduk

-----

---- LEFT - RIGHT- SUBSTRING

SELECT LEFT('CHARACTER', 3)

SELECT LEFT(' CHARACTER', 3) -- Bo�lu�u da bir karakter olarak sayar.


SELECT RIGHT('CHARACTER', 3)

SELECT RIGHT('CHARACTER ', 3)



SELECT SUBSTRING('CHARACTER', 3, 5)  -- 3. index ile birlikte 5 karakter getir dedik

SELECT SUBSTRING('CHARACTER', -1, 5)  -- -1. index ile birlikte 5 karakter getir dedik. -1. ve 0. index'i bo�luk olarak sayar ��nk� indexler 1'den ba�l�yor.

 ---- LOWER - UPPER -STRING-SPLIT

 SELECT LOWER('CHARACTER')

 SELECT UPPER('character')

 ----How to grow the first character of the 'character' word.
 ---- CIKTI: Character

 SELECT UPPER(LEFT('character',1)) + LOWER(RIGHT('character',8))

 SELECT UPPER(LEFT('character',1)) + LOWER (RIGHT('character', LEN ('character')-1))

 SELECT 'A'+'B'


 SELECT * FROM STRING_SPLIT ('John, Jeremy, Jack, George', ',')  -- Aralar�nda virg�l olan de�erleri ay�rd�k (split ettik)


 ----- ltrim/ rtrim/ trim

 SELECT TRIM('     CHARACTER')

 SELECT TRIM('     CHARACTER     ')


 SELECT TRIM('     CHAR  ACTER     ')  -- Sadece sa� ve soldaki bo�uklar� silece�i i�in ortadaki bo�luk kal�r.


 SELECT TRIM('?, ' FROM '    ?SQL Server,    ') AS TrimmedString;  -- �stemedi�imiz de�erleri belirttik ve onlar� silmesini istedik


 SELECT LTRIM('     CHARACTER     ')  -- A�a��daki character yaz�s�n� outputtan kopyalad�k. Tarad���mda sa�daki bo�lu�un silinmedi�ini g�r�r�m

 CHARACTER     


 SELECT RTRIM('     CHARACTER     ')

      CHARACTER

---- REPLACE & str

SELECT  REPLACE('CHARACTER STRING', ' ', '/')


SELECT STR(5454)  -- Default'u 10'du o y�zden bo�luk da getirdi

SELECT STR(123456789)

SELECT STR (5454, 10, 5)  -- Toplamda 10 karakter, virg�lden sonra 5 karakter d�ns�n dedik

SELECT STR (133215.654645, 11, 3)

SELECT STR (5454, 6, 5)  

---- CAST/ CONVERT/ COALESCE/ NULLIF/ ROUND


SELECT CAST (456123 AS CHAR)  -- Veri tipini CHAR yapt�k

SELECT CAST (456.123 AS INT)  -- Veri tipini INT yapt�k

SELECT CAST (30.60 AS INT)



SELECT CONVERT (INT , 30.60)  -- Bu da �stteki mant�kta. 30.60'� INT yapt�k

SELECT CONVERT (VARCHAR(10), '2020-10-10')



SELECT COALESCE (NULL, NULL ,'Hi', 'Hello', NULL) result;  -- �lk Null olmayan de�eri getirir



SELECT NULLIF (10,10)  --Her ikisi de ayn� de�er ise NULL, de�ilse ilk de�eri getirir

SELECT NULLIF('Hello', 'Hi') result;



SELECT ROUND (432.368, 2, 0)  -- Virg�lden sonraki 2 de�eri al�r, di�erlerini yukar� yuvarlar (0 yukar� yuvarla demek).Default'u 0'd�r.

SELECT ROUND (432.368, 1, 0)  -- Virg�lden sonraki 1 de�eri al�r, di�erlerini yukar� yuvarlar (1 a�a�� yuvarla demek). 

SELECT ROUND (432.368, 2, 1)  -- Virg�lden sonraki 2 de�eri al�r, di�erlerini a�a�� yuvarlar (1 a�a�� yuvarla demek).

SELECT ROUND (432.368, 2) -- ROUND mant���n� tam anlamad�m
