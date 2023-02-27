


--List the products ordered the last 10 orders in Buffalo city.
-- Buffalo �ehrinde son 10 sipari�te sipari� verilen �r�nleri listeleyin.

-- Son 10 sipari�te sipari� verilen �r�nleri listeledik bu nedenle 10 sat�rdan fazla sat�r d�nd�. ��nk� �r�nleri istedik.

SELECT	B.product_id, B.product_name, A.order_id
FROM	sale.order_item A, product.product B
WHERE	A.product_id = B.product_id
AND		A.order_id IN (
						SELECT	TOP 10 order_id
						FROM	sale.customer A, sale.orders B
						WHERE	A.customer_id = B.customer_id
						AND		A.city = 'Buffalo'
						ORDER BY order_id desc
						)
order by 3  -- 3 dedik bu nedenle 3. s�tun olan order_id'yi default olan asc'ye g�re s�ralad�. 1 deseydik product id'yi s�ralard�.



--M��terilerin sipari� say�lar�n�, sipari� ettikleri �r�n say�lar�n� ve �r�nlere �dedikleri toplam net miktar� raporlay�n�z.

SELECT	A.customer_id, A.first_name, A.last_name, c.*, b.product_id, B.quantity, b.list_price, b.discount, quantity*list_price*(1-discount)
FROM	sale.customer A, sale.order_item B, sale.orders C
WHERE	A.customer_id = C.customer_id
AND		B.order_id = C.order_id
AND A.customer_id = 1  -- Yaln�zca 1 numaral� customer bilgilerini g�rmek istiyorum




