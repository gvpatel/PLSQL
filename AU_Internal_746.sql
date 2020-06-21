SELECT NAME, integration_id, agree_num, rev_num,TERM_TYPE, GCRM_STATUS, REAL_STATUS,
MEDIA,X_CUST_CLASS,X_CUSTOMER_SUBCLASS,
EFF_START_DT, EFF_END_DT, X_MONTLY_NET_PRICE,

CASE WHEN rev_num < 2 then 'REOPEN_RESUMBIT_ORDER' ELSE 'MANUAL_FIX' END AS RECOMMENDATION
FROM (
SELECT c.name, c.integration_id , a.row_id, a.agree_num, a.stat_cd as GCRM_STATUS, a.rev_num , a.X_TERM_TYPE TERM_TYPE
,RANK() OVER (PARTITION BY a.AGREE_NUM ORDER BY a.rev_num desc) AS r
,case when (( X_TERM_TYPE = 'Fixed Term' and EFF_END_DT < sysdate ) 
                        OR  a.stat_cd = 'Inactive' )  THEN
     'EXPIRED'
     ELSE 'ACTIVE' 
   END  AS REAL_STATUS,
   X_MONTLY_NET_PRICE,
 
 (  SELECT case when count(*) > 0 then 'Y' ELSE 'N' END from siebel.s_doc_agree p, siebel.s_asset q
, siebel.s_prod_int r
where p.row_id = q.cur_agree_id
and q.prod_id = r.row_id
and r.X_LN_PRODUCT_SEGMENT = 'Media'
and p.row_id = a.row_id ) AS MEDIA   

,a.X_TERM_TYPE , a.X_ORDER_SUB_TYPE
, a.EFF_START_DT, a.EFF_END_DT, a.X_MULTI_TERM_FLG, c.X_CUST_CLASS, c.X_CUSTOMER_SUBCLASS
  
FROM  SIEBEL.s_doc_agree a,
siebel.s_org_Ext c
where a.TARGET_OU_ID = c.row_id
 and c.LOC IN
('4252C4LWW',
'4252TD4QJ',
'422M5QWBK',
'422JT3CLN',
'42529JTDR',
'424YP45Y2',
'42535MHRR',
'4252ZCGPP',
'4254B4QSQ',
'42528JM8M'
)



order by c.integration_id, agree_num, a.rev_num desc
) WHERE r = 1
--and real_status <> 'EXPIRED'
ORDER BY rev_num
