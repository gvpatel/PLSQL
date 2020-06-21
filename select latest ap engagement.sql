( select /*+ parallel(auto) */  contact.INTEGRATION_ID as AFF_PER_ID
, contact.ROW_ID as SRC_PK
, ROW_NUMBER() OVER( partition by contact.INTEGRATION_ID ORDER BY OptyCon.last_upd DESC) r
,contact.PER_TITLE as PREFIX
,contact.fst_name as FIRST_NAME
,contact.MID_NAME as MIDDLE_NAME
,contact.last_name as LAST_NAME
,replace(replace(contact.work_ph_num, chr(10),' '), chr(13),' ') as WORK_PHONE
,replace(replace(contact.cell_ph_num, chr(10),' '), chr(13),' ') as MOBILE_PHONE
,contact.email_addr as EMAIL
,address1.addr as ADDRESS_LINE1
,address1.addr_line_2 as ADDRESS_LINE2
,address1.city as CITY
,address1.state as STATE
,address1.zipcode as POSTAL_CODE
,address1.country as COUNTRY
,TO_CHAR(OptyCon.last_upd, 'YYYY-MM-DD') as ENGAGEMENT_DATE, 
'Opportunity' as ENGAGEMENT_TYPE,
case customer.CUST_STAT_CD
WHEN 'Active' THEN 'Y' ELSE 'N' END
as CUSTOMER_FLAG,
'GCRM' as SOURCE,
TO_CHAR(SYSDATE, 'YYYY-MM-DD')  as TRANS_DATE
from siebel.s_opty Opportunity,
siebel.S_OPTY_CON OptyCon,
siebel.S_CONTACT contact,
siebel.S_ADDR_PER address1,
siebel.S_ORG_EXT customer
where OptyCon.OPTY_ID = Opportunity.ROW_ID
and Optycon.PER_ID = contact.par_row_id 
and Opportunity.PR_DEPT_OU_ID = Customer.ROW_ID
and address1.ROW_ID =
(CASE  
    WHEN  contact.PR_OU_ADDR_ID is not null AND  contact.PR_OU_ADDR_ID <> 'No Match Row Id'
    THEN
     contact.PR_OU_ADDR_ID
    WHEN contact.PR_PER_ADDR_ID is not null AND  contact.PR_PER_ADDR_ID <> 'No Match Row Id'
    THEN
      contact.PR_PER_ADDR_ID
    ELSE
      CUSTOMER.PR_ADDR_ID
    END)
--and address1.ROW_ID(+) = contact.pr_ou_addr_id 
--and address2.ROW_ID(+) = contact.pr_con_addr_id
--and Opportunity.ROW_ID = '1-1881JQ'
and OptyCon.LAST_UPD >= sysdate-2555
)

