select * from siebel.s_con_addr where accnt_id = '1-1W3FAP4'



update siebel.s_con_addr set addr_per_id = '1-102LISV_1' where row_id = '1-1WAVHD3'

update siebel.s_con_addr set ph_num = '1234567890' where accnt_id = '1-CD1S2F'

select name, ship_addr_id, x_con_addr_id, a.* From siebel.s_doc_quote a where row_id = '1-CD39PM'

----------------------------------------------------------------------------

select count(*), addr_per_id, accnt_id from siebel.s_con_addr 
where relation_type_cd in ('Place Of Business', 'Shipping Address')
and created > sysdate - 25
group by addr_per_id, accnt_id
having count(*) > 1

select row_id,loc, name, accnt_type_cd , cust_stat_cd From siebel.s_org_Ext where row_id = '1-1VOFEO0'


select * From siebel.s_addr_per

select * From siebel.s_con_addr WHERE ACCNT_ID IN ('1-1W3F6D2','1-1W53B5R')



SELECT  distinct a.row_id,b.loc, b.name, b.accnt_type_cd , b.cust_stat_cd, relation_type_cd,c.addr,c.city,c.province,
c.country, c.integration_id, c.row_id
FROM SIEBEL.S_CON_ADDR a, siebel.s_org_ext b, siebel.s_addr_per c WHERE
a.accnt_id = b.row_id and 
a.addr_per_id = c.row_id and 
cust_stat_cd <> 'Delete' and
ACCNT_ID IN ('1-1VN1WS1',
'1-1VOFEO0',
'1-1VOFH3T',
'1-1VY4DC3',
'1-1VY4DOB',
'1-1VYE9Z0',
'1-1W3F6D2',
'1-1W53B5R',
'1-1W5FI5B',
'1-1WB5UXG',
'1-1WB9W65',
'1-1WBAHWW',
'1-1WDGZIP',
'1-1XQACL1',
'1-1XX465K')
order by name



SELECT ROW_ID, ADDR_PER_ID, ACCNT_ID, X_INTEGRATION_ID, RELATION_TYPE_CD FROM SIEBEL.S_CON_ADDR WHERE ROW_ID IN (
'1-1W5FIGI',
'1-1WB5VBZ',
'1-1XX60WD',
'1-1WB9WLD',
'1-1W8240A',
'1-1VYESPF',
'1-1W5008Z',
'1-1W54WSL',
'1-1WDU82M',
'1-1VRFSNN',
'1-1XX7TBM',
'1-1WBAI9V',
'1-1VYC7P6')

/*
UPDATE SIEBEL.S_CON_ADDR SET ADDR_PER_ID = ADDR_PER_ID||'_1' WHERE ROW_ID IN (
'1-1W5FIGI',
'1-1WB5VBZ',
'1-1XX60WD',
'1-1WB9WLD',
'1-1W8240A',
'1-1VYESPF',
'1-1W5008Z',
'1-1W54WSL',
'1-1WDU82M',
'1-1VRFSNN',
'1-1XX7TBM',
'1-1WBAI9V',
'1-1VYC7P6')
*/
