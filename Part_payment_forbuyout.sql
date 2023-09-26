

SELECT *, 
	CASE 
	
	 WHEN c.Sept_total_payment > avg_monthly_payment AND c.Sept_paidperiod < c. expectedsept_paideriod THEN 'part_payment_forbuyout'
	 ELSE 'not_paying_part'
	 
END AS partpayment_status

FROM

(

SELECT c.*,

	
	ROUND(SUM(d.charged_amount) / COUNT(DISTINCT DATE_FORMAT(d.report_date, '%Y-%m')),0) AS avg_monthly_payment

FROM
(
        
 SELECT *,
	
	CASE
	#HEN Sept_paidperiod >= expectedsept_paideriod AND discount_offer = 0 THEN 'promote_long_plan_owner'
	
	#WHEN Sept_paidperiod < expectedsept_paideriod AND discount_offer = 0 THEN 'promote_long_plan'
	 
	WHEN Sept_paidperiod < expectedsept_paideriod AND sept_mtnairtime_payment <= 0 THEN 'eligible_towardsbuyout'
	
	WHEN Sept_paidperiod < expectedsept_paideriod AND sept_mtnairtime_payment > 0 AND sept_mtn_paidperiod  <  Sept_paidperiod THEN 'mixed_payment_towardsbuyout'
	
	WHEN Sept_paidperiod < expectedsept_paideriod AND sept_mtnairtime_payment> 0 AND sept_mtnairtimebank_payment  <= 0 AND sept_quickteller_payment <= 0 AND   sept_corapay_payment <= 0  AND  sept_directbank_payment <= 0 THEN 'fullairtimepayment_towardsbuyout'
	
	ELSE 'Not elegible'
	
END AS eligiblity_status,

	CASE    
		WHEN discount_offer = 0 THEN 'Promote long plan purchase for discounts'
		
		WHEN discount_offer = 1 OR discount_offer = 30  THEN 'Enjoy 1-month discount, buy out unit today'
		
		WHEN discount_offer = 2 OR discount_offer = 60 THEN 'Enjoy 2-months discount, buy out unit today'
		
		WHEN discount_offer = 3 OR discount_offer = 90 THEN 'Enjoy 3-month discount, buy out unit today'
		
		WHEN discount_offer = 4 OR discount_offer = 120 THEN 'Enjoy 4-months discount, buy out unit today'
		
		ELSE 'check'
END AS Offer_rate


FROM 

(
	
SELECT*,
	(sept_mtnairtime_payment +sept_mtnairtimebank_payment + sept_corapay_payment + sept_quickteller_payment + sept_directbank_payment) AS Sept_total_payment,
	
	(sept_mtn_paidperiod + sept_airtimebank_paidperiod + sept_coralpay_paidperiod + sept_quickteller_paidperiod + sept_directbank_paidperiod) AS Sept_paidperiod

FROM
(
SELECT 
    b.`contract`,b.`crmcontract`,b.`customer_name`,b.`customer_payer_phone_number`, b.`ltoperiod`,b.`generation`,
     b.`Days_remaining_to_ownership`, b.`customer_status`,b.`Required_Status`, b.`paidperiod` AS preofferpaidperiod, discount_offer,
    (b.`Days_remaining_to_ownership`-b.discount_offer) AS expectedsept_paideriod,
     
    #SUM(CASE WHEN date(c.transaction_date) <= '2023-09-02'  THEN c.charged_amount ELSE 0 END) AS sept1_payments,
    
    #SUM(CASE when  date(c.transaction_date) <= '2023-09-02' THEN c.`payment_duration` else 0 end) AS sept1_paidperiod,

    SUM(CASE WHEN c.payment_channel = 'MTN' THEN c.charged_amount ELSE 0 END) AS sept_mtnairtime_payment,
    
    SUM(CASE WHEN c.payment_channel = 'MTN' THEN c.`payment_duration` ELSE 0 END) AS sept_mtn_paidperiod,
    
    SUM(CASE WHEN c.payment_channel = 'MTN NG Airtime Bank' THEN c.charged_amount ELSE 0 END) AS sept_mtnairtimebank_payment,
    
    SUM(CASE WHEN  c.payment_channel = 'MTN NG Airtime Bank'  THEN c.`payment_duration` ELSE 0 END) AS sept_airtimebank_paidperiod,
     
    SUM(CASE WHEN c.payment_channel = 'CoralPay' THEN c.charged_amount ELSE 0 END) AS sept_corapay_payment,
    
    SUM(CASE WHEN c.payment_channel = 'CoralPay'  THEN c.`payment_duration` ELSE 0 END) AS sept_coralpay_paidperiod,
   
    
    SUM(CASE WHEN  c.payment_channel = 'QuickTeller' THEN c.charged_amount ELSE 0 END) AS sept_quickteller_payment,
    
    
    SUM(CASE WHEN c.payment_channel = 'QuickTeller'  THEN c.`payment_duration` ELSE 0 END) AS sept_quickteller_paidperiod,
     
    SUM(CASE WHEN  c.payment_channel = 'DIRECT NG Bank' THEN c.charged_amount ELSE 0 END) AS sept_directbank_payment,
    
    SUM(CASE WHEN  c.payment_channel = 'DIRECT NG Bank'  THEN c.`payment_duration` ELSE 0 END) AS sept_directbank_paidperiod
  
    
FROM (
    SELECT 
        `contract`,`crmcontract`,`customer_name`,`customer_payer_phone_number`,`generation`, `customer_status`,`Required_Status`,`ltoperiod`,`Days_remaining_to_ownership`, `paidperiod`, 
       
     CASE
            WHEN generation = 'LEGACY' AND (ltoperiod - `paidperiod`) >= 1110 THEN 120 
            WHEN generation = 'UNIFIED' AND (ltoperiod - `paidperiod`) >= 37 THEN 4 
            WHEN generation = 'LEGACY' AND (ltoperiod - `paidperiod`) >= 720 THEN 90 
            WHEN generation = 'UNIFIED' AND (ltoperiod - `paidperiod`) >= 24 THEN 3
            WHEN generation = 'LEGACY' AND (ltoperiod - `paidperiod`) >= 540 THEN 60
            WHEN generation = 'UNIFIED' AND (ltoperiod - `paidperiod`) >= 18 THEN 2
            WHEN generation = 'LEGACY' AND (ltoperiod - `paidperiod`) >= 360 THEN 30
            WHEN generation = 'UNIFIED' AND (ltoperiod - paidperiod) >= 12   THEN 1
            ELSE 0
        END AS discount_offer
       
    
    FROM `buyout_offer`
    )b
    
    LEFT JOIN `daily_transactions_curr_MTD` c
    
    ON b.contract = c.contract
    
    
    GROUP BY     b.`contract`,b.`crmcontract`,b.`customer_name`,b.`customer_payer_phone_number`, b.`ltoperiod`,b.`generation`, b.`customer_status`,
     b.`Days_remaining_to_ownership`, b.`Required_Status`,preofferpaidperiod,discount_offer, expectedsept_paideriod
    
) AS c



)c
)c
LEFT JOIN `daily_transactions` d
ON c.contract = d.contract

 
GROUP BY  c.`contract`,c.`crmcontract`,c.`customer_name`,c.`customer_payer_phone_number`, c.`ltoperiod`,c.`generation`, c.`customer_status`,c.Sept_total_payment,
     c.`Days_remaining_to_ownership`, c.`Required_Status`,c.preofferpaidperiod,c.discount_offer, c.expectedsept_paideriod,c.eligiblity_status,c.expectedsept_paideriod,
     c.Offer_rate
   
)c

WHERE c.Sept_paidperiod < c.expectedsept_paideriod  
    