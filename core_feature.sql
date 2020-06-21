SELECT d.name, c.AGREE_NUM, d.X_GO_TO_MARKET_TYPE, d.X_PRODUCT_CLASS, c.X_ORDER_SUB_TYPE,
e.X_CUST_CLASS, e.X_CUSTOMER_SUBCLASS
FROM 
SIEBEL.S_ASSET A, siebel.s_doc_agree c, siebel.s_prod_int d,
siebel.s_org_Ext e
WHERE a.cur_agree_id = c.row_id
and a.prod_id = d.row_id
and c.target_ou_id = e.row_id
and c.AGREE_CD = 'Service Level Agreement'
and c.STAT_CD = 'Active'
AND c.AGREE_NUM in (
SELECT DISTINCT  c.AGREE_NUM
FROM 
SIEBEL.S_ASSET A, siebel.s_doc_agree c, siebel.s_prod_int d
WHERE a.cur_agree_id = c.row_id
and a.prod_id = d.row_id
and c.AGREE_CD = 'Service Level Agreement'
and c.STAT_CD = 'Active'
and (d.X_GO_TO_MARKET_TYPE <> 'Core Feature' OR d.X_GO_TO_MARKET_TYPE is null)
MINUS
SELECT DISTINCT  c.AGREE_NUM
FROM 
SIEBEL.S_ASSET A, siebel.s_doc_agree c, siebel.s_prod_int d
WHERE a.cur_agree_id = c.row_id
and a.prod_id = d.row_id
and c.AGREE_CD = 'Service Level Agreement'
and c.STAT_CD = 'Active'
and d.X_GO_TO_MARKET_TYPE = 'Core Feature'
)
ORDER BY  AGREE_NUM




SELECT d.name, c.AGREE_NUM, d.X_GO_TO_MARKET_TYPE, d.X_PRODUCT_CLASS
FROM 
SIEBEL.S_ASSET A, siebel.s_doc_agree c, siebel.s_prod_int d
WHERE a.cur_agree_id = c.row_id
and a.prod_id = d.row_id
and c.AGREE_CD = 'Service Level Agreement'
and c.STAT_CD = 'Active'

select * from siebel.s_doc_agree


SELECT d.name, c.AGREE_NUM, d.X_GO_TO_MARKET_TYPE, d.X_PRODUCT_CLASS
FROM 
SIEBEL.S_ASSET A, siebel.s_doc_agree c, siebel.s_prod_int d
WHERE a.cur_agree_id = c.row_id
and a.prod_id = d.row_id
and c.AGREE_CD = 'Service Level Agreement'
and c.STAT_CD = 'Active'


SELECT d.row_id, d.name, c.AGREE_NUM, d.X_GO_TO_MARKET_TYPE, d.X_PRODUCT_CLASS
,
(select count(*) from 
SIEBEL.S_ASSET x, siebel.s_doc_agree y, siebel.s_prod_int z
WHERE x.cur_agree_id = y.row_id
and x.prod_id = z.row_id
and y.AGREE_CD = 'Service Level Agreement'
and y.STAT_CD = 'Active'
and z.X_GO_TO_MARKET_TYPE = 'Core Feature'
and y.row_id = c.row_id) core_feature
,
(select count(*) from 
SIEBEL.S_ASSET x, siebel.s_doc_agree y, siebel.s_prod_int z
WHERE x.cur_agree_id = y.row_id
and x.prod_id = z.row_id
and y.AGREE_CD = 'Service Level Agreement'
and y.STAT_CD = 'Active'
and z.X_GO_TO_MARKET_TYPE = 'Core Content'
and y.row_id = c.row_id) core_content
,
(select count(*) from 
SIEBEL.S_ASSET x, siebel.s_doc_agree y, siebel.s_prod_int z
WHERE x.cur_agree_id = y.row_id
and x.prod_id = z.row_id
and y.AGREE_CD = 'Service Level Agreement'
and y.STAT_CD = 'Active'
and z.X_GO_TO_MARKET_TYPE = 'Add On Feature'
and y.row_id = c.row_id) Add_on

FROM 
SIEBEL.S_ASSET A, siebel.s_doc_agree c, siebel.s_prod_int d
WHERE a.cur_agree_id = c.row_id
and a.prod_id = d.row_id
and c.AGREE_CD = 'Service Level Agreement'
and c.STAT_CD = 'Active'
--and agree_num in ('1000267010','1000267108')





SELECT * FROM 
(


SELECT d.row_id, d.name, c.AGREE_NUM, d.X_GO_TO_MARKET_TYPE, d.X_PRODUCT_CLASS
,
(select count(*) from 
SIEBEL.S_ASSET x, siebel.s_doc_agree y, siebel.s_prod_int z
WHERE x.cur_agree_id = y.row_id
and x.prod_id = z.row_id
and y.AGREE_CD = 'Service Level Agreement'
and y.STAT_CD = 'Active'
and z.X_GO_TO_MARKET_TYPE = 'Core Feature'
and y.row_id = c.row_id) core_feature
,
(select count(*) from 
SIEBEL.S_ASSET x, siebel.s_doc_agree y, siebel.s_prod_int z
WHERE x.cur_agree_id = y.row_id
and x.prod_id = z.row_id
and y.AGREE_CD = 'Service Level Agreement'
and y.STAT_CD = 'Active'
and z.X_GO_TO_MARKET_TYPE = 'Core Content'
and y.row_id = c.row_id) core_content
,
(select count(*) from 
SIEBEL.S_ASSET x, siebel.s_doc_agree y, siebel.s_prod_int z
WHERE x.cur_agree_id = y.row_id
and x.prod_id = z.row_id
and y.AGREE_CD = 'Service Level Agreement'
and y.STAT_CD = 'Active'
and z.X_GO_TO_MARKET_TYPE = 'Add On Feature'
and y.row_id = c.row_id) Add_on

FROM 
SIEBEL.S_ASSET A, siebel.s_doc_agree c, siebel.s_prod_int d
WHERE a.cur_agree_id = c.row_id
and a.prod_id = d.row_id
and c.AGREE_CD = 'Service Level Agreement'
and c.STAT_CD = 'Active'
--and agree_num in ('1000267010','1000267108')
) WHERE CORE_FEATURE = 0



select * from siebel.s_doc_Agree

select name, X_GO_TO_MARKET_TYPE, X_PRODUCT_CLASS From siebel.s_prod_int where integration_id = 'urn:product:1200027'