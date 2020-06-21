select b.created, b.agree_num, d.integration_id, b.stat_cd, b.x_term_type
, d.x_cust_class, d.x_customer_subclass, b.agree_cd
from siebel.s_asset a, siebel.s_doc_agree b, siebel.s_prod_int c,
siebel.s_org_ext d
where a.cur_agree_id = b.row_id
and a.prod_id = c.row_id
and b.target_ou_id = d.row_id 
and c.integration_id = 'urn:product:1000901'
and stat_cd = 'Active'
order by b.created desc
