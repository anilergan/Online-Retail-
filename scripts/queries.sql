-- Toplam satır 
SELECT COUNT(*) FROM online_retail;

-- Eşsiz müşteri sayısı
SELECT COUNT(DISTINCT (customerid)) FROM online_retail; 

-- Null değer mevcut mu?
SELECT COUNT(*)
FROM online_retail
WHERE customerid IS NULL;

SELECT COUNT(*)
FROM online_retail
WHERE stockcode IS NULL;

-- Eşsiz ürün sayısı
SELECT COUNT(DISTINCT StockCode)
FROM online_retail;

-- Hangi üründen kaç tane mevcut
SELECT stockcode , COUNT(*) AS frequency
FROM online_retail
GROUP BY stockcode 
ORDER BY frequency DESC;

-- ** KOLON İSİMLERİNİ GÖRÜNTÜLEMEK ** --
SELECT column_name 
FROM information_schema.columns
WHERE table_name = 'online_retail';

-- Azalan şekilde en çok sipariş edilen top 5 ürün
SELECT invoiceno, COUNT(*) AS valuecount
FROM online_retail
GROUP BY invoiceno
ORDER BY valuecount DESC;

-- Ürüne ödenen miktarı belirten total_price adında bir alan oluşturma.
SELECT stockcode , SUM(price) AS total_price
FROM online_retail
GROUP BY stockcode
ORDER BY total_price DESC;

-- İptal edilen işlemlerin başında C ifadesi geçiyor. İptal edilen işlemleri listeleme.
SELECT *
FROM online_retail
WHERE invoiceno LIKE 'C%';

-- ** PEKİ BİZE DÖNDÜRDÜĞÜ BU TABLO KAÇ SATIR? ** --
SELECT count(*) AS row_count
FROM online_retail
WHERE invoiceno LIKE 'C%';

-- En çok iade alan ürün
SELECT stockcode , COUNT(*) AS cancel_frequency
FROM online_retail 
WHERE invoiceno LIKE 'C%'
GROUP BY stockcode 
ORDER BY cancel_frequency DESC;

-- İptal edilen ürünleri sil
SELECT *
FROM online_retail
WHERE invoiceno NOT LIKE 'C%';

-- Her bir faturanın tutarını öğrenme
SELECT *, (Quantity * Price) AS "invoice_amount"
FROM online_retail;

-- Müşteri bazında ortalama sipariş sayısı 
-- Toplam müşteri / Toplam sipariş
SELECT  
	(SELECT COUNT(DISTINCT invoiceno) 
	FROM online_retail)::float 
	/ 
	(SELECT COUNT(DISTINCT customerid) 
	FROM online_retail)::float
	AS avg_order


-- Müşteri bazında ortalam sipariş tutarı
WITH total_prices AS (
	SELECT stockcode , SUM(price) AS total_price
	FROM online_retail
	GROUP BY stockcode
)
SELECT  
	(SELECT SUM(DISTINCT total_price) 
	FROM total_prices)::float 
	/ 
	(SELECT COUNT(DISTINCT customerid) 
	FROM online_retail)::float
	AS avg_order_amount;

	
-- Müşteri bazında sipariş edilen toplam ürün sayısı
SELECT customerid, count(DISTINCT stockcode)
FROM online_retail
GROUP BY customerid;
	
-- Müşteri bazında toplam sipariş sayısı
SELECT customerid, count(DISTINCT invoiceno)
FROM online_retail
GROUP BY customerid;

-- Hangi ülkeden kaç tane sipariş var
SELECT country, count(DISTINCT stockcode)
FROM online_retail
GROUP BY country;

-- En çok para kazandıran beş ülke
WITH no_cancelled_order AS (
	SELECT *
	FROM online_retail
	WHERE invoiceno NOT LIKE 'C%'
)
SELECT country, sum(quantity * price)::float AS total_price
FROM no_cancelled_order
GROUP BY country 
ORDER BY total_price DESC
LIMIT 5;
