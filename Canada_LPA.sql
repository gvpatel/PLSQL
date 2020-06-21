select b.name, c.name, c.row_id, a.status_cd From siebel.s_asset a, siebel.s_prod_int b,
siebel.s_org_Ext c, siebel.s_bu d
where a.owner_accnt_id = c.row_id
and a.prod_id = b.row_id
and c.bu_id = d.row_id
and b.name like '%Practice%Advisor%Canada%'

select bu_id from siebel.s_org_Ext where row_id = '1-J48CHV'