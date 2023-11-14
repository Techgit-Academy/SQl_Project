# Upya LCP Base use Creation.
INSERT INTO `upya_lcp_base_use`

SELECT `client_number`, `contract_number`, `onboarding_status`, `created_date`, `system_id`, `grid_category`, `status`,`tenure`,

`full_initial_payment`, `monthly_payment`, `initial_down_payment`, `total_cost`, `upfront_days`, `first_name`, `last_name`, `customer_contact`,

`customer_gender`, `customer_language`, `customer_address`, `customer_landmark`, `customer_city`, `customer_district`, `customer_state`, `customer_latitude`, `customer_longitude`, `agent_id`, 

CONCAT(`agent_first_name`, ' ', `agent_last_name`) source_agent_name, CASE 

		WHEN `agent_first_name` =  'Darlington' AND `agent_last_name` = 'Osayi' THEN 'Godstime Omeregie'
				
		WHEN `agent_first_name` =  'Etim' AND `agent_last_name` = 'Etim' THEN 'Emmanuel Effiong'
		
		WHEN `agent_first_name` =  'Augustine ' AND `agent_last_name` = 'Keshi' THEN 'Godknows Chuku'
		
		WHEN `agent_first_name` =  'Osayemen' AND `agent_last_name` = 'Edogiawere' THEN 'Tochi Chijioke'
		
		WHEN `agent_first_name` =  'Omoruviefe' AND `agent_last_name` = 'Emmanuel' THEN 'Solomon Shaka'
		
	ELSE CONCAT(`agent_first_name`, ' ', `agent_last_name`) END AS current_agent_name, `agent_gender`, `agent_contact`, 
	
	`sales_mk`, `role`, `agent_district`, CONCAT(`tm_first_name`, ' ',`tm_last_name`) source_tm, CASE 
	
WHEN `agent_district` = 'OBIOAKPOR' THEN 'Emmanuel Tom'
WHEN `agent_district` = 'ELEME' THEN 'Aniebiet Etim'
WHEN `agent_district` = 'IKWERRE' THEN 'Godstime Atamako'
WHEN `agent_district` = 'OYIGBO' THEN 'TBD'
WHEN `agent_district` = 'PHALGA' THEN 'TBD'
WHEN `agent_district` = 'OKRIKA' THEN 'TBD'
WHEN `agent_district` = 'OGBA EGBEMA NDONI' THEN 'TBD'
WHEN `agent_district` = 'EMUOHA' THEN 'TBD'
WHEN `agent_district` = 'ETCHE' THEN 'Augustine Keshi'
WHEN `agent_district` = 'OWERRI NORTH' THEN 'Bruno Mbagwu'
WHEN `agent_district` = 'UGHELLI' THEN 'Kingsley Akpoviri'
WHEN `agent_district` = 'UKWUANI' THEN 'TBD'
WHEN `agent_district` = 'OSHIMILI NORTH' THEN 'John Akarah'
WHEN `agent_district` = 'WARRI SOUTH ' THEN 'Izobo Jeris'
WHEN `agent_district` = 'NDOKWA WEST' THEN 'Kelvin Umujedo'
WHEN `agent_district` = 'SAPELE' THEN 'TBD'
WHEN `agent_district` = 'UDU' THEN 'Izobo Jeris'
WHEN `agent_district` = 'BOMADI' THEN 'TBD'
WHEN `agent_district` = 'OREDO' THEN 'Erhun Aitituwa'
WHEN `agent_district` = 'EGOR' THEN 'Emmanuel Igemokhai'
WHEN `agent_district` = 'IKPOBA OKHA ' THEN 'TBD'
WHEN `agent_district` = 'OVIA NORTHEAST' THEN 'TBD'
WHEN `agent_district` = 'ESAN NORTHEAST' THEN 'TBD'
WHEN `agent_district` = 'ORHIHONWON' THEN 'TBD'
WHEN `agent_district` = 'ESAN SOUTHEAST' THEN 'TBD'
WHEN `agent_district` = 'ETSAKO WEST' THEN 'Sikiru Ibrahim'
WHEN `agent_district` = 'UYO' THEN 'Uduakabasi Daniel'
WHEN `agent_district` = 'IBESIKPO ASUTAN' THEN 'Ifiok Akpan'
WHEN `agent_district` = 'ORON' THEN 'Etim Etim'
			
ELSE CONCAT(`tm_first_name`, ' ',`tm_last_name`) END AS current_tm, `sm`, `sm_state`
	
FROM `upya_lcp_base`

WHERE `created_date` >= '2023-11-13'


