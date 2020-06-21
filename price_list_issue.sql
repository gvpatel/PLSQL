select a.name, from siebel.s_prod_int a, siebel.s_pri_lst b, siebel.s_pri_lst
where a.row_id = b.row_id
and a.integration_id = 'urn:product:1010385'


select c.name, b.name, a.eff_start_dt,a.eff_end_dt, a.std_pri_unit from 
siebel.s_pri_lst_item a,
siebel.s_pri_lst b,
siebel.s_prod_int c
where a.pri_lst_id = b.row_id
and a.prod_id = c.row_id
and c.integration_id = 'urn:product:1010385'