/* Last Month */

SELECT CASE WHEN tenant_name = 'MTN_NG' AND Product_Type = 'Classic' THEN 'MTN-Legacy'
WHEN tenant_name = 'MTN_NG' AND Product_Type <> 'Classic' THEN 'MTN-Unified'
WHEN `product_description` LIKE '%NWO%' AND contract NOT IN ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'LCP'
#WHEN tenant_name = 'AIRTEL_NG' AND product_code = 'null' AND product_description LIKE '%Lite tool%' THEN 'LCP'
#WHEN tenant_name = 'AIRTEL_NG' AND payment_channel = 'DIRECT NG Bank' AND product_code LIKE '%NWO%' and contract not in ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'LCP'
WHEN tenant_name = 'AIRTEL_NG' AND product_type <> 'Classic' AND generation = 'Unified' THEN 'Airtel_Non-LCP'
WHEN contract IN ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'Airtel_Non-LCP'
ELSE 'Check' END Revenue_Category, 

SUM(CASE WHEN report_date = LAST_DAY(CURDATE() - INTERVAL 1 MONTH)+INTERVAL 1 DAY
              AND CAST(`transaction_date` AS DATE) < (CURDATE() - INTERVAL 1 MONTH)  THEN `charged_amount` END) Last_Month_revenue,
COUNT(DISTINCT CASE WHEN report_date = LAST_DAY(CURDATE() - INTERVAL 1 MONTH)+INTERVAL 1 DAY 
              AND CAST(`transaction_date` AS DATE) < (CURDATE() - INTERVAL 1 MONTH)  THEN contract END) Last_Month_unique_customers
FROM `daily_transactions`
WHERE repayment_status = 'Subsequent_Repayment'
GROUP BY Revenue_Category;

#.....This Month....#
SELECT
CASE WHEN tenant_name = 'MTN_NG' AND Product_Type = 'Classic' THEN 'MTN-Legacy'
WHEN tenant_name = 'MTN_NG' AND Product_Type <> 'Classic' THEN 'MTN-Unified'
WHEN `product_description` LIKE '%NWO%' AND contract NOT IN ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'LCP'
#WHEN tenant_name = 'AIRTEL_NG' AND product_code = 'null' AND product_description LIKE '%Lite tool%' THEN 'LCP'
#WHEN tenant_name = 'AIRTEL_NG' AND payment_channel = 'DIRECT NG Bank' AND product_code LIKE '%NWO%' and contract not in ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'LCP'
WHEN tenant_name = 'AIRTEL_NG' AND product_type <> 'Classic' AND generation = 'Unified' THEN 'Airtel_Non-LCP'
WHEN contract IN ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'Airtel_Non-LCP'
ELSE 'Check' END Revenue_Category, SUM(charged_amount) AS This_Month_Revenue, COUNT(DISTINCT contract) AS This_Month_unique_count
FROM`daily_transactions_curr_MTD`
WHERE repayment_status = 'Subsequent_Repayment' 
#and report_date = '2023-09-01'  
GROUP BY  Revenue_Category;





### For Paid Base
SELECT generation,`sales_channel`, `lcp_status`, COUNT(`contract`) This_Month_Count
FROM `activity`
WHERE `customer_status` = 'Paid'
#AND `month_date` = 'Dec-22'
GROUP BY generation,`sales_channel`, `lcp_status`;


## For Prev Paid Base
SELECT `generation`, `sales_channel`, `lcp_status`, COUNT(`contract`) Last_Month_Count
FROM `activity_log` 
WHERE `month_date` = 'Aug-23'
AND `customer_status` = 'Paid'
GROUP BY `generation`,`sales_channel`, `lcp_status`;




## Active Base on 1st of Month
SELECT 
COUNT( DISTINCT CASE WHEN `old_active_status`= 'Active' AND `month_date` = 'Aug-23' THEN contract END)'This_Month_Open_AIB',
COUNT( DISTINCT CASE WHEN `old_active_status`= 'Active' AND `month_date` = 'Jul-23' THEN contract END)'Last_Month_Open_AIB'
FROM  `activity_log` 

## Paid&Recovery Base on 1st of Month
SELECT 
COUNT( DISTINCT CASE WHEN `customer_status` IN ('Paid','Recovery') AND `month_date` = 'Aug-23' THEN  contract END)'This_Month_Open_PR',
COUNT( DISTINCT CASE WHEN `customer_status` IN ('Paid','Recovery')  AND `month_date` = 'Jul-23' THEN contract END)'Last_Month_Open_PR'
FROM  `activity_log`


SELECT
COUNT( DISTINCT CASE WHEN `customer_status` IN ('Paid','Recovery') AND `month_date` = 'Jul-23' AND generation = 'UNIFIED' AND lcp_status = 'LCP' THEN contract END)'LCP',
COUNT( DISTINCT CASE WHEN `customer_status` IN ('Paid','Recovery') AND `month_date` = 'Jul-23' AND generation = 'LEGACY' THEN contract END)'Legacy',
COUNT( DISTINCT CASE WHEN `customer_status` IN ('Paid','Recovery') AND `month_date` = 'Jul-23' AND generation = 'UNIFIED' AND lcp_status = 'Non-LCP' THEN contract END)'Unified'
FROM `activity_log`


SELECT
CASE WHEN tenant_name = 'MTN_NG' AND Product_Type = 'Classic' THEN 'MTN-Legacy'
WHEN tenant_name = 'MTN_NG' AND Product_Type <> 'Classic' THEN 'MTN-Unified'
WHEN `product_description` LIKE '%NWO%' AND contract NOT IN ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'LCP'
#WHEN tenant_name = 'AIRTEL_NG' AND product_code = 'null' AND product_description LIKE '%Lite tool%' THEN 'LCP'
#WHEN tenant_name = 'AIRTEL_NG' AND payment_channel = 'DIRECT NG Bank' AND product_code LIKE '%NWO%' and contract not in ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'LCP'
WHEN tenant_name = 'AIRTEL_NG' AND product_type <> 'Classic' AND generation = 'Unified' THEN 'Airtel_Non-LCP'
WHEN contract IN ('a0D6700001DGhlVEAT','a0D6700001Ea5R4EAJ','a0D6700001DGhnYEAT','a0D6700001DGhoMEAT','a0D6700001DGhnJEAT') THEN 'Airtel_Non-LCP'
ELSE 'Check' END Revenue_Category, SUM(charged_amount) AS Last_Month_Revenue, COUNT(DISTINCT contract) AS Last_Month_unique_count
FROM`daily_transactions`
WHERE repayment_status = 'Subsequent_Repayment' 
AND report_date = '2023-07-01'  
GROUP BY  Revenue_Category;
