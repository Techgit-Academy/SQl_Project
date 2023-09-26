
SELECT 
CASE WHEN product_name LIKE '%PRIME%' THEN 'PRIME'
     WHEN product_name LIKE '%ECO%' THEN 'ECO'
ELSE product_name 
END AS Product_Categ,

CASE WHEN product_name LIKE '%28M%' THEN '28M LTO'
     WHEN product_name LIKE '%12M%' THEN '12M LTO'
     WHEN product_name LIKE '%24M%' THEN '24M LTO'
     
     
ELSE 'Outright'
END AS Active_base_Product_LTO, COUNT(DISTINCT(contract))

FROM `activity_log`
WHERE month_date = 'Aug-23' AND lcp_status = 'LCP' AND customer_status IN ('Paid','Recovery')
GROUP BY Active_base_Product_LTO, Product_Categ


#.................Merged with LCP_base_Use


SELECT 
    CASE 
        WHEN a.product_name LIKE '%PRIME%' THEN 'PRIME'
        WHEN a.product_name LIKE '%ECO%' THEN 'ECO'
        ELSE a.product_name 
    END AS Product_Categ,
    CASE 
        WHEN a.product_name LIKE '%28M%' THEN '28M LTO'
        WHEN a.product_name LIKE '%12M%' THEN '12M LTO'
        WHEN a.product_name LIKE '%24M%' THEN '24M LTO'
        ELSE 'Outright'
    END AS Active_base_Product_LTO, 
    COUNT(DISTINCT a.contract) AS contract_count
FROM `activity_log` a 
LEFT JOIN `lcp_base_use` b ON a.contract = b.contract
WHERE 
    a.month_date = 'Aug-23' 
    AND a.lcp_status = 'LCP' 
    AND a.customer_status IN ('Paid', 'Recovery')
GROUP BY Active_base_Product_LTO, Product_Categ;



   #Active Base#
 SELECT 
 CASE
 WHEN `tenure` LIKE '%12m%'  THEN '12m LTO'
 WHEN `tenure` LIKE '%28m%' THEN '28m LTO'
 ELSE 'outright plan'
 END AS category, COUNT( DISTINCT `contract_number`) active_base_count
 FROM`upya_activity_log`
 
 WHERE active_status IN ('Paid', 'Recovery') AND `report_date` = '2023-08-31'
 AND `ltoperiod` != 1 AND  `status` IN('ENABLED','LOCKED', 'REPOSSESSED')
 GROUP BY category
 
SELECT * FROM `activity_log` WHERE month_date = 'Aug-23' AND
lcp_status = 'LCP' AND customer_status IN ('Paid','Recovery')

