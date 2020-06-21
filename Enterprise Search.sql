SELECT account,ACCOUNT_TLC,ACCOUNT_SBL_STATUS, ACCOUNT_SBL_STATUS FROM ln_prospects_text 


SELECT ACCOUNT,ORG_CUST_NUMBER,ACCOUNT_TLC,CITY,STATE, AP_PHONE,ACCOUNT_SBL_STATUS
, ROW_NUMBER() OVER (PARTITION BY ORG_CUST_NUMBER order by ORG_CUST_NUMBER ) r 
FROM ln_prospects_text
where CONTAINS(search_txt, 'Pusher') > 1
--and CONTAINS(search_txt,'') > 1

SELECT account,ACCOUNT_TLC,ACCOUNT_SBL_STATUS FROM ln_prospects_text WHERE ORG_CUST_PGUID in (
'urn:ecm:1000K6JJL',
'urn:ecm:1000KA0EL',
'urn:ecm:10002G2YG',
'urn:ecm:10001TBV6',
'urn:ecm:1000J6IT1',
'urn:ecm:1000JRJDL',
'urn:ecm:10001IGGE',
'urn:ecm:10002E3HB',
'urn:ecm:1000JUYO1',
'urn:ecm:10015PNQP' )



where account = 'Amy Alyssa McGeever'

WHERE ORG_CUST_PGUID ='urn:ecm:10001PSCJ'

select name,accnt_type_cd,cust_stat_Cd from siebel.s_org_ext A where integration_id = 'urn:ecm:10002HVGZ'
select * from siebel.s_org_ext A where integration_id = 'urn:ecm:10001PSCJ'

UPDATE ln_prospects_text SET ACCOUNT_SBL_ROW_ID = <<>> WHERE ORG_CUST_PGUID = <<>>



SELECT ACCOUNT,ORG_CUST_NUMBER,ACCOUNT_TLC,CITY,STATE, AP_PHONE
, ROW_NUMBER() OVER (PARTITION BY ORG_CUST_NUMBER order by ORG_CUST_NUMBER ) r 
FROM ln_prospects_text
where CONTAINS(search_txt, 'CoilTainer ') > 1
and CONTAINS(search_txt,'') > 1

CREATE OR REPLACE VIEW TEMP_PROSPECT AS
SELECT ACCOUNT,ORG_CUST_NUMBER,ACCOUNT_TLC,CITY,STATE, AP_PHONE, search_txt
, ROW_NUMBER() OVER (PARTITION BY ORG_CUST_NUMBER order by ORG_CUST_NUMBER ) r 
FROM ln_prospects_text

SELECT * FROM TEMP_PROSPECT
where CONTAINS(search_txt, 'Oracle') > 1
OR CONTAINS(search_txt,'DiSalvatore') > 1


select * From siebel.s_org_ext

-- OC in GCRM no Promote OC button
select count(*),ACCOUNT
from ln_prospects_text
WHERE ACCOUNT_SBL_STATUS <> 'Delete'
and ACCOUNT_SBL_ROW_ID IS NOT NULL
having count(*) < 3
group by account

-- Prospect with Promote Button
select count(*),ACCOUNT
from ln_prospects_text
WHERE ACCOUNT_SBL_ROW_ID IS NULL
AND ACCOUNT_SBL_STATUS is null
--having count(*) 
group by account



SELECT  DISTINCT ACCOUNT, ORG_CUST_PGUID FROM ln_prospects_text
where CONTAINS(search_txt, 'Oracle Transcription') > 1
OR CONTAINS(search_txt,'DiSalvatore') > 1
OR  CONTAINS(search_txt,'MD') > 1


SELECT * FROM ln_prospects_text
where CONTAINS(search_txt, 'Marvin') > 1
OR CONTAINS(search_txt,'DiSalvatore') > 1
OR


SELECT * FROM ln_prospects_text WHERE ACCOUNT_SBL_ROW_ID IS NULL

Oracle Transcription Inc 10002PPTS ROCKVILLE MD 20853-1887 John DiSalvatore   Prospect

search_txt contains ('Oracle Transcription') 