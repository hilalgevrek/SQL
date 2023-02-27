 


-------------------------------------
-- DS 10/22 EU -- DAwSQL Session 9 --
----------- 12.03.2022 --------------
-------------------------------------



-- Ürünlerin stock sayılarını bulunuz

select	product_id, sum(quantity) total_stock
from	product.stock
group by product_id
order by product_id
;

select	*, sum(quantity) over (partition by product_id) total_stock
from	product.stock
order by product_id
;

select * from product.stock;  
-- Group by yaptığımızda veri sayısı azaldı çünkü yalnızca grup verilerini getirdi.
-- Window function her bir satırın hangi gruba ait olduğunu yazdırdı o yüzden veri sayısı değişmedi

-- Markalara göre ortalama ürün fiyatlarını hem Group By hem de Window Functions ile hesaplayınız.

select	brand_id, avg(list_price) avg_price
from	product.product
group by brand_id
;

select	distinct brand_id, avg(list_price) over(partition by brand_id) avg_price
from	product.product
order by 2 desc  -- 'order by avg_price desc' yerine 'order by 2 desc' yazdık. 2. sütuna göre desc şeklinde (azalana göre) sırala demiş olduk.
;  -- Burada window function kullanmış ama distinct demiş, o nedenle group by gibi davrandı.



-- Windows frame i anlamak için birkaç örnek:
-- Herbir satırda işlem yapılacak olan frame in büyüklüğünü (satır sayısını) tespit edip window frame in nasıl oluştuğunu aşağıdaki sorgu sonucuna göre konuşalım.


SELECT	category_id, product_id,
		COUNT(*) OVER() NOTHING,  -- Belli bir partition belirtmedim
		COUNT(*) OVER(PARTITION BY category_id) countofprod_by_cat,  -- 1 numaralı kategoride (category_id = 1) 40 satır var gibi bir yorum çıkarabilirim
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) whole_rows,  -- Burada da sınırlandırma yapmış. Ama aslında en üst ve en alt sınırı belirtmiş bu nedenle üstteki kod ile aynı anlama geliyor.
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) countofprod_by_cat_2,  -- Bound tanımlamadan direkt order by tanımlarsak deafult'a göre (BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sıralar. Her bir kategori grubu için kendisi ve bir önceki satır şeklinde hesaplama yapar.
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current,  -- Üstteki kod ile aynı anlama gelir. Çünkü order by'dan sonra yazdığımız default'udur.
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following,  -- Aynı kategorideki şu anki + sonraki satırların sayısını döndürür. Bu nedenle kategorideki son satır 1 değerini alır.
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) specified_columns_1,  -- Partition'ın bir önceki satırı+şu anki satır+sonraki satır değerini döndürür. Bu nedenle bir partition için ilk satır ve son satır değeri 2 olarak dönmüş (Çünkü ilk satırda bir önce ve son satırda bir sonraki değer yok).
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) specified_columns_2  -- Partition'un 2 önceki satırı+şu anki satır+3 sonraki satır değerini döndürür.
FROM	product.product
ORDER BY category_id, product_id

;


-- en ucuz ürünün fiyatı

select	top 1 list_price
from	product.product
order by list_price  -- Artan (Order by'ın default'u asc) list_price'a göre sırala ve 1. değeri getir dedik.
;

select distinct min(list_price) over() 
from product.product  -- window function ile yapılışı
;



-- en ucuz ürünlerin isimlerini ve fiyatlarını getiriniz.
select	*
from	(
		select	product_name, list_price, min(list_price) over() cheapest  -- Yalnızca over() dememizin nedeni: Gruplama yapma tüm tablo üzerinde çalış dedik. Çünkü tüm tablo için en ucuz olanları istiyoruz.
		from	product.product
		) A
where	A.list_price = A.cheapest
;


-- Herbir kategorideki en ucuz ürünün fiyatı

select	distinct category_id, min(list_price) over(partition by category_id) cheapest_by_cat
from	product.product
;


-- Product tablosunda toplam kaç faklı product bulunduğu

select count(model_year) 
from product.product
;

select	distinct count(*) over()
from	product.product  -- window function kullanılarak yapılışı
;

-- Order_item tablosunda kaç farklı ürün bulunmaktadır? (Kaç tane ürünü en az bir kere satmışız?)

select	count(distinct product_id)
from	sale.order_item
;

