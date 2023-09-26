
#...................Monhtly Daily Repayment....................#

SELECT CAST(transaction_date AS DATE) Transact_date, product_category, tenant_name, payment_channel, generation, b.region,
CASE WHEN tenant_name = 'MTN_NG' AND Product_Type = 'Classic' THEN 'MTN-Legacy'
WHEN tenant_name = 'MTN_NG' AND Product_Type <> 'Classic' THEN 'MTN-Unified'
WHEN `product_description` LIKE '%NWO%' AND a.contract NOT IN ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'LCP'
#WHEN tenant_name = 'AIRTEL_NG' AND product_code = 'null' AND product_description LIKE '%Lite tool%' THEN 'LCP'
#WHEN tenant_name = 'AIRTEL_NG' AND payment_channel = 'DIRECT NG Bank' AND product_code LIKE '%NWO%' and contract not in ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'LCP'
WHEN tenant_name = 'AIRTEL_NG' AND product_type <> 'Classic' AND generation = 'Unified' THEN 'Airtel_Non-LCP'
WHEN a.contract IN ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'Airtel_Non-LCP'
ELSE 'Check' END Revenue_Category, SUM(charged_amount) AS Revenue, COUNT(a.contract) AS subscription_count
FROM `daily_transactions` a

LEFT JOIN
(
SELECT region, contract
FROM customer_location) b
ON a.contract= b.contract
WHERE repayment_status = 'Subsequent_Repayment'
AND `report_date` = '2023-09-01'

GROUP BY  product_category,Revenue_Category,Transact_date,tenant_name,payment_channel, generation,b.region,report_date


#..................Payment_subscribers................#

SELECT CAST(transaction_date AS DATE) Transact_date,product_category,
CASE WHEN tenant_name = 'MTN_NG' AND Product_Type = 'Classic' THEN 'MTN-Legacy'
WHEN tenant_name = 'MTN_NG' AND Product_Type <> 'Classic' THEN 'MTN-Unified'
WHEN `product_description` LIKE '%NWO%' AND contract NOT IN ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'LCP'
#WHEN tenant_name = 'AIRTEL_NG' AND product_code = 'null' AND product_description LIKE '%Lite tool%' THEN 'LCP'
#WHEN tenant_name = 'AIRTEL_NG' AND payment_channel = 'DIRECT NG Bank' AND product_code LIKE '%NWO%' and contract not in ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'LCP'
WHEN tenant_name = 'AIRTEL_NG' AND product_type <> 'Classic' AND generation = 'Unified' THEN 'Airtel_Non-LCP'
WHEN contract IN ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'Airtel_Non-LCP'
ELSE 'Check' END Revenue_Category, COUNT(contract) AS Payment_count, SUM(charged_amount) Payment_Revenue
FROM 
`daily_transactions`
WHERE repayment_status = 'Subsequent_Repayment' AND report_date = '2023-09-01'
GROUP BY Revenue_Category,Transact_date,product_category

#...................unique payers....#

SELECT  product_category,Revenue_Category, SUM(unique_count)
FROM
(
SELECT
CASE WHEN tenant_name = 'MTN_NG' AND Product_Type = 'Classic' THEN 'MTN-Legacy'
WHEN tenant_name = 'MTN_NG' AND Product_Type <> 'Classic' THEN 'MTN-Unified'
WHEN `product_description` LIKE '%NWO%' AND contract NOT IN ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'LCP'
#WHEN tenant_name = 'AIRTEL_NG' AND product_code = 'null' AND product_description LIKE '%Lite tool%' THEN 'LCP'
#WHEN tenant_name = 'AIRTEL_NG' AND payment_channel = 'DIRECT NG Bank' AND product_code LIKE '%NWO%' and contract not in ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'LCP'
WHEN tenant_name = 'AIRTEL_NG' AND product_type <> 'Classic' AND generation = 'Unified' THEN 'Airtel_Non-LCP'
WHEN contract IN ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'Airtel_Non-LCP'
ELSE 'Check' END Revenue_Category,

product_category,ROW_NUMBER() OVER (PARTITION BY contract ORDER BY payment_duration DESC) AS Product, 
COUNT(DISTINCT contract) AS unique_count
FROM `daily_transactions`
WHERE `report_date` = '2023-09-01' AND repayment_status = 'Subsequent_Repayment'
GROUP BY Revenue_Category, product_category,payment_duration,contract)a
WHERE Product = 1
GROUP BY Revenue_Category,product_category




