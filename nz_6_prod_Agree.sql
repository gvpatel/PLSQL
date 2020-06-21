select d.name CUSTOMER, d.integration_id OC_PGUID, a.name PRODUCT_NAME, a.integration_id PRODUCT_PGUID, c.qty, b.agree_num, b.rev_num, b.stat_cd agree_status, b.EFF_START_DT, b.EFF_END_DT , c.STATUS_CD Line_status,
c.asset_num as stable_key,  d.X_CUST_CLASS,d.X_CUSTOMER_SUBCLASS
--,c.*
from siebel.s_prod_int a, siebel.s_doc_agree b, siebel.s_asset c,
siebel.s_org_Ext d
where b.row_id = c.cur_agree_id
and c.prod_id = a.row_id 
and b.TARGET_OU_ID = d.row_id
and a.integration_id in (
'urn:product:9005414',
'urn:product:9006586',
'urn:product:9005407',
'urn:product:9005422',
'urn:product:9005413',
'urn:product:9005430')
ORDER BY d.integration_id,b.agree_num,b.EFF_START_DT, b.EFF_END_DT


--
SELECT count(*), a.order_num  FROM SIEBEL.S_ORDER A, SIEBEL.S_ORDER_ITEM B,
SIEBEL.S_PROD_INT C, siebel.s_doc_agree d
WHERE a.row_id = b.order_id
and b.prod_id = c.row_id
and a.agree_id = d.row_id
and d.agree_num = '1000498490'
group by a.order_num


SELECT C.NAME, b.asset_integ_id, b.QTY_REQ FROM SIEBEL.S_ORDER A, SIEBEL.S_ORDER_ITEM B,
SIEBEL.S_PROD_INT C, siebel.s_doc_agree d
WHERE a.row_id = b.order_id
and b.prod_id = c.row_id
and a.agree_id = d.row_id
and d.agree_num = '1000498490'
AND a.order_num = 'N06014_2020-07-01'

MINUS

SELECT  C.NAME, b.asset_integ_id,  b.QTY_REQ  FROM SIEBEL.S_ORDER A, SIEBEL.S_ORDER_ITEM B,
SIEBEL.S_PROD_INT C, siebel.s_doc_agree d
WHERE a.row_id = b.order_id
and b.prod_id = c.row_id
and a.agree_id = d.row_id
and d.agree_num = '1000498490'
AND a.order_num = '1-8192734042'


INTERSECT
SELECT C.NAME, b.asset_integ_id  FROM SIEBEL.S_ORDER A, SIEBEL.S_ORDER_ITEM B,
SIEBEL.S_PROD_INT C, siebel.s_doc_agree d
WHERE a.row_id = b.order_id
and b.prod_id = c.row_id
and a.agree_id = d.row_id
and d.agree_num = '1000498490'
AND a.order_num = '1-8090898337'


select count(*), X_ORDER_SUB_TYPE, agree_id from siebel.s_order 
where bu_id in ( '1-TN9AV', '1-TN9AP')
and X_ORDER_SUB_TYPE = 'New Purchase'
and agree_id IS NOT NULL
group by X_ORDER_SUB_TYPE, agree_id 
having count(*) > 1

SELECT A.CREATED, A.X_ORDER_SUB_TYPE,  ORDER_NUM, STATUS_CD, AGREE_NUM, STAT_CD FROM
SIEBEL.S_ORDER A, SIEBEL.S_DOC_AGREE B
WHERE A.AGREE_ID = B.ROW_ID
AND B.ROW_ID IN(
select agree_id from siebel.s_order 
where bu_id in ( '1-TN9AV', '1-TN9AP')
and X_ORDER_SUB_TYPE = 'New Purchase'
and agree_id IS NOT NULL
group by X_ORDER_SUB_TYPE, agree_id 
having count(*) > 1)
ORDER BY AGREE_NUM DESC, A.CREATED





select * from siebel.s_bu where name = 'USA'

select * from siebel.s_order

select row_id, created, order_num,X_ORDER_SUB_TYPE, STATUS_CD, agree_id From siebel.s_order where
 X_ORDER_SUB_TYPE = 'New Purchase'
