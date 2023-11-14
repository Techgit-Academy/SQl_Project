UPDATE`upya_lcp_base_use`
SET `current_tm` =
CASE
WHEN `current_tm` = 'Emmanuel Igemokhai' THEN 'Emmanuell Igemokhai'
ELSE`current_tm`
END 

UPDATE `upya_lcp_base`
SET
    agent_first_name = 'Solomon',
    agent_last_name = 'Shaka',
    agent_district = 'WARRI SOUTH',
    tm_first_name = 'Izobo',
    tm_last_name = 'Jeris',
    sm = 'Harrison Nwagwu',
    sm_state = 'Delta'
WHERE `contract_number` IN(535533004,
613737777,
28758336)


UPDATE `upya_lcp_base`
SET
    agent_first_name = 'Solomon',
    agent_last_name = 'Shaka',
    agent_district = 'WARRI SOUTH',
    tm_first_name = 'Izobo',
    tm_last_name = 'Jeris',
    sm = 'Harrison Nwagwu',
    sm_state = 'Delta'
WHERE `contract_number` IN(535533004,
613737777,
28758336)


UPDATE `upya_lcp_base_use`

SET
  
    agent_district = 'WARRI SOUTH',
    current_tm = 'Izobo Jeris',
    sm = 'Harrison Nwagwu',
    sm_state = 'Delta'
WHERE `contract_number` IN(535533004,
613737777,
28758336)