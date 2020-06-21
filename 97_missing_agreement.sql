SELECT NAME, integration_id, ORG_NAME, agree_num, rev_num,TERM_TYPE, GCRM_STATUS, REAL_STATUS,
MEDIA,X_CUST_CLASS,X_CUSTOMER_SUBCLASS,
EFF_START_DT, EFF_END_DT, X_MONTLY_NET_PRICE,

CASE WHEN rev_num < 2 then 'REOPEN_RESUMBIT_ORDER' ELSE 'MANUAL_FIX' END AS RECOMMENDATION
FROM (
SELECT c.name, c.integration_id , a.row_id, a.agree_num, a.stat_cd as GCRM_STATUS, a.rev_num , a.X_TERM_TYPE TERM_TYPE, bu.name as ORG_NAME
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
siebel.s_org_Ext c, siebel.s_bu bu
where a.TARGET_OU_ID = c.row_id
and c.bu_id = bu.row_id
and bu.name IN( 'Australia', 'New Zealand')
and a.stat_cd = 'Active'

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

and a.agree_num in (
'1000246076',
'1000246270',
'1000249535',
'1000250122',
'1000263593',
'1000264443',
'1000264444',
'1000271004',
'1000272226',
'1000272937',
'1000280231',
'1000280679',
'1000282820',
'1000283273',
'1000290858',
'1000293066',
'1000295968',
'1000312009',
'1000312058',
'1000314402',
'1000314714',
'1000314717',
'1000319604',
'1000321302',
'1000321507',
'1000321710',
'1000322336',
'1000325258',
'1000325485',
'1000332690',
'1000335180',
'1000335818',
'1000340876',
'1000341838',
'1000342633',
'1000343119',
'1000345743',
'1000345778',
'1000345781',
'1000346038',
'1000346044',
'1000346089',
'1000346091',
'1000346122',
'1000346123',
'1000346125',
'1000346141',
'1000346142',
'1000346143',
'1000346145',
'1000346147',
'1000346148',
'1000346149',
'1000346150',
'1000346152',
'1000346163',
'1000346213',
'1000346215',
'1000346499',
'1000346501',
'1000346505',
'1000346508',
'1000346511',
'1000346633',
'1000346663',
'1000346667',
'1000346668',
'1000346669',
'1000346671',
'1000346713',
'1000346714',
'1000346728',
'1000346733',
'1000347119',
'1000347122',
'1000347127',
'1000347189',
'1000347200',
'1000347203',
'1000347221',
'1000349415',
'1000349416',
'1000349417',
'1000349678',
'1000371405',
'1000376092',
'1000414468',
'1000415422',
'1000352513',
'1000498060',
'1000498173',
'1000498228',
'1000498277',
'1000498420',
'1000498421',
'1000498679',
'1000498680'

)
*/

--order by c.integration_id, agree_num, a.rev_num desc
) WHERE r = 1
--and real_status <> 'EXPIRED'
--ORDER BY 13, 12