-- Aynı sorguyu Window Functions ile yaptığınız hata alırsınız.
-- Çünkü windows functions içinde count(distinct ...) kullanamazsınız
select	count(distinct product_id) over ()
from	sale.order_item
;

-- Her siparişte kaç farklı ürün olduğunu döndüren bir sorgu yazın?
select	distinct order_id, count(item_id) over(partition by order_id) cnt_product  -- order_id'ye göre grupla, item_id'lerini say dedik.
from	sale.order_item
;

-- Herbir kategorideki herbir markada kaç farklı ürünün bulunduğu
select	distinct category_id, brand_id, count(*) over(partition by brand_id, category_id) num_of_prod  -- count(*) ile satır sayısını say dedik
from	product.product
order by brand_id, category_id
;


-- Müşterilerin sipariş tarihini ve ayrıca tüm siparişler içinde en eski sipariş tarihini getiriniz
select	a.customer_id, a.first_name, b.order_date,
		FIRST_VALUE(b.order_date) over(order by b.order_date, b.order_id) min_order_date
from	sale.customer a, sale.orders b
where	a.customer_id = b.customer_id
;


-- Müşterilerin sipariş tarihini ve ayrıca tüm siparişler içinde en yeni sipariş tarihini getiriniz
select	a.customer_id, a.first_name, b.order_date,
		FIRST_VALUE(b.order_date) over(order by b.order_date desc, b.order_id desc) store_id
from	sale.customer a, sale.orders b
where	a.customer_id = b.customer_id
;


-- Bu sorguyu LAST_VALUE ile yaptığımızda window frame i belirlememiz gerekiyor.
-- Aksi taktirde order by kullandığımızda default window frame UNBOUNDED PRECEDING AND CURRENT ROW oluyor.
select	a.customer_id, a.first_name, b.order_date,
		FIRST_VALUE(b.order_date) over(order by b.order_date desc, b.order_id desc ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) store_id
from	sale.customer a, sale.orders b
where	a.customer_id = b.customer_id
;



-- Liste fiyatı en düşük olan ürünün adını getiriniz.
select	distinct first_value(product_name) over (order by list_price, model_year DESC) cheapest_product  -- En ucuz olan gelsin. Bir kaç tane en ucuz varsa model_year'ı en yeni olan gelsin dedik.
from	product.product
;


-- Liste fiyatı en düşük olan ürünün adını e fiyatını getiriniz.
select	distinct
		first_value(product_name) over (order by list_price, model_year DESC) cheapest_product_name,
		first_value(list_price) over (order by list_price, model_year DESC) cheapest_product_price
from	product.product
;

-- Çalışanların satış yaptıkları tarihleri listeleyin ve ayrıca bir önceki satış tarihlerini de yanına yazdırınız.
select	b.order_id, a.staff_id, a.first_name, a.last_name, b.order_date,
		lag(b.order_date) over(partition by a.staff_id order by b.order_id) previous_order_date
from	sale.staff a, sale.orders b
where	a.staff_id = b.staff_id
order by a.staff_id, b.order_date
;

-- Çalışanların satış yaptıkları tarihleri listeleyin ve ayrıca bir sonraki satış tarihlerini de yanına yazdırınız.
select	b.order_id, a.staff_id, a.first_name, a.last_name, b.order_date,
		lead(b.order_date) over(partition by a.staff_id order by b.order_id) previous_order_date
from	sale.staff a, sale.orders b
where	a.staff_id = b.staff_id
order by a.staff_id, b.order_date
;

-- Lead ve lag fonksiyonları ile yapabileceğiniz başka örnekler:
-- Çalışanların 2 önceki satış tarihi, bir önceki satış tarihi, bir sonraki satış tarihi ve 2 sonraki satış tarihi
select	b.order_id, a.staff_id, a.first_name, a.last_name, b.order_date,
		lag(b.order_date, 2) over(partition by a.staff_id order by b.order_date, b.order_id) lag2,
		lag(b.order_date, 1) over(partition by a.staff_id order by b.order_date, b.order_id) lag1,
		lead(b.order_date, 1) over(partition by a.staff_id order by b.order_date, b.order_id) lead1,
		lead(b.order_date, 2) over(partition by a.staff_id order by b.order_date, b.order_id) lead2
from	sale.staff a, sale.orders b
where	a.staff_id = b.staff_id
order by a.staff_id, b.order_date
;

-- DİKKAT ! over içine order by yazarsam her bir partition'a göre sıralama yapar. Query'nin en sonuna yazarsam tüm tabloyu baz alarak sıralama yapar.