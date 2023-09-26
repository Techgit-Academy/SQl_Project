
SELECT CAST(transaction_date AS DATE) Transact_date, product_category, tenant_name, payment_channel, generation, b.region, a.contract, report_date,
CASE WHEN tenant_name = 'MTN_NG' AND Product_Type = 'Classic' THEN 'MTN-Legacy'
WHEN tenant_name = 'MTN_NG' AND Product_Type <> 'Classic' THEN 'MTN-Unified'
WHEN `product_description` LIKE '%NWO%' AND a.contract NOT IN ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'LCP'
#WHEN tenant_name = 'AIRTEL_NG' AND product_code = 'null' AND product_description LIKE '%Lite tool%' THEN 'LCP'
#WHEN tenant_name = 'AIRTEL_NG' AND payment_channel = 'DIRECT NG Bank' AND product_code LIKE '%NWO%' and contract not in ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'LCP'
WHEN tenant_name = 'AIRTEL_NG' AND product_type <> 'Classic' AND generation = 'Unified' THEN 'Airtel_Non-LCP'
WHEN a.contract IN ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'Airtel_Non-LCP'
ELSE 'Check' END Revenue_Category, IFNULL(SUM(charged_amount),0) AS revenue
FROM `daily_transactions` a

LEFT JOIN
(
SELECT region, contract
FROM customer_location) b
ON a.contract= b.contract
WHERE repayment_status = 'Subsequent_Repayment'
AND `report_date` = '2023-04-01'

GROUP BY  product_category,Revenue_Category,Transact_date,tenant_name,payment_channel, generation,b.region,report_date,a.contract