SELECT	A.customer_id, A.first_name, A.last_name,
		COUNT (DISTINCT C.order_id) AS cnt_order,  -- Ka� farkl� sipari� vermi�
		SUM(B.quantity) cnt_product,  -- Toplam sipari� miktar� ne kadar
		SUM(quantity*list_price*(1-discount)) net_amount  -- Net olarak ne kadar �demi� (discount'u d���nce)
FROM	sale.customer A, sale.order_item B, sale.orders C
WHERE	A.customer_id = C.customer_id
AND		B.order_id = C.order_id
GROUP BY  A.customer_id, A.first_name, A.last_name



--Hi� sipari� vermemi� m��teriler de rapora dahil olsun.



SELECT	A.customer_id, A.first_name, A.last_name,
		COUNT (DISTINCT C.order_id) AS cnt_order,
		SUM(C.quantity) cnt_product,
		SUM(quantity*list_price*(1-discount)) net_amount
FROM	sale.customer A
		LEFT JOIN sale.orders B ON A.customer_id = B.customer_id  -- Customer tablosundaki de�erlerin orders'da bir kar��l��� olmasa da customer bilgisi gelsin
		LEFT JOIN sale.order_item C ON B.order_id = C.order_id  -- Customer tablosundaki de�erlerin order_item'da bir kar��l��� olmasa da customer bilgisi gelsin
GROUP BY  A.customer_id, A.first_name, A.last_name
ORDER BY 1 DESC  -- customer_id'yi (1. s�tunu) azalana g�re s�rala


--�ehirlerde verilen sipari� say�lar�n�, sipari� edilen �r�n say�lar�n� ve �r�nlere �denen toplam net miktarlar� raporlay�n�z.



SELECT	a.state, A.city,
		COUNT (DISTINCT C.order_id) AS cnt_order,  -- Ka� farkl� sipari� verilmi�
		SUM(B.quantity) cnt_product,  -- Toplam sipari� miktar� ne kadar
		SUM(quantity*list_price*(1-discount)) net_amount  -- Net olarak ne kadar �demi� (discount'u d���nce)
FROM	sale.customer A, sale.order_item B, sale.orders C
WHERE	A.customer_id = C.customer_id
AND		B.order_id = C.order_id
GROUP BY  a.state, A.city
order by 2


--Eyaletlerde verilen sipari� say�lar�n�, sipari� edilen �r�n say�lar�n� ve �r�nlere �denen toplam net miktarlar� raporlay�n�z.



SELECT	a.state,
		COUNT (DISTINCT C.order_id) AS cnt_order,
		SUM(B.quantity) cnt_product,
		SUM(quantity*list_price*(1-discount)) net_amount
FROM	sale.customer A, sale.order_item B, sale.orders C
WHERE	A.customer_id = C.customer_id
AND		B.order_id = C.order_id
GROUP BY  a.state
order by 1




-------------


----State ortalamas�n�n alt�nda ortalama ciroya sahip �ehirleri listeleyin.

WITH T1 AS
(
SELECT	DISTINCT A.state, A.city,  -- state ve city �eklinde distinct olmas�n� istedik
		AVG(quantity*list_price*(1-discount)) OVER (PARTITION BY A.state) avg_turnover_ofstate,  -- Eyaletlere g�re grupla ve discount sonras� �denen net �cretin ortalamas�n� hesapla
		AVG(quantity*list_price*(1-discount)) OVER (PARTITION BY A.state, A.city) avg_turnover_ofcity  -- Eyalet ve �ehirlere g�re grupla ve discount sonras� �denen net �cretin ortalamas�n� hesapla
FROM	sale.customer A, sale.orders B, sale.order_item C 
WHERE	A.customer_id = B.customer_id 
AND		B.order_id = C.order_id
)
SELECT *
FROM T1
WHERE	avg_turnover_ofcity < avg_turnover_ofstate  -- State ortalamas�n�n alt�nda kalan city'leri getir




------


--Create a report shows daywise turnovers of the BFLO Store.
--BFLO Store Ma�azas�n�n haftan�n g�nlerine g�re elde etti�i ciro miktar�n� g�steren bir rapor haz�rlay�n�z.




SELECT	DATENAME(WEEKDAY, order_date) dayofweek_, SUM (quantity*list_price*(1-discount)) daywise_turnover
FROM	sale.store A, sale.orders B, sale.order_item C
WHERE	A.store_name = 'The BFLO Store'
AND		A.store_id = B.store_id
AND		B.order_id = C.order_id
GROUP BY DATENAME(WEEKDAY, order_date)





SELECT *
FROM
(
SELECT	DATENAME(WEEKDAY, order_date) dayofweek_, quantity*list_price*(1-discount) net_amount, datepart(ISOWW, order_date) WEEKOFYEAR  -- Y�l�n hangi haftas�nda oldu�umu da bilmek istiyorum
FROM	sale.store A, sale.orders B, sale.order_item C
WHERE	A.store_name = 'The BFLO Store'
AND		A.store_id = B.store_id
AND		B.order_id = C.order_id
AND		YEAR(B.order_date) = 2018  -- Sadece 2018 y�l� i�in g�r�nt�lemek istiyorum
) A
PIVOT
(
SUM (net_amount)
FOR dayofweek_
IN ([Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[Saturday],[Sunday] )
) AS PIVOT_TABLE




---------------



--Write a query that returns how many days are between the third and fourth order dates of each staff.
--Her bir personelin ���nc� ve d�rd�nc� sipari�leri aras�ndaki g�n fark�n� bulunuz.


WITH T1 AS 
(
SELECT staff_id, order_date, order_id, 
		LEAD(order_date) OVER (PARTITION BY staff_id ORDER BY order_id) next_ord_date,  -- Personele g�re grupla, order_id artan �eklinde s�rala ve bir sonraki sipari� tarihini getir. Bu column'� next_ord_date olarak adland�r.
		ROW_NUMBER () OVER (PARTITION BY staff_id ORDER BY order_id) row_num
FROM sale.orders
)
SELECT *, DATEDIFF(DAY, order_date, next_ord_date) DIFF_OFDATE
FROM T1
WHERE row_num = 3  -- Sat�r numaras� de�eri 3 olan yerdeki order_date (3.sipari�) ve next_ord_date (4.sipari�) de�erleri fark�n� al


















