
SELECT * FROM SIEBEL.S_WFA_INSTP_LOG

SELECT * FROM siebel.S_WFA_INST_LOG WHERE ROW_ID = '1-2O6MRS7'

select EXEC_INST_VAL from siebel.S_WFA_INST_LOG 
where row_id in( 
select distinct INST_LOG_ID from siebel.S_WFA_INSTP_LOG where row_id in(
select step_log_id from siebel.S_WFA_STPRP_LOG where NAME ='Error Message'))


select A.CREATED, b.row_id,a.NAME,b.STATUS_CD,a.busobj_name,b.EXEC_INST_VAL, d.*
from siebel.S_WFA_DEFN_LOG a,siebel.S_WFA_INST_LOG b,
siebel.S_WFA_INSTP_LOG C,  siebel.S_WFA_STPRP_LOG d
where b.definition_id = a.row_id
and a.deploy_status_cd = 'ACTIVE'
and b.row_id = c.INST_LOG_ID
and c.row_id = d.step_log_id
and a.Name = 'LN Inbound CreateUpdate Account Attributes'
--AND  b.row_id = '1-2O6MRS9'
and  d.name = 'Error Message' AND D.PROP_VAL <> 'SUCCESS'
AND A.CREATED > SYSDATE - 2 