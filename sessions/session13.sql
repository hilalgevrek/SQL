

--------------------------------------
-- DS 10/22 EU -- DAwSQL Session 13 --
----------- 19.03.2022 ---------------
--------------------------------------


-- Product tablosunun sütun isimlerini ve özelliklerini listeleyiniz.
exec sys.sp_columns 'product', 'product';  -- İlki tablo adı ikinci yazdığımız şema adı

-- Orter_item tablosunun sütun isimlerini ve özelliklerini listeleyiniz.
exec sys.sp_columns 'order_item' 
;

-- user defined procedures
-- En güncel sipariş bilgisini getiriniz
select	top 1 *
from	sale.orders
order by order_id desc
;

-- Yukarıdaki sorguyu döndüren prosedürü oluşturup exec komutu ile çalıştırınız
create or alter procedure usp_thelastorder

AS  -- AS'den sonra istediğimiz sql sorgusunu yazarız

select	top 1 *
from	sale.orders
order by order_id desc
;

exec usp_thelastorder
;


-- Bugünün tarihi: '2020-04-29'
-- Bugün yapılan toplam sipariş sayısını getiren prosedür

create procedure usp_datecount

AS

select  order_date, count(order_id)
from    sale.orders
WHERE order_date = '2020-04-29'
GROUP by    order_date
;

exec usp_datecount
;

-- Girdiğimiz tarihte yapılan toplam sipariş sayısını getiren bir prosedür yazınız.

create procedure usp_datecount2 
(@tarih DATE)  -- bu prosedür bu formatta bir veri istiyor dedik

AS

select  order_date, count(order_id)
from    sale.orders
WHERE order_date = @tarih
GROUP by    order_date
;

exec usp_datecount2 '2020-04-04'
;


-- İKi tarih arasındaki sipariş sayılarını günlük olarak listeleyiniz
create procedure usp_datecount3 
(@tarih1 DATE, @tarih2 DATE)

AS

select  order_date, count(order_id)
from    sale.orders
WHERE order_date between @tarih1 and @tarih2
GROUP by    order_date
;



-- Parametreler

-- Alt kısmın çalışması için bir arada çalıştırmam lazım
-- parametre tanımlama
DECLARE @param1 DATE
-- parametrelere değer atama
SET @param1 = '2020-04-29'
-- parametreleri sorgu içinde kullanma
select	*
from	sale.orders
where	order_date = @param1

-- Select bloğu içinde parametrelerin atanması
DECLARE @param1 DATE, @param2 INT  -- sipariş tarihi, o tarihteki sipariş miktarı

SET @param1 = '2020-04-02'

SET @param2 = (
	select  count(*)
	from	sale.orders
	where	order_date = @param1
)
print @param2


-- İkinci yöntem
DECLARE @param1 DATE, @param2 INT  -- sipariş tarihi, o tarihteki sipariş miktarı

SET @param1 = '2020-04-02'

select	@param2 = count(*)
from	sale.orders
where	order_date = @param1
print @param2
;

-- Girdiğimiz tarihte yapılan toplam sipariş sayısını getiren bir prosedür yazınız.
-- Print komutunu kullanınız.

create procedure usp_datecount4
(@tarih DATE)

AS

DECLARE @param INT

select  @param = count(order_id)
from    sale.orders
WHERE order_date = @tarih
GROUP by    order_date

print @param
;

exec usp_datecount4 '2020-04-04'
;



-- Fonksiyonlar

select len('abc');  -- tabular formatta sonuç verir

print len('abc');  -- text formatında sonuç verir


-- Girilen harfleri büyük harfe çevirmesini istiyoruz
create function udf_upper 
(@param nvarchar(max))

RETURNS nvarchar(max)  -- fonksiyon sonucunda döndürmesini istediğim şey

AS

BEGIN
	return upper(@param)
END
;

select	dbo.udf_upper('abc')
;



-- Bir harfin sesli mi sessiz mi olduğunu döndüren fonksiyon yazınız.
-- Mehmet Emin arkadaşımıza teşekkür ediyoruz (hem bu kodun yazımında hem de diğer desteklerinde)
CREATE FUNCTION udf_sesli
(@harf NVARCHAR(MAX))

RETURNS NVARCHAR(MAX)

BEGIN

    if @harf in ('a', 'e', 'ı', 'i', 'o', 'ö', 'u', 'ü')
       SET @harf =   'sesli harf'
    else if @harf in ('b', 'c', 'ç', 'd', 'f', 'g', 'ğ', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'r', 's', 'ş', 't', 'v', 'y', 'z')
       SET @harf =  'sessiz harf'
    else
       SET @harf =   'Lütfen Türkçe bir harf yazınız.'

    RETURN @harf
END;

select	dbo.udf_sesli('h')
;

-- 1 2 3 4 5 6 7 8 9 
-- Girdiğimiz rakama kadar tüm rakamların toplamını döndüren bir kod yazınız.

DECLARE @input INT, @counter INT, @sonuc INT

SET @input = 10
SET @counter = 1
SET @sonuc = 0

while @counter <= @input
	BEGIN
		set @sonuc = @sonuc + @counter
		set @counter = @counter + 1
	END;

print @sonuc

