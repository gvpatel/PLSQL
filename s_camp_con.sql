select a.con_per_id, c.integration_id, a.con_pr_dept_ou_id, b.integration_id, a.postn_id, a.x_merge_field01, 
--INSTR ('+1' , x_merge_field01) AS POS,
--translate(a.x_merge_field01, '1234567890+/ -()EXTxt', '1234567890') TRANS,
d.ph_num OC_PRIMARY_PHONE,
c.work_ph_num AP_PHONE,b.x_customer_subclass OC_SUBCLASS,
a.x_merge_field02, c.email_addr AP_EMAIL,
a.x_merge_field03,c.JOB_TITLE, c.X_DEPT_CD, a.x_merge_field04, a.x_merge_field05
from SIEBEL.s_camp_con a ,siebel.s_org_ext b, siebel.s_contact c,
siebel.s_con_addr d
where
a.con_pr_dept_ou_id = b.row_id
and a.con_per_id = c.row_id
and b.pr_addr_id = d.addr_per_id 
and b.row_id = d.accnt_id
and a.created > sysdate - 30




select * from siebel.s_camp_con where  con_pr_dept_ou_id
IS NULL and created > sysdate - 365


select * from siebel.s_con_addr
--584262

select * from siebel.s_con_addr


select * from siebel.s_con_addr


select * from SIEBEL.s_camp_con

select count(*) from SIEBEL.S_ORG_EXT where ROW_ID  NOT IN (SELECT con_pr_dept_ou_id FROM SIEBEL.s_camp_con
WHERE created > sysdate - 200)

SELECT COUNT(*) FROM SIEBEL.S_CAMP_CON WHERE 
con_pr_dept_ou_id NOT IN ( SELECT ROW_ID FROM SIEBEL.S_ORG_EXT)

--582769