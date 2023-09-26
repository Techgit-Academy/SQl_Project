
#....comparing 2 mnths****#
    SELECT 
    CASE 
        WHEN payment_date BETWEEN '2023-08-01' AND '2023-08-18' THEN 'Aug (1-17)'
        WHEN report_date = '2023-09-17' THEN 'Sept (1-17)'
END AS MONTH,
    SUM(CASE WHEN payment_classification = 'Initial Payment' THEN amount ELSE 0 END) AS Full_Initial_payment,
    SUM(CASE WHEN payment_classification = 'Outright' THEN amount ELSE 0 END) AS Outright_payment,
    SUM(CASE WHEN payment_classification = 'Repayment' THEN amount ELSE 0 END) AS Repayment,
    COUNT(DISTINCT CASE WHEN payment_classification = 'Repayment' THEN contract_number END) AS Repayment_count,
     COUNT(DISTINCT CASE WHEN payment_classification = 'Outright' THEN contract_number END) AS Outright_count,
      COUNT(DISTINCT CASE WHEN payment_classification = 'Initial Payment' THEN contract_number END) AS Initial_Count
FROM 
    `upya_daily_transactions`
WHERE 
    (payment_date BETWEEN '2023-08-01' AND '2023-08-18' 
    AND report_date = '2023-08-31') OR (report_date = '2023-09-17') 
     AND `payment_classification` NOT IN ('Check','Invalid') 
GROUP BY MONTH;
 

 
   #***Paid Base*** #      
 SELECT COUNT(DISTINCT contract_number) paid_base FROM `upya_activity_log`
 WHERE active_status = 'Paid' AND report_date = '2023-09-17' 
 AND `ltoperiod` != 1 AND `status` IN('ENABLED','LOCKED')
 

 #Previous Paid Base#
 SELECT COUNT(DISTINCT contract_number) previous_paid_base FROM`upya_activity_log`
 WHERE active_status = 'Paid' AND `report_date` = '2023-08-31'
 AND `ltoperiod` != 1 AND `status` IN('ENABLED','LOCKED')
 
  #Active Base#
 SELECT COUNT(DISTINCT contract_number) previous_paid_base FROM`upya_activity_log`
 WHERE active_status IN ('Paid', 'Recovery') AND `report_date` = '2023-09-17'
 AND `ltoperiod` != 1 AND  `status` IN('ENABLED','LOCKED', 'REPOSSESSED')
 
 #Retrieval Base
SELECT COUNT(DISTINCT contract_number) previous_paid_base FROM`upya_activity_log`
 WHERE active_status IN ( 'Retrieval') AND `report_date` = '2023-09-17'
 AND `ltoperiod` != 1 AND  `status` = 'REPOSSESSED'
         
     SELECT SUM(amount)Revenue,COUNT(contract_number) unique_count, payment_date,system_status, payment_code
     FROM 
      upya_daily_transactions  
      WHERE report_date ='2023-08-13' AND payment_classification = 'Repayment'
      GROUP BY payment_date,system_status, payment_code





#....comparing 2 mnths****#
    SELECT 
    CASE 
        WHEN report_date = '2023-07-31' THEN 'July'
        WHEN report_date = '2023-08-31' THEN 'August'
END AS MONTH,
    #SUM(CASE WHEN payment_classification = 'Initial Payment' THEN amount ELSE 0 END) AS Full_Initial_Payment,
    #SUM(CASE WHEN payment_classification = 'Outright' THEN amount ELSE 0 END) AS Outright_Payment,
    SUM(CASE WHEN payment_classification = 'Repayment' THEN amount ELSE 0 END) AS Repayment,
    COUNT( DISTINCT CASE WHEN payment_classification = 'Repayment' THEN contract_number END) AS Repayment_count
     #COUNT(DISTINCT CASE WHEN payment_classification = 'Outright' THEN contract_number END) AS Outright_count,
      #COUNT(DISTINCT CASE WHEN payment_classification = 'Initial Payment' THEN contract_number END) AS Initial_Count
FROM 
    `upya_daily_transactions`
WHERE report_date >= '2023-07-31'
GROUP BY
   MONTH;

SELECT DISTINCT `contract_number`,`tenure`,`status`,`ltoperiod`,`active_status`,`onboarding_status`,`lto_segment`,`age_segment`,`active_status`,`segmentation_status`,`segmentation_score`,`days_deficit`,`age`,`paidperiod` FROM`upya_activity_log` 
WHERE `report_date` = '2023-09-17'