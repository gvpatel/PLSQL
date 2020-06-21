SELECT b.name, b.x_legal_owner, b.x_ln_prod_identifier,  a.std_pri_unit,
a.promo_pri, a.eff_start_dt, a.eff_end_dt, e.min_qty,  e.discnt_amt ,
'AU_STORE'
FROM SIEBEL.s_pri_lst_item a,
siebel.s_prod_int b, siebel.s_pri_lst c,
SIEBEL.S_VDISCNT_ITEM e
where a.prod_id = b.row_id
and c.row_id = a.pri_lst_id
and a.VOL_DISCNT_ID = e.VOL_DISCNT_ID(+)
and x_ln_product_segment = 'Media'
and orderable_flg = 'Y'
and (  (a.eff_end_dt IS NULL OR a.eff_end_dt  >= sysdate) and a.eff_start_dt <= sysdate)
and b.name = 'Legal Writing VU custom publication 9004926'
and c.name = 'NL AU Subscription'
UNION

SELECT b.name, b.x_legal_owner, b.x_ln_prod_identifier,  a.std_pri_unit,
a.promo_pri, a.eff_start_dt, a.eff_end_dt, e.min_qty,  e.discnt_amt 
FROM SIEBEL.s_pri_lst_item a,
siebel.s_prod_int b, siebel.s_pri_lst c,
SIEBEL.S_VDISCNT_ITEM e
where a.prod_id = b.row_id
and c.row_id = a.pri_lst_id
and a.VOL_DISCNT_ID = e.VOL_DISCNT_ID(+)
and x_ln_product_segment = 'Media'
and orderable_flg = 'Y'
and (  (a.eff_end_dt IS NULL OR a.eff_end_dt  >= sysdate) and a.eff_start_dt <= sysdate)
and b.name = 'Legal Writing VU custom publication 9004926'
and c.name = 'NL NZ Subscription'




--Quote iD - 1-26MJI25

select * From siebel.s_pri_lst_item

select * from siebel.s_volumne_disc

select * From all_tables where owner = 'SIEBEL'
and table_name like '%ITEM%'

SELECT * FROM SIEBEL.S_VOL_DISCNT, SIEBEL.S_VDISCNT_ITEM B

select * from SIEBEL.S_VDISCNT_ITEM B

