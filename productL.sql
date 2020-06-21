select * from LN_EPOCH_STORE_TABLE

 
select * from LN_REFERENCE_TABLE


select x_priced, x_last_sync_dt From siebel.s_prod_int a
where integration_id ='urn:product:1001148'

update siebel.s_prod_int set x_priced = 'N' , x_last_sync_dt = null 
WHERE  x_priced = 'Y' and x_last_sync_dt IS NOT NULL



select count(*) from siebel.s_prod_int where  x_priced = 'Y' and x_last_sync_dt IS NOT NULL


--UPDATE LN_EPOCH_STORE_TABLE SET LAST_PROCESSED_EPOCH = LAST_PROCESSED_EPOCH - 6

select * From siebel.s_prod_int
where created > sysdate - 1
order by created desc



select * from PRINTMIG.LN_EPOCH_STORE_TABLE


sele

select * from LN_PSH_CRM_SUCCESS_TABLE
where CREATED_DATE > sysdate - 1 
ORDER BY CREATED_DATE DESC


select * from LN_PSH_CRM_SUCCESS_TABLE where product_pguid in ( 

'urn:product:1089689')


select * from all_tables where table_name like '%SUCCESS%'

select * from LN_REFERENCE_TABLE


select psh_url, partition_pguid from LN_REFERENCE_TABLE



--http://cdc4-i-services.lexisnexis.com/shared/pubsubhub/subscription/

SELECT * FROM LN_PSH_PM_SYNC_PSH

SELECT * FROM LN_PSH_ECM_URL



select * from all_tables where table_name like '%PSH%'


select * from ln_epoc_exception_table where product_guid in ( 

'urn:product:1089689')



select * FROM ln_psh_crm_success_table
where product_pguid =   'urn:product:8700077'
ORDER BY CREATED_DATE DESC

select * from siebel.s_prod_int where integration_id = 'urn:product:8700077'


select  COUNT(*) , PRODUCT_TYPE from 
(SELECT DISTINCT product_pguid,PRODUCT_TYPE FROM siebelwork.ln_psh_crm_success_table
WHERE CREATED_DATE > SYSDATE - 2)
GROUP BY PRODUCT_TYPE

where product_pguid = 'urn:product:1521247'

SELECT * FROM DBA_TABLES WHERE TABLE_NAME LIKE 'S%DEF%'
AND OWNER = 'SIEBEL'

SELECT * FROM ln_psh_crm_success_table
WHERE PRODUCT_PGUID in ( 'urn:product:8700094','urn:product:8700095')






SELECT A.NAME, A.INTEGRATION_ID, C.VER_NUM, C.START_DT,END_DT FROM SIEBEL.S_PROD_INT A, SIEBEL.S_VOD B,
SIEBEL.S_VOD_VER C, SIEBEL.S_ISS_OBJ_DEF D
WHERE A.CFG_MODEL_ID = B.OBJECT_NUM
AND A.INTEGRATION_ID = 'urn:product:1502293'
--'urn:product:1010385'
AND B.VOD_TYPE_CD = 'ISS_PROD_DEF'
AND B.ROW_ID = C.VOD_ID
AND b.row_id = d.vod_id
AND C.RELEASED_FLG = 'Y'
AND D.LAST_VERS = 0
ORDER BY C.START_DT DESC
-----

SELECT b.row_id, A.NAME, A.INTEGRATION_ID, C.VER_NUM,d.sub_obj_name, d.sub_obj_id,orig_id FROM SIEBEL.S_PROD_INT A, SIEBEL.S_VOD B,
SIEBEL.S_VOD_VER C, SIEBEL.S_ISS_SUB_OBJ D
WHERE A.CFG_MODEL_ID = B.OBJECT_NUM
AND A.INTEGRATION_ID = 'urn:product:1502293'
--'urn:product:1010385'
AND B.VOD_TYPE_CD = 'ISS_PROD_DEF'
AND B.ROW_ID = C.VOD_ID
AND b.row_id = d.vod_id
AND C.curr_ver_flg = 'Y'
AND D.LAST_VERS = 0
ORDER BY C.START_DT DESC




SELECT name FROM SIEBEL.S_PROD_INT where CFG_MODEL_ID = '1-60FYPO'

SELECT * FROM SIEBEL.S_VOD
SELECT * FROM SIEBEL.S_VOD_ver where vod_id = '1-60FYPN'


SELECT * FROM SIEBEL.S_ISS_OBJ_DEF

SELECT * FROM SIEBEL.S_ISS_SUB_OBJ where vod_id = '1-60FYPN'

SELECT * FROM SIEBEL.S_ISS_OBJ_DEF where vod_id  = '1-60FYPN'

1-60FYPO

select * from siebelwork.ln_epoc_exception_table where product_guid in ( 'urn:product:1521246', 'urn:product:1521247')

select * From siebel.s_prod_int where integration_id =  'urn:product:1521247'

select * from siebel.s_vod where vod_name like '%1521246%'

--update siebel.s_vod set vod_name = 'OnBoarding Advanced Matter Management & Essentials Legal Spend Management 1521246'||''||row_id where row_id = '1-14ZN6LX' 

update siebel.s_prod_int set integration_id =  'urn:product:1521247'
where name = 'OnBoarding Advanced Matter Management & Global Essentials for Legal Spend Management 1521247'
set define off
select name, integration_id From siebel.s_prod_int where name = 'OnBoarding Advanced Matter Management & Global Essentials for Legal Spend Management 1521247'