UNION
--Activity
(select /*+ parallel(auto) */  contact.INTEGRATION_ID as AFF_PER_ID
,contact.ROW_ID as SRC_PK
,ROW_NUMBER() OVER( partition by contact.INTEGRATION_ID ORDER BY ActCon.last_upd DESC) r
,contact.PER_TITLE as PREFIX
,contact.fst_name as FIRST_NAME
,contact.MID_NAME as MIDDLE_NAME
,contact.last_name as LAST_NAME
,replace(replace(contact.work_ph_num, chr(10),' '), chr(13),' ') as WORK_PHONE
,replace(replace(contact.cell_ph_num, chr(10),' '), chr(13),' ') as MOBILE_PHONE
,contact.email_addr as EMAIL
,address1.addr as ADDRESS_LINE1
,address1.addr_line_2 as ADDRESS_LINE2
,address1.city as CITY
,address1.state as STATE
,address1.zipcode as POSTAL_CODE
,address1.country as COUNTRY
,TO_CHAR(ActCon.last_upd, 'YYYY-MM-DD') as ENGAGEMENT_DATE, 
'Activity' as ENGAGEMENT_TYPE,
case customer.CUST_STAT_CD
WHEN 'Active' THEN 'Y' ELSE 'N' END
as CUSTOMER_FLAG,
'GCRM' as SOURCE,
TO_CHAR(SYSDATE, 'YYYY-MM-DD')  as TRANS_DATE
from siebel.S_EVT_ACT activity,siebel.S_ACT_CONTACT ActCon,
siebel.S_CONTACT contact,siebel.S_ADDR_PER address1,siebel.S_ORG_EXT customer
where actcon.activity_id = activity.ROW_ID and actcon.CON_ID = contact.par_row_id 
and activity.TARGET_OU_ID = Customer.ROW_ID
and address1.ROW_ID =
(CASE  
    WHEN  contact.PR_OU_ADDR_ID is not null AND  contact.PR_OU_ADDR_ID <> 'No Match Row Id'
    THEN
     contact.PR_OU_ADDR_ID
    WHEN contact.PR_PER_ADDR_ID is not null AND  contact.PR_PER_ADDR_ID <> 'No Match Row Id'
    THEN
      contact.PR_PER_ADDR_ID
    ELSE
      CUSTOMER.PR_ADDR_ID
    END)
--and activity.ROW_ID = '1-18L106T'
and ActCon.LAST_UPD >= sysdate - 2555
)
--and ActCon.LAST_UPD >= sysdate-2555)
UNION
--Campaign
(select /*+ parallel(auto) */  contact.INTEGRATION_ID as AFF_PER_ID
,contact.ROW_ID as SRC_PK
,ROW_NUMBER() OVER( partition by contact.INTEGRATION_ID ORDER BY CampCon.LAST_UPD DESC) r
,contact.PER_TITLE as PREFIX
,contact.fst_name as FIRST_NAME
,contact.MID_NAME as MIDDLE_NAME
,contact.last_name as LAST_NAME
,replace(replace(contact.work_ph_num, chr(10),' '), chr(13),' ') as WORK_PHONE
,replace(replace(contact.cell_ph_num, chr(10),' '), chr(13),' ') as MOBILE_PHONE
,contact.email_addr as EMAIL
,address1.addr as ADDRESS_LINE1
,address1.addr_line_2 as ADDRESS_LINE2
,address1.city as CITY
,address1.state as STATE
,address1.zipcode as POSTAL_CODE
,address1.country as COUNTRY
,TO_CHAR(CampCon.last_upd, 'YYYY-MM-DD') as ENGAGEMENT_DATE, 
'Campaign' as ENGAGEMENT_TYPE,
case customer.CUST_STAT_CD
WHEN 'Active' THEN 'Y' ELSE 'N' END
as CUSTOMER_FLAG,
'GCRM' as SOURCE,
TO_CHAR(SYSDATE, 'YYYY-MM-DD')  as TRANS_DATE
from siebel.S_SRC camp, siebel.S_CAMP_CON CampCon,
siebel.S_CONTACT contact,siebel.S_ADDR_PER address1, siebel.S_ORG_EXT customer
where CampCon.SRC_ID = camp.ROW_ID
and CampCon.CON_PER_ID = contact.row_id 
and CampCon.CON_PR_DEPT_OU_ID = Customer.ROW_ID
and address1.ROW_ID =
(CASE  
    WHEN  contact.PR_OU_ADDR_ID is not null AND  contact.PR_OU_ADDR_ID <> 'No Match Row Id'
    THEN
     contact.PR_OU_ADDR_ID
    WHEN contact.PR_PER_ADDR_ID is not null AND  contact.PR_PER_ADDR_ID <> 'No Match Row Id'
    THEN
      contact.PR_PER_ADDR_ID
    ELSE
      CUSTOMER.PR_ADDR_ID
    END)
--and address1.ROW_ID(+) = contact.pr_ou_addr_id 
--and address2.ROW_ID(+) = contact.pr_con_addr_id
--and camp.ROW_ID = '1-B6J-2085')
and CampCon.LAST_UPD >= sysdate- 2555
)
UNION
--Response Contact
(select /*+ parallel(auto) */  contact.INTEGRATION_ID as AFF_PER_ID
,contact.ROW_ID as SRC_PK
,ROW_NUMBER() OVER( partition by contact.INTEGRATION_ID ORDER BY Resp.LAST_UPD DESC) r
,contact.PER_TITLE as PREFIX
,contact.fst_name as FIRST_NAME
,contact.MID_NAME as MIDDLE_NAME
,contact.last_name as LAST_NAME
,replace(replace(contact.work_ph_num, chr(10),' '), chr(13),' ') as WORK_PHONE
,replace(replace(contact.cell_ph_num, chr(10),' '), chr(13),' ') as MOBILE_PHONE
,contact.email_addr as EMAIL
,address1.addr as ADDRESS_LINE1
,address1.addr_line_2 as ADDRESS_LINE2
,address1.city as CITY
,address1.state as STATE
,address1.zipcode as POSTAL_CODE
,address1.country as COUNTRY
,TO_CHAR(Resp.last_upd, 'YYYY-MM-DD') as ENGAGEMENT_DATE, 
'Response' as ENGAGEMENT_TYPE,
case customer.CUST_STAT_CD
WHEN 'Active' THEN 'Y' ELSE 'N' END
as CUSTOMER_FLAG,
'GCRM' as SOURCE,
TO_CHAR(SYSDATE, 'YYYY-MM-DD')  as TRANS_DATE
from siebel.S_COMMUNICATION Resp,
siebel.S_CONTACT contact,siebel.S_ADDR_PER address1, siebel.S_ORG_EXT customer
where Resp.pr_con_id = contact.PAR_row_id 
and Resp.ACCNT_ID = Customer.ROW_ID
and address1.ROW_ID =
(CASE  
    WHEN  contact.PR_OU_ADDR_ID is not null AND  contact.PR_OU_ADDR_ID <> 'No Match Row Id'
    THEN
     contact.PR_OU_ADDR_ID
    WHEN contact.PR_PER_ADDR_ID is not null AND  contact.PR_PER_ADDR_ID <> 'No Match Row Id'
    THEN
      contact.PR_PER_ADDR_ID
    ELSE
      CUSTOMER.PR_ADDR_ID
    END)
and (Resp.pr_con_id IS NOT NULL
and Resp.pr_con_id <> 'No Match Row Id')
--and address1.ROW_ID(+) = contact.pr_ou_addr_id 
--and address2.ROW_ID(+) = contact.pr_con_addr_id
--and Resp.ROW_ID = '1-2TII-1559'
and Resp.LAST_UPD >= sysdate-2555
)
UNION
--Response Prospect
(select /*+ parallel(auto) */  null as AFF_PER_ID
,contact.ROW_ID as SRC_PK
,ROW_NUMBER() OVER( partition by contact.ROW_ID ORDER BY contact.LAST_UPD DESC) r
,contact.PER_TITLE as PREFIX
,contact.FST_NAME as FIRST_NAME
,contact.MID_NAME as MIDDLE_NAME
,contact.LAST_NAME as LAST_NAME
,contact.WORK_PH_NUM as WORK_PHONE
,contact.CELL_PH_NUM as MOBILE_PHONE
,contact.EMAIL_ADDR as EMAIL
,contact.addr as ADDRESS_LINE1
,contact.ADDR_LINE_2 as ADDRESS_LINE2
,contact.city as CITY
,contact.state as STATE
,contact.zipcode as POSTAL_CODE
,contact.country as COUNTRY
,TO_CHAR(Resp.last_upd, 'YYYY-MM-DD') as ENGAGEMENT_DATE, 
'Response' as ENGAGEMENT_TYPE,
'N' as CUSTOMER_FLAG,
'GCRM' as SOURCE,
TO_CHAR(SYSDATE, 'YYYY-MM-DD')  as TRANS_DATE
from siebel.S_COMMUNICATION Resp,
siebel.S_PRSP_CONTACT contact
where Resp.PRSP_CON_ID = contact.row_id 
and (Resp.prsp_con_id IS NOT NULL
and Resp.prsp_con_id <> 'No Match Row Id')
--and address1.ROW_ID(+) = contact.pr_ou_addr_id 
--and address2.ROW_ID(+) = contact.pr_con_addr_id
--and Resp.ROW_ID = '1-18CR36I')
and contact.LAST_UPD >= sysdate-2555)
UNION
--AP User PERMID
(select /*+ parallel(auto) */  contact.INTEGRATION_ID as AFF_PER_ID
,contact.ROW_ID as SRC_PK
,ROW_NUMBER() OVER( partition by contact.INTEGRATION_ID ORDER BY contact.LAST_UPD DESC) r
,contact.PER_TITLE as PREFIX
,contact.fst_name as FIRST_NAME
,contact.MID_NAME as MIDDLE_NAME
,contact.last_name as LAST_NAME
,replace(replace(contact.work_ph_num, chr(10),' '), chr(13),' ') as WORK_PHONE
,replace(replace(contact.cell_ph_num, chr(10),' '), chr(13),' ') as MOBILE_PHONE
,contact.email_addr as EMAIL
,address1.addr as ADDRESS_LINE1
,address1.addr_line_2 as ADDRESS_LINE2
,address1.city as CITY
,address1.state as STATE
,address1.zipcode as POSTAL_CODE
,address1.country as COUNTRY
,TO_CHAR(contact.last_upd, 'YYYY-MM-DD') as ENGAGEMENT_DATE, 
'AP-userPermID' as ENGAGEMENT_TYPE,
case customer.CUST_STAT_CD
WHEN 'Active' THEN 'Y' ELSE 'N' END
as CUSTOMER_FLAG,
'GCRM' as SOURCE,
TO_CHAR(SYSDATE, 'YYYY-MM-DD')  as TRANS_DATE
from
siebel.S_CONTACT contact,siebel.S_ADDR_PER address1, siebel.S_ORG_EXT customer
where contact.x_user_perm_id is not null
and contact.PR_DEPT_OU_ID = Customer.ROW_ID
and address1.ROW_ID =
(CASE  
    WHEN  contact.PR_OU_ADDR_ID is not null AND  contact.PR_OU_ADDR_ID <> 'No Match Row Id'
    THEN
     contact.PR_OU_ADDR_ID
    WHEN contact.PR_PER_ADDR_ID is not null AND  contact.PR_PER_ADDR_ID <> 'No Match Row Id'
    THEN
      contact.PR_PER_ADDR_ID
    ELSE
      CUSTOMER.PR_ADDR_ID
    END)
--and address1.ROW_ID(+) = contact.pr_ou_addr_id 
--and address2.ROW_ID(+) = contact.pr_con_addr_id
--and contact.ROW_ID = '1-NVK8CO')
and contact.LAST_UPD >= sysdate-2555)
UNION
--Lead
(select /*+ parallel(auto) */  contact.INTEGRATION_ID as AFF_PER_ID
,contact.ROW_ID as SRC_PK
,ROW_NUMBER() OVER( partition by contact.INTEGRATION_ID ORDER BY lead.LAST_UPD DESC) r
,contact.PER_TITLE as PREFIX
,contact.fst_name as FIRST_NAME
,contact.MID_NAME as MIDDLE_NAME
,contact.last_name as LAST_NAME
,replace(replace(contact.work_ph_num, chr(10),' '), chr(13),' ') as WORK_PHONE
,replace(replace(contact.cell_ph_num, chr(10),' '), chr(13),' ') as MOBILE_PHONE
,contact.email_addr as EMAIL
,address1.addr as ADDRESS_LINE1
,address1.addr_line_2 as ADDRESS_LINE2
,address1.city as CITY
,address1.state as STATE
,address1.zipcode as POSTAL_CODE
,address1.country as COUNTRY
,TO_CHAR(lead.last_upd, 'YYYY-MM-DD') as ENGAGEMENT_DATE, 
'Lead' as ENGAGEMENT_TYPE,
case customer.CUST_STAT_CD
WHEN 'Active' THEN 'Y' ELSE 'N' END
as CUSTOMER_FLAG,
'GCRM' as SOURCE,
TO_CHAR(SYSDATE, 'YYYY-MM-DD')  as TRANS_DATE
from siebel.S_LEAD lead, 
siebel.S_CONTACT contact,siebel.S_ADDR_PER address1, siebel.S_ORG_EXT customer
where lead.CONTACT_ID = contact.ROW_ID
and lead.ACCNT_ID = Customer.ROW_ID
and address1.ROW_ID =
(CASE  
    WHEN  contact.PR_OU_ADDR_ID is not null AND  contact.PR_OU_ADDR_ID <> 'No Match Row Id'
    THEN
     contact.PR_OU_ADDR_ID
    WHEN contact.PR_PER_ADDR_ID is not null AND  contact.PR_PER_ADDR_ID <> 'No Match Row Id'
    THEN
      contact.PR_PER_ADDR_ID
    ELSE
      CUSTOMER.PR_ADDR_ID
    END)
--and address1.ROW_ID(+) = contact.pr_ou_addr_id 
--and address2.ROW_ID(+) = contact.pr_con_addr_id
--and lead.ROW_ID = '1-18CRZU2')
and lead.LAST_UPD >= sysdate-2555)
--Quote
UNION
(select /*+ parallel(auto) */  contact.INTEGRATION_ID as AFF_PER_ID
,contact.ROW_ID as SRC_PK
,ROW_NUMBER() OVER( partition by contact.INTEGRATION_ID ORDER BY Quote.LAST_UPD DESC) r
,contact.PER_TITLE as PREFIX
,contact.fst_name as FIRST_NAME
,contact.MID_NAME as MIDDLE_NAME
,contact.last_name as LAST_NAME
,replace(replace(contact.work_ph_num, chr(10),' '), chr(13),' ') as WORK_PHONE
,replace(replace(contact.cell_ph_num, chr(10),' '), chr(13),' ') as MOBILE_PHONE
,contact.email_addr as EMAIL
,address1.addr as ADDRESS_LINE1
,address1.addr_line_2 as ADDRESS_LINE2
,address1.city as CITY
,address1.state as STATE
,address1.zipcode as POSTAL_CODE
,address1.country as COUNTRY
,TO_CHAR(Quote.last_upd, 'YYYY-MM-DD') as ENGAGEMENT_DATE, 
'Quote' as ENGAGEMENT_TYPE,
case customer.CUST_STAT_CD
WHEN 'Active' THEN 'Y' ELSE 'N' END
as CUSTOMER_FLAG,
'GCRM' as SOURCE,
TO_CHAR(SYSDATE, 'YYYY-MM-DD')  as TRANS_DATE
from siebel.S_DOC_QUOTE Quote,
siebel.S_CONTACT contact,siebel.S_ADDR_PER address1, siebel.S_ORG_EXT customer
where Quote.CON_PER_ID = contact.par_row_id
and Quote.TARGET_OU_ID = Customer.ROW_ID
and address1.ROW_ID =
(CASE  
    WHEN  contact.PR_OU_ADDR_ID is not null AND  contact.PR_OU_ADDR_ID <> 'No Match Row Id'
    THEN
     contact.PR_OU_ADDR_ID
    WHEN contact.PR_PER_ADDR_ID is not null AND  contact.PR_PER_ADDR_ID <> 'No Match Row Id'
    THEN
      contact.PR_PER_ADDR_ID
    ELSE
      CUSTOMER.PR_ADDR_ID
    END)
--and address1.ROW_ID(+) = contact.pr_ou_addr_id 
--and address2.ROW_ID(+) = contact.pr_con_addr_id
--and Quote.ROW_ID = '1-13CC14X')
and Quote.LAST_UPD >= sysdate-2555)
UNION
--Order
(select /*+ parallel(auto) */  contact.INTEGRATION_ID as AFF_PER_ID
,contact.ROW_ID as SRC_PK
,ROW_NUMBER() OVER( partition by contact.INTEGRATION_ID ORDER BY ord.LAST_UPD DESC) r
,contact.PER_TITLE as PREFIX
,contact.fst_name as FIRST_NAME
,contact.MID_NAME as MIDDLE_NAME
,contact.last_name as LAST_NAME
,replace(replace(contact.work_ph_num, chr(10),' '), chr(13),' ') as WORK_PHONE
,replace(replace(contact.cell_ph_num, chr(10),' '), chr(13),' ') as MOBILE_PHONE
,contact.email_addr as EMAIL
,address1.addr as ADDRESS_LINE1
,address1.addr_line_2 as ADDRESS_LINE2
,address1.city as CITY
,address1.state as STATE
,address1.zipcode as POSTAL_CODE
,address1.country as COUNTRY
,TO_CHAR(ord.last_upd, 'YYYY-MM-DD') as ENGAGEMENT_DATE, 
'Order' as ENGAGEMENT_TYPE,
case customer.CUST_STAT_CD
WHEN 'Active' THEN 'Y' ELSE 'N' END
as CUSTOMER_FLAG,
'GCRM' as SOURCE,
TO_CHAR(SYSDATE, 'YYYY-MM-DD')  as TRANS_DATE
from siebel.S_ORDER ord,
siebel.S_CONTACT contact,siebel.S_ADDR_PER address1, siebel.S_ORG_EXT customer
where ord.contact_id = contact.par_row_id
and ord.ACCNT_ID = Customer.ROW_ID
and address1.ROW_ID =
(CASE  
    WHEN  contact.PR_OU_ADDR_ID is not null AND  contact.PR_OU_ADDR_ID <> 'No Match Row Id'
    THEN
     contact.PR_OU_ADDR_ID
    WHEN contact.PR_PER_ADDR_ID is not null AND  contact.PR_PER_ADDR_ID <> 'No Match Row Id'
    THEN
      contact.PR_PER_ADDR_ID
    ELSE
      CUSTOMER.PR_ADDR_ID
    END)
--and address1.ROW_ID(+) = contact.pr_ou_addr_id 
--and address2.ROW_ID(+) = contact.pr_con_addr_id
--and ord.ROW_ID = '1-11NSHYT')
and ord.LAST_UPD >= sysdate-2555)
UNION 
--Agreement
(select /*+ parallel(auto) */  contact.INTEGRATION_ID as AFF_PER_ID
,contact.ROW_ID as SRC_PK
,ROW_NUMBER() OVER( partition by contact.INTEGRATION_ID ORDER BY agree.LAST_UPD DESC) r
,contact.PER_TITLE as PREFIX
,contact.fst_name as FIRST_NAME
,contact.MID_NAME as MIDDLE_NAME
,contact.last_name as LAST_NAME
,replace(replace(contact.work_ph_num, chr(10),' '), chr(13),' ') as WORK_PHONE
,replace(replace(contact.cell_ph_num, chr(10),' '), chr(13),' ') as MOBILE_PHONE
,contact.email_addr as EMAIL
,address1.addr as ADDRESS_LINE1
,address1.addr_line_2 as ADDRESS_LINE2
,address1.city as CITY
,address1.state as STATE
,address1.zipcode as POSTAL_CODE
,address1.country as COUNTRY
,TO_CHAR(agree.last_upd, 'YYYY-MM-DD') as ENGAGEMENT_DATE, 
'Agreement' as ENGAGEMENT_TYPE,
case customer.CUST_STAT_CD
WHEN 'Active' THEN 'Y' ELSE 'N' END
as CUSTOMER_FLAG,
'GCRM' as SOURCE,
TO_CHAR(SYSDATE, 'YYYY-MM-DD')  as TRANS_DATE
from siebel.S_DOC_AGREE agree,
siebel.S_CONTACT contact,siebel.S_ADDR_PER address1, siebel.S_ORG_EXT customer
where agree.CON_PER_ID = contact.par_row_id
and agree.TARGET_OU_ID = Customer.ROW_ID
and address1.ROW_ID =
(CASE  
    WHEN  contact.PR_OU_ADDR_ID is not null AND  contact.PR_OU_ADDR_ID <> 'No Match Row Id'
    THEN
     contact.PR_OU_ADDR_ID
    WHEN contact.PR_PER_ADDR_ID is not null AND  contact.PR_PER_ADDR_ID <> 'No Match Row Id'
    THEN
      contact.PR_PER_ADDR_ID
    ELSE
      CUSTOMER.PR_ADDR_ID
    END)
--and address1.ROW_ID(+) = contact.pr_ou_addr_id 
--and address2.ROW_ID(+) = contact.pr_con_addr_id
--and agree.ROW_ID = '1-17OCTCB')
and agree.LAST_UPD >= sysdate-2555)
