
SELECT d.name, B.AGREE_NUM, B.EFF_START_DT, b.eff_end_dt, c.name, X_TERM_TYPE
  FROM SIEBEL.S_ASSET A, SIEBEL.S_DOC_AGREE B, SIEBEL.S_PROD_INT C,
siebel.s_org_Ext d
WHERE B.ROW_ID = a.cur_agree_id
AND A.PROD_ID = C.ROW_ID
and b.target_ou_id = d.row_id
AND B.AGREE_CD = 'Service Level Agreement'
--AND  B.AGREE_NUM = '1000277299'
AND  B.STAT_CD = 'Active'
AND c.X_LN_PRODUCT_SEGMENT IN ('Services', 'Media')
AND d.bu_id in ('1-TN9AV','1-TN9AP')
AND B.X_TERM_TYPE = 'AAR'


SELECT * FROM SIEBEL.S_DOC_AGREE 

select row_id, name from siebel.s_bu where name  in ('Australia', 'New Zealand')

SELECT * FROM SIEBEL.S_PROD_INT WHERE NAME LIKE 'Freight%'