select row_id,status_cd from siebel.s_order_item where order_id = '1-15RWY-463'

select * From siebel.s_order_postn


SELECT so.row_id,SO.order_num, SO.status_cd,  SO.EAI_ERROR_TEXT
FROM SIEBELWORK.LN_GCRM_AGRMT_MIGPR1 REF
JOIN SIEBEL.S_ORDER SO ON SO.ORDER_NUM = REF.AGREEMENT_ID  AND  SO.status_cd = 'Errored'

select order_num, agree_id, status_cd from siebel.s_order where order_num = 'M00204390-40450337_01-02-2020'

update siebel.s_order set agree_id = NULL where order_num = 'M00204390-40450337_01-02-2020'


select * from siebel.s_doc_agree where order_id = '1-15RWY-348'

--1-3VNHXLD

--update siebel.s_doc_agree set order_id = null where row_id = '1-3VNHXLD'



SELECT SO.ORDER_NUM, ORG.INTEGRATION_ID OCPUGID, BILL.INTEGRATION_ID FAPGUID, SO.status_cd, SO.EAI_ERROR_TEXT
FROM SIEBELWORK.LN_GCRM_AGRMT_MIGPR1 REF
JOIN SIEBEL.S_ORDER SO ON SO.ORDER_NUM = REF.AGREEMENT_ID AND SO.status_cd = 'Complete'
-- AND SO.EAI_ERROR_TEXT <>  'ErrorCode=156; ErrorDesc=Following error was returned when synching the order to FBM - Line of Business is different from the Line of Business of Original order. (32000,156)'
JOIN SIEBEL.S_ORG_EXT BILL ON SO.BILL_ACCNT_ID = BILL.ROW_ID
JOIN SIEBEL.S_ORG_EXT ORG ON SO.ACCNT_ID = ORG.ROW_ID
--GROUP BY SO.status_cd, SO.EAI_ERROR_TEXT

SELECT * FROM SIEBEL.S_ORDER WHERE ROW_ID = '1-15RWY-353'

SELECT count(*),  SO.status_cd,  SO.EAI_ERROR_TEXT
FROM SIEBELWORK.LN_GCRM_AGRMT_MIGPR1 REF
JOIN SIEBEL.S_ORDER SO ON SO.ORDER_NUM = REF.AGREEMENT_ID 
group by  SO.status_cd,  SO.EAI_ERROR_TEXT




SELECT so.row_id,SO.order_num, SO.status_cd, SP.NAME, DIVN.NAME DIVISION, DIVN.X_LN_OF_BUSINESS, SO.EAI_ERROR_TEXT
FROM SIEBELWORK.LN_GCRM_AGRMT_MIGPR1 REF
JOIN SIEBEL.S_ORDER SO ON SO.ORDER_NUM = REF.AGREEMENT_ID and so.STATUS_CD = ''
JOIN SIEBEL.S_ORDER_POSTN SPO ON SO.ROW_ID = SPO.ORDER_ID
JOIN SIEBEL.S_POSTN SP ON SP.ROW_ID = SPO.POSTN_ID
JOIN SIEBEL.S_ORG_EXT DIVN ON SP.OU_ID = DIVN.ROW_ID  