and agree_id in (
'1-Y0KB4C',
'1-104NHU6',
'1-123C90X',
'1-12OCJ0O',
'1-165R1YW',
'1-16ZKZB2',
'1-14W1QUZ',
'1-2WCRYF2',
'1-2WCAVHS',
'1-2WCBVZM',
'1-2WDBDA8',
'1-2W64NH6',
'1-2WC71JZ',
'1-2WD1B53',
'1-2WCL6I0',
'1-2WCI4LY',
'1-2WCE9ZJ',
'1-2WCPCXI',
'1-2WCEKLJ',
'1-2WCJIA2',
'1-2WD2H7H',
'1-2WCNRQ8',
'1-2WF7L3X',
'1-2WDANN8',
'1-2WCUKT8',
'1-2WD0W4L',
'1-2WC6S74',
'1-3S3LTC8',
'1-11R9XQY',
'1-11TQ42U',
'1-132H98W',
'1-13K6BPH',
'1-14BI12T',
'1-14E12Y7',
'1-1526LHS',
'1-14AWIED',
'1-14VZCZD',
'1-2WAC64K',
'1-2WEZSWC',
'1-2WCDDRH',
'1-2WC4DON',
'1-2WCQAF9',
'1-2WCANF5',
'1-2WC914Q',
'1-2WCFFW3',
'1-2WCN6FF',
'1-2WCV25E',
'1-2WD3T2Y',
'1-2WD4XSJ',
'1-2WCL8KR',
'1-2WCH6UE',
'1-2WD1VZ3',
'1-2WF7X37',
'1-2WD0ALQ',
'1-2WD8XR8',
'1-2WC64O8',
'1-2WDGBSO',
'1-13KGCGE',
'1-13RDRMR',
'1-145L3T2',
'1-14DK5IH',
'1-14TBDH5',
'1-2WCECJH',
'1-2WC9OMU',
'1-2WC4VYZ',
'1-2WC7X8G',
'1-2WCD7JW',
'1-2WCLVPT',
'1-2WCEBPB',
'1-2WCK79I',
'1-2WCG68G',
'1-2WCQ4XK',
'1-2WCMAX7',
'1-2WD1A01',
'1-2WCUV5B',
'1-2WF803O',
'1-2WCMW4V',
'1-2WDBNPH',
'1-2WD8AJ3',
'1-2WCU6UK',
'1-2WD0B0I',
'1-2WCF51E',
'1-104MT00',
'1-11T3ARF',
'1-11TM5GS',
'1-13MY0AW',
'1-13RBKQN',
'1-15C6AHE',
'1-2WCWW87',
'1-2WCPS0W',
'1-2WDCBON',
'1-2WC71UR',
'1-2WCC98Q',
'1-2WCEZK9',
'1-2WCM5HD',
'1-2WDCWGG',
'1-2WD34CZ',
'1-2WCQ6KJ',
'1-10ZICG9',
'1-14DH9KT',
'1-1528QQ3',
'1-2226ZDH',
'1-2W6K86B',
'1-2WCL2MM',
'1-2WC5QWN',
'1-2WCFHQY',
'1-2WCKOYU',
'1-2WCG3TA',
'1-2WCGZIW',
'1-2WCF2AZ',
'1-2WDEN9C',
'1-2WD2RSM',
'1-2WD9SQ2',
'1-2WD09UF',
'1-2WD89KO',
'1-2WCLX2G',
'1-2WCXYKH',
'1-2WCJE9O',
'1-2WD2AZ6',
'1-WES3J3',
'1-10HK0PO',
'1-11Q0B78',
'1-12O2ZMS',
'1-145LJ1O',
'1-2WCMVRI',
'1-2WC725M',
'1-2WCDC3U',
'1-2WCAIGQ',
'1-2WC76I4',
'1-2WC3W4F',
'1-2WC3Y3J',
'1-2WC9F5L',
'1-2WCG9DD',
'1-2WCGBBI',
'1-2WCKCBU',
'1-2WCFO0L',
'1-2WCTMVQ',
'1-2WCUB4K',
'1-2WCMY3A',
'1-2WCIGIY',
'1-3LRXYUL',
'1-YC3LFY',
'1-12CJRVB',
'1-13U0ESQ',
'1-14567AW',
'1-15MYS8V',
'1-2WCBN61',
'1-2WC4ILZ',
'1-2WC9PCM',
'1-2WCGY3I',
'1-2WC8696',
'1-2WCE5VG',
'1-2WCI9GW',
'1-2WD6Y6X',
'1-2WBBAIM',
'1-2WC469U',
'1-2WC7SGF',
'1-2WC7ZN7',
'1-2WCHNB0',
'1-2WCJKTS',
'1-2WCXK4R',
'1-2WCIQZG',
'1-2WC8FHG',
'1-2WCCRBA',
'1-121YQDQ',
'1-131TDM9',
'1-13K0VL6',
'1-145V0LQ',
'1-2ZMV41C',
'1-2WCWP7T',
'1-2WD5E2O',
'1-2WD51AJ',
'1-2WC8P4I',
'1-2WCF7WN',
'1-2WDEBDM',
'1-2WCXIBH',
'1-2WCJ3SW')
order by agree_id, created desc
