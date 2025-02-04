-- run the below delete code only when loading the datasets for the first time

-- DELETE FROM products
-- WHERE "BARCODE" = '4003207' AND "CATEGORY_2" = 'Nuts & Seeds';

-- 1. What are the top 5 brands by receipts scanned among users 21 and over? 

-- SELECT p."BRAND", COUNT(DISTINCT "RECEIPT_ID") AS receipt_count  
-- FROM transactions t  
-- LEFT JOIN users u ON t."USER_ID" = u."ID"  
-- LEFT JOIN products p ON t."BARCODE" = p."BARCODE"  
-- WHERE p."BRAND" IS NOT NULL  
-- AND (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM "BIRTH_DATE"))  
--     - CASE  
--         WHEN EXTRACT(MONTH FROM CURRENT_DATE) < EXTRACT(MONTH FROM "BIRTH_DATE")  
--         OR (EXTRACT(MONTH FROM CURRENT_DATE) = EXTRACT(MONTH FROM "BIRTH_DATE")  
--         AND EXTRACT(DAY FROM CURRENT_DATE) < EXTRACT(DAY FROM "BIRTH_DATE"))  
--         THEN 1 ELSE 0  
--     END >= 21  
-- GROUP BY p."BRAND"  
-- ORDER BY receipt_count DESC
-- limit 5;

-- 2. What is the percentage of sales in the Health & Wellness category by generation?

-- SELECT
-- CASE
-- 	WHEN u.age IS NULL THEN 'Birth date missing'
-- 	WHEN u.age<=12 THEN 'Gen Alpha'
-- 	WHEN u.age>12 AND u.age<=28 THEN 'Gen Z'
-- 	WHEN u.age>28 AND u.age<=44 THEN 'Millennials'
-- 	WHEN u.age>44 AND u.age<=60 THEN 'Gen X'
-- 	WHEN u.age>60 THEN 'Baby Boomer and earlier'
-- END AS generation,
-- ROUND(SUM(t."FINAL_SALE")::NUMERIC,0) AS total_sales,
-- ROUND(SUM(CASE WHEN p."CATEGORY_1" = 'Health & Wellness' THEN t."FINAL_SALE" ELSE 0 END)::NUMERIC,0) AS health_wellness_sales,
-- ROUND(
-- (SUM(CASE 
-- 		WHEN p."CATEGORY_1" = 'Health & Wellness' THEN t."FINAL_SALE" 
-- 		ELSE 0 
-- 	END)*100)::NUMERIC
-- 	/(SELECT SUM(t."FINAL_SALE")::NUMERIC 
-- 	FROM transactions t 
-- 	LEFT JOIN products p ON t."BARCODE" = p."BARCODE")
-- ,2)AS percentage_of_total,
-- ROUND(
-- (SUM(CASE 
-- 		WHEN p."CATEGORY_1" = 'Health & Wellness' THEN t."FINAL_SALE" 
-- 		ELSE 0 
-- 	END)*100)::NUMERIC
-- 	/(SELECT SUM(t."FINAL_SALE")::NUMERIC 
-- 	FROM transactions t 
-- 	LEFT JOIN products p ON t."BARCODE" = p."BARCODE" 
-- 	WHERE p."CATEGORY_1"='Health & Wellness')
-- ,2) AS percentage_of_health_wellness
-- FROM
-- transactions t
-- LEFT JOIN (SELECT *, (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM "BIRTH_DATE"))
--     - CASE  
--         WHEN EXTRACT(MONTH FROM CURRENT_DATE) < EXTRACT(MONTH FROM "BIRTH_DATE")  
--         OR (EXTRACT(MONTH FROM CURRENT_DATE) = EXTRACT(MONTH FROM "BIRTH_DATE")  
--         AND EXTRACT(DAY FROM CURRENT_DATE) < EXTRACT(DAY FROM "BIRTH_DATE"))  
--         THEN 1 ELSE 0
-- 		END AS age
-- FROM users) u ON t."USER_ID" = u."ID"
-- LEFT JOIN products p ON t."BARCODE" = p."BARCODE"
-- GROUP BY generation ORDER BY total_sales DESC;

-- 3. Which is the leading brand in the Dips & Salsa Category? 

-- SELECT p."BRAND", 
-- COUNT(DISTINCT t."RECEIPT_ID") AS receipt_count,
-- ROUND(SUM(t."FINAL_SALE")::NUMERIC,0) AS total_sales,
-- COUNT(DISTINCT t."STORE_NAME") AS total_stores,
-- SUM(t."FINAL_QUANTITY") AS total_quantity 
-- FROM transactions t    
-- LEFT JOIN products p ON t."BARCODE" = p."BARCODE" 
-- WHERE p."CATEGORY_2" = 'Dips & Salsa' AND p."BRAND" IS NOT NULL
-- GROUP BY p."BRAND"
-- ORDER BY total_stores DESC;








