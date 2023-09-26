

#..................................Active Customer base...................#
SELECT 
CASE
WHEN generation = 'LEGACY'  THEN 'LEGACY'
WHEN lcp_status ='LCP' THEN 'LCP'
WHEN generation ='UNIFIED' AND sales_channel = 'MTN_NG' THEN 'MTN UNIFIED'
WHEN generation ='UNIFIED' AND sales_channel = 'AIRTEL_NG' THEN ' UNIFIED Non MTN'


END AS Active_base_Mar23, COUNT(DISTINCT(contract))


FROM `activity_log`
WHERE month_date = 'Aug-23' AND customer_status NOT IN ('Retrieval', 'Owner', 'Cancelled', 'Rental')
GROUP BY Active_base_Mar23
;
 #------------------------LTO To Owner-------------------------------#
 SELECT 
CASE
WHEN generation = 'LEGACY'  THEN 'LEGACY'
WHEN lcp_status ='LCP' THEN 'LCP'
WHEN generation ='UNIFIED' AND sales_channel = 'MTN_NG' THEN 'MTN UNIFIED'
WHEN generation ='UNIFIED' AND sales_channel = 'AIRTEL_NG' THEN ' UNIFIED Non MTN'


END AS LTO_Owner_Mar23, COUNT(DISTINCT(contract))

FROM `activity_log`

WHERE customer_status = 'Owner' AND  month_date = 'Aug-23' 
 AND  contract  IN ( SELECT contract FROM activity_log WHERE
  customer_status != 'Owner' AND month_date = 'Jul-23')
GROUP BY  LTO_Owner_Mar23
;

#...................................Retrieval base................#
SELECT 
CASE
WHEN generation = 'LEGACY'  THEN 'LEGACY'
WHEN lcp_status ='LCP' THEN 'LCP'
WHEN generation ='UNIFIED' AND sales_channel = 'MTN_NG' THEN 'MTN UNIFIED'
WHEN generation ='UNIFIED' AND sales_channel = 'AIRTEL_NG' THEN ' UNIFIED Non MTN'


END AS Retrieval_base_Mar23, COUNT(DISTINCT(contract))


FROM `activity_log`
WHERE month_date = 'Aug-23' AND customer_status NOT IN ('Paid', 'Recovery', 'Owner', 'Cancelled', 'Rental')
GROUP BY Retrieval_base_Mar23
;


  #Active Base#
 SELECT COUNT(DISTINCT contract_number) previous_paid_base FROM`upya_activity_log`
 WHERE active_status IN ('Paid', 'Recovery') AND `report_date` = '2023-08-31'
 AND `ltoperiod` != 1
 #Upya LTO-Owner
 SELECT COUNT(DISTINCT contract_number) LTO_Owner FROM`upya_activity_log`
 WHERE active_status = 'Owner' AND  report_date = '2023-08-31' 
 AND  contract_number  IN ( SELECT contract_number FROM `upya_activity_log` WHERE
  active_status != 'Owner' AND report_date = '2023-07-31')
  AND `ltoperiod` != 1

 
 select * from `upya_activity_log` where `ltoperiod` != 1
 