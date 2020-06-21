SELECT * FROM TEMP_CANADA

SELECT DISTINCT OC_PGUID FROM TEMP_CANADA where OC_IsCanadaPMCsOnly = 'Y'
SELECT * FROM TEMP_CANADA where to_number(NbrBridgedAgrmts) < 1 and to_number(NbrSLAgrmts) < 1

SELECT distinct OC_PGUID, SUB_ACCT_ID, actv_ind FROM TEMP_CANADA where to_number(NbrBridgedAgrmts) < 1 and to_number(NbrSLAgrmts) < 1
and actv_ind = 'Y'

-- All Orders with sub type Bridged

SELECT DISTINCT b.sa_pmc, b.OC_IsCanadaPMCsOnly,b.NbrBridgedAgrmts TOTAL_BRIDGED_AGREEMENT,b.NbrSLAgrmts TOTAL_SLA,
a.order_num,c.agree_num, c.agree_cd, a.X_ORDER_SUB_TYPE,a.X_LN_BILL_GROUP_ID, a.AGREE_ID, 
d.name, d.integration_id, d.cust_stat_cd
, b.Affil_OC_PGUID, b.MastBgrp_OC_PGUID
from siebel.s_order a,
TEMP_CANADA b,  siebel.s_doc_agree c, siebel.s_org_ext d
WHERE a.X_ORDER_SUB_TYPE  = 'Bridged'
and a.status_cd = 'Complete'
and a.X_LN_BILL_GROUP_ID = b.sub_acct_id
and a.AGREE_ID = c.row_id
and b.sa_pmc in ('19','46','75','84') 
--and b.OC_IsCanadaPMCsOnly = 'Y'
and c.target_ou_id = d.row_id
order by a.X_LN_BILL_GROUP_ID


-- All Bridged orders and agreements

select * From (
select DISTINCT a.order_num,c.agree_num,c.last_upd
, DENSE_RANK() OVER (PARTITION BY c.agree_num order by c.agree_num, c.last_upd desc) r
,c.rev_num, c.stat_cd, c.agree_cd, a.X_ORDER_SUB_TYPE,a.X_LN_BILL_GROUP_ID, a.AGREE_ID, 
d.name, d.integration_id, d.cust_stat_cd
from siebel.s_order a,
TEMP_CANADA b,  siebel.s_doc_agree c, siebel.s_org_ext d
WHERE  a.status_cd = 'Complete'
and a.X_LN_BILL_GROUP_ID = b.sub_acct_id
and a.AGREE_ID = c.row_id
and b.sa_pmc in ('19','46','75','84')
and c.target_ou_id = d.row_id
order by c.agree_num,  c.last_upd  desc )

where r = 1






select * From siebel.s_doc_agree

select DISTINCT a.X_ORDER_SUB_TYPE,a.X_LN_BILL_GROUP_ID, a.status_cd, agree_id from siebel.s_order a,
(select distinct sub_acct_id from TEMP_CANADA) b 
WHERE a.X_ORDER_SUB_TYPE  = 'Bridged'
and a.X_LN_BILL_GROUP_ID = b.sub_acct_id
and status_cd = 'Complete'
order by 2

select  sub_acct_id from TEMP_CANADA where sub_acct_id = '103946'

select * from siebel.s_order

select * from siebel.s_doc_agree

update TEMP_CANADA set sa_pmc = trim(sa_pmc)

select order_num, X_ORDER_SUB_TYPE,X_LN_BILL_GROUP_ID from siebel.s_order a
where X_ORDER_SUB_TYPE  in ('Modify Bridged','Bridged')




select lsa.legacy_subacc_name, lsa.source_id, lsa.legacy_subacc_id,lsa.country,lsa.legacy_primary_mkt_code,
lsa.legacy_master_acct, lsa.legacy_affiliate_id,
-- legacy users
lu.first_name,lu.last_name, lu.email_addr, lu.source_id user_source,
--OC/AP
oc.org_cust_pguid oc_pguid, ap.aff_per_pguid ap_guid

from cmx_ors.c_legacy_user@psgcm_link.isprod.lexisnexis.com lu,
 cmx_ors.c_affiliated_person@psgcm_link.isprod.lexisnexis.com ap,
 cmx_ors.c_org_customer@psgcm_link.isprod.lexisnexis.com oc,
 cmx_ors.c_legacy_subacc@psgcm_link.isprod.lexisnexis.com lsa,
 cmx_ors.c_legacy_user_subacc@psgcm_link.isprod.lexisnexis.com lus
 where ap.rowid_object = lu.rowid_aff_per
 and ap.rowid_org_cust = oc.rowid_object
 and lsa.rowid_org_cust = oc.rowid_object
 and lus.rowid_legacy_subacc = lsa.rowid_object
 and lus.rowid_legacy_user = lu.rowid_object
and oc.org_cust_pguid = 'urn:ecm:100017K1B'
-- and lsa.legacy_subacc_id = '103946'
 and lu.source_id = 'ICUST'
 and lus.end_Date is null and lus.hub_state_ind=1
 
 
 
