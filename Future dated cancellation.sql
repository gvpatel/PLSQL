select * From siebel.s_doc_agree
select agree_num, rev_num,X_CANCEL_DATE,X_CANCEL_END_FLG  From siebel.s_doc_agree where 
X_CANCEL_DATE IS NOT NULL AND 
agree_num in (
'5000000004793',
'1000266416',
'5000000003339',
'1000417196',
'1000322378',
'1000280005',
'1000439627',
'1000439473',
'1000287639',
'1000442287',
'1000442229',
'1000440462',
'1000440165',
'1000439964',
'1000439945',
'1000439771',
'1000439740',
'1000439541',
'1000439288',
'1000441875',
'1000440865',
'1000440489',
'1000439443',
'1000299908',
'1000443519',
'1000440368',
'1000440367')

select B.NAME, agree_num,STAT_CD, rev_num,X_CANCEL_DATE,X_CANCEL_END_FLG  From siebel.s_doc_agree A, SIEBEL.S_BU B where 
A.BU_ID = B.ROW_ID AND
X_CANCEL_DATE < SYSDATE
AND STAT_CD = 'Active'
AND B.NAME IN ('Australia', 'New Zealand')

select * From siebel.s_order  EAI_ERROR_TEXT

select B.NAME, a.agree_num, a.STAT_CD, a.rev_num, a.X_CANCEL_DATE, a.X_CANCEL_END_FLG,

(select distinct order_num  from siebel.s_order p, siebel.s_order_item q
where p.row_id = q.order_id and p.agree_id = a.row_id and
p.STATUS_CD = 'Pending' and  p.X_ORDER_SUB_TYPE = 'Cancel' ) order_num,

(SELECT COUNT(*) FROM SIEBEL.S_ASSET WHERE CUR_AGREE_ID = A.ROW_ID ) agree_line ,

(select count(*)  from siebel.s_order p, siebel.s_order_item q
where p.row_id = q.order_id and p.agree_id = a.row_id and
p.STATUS_CD = 'Pending' and  p.X_ORDER_SUB_TYPE = 'Cancel' ) order_lines,

(select distinct EAI_ERROR_TEXT  from siebel.s_order p, siebel.s_order_item q
where p.row_id = q.order_id and p.agree_id = a.row_id and
p.STATUS_CD = 'Pending' and  p.X_ORDER_SUB_TYPE = 'Cancel' ) error_msg

From siebel.s_doc_agree A,
SIEBEL.S_BU B
where 
A.BU_ID = B.ROW_ID AND
X_CANCEL_DATE < SYSDATE
AND STAT_CD = 'Active'
AND B.NAME IN ('Australia', 'New Zealand')