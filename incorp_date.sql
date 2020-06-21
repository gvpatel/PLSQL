select * From DBA_DB_LINKS

/*
select a.org_cust_pguid, a.date_formed, b.name from cmx_ors.c_org_customer@drgcm_link.isprod.lexisnexis.com a, siebel.s_org_Ext b
where DATE_FORMED IS NOT NULL
and a.ORG_CUST_PGUID = b.integration_id 
*/

select * from   cmx_ors.c_org_customer@INTGCM_LINK.ISCERT.LEXISNEXIS.COM
where ORG_CUST_PGUID = 'urn:ecm:I14252R3X6P'



CREATE TABLE TEMP_ECM_INCORP
AS 
select org_cust_pguid, date_formed  from cmx_ors.c_org_customer@drgcm_link.isprod.lexisnexis.com
WHERE date_formed IS NOT NULL

SELECT * FROM TEMP_ECM_INCORP

ALTER TABLE TEMP_ECM_INCORP ADD CONSTRAINT PK_OCGUID PRIMARY KEY (org_cust_pguid);


update (
select a.org_cust_pguid, a.date_formed ECM_DATE, B.INTEGRATION_ID, 
b.name,b.X_INCORPORATION_DATE GCRM_DATE 
from TEMP_ECM_INCORP a, siebel.s_org_Ext b
where --DATE_FORMED IS NOT NULL and 
a.ORG_CUST_PGUID = b.integration_id
--and a.org_cust_pguid in ('urn:ecm:10000000C', 'urn:ecm:10000000G')
)
set GCRM_DATE = ECM_DATE

 