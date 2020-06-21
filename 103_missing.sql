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
/* and c.LOC IN
('42528JM8M',
'425295K5X',
'425288D6H',
'425288LMQ',
'4252827BS',
'42528VQJZ',
'42529BJH2',
'42529LJB5',
'42529JTDR',
'42537C96S',
'425285H54')
*/
and a.agree_num in (
'1000498140',
'1000498128',
'1000498354',
'1000498062',
'1000498064',
'1000498760',
'1000498234',
'1000498410',
'1000498574',
'1000498129',
'1000498409',
'1000498143',
'1000498682',
'1000479762',
'1000498142',
'1000481569',
'1000482183',
'1000498141',
'1000484331',
'1000498837',
'1000487167',
'1000498424',
'1000490078',
'1000492777',
'1000492771',
'1000492770',
'1000492781',
'1000492769',
'1000493286',
'1000493482',
'1000492888',
'1000493483',
'1000493481',
'1000493440',
'1000493284',
'1000498153',
'1000495613',
'1000495609',
'1000498613',
'1000498759',
'1000498425',
'1000498428',
'1000499967',
'1000499966',
'1000499976',
'1000499975',
'1000499972',
'1000499968',
'1000499970',
'1000499971',
'1000499969',
'1000498059',
'1000498144',
'1000498417',
'1000498275',
'1000498120',
'1000498674',
'1000498419',
'1000498231',
'1000498635',
'1000498229',
'1000498307',
'1000498361',
'1000498360',
'1000498423',
'1000498362',
'1000498418',
'1000498838',
'1000498675',
'1000498676',
'1000498681',
'1000498230',
'1000498411',
'1000498429',
'1000498412',
'1000537618',
'1000498416',
'1000540867',
'1000540885',
'1000540863',
'1000540861',
'1000498232',
'1000542120',
'1000498470',
'1000498836',
'1000498233',
'1000498139',
'1000498063',
'1000498276',
'1000498119',
'1000498677',
'1000498061',
'1000498678',
'1000498422',
'1000498277',
'1000498679',
'1000562794',
'1000498421',
'1000498060',
'1000498420',
'1000498228',
'1000498680',
'1000498274'



)

order by c.integration_id, agree_num, a.rev_num desc
) WHERE r = 1
--and real_status <> 'EXPIRED'
ORDER BY REV_NUM