SELECT a.name,a.curcy_cd CURRENCY, b.name PRICING_SEGMENT FROM SIEBEL.S_PRI_LST a, SIEBEL.CX_LN_PRC_SGMNt b
WHERE X_SELL_TYPE = 'Transaction' AND X_SYSTEM_ACCESS != 'Y'
and a.row_id = b.par_row_id
ORDER BY 1


SELECT DISTINCT a.curcy_cd, b.name FROM SIEBEL.S_PRI_LST a, SIEBEL.CX_LN_PRC_SGMNt b
WHERE X_SELL_TYPE = 'Transaction' AND X_SYSTEM_ACCESS != 'Y'
and a.row_id = b.par_row_id
ORDER BY 2

SELECT DISTINCT  b.name FROM SIEBEL.S_PRI_LST a, SIEBEL.CX_LN_PRC_SGMNt b
WHERE X_SELL_TYPE = 'Transaction' AND X_SYSTEM_ACCESS != 'Y'
and a.row_id = b.par_row_id
ORDER BY 1

select * from siebel.CX_LN_PRC_SGMNT where par_row_id in ('1-H4EZ-1','1-H4F5-1') 

SELECT distinct d.name, a.curcy_cd , b.type,  b.name PRICING_SEGMENT FROM SIEBEL.S_PRI_LST a,
SIEBEL.CX_LN_PRC_SGMNt b,
siebel.s_pri_lst_item c, siebel.s_prod_int d
WHERE a.X_SELL_TYPE = 'Subscription' 
and a.row_id = b.par_row_id
and a.row_id = c.pri_lst_id
and c.prod_id = d.row_id
and d.x_pkg_lvl = 'Component'
--and d.integration_id = 'urn:product:9005360'
ORDER BY 1



SELECT distinct a.name, d.name, a.curcy_cd, d.x_pkg_lvl  FROM SIEBEL.S_PRI_LST a,
SIEBEL.CX_LN_PRC_SGMNt b,
siebel.s_pri_lst_item c, siebel.s_prod_int d
WHERE a.X_SELL_TYPE = 'Subscription' 
and a.row_id = b.par_row_id
and a.row_id = c.pri_lst_id
and c.prod_id = d.row_id
and d.x_pkg_lvl = 'Component'
--and d.integration_id = 'urn:product:9005360'
ORDER BY 1