#................Region...................#
SELECT generation, c.region, SUM(last_month_Revenue) Total_last_Month, SUM(This_month_Revenue) Total_this_month
FROM(
SELECT product_category, tenant_name, payment_channel, generation,b.region,
CASE WHEN tenant_name = 'MTN_NG' AND Product_Type = 'Classic' THEN 'MTN-Legacy'
WHEN tenant_name = 'MTN_NG' AND Product_Type <> 'Classic' THEN 'MTN-Unified'
WHEN `product_description` LIKE '%NWO%' AND a.contract NOT IN ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'LCP'
#WHEN tenant_name = 'AIRTEL_NG' AND product_code = 'null' AND product_description LIKE '%Lite tool%' THEN 'LCP'
#WHEN tenant_name = 'AIRTEL_NG' AND payment_channel = 'DIRECT NG Bank' AND product_code LIKE '%NWO%' and contract not in ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'LCP'
WHEN tenant_name = 'AIRTEL_NG' AND product_type <> 'Classic' AND generation = 'Unified' THEN 'Airtel_Non-LCP'
WHEN a.contract IN ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'Airtel_Non-LCP'
ELSE 'Check' END Revenue_Category, COUNT(a.contract) AS total_count,
SUM(CASE WHEN report_date ='2023-08-01' THEN charged_amount END) last_month_Revenue,
SUM(CASE WHEN report_date ='2023-09-01' THEN charged_amount END) This_month_Revenue
FROM `daily_transactions` a

LEFT JOIN
(
SELECT region, contract
FROM customer_location) b
ON a.contract= b.contract
WHERE repayment_status = 'Subsequent_Repayment'
GROUP BY  product_category,Revenue_Category,tenant_name,payment_channel, generation, b.region
)c
GROUP BY generation, c.region




#......Raw................#
SELECT Revenue_Category, product_category,c.region, SUM(last_month_Revenue) Total_Rev_last_Month, SUM(last_month_Revenue_count) Total_LastMonth_payment_count,
SUM(This_month_Revenue) Total_this_month_Rev, SUM( This_month_Revenue_count) Total_this_month_PaymentCount
FROM(
SELECT product_category, tenant_name, payment_channel, generation,b.region,
CASE WHEN tenant_name = 'MTN_NG' AND Product_Type = 'Classic' THEN 'MTN-Legacy'
WHEN tenant_name = 'MTN_NG' AND Product_Type <> 'Classic' THEN 'MTN-Unified'
WHEN `product_description` LIKE '%NWO%' AND a.contract NOT IN ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'LCP'
#WHEN tenant_name = 'AIRTEL_NG' AND product_code = 'null' AND product_description LIKE '%Lite tool%' THEN 'LCP'
#WHEN tenant_name = 'AIRTEL_NG' AND payment_channel = 'DIRECT NG Bank' AND product_code LIKE '%NWO%' and contract not in ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'LCP'
WHEN tenant_name = 'AIRTEL_NG' AND product_type <> 'Classic' AND generation = 'Unified' THEN 'Airtel_Non-LCP'
WHEN a.contract IN ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'Airtel_Non-LCP'
ELSE 'Check' END Revenue_Category, COUNT(a.contract) AS total_count,
SUM(CASE WHEN report_date ='2023-08-01' THEN charged_amount END) last_month_Revenue,
COUNT(CASE WHEN report_date ='2023-08-01' THEN a.contract END) last_month_Revenue_count,
SUM(CASE WHEN report_date ='2023-09-01' THEN charged_amount END) This_month_Revenue,
COUNT(CASE WHEN report_date ='2023-09-01' THEN a.contract END) This_month_Revenue_count

FROM `daily_transactions` a

LEFT JOIN
(
SELECT region, contract
FROM customer_location) b
ON a.contract= b.contract
WHERE repayment_status = 'Subsequent_Repayment'
GROUP BY  product_category,Revenue_Category,tenant_name,payment_channel, generation, b.region
)c
GROUP BY Revenue_Category, product_category,c.region


#*****Upaya****

SELECT CAST(payment_date AS DATE) Transact_date,
CASE WHEN `payment_classification` = 'Repayment' THEN 'LCP(L1)'

END Revenue_Category, COUNT(contract_number) AS Payment_count, SUM(amount) Payment_Revenue
FROM 
`upya_daily_transactions`

WHERE report_date = '2023-07-31' AND `payment_classification` = 'Repayment'
GROUP BY Revenue_Category,Transact_date