SELECT * fROM CMX_ORS.C_ORG_CUSTOMER@PSGCM_LINK.ISPROD.LEXISNEXIS.COM 
WHERE ORG_CUST_PGUID = 'urn:ecm:J22KDS6VN'

select * from cmx_ors.c_legacy_subacc@PSGCM_LINK.ISPROD.LEXISNEXIS.COM
WHERE  ROWID_ORG_CUST = '14507848'      




select X_LN_DUMMY_FLAG, X_LN_USER_VALIDATED_FLG, addr, city,province, country, b.last_name, b.fst_name, A.* from siebel.s_addr_per A, siebel.s_contact b
WHERE  a.CREATED > SYSDATE - 360
and X_LN_DUMMY_FLAG = 'Y'
and a.created_by = b.row_id


select X_LN_DUMMY_FLAG, X_LN_USER_VALIDATED_FLG, addr, city,province, country, b.last_name, b.fst_name, A.* from siebel.s_addr_per A, siebel.s_contact b
WHERE  a.CREATED > SYSDATE - 360
and X_LN_USER_VALIDATED_FLG = 'Y'
and a.created_by = b.row_id




select *  FROM SIEBEL.S_ADDR_PER

SELECT * fROM CMX_ORS.C_ORG_CUSTOMER@PSGCM_LINK.ISPROD.LEXISNEXIS.COM 
WHERE ORG_CUST_PGUID = 'urn:ecm:10001JE4K'

SELECT * fROM CMX_ORS.C_AFFILIATED_PERSON@PSGCM_LINK.ISPROD.LEXISNEXIS.COM 


SELECT * fROM CMX_ORS.C_ADDRESS@PSGCM_LINK.ISPROD.LEXISNEXIS.COM 
WHERE ADDRESS_PGUID  in ( 'urn:ecm:422PN8Z5L', 'urn:ecm:425298725', 'urn:ecm:424ZQL8ZC')


SELECT * fROM CMX_ORS.C_POB@PSGCM_LINK.ISPROD.LEXISNEXIS.COM 
WHERE ADDRESS_PGUID  in ( 'urn:ecm:422PN8Z5L', 'urn:ecm:425298725', 'urn:ecm:424ZQL8ZC')


WHERE ROWID_ORG_CUST = '1586585'

SELECT ACCNT_ID FROM SIEBEL.S_CON_ADDR WHERE ADDR_PER_ID = '1-1UZ2RSZ'

select * from siebel.s_opty_postn

--CERT1 link
SELECT * fROM CMX_ORS.C_AFFILIATED_PERSON@INTGCM_LINK.ISCERT.LEXISNEXIS.COM 

SELECT * fROM CMX_ORS.C_ADDRESS@INTGCM_LINK.ISCERT.LEXISNEXIS.COM 
WHERE ADDRESS_PGUID  in ( 'urn:ecm:I1424ZZ4DPW')

SELECT * FROM CMX_ORS.C_POB@INTGCM_LINK.ISCERT.LEXISNEXIS.COM 
WHERE POB_PGUID = 'urn:ecm:I1424ZZ4DPX'

SELECT * FROM CMX_ORS.C_RELATED_ADDRESS@INTGCM_LINK.ISCERT.LEXISNEXIS.COM 
WHERE RELATED_ADDRESS_PGUID = 'urn:ecm:I1424ZZ4DPX'

SELECT COUNT(*), CUST_STAT_CD FROM  SIEBEL.S_ORG_EXT A WHERE INTEGRATION_ID IN (SELECT ORG_CUST_PGUID FROM SIEBELWORK.OC_DEMOTE_13APR18 )
GROUP BY CUST_STAT_CD


SELECT * FROM  SIEBEL.S_ORG_EXT A WHERE INTEGRATION_ID IN (SELECT ORG_CUST_PGUID FROM SIEBELWORK.OC_DEMOTE_13APR18 )


select * from cmx_ors.c_legacy_user@PSGCM_LINK.ISPROD.LEXISNEXIS.COM
where crc = 'F6CD2D4'


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
-- and oc.org_cust_pguid = 'urn:ecm:10001JE4K'
 and lsa.legacy_subacc_id = '149P4Q'
 and lu.source_id = 'ICUST'
 and lus.end_Date is null and lus.hub_state_ind=1
 
select * from CMX_ORS.c_legacy_user_subacc@PSGCM_LINK.ISPROD.LEXISNEXIS.COM

select * from all_tables@PSGCM_LINK.ISPROD.LEXISNEXIS.COM
where

SELECT * FROM cmx_ors.c_org_customer@psgcm_link.isprod.lexisnexis.com 
WHERE org_cust_pguid = 'urn:ecm:J22KDS6VN'


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
-- and lsa.legacy_subacc_id = '145D1N'
 and lu.source_id = 'ICUST'
 and lus.end_Date is null and lus.hub_state_ind=1
 and oc.org_cust_pguid  in ( 'urn:ecm:1000022XX',
'urn:ecm:1000022XX',
'urn:ecm:10000QZLH',
'urn:ecm:10001IAGK',
'urn:ecm:10001JE4K',
'urn:ecm:10001LTVT',
'urn:ecm:10001LTVT',
'urn:ecm:10001LTVT',
'urn:ecm:10001LTVT',
'urn:ecm:10001XS55',
'urn:ecm:10002FSDB',
'urn:ecm:10002TH2R',
'urn:ecm:1000WVSWX',
'urn:ecm:1000WVSWX',
'urn:ecm:1000WVSWX',
'urn:ecm:422K3XTYM',
'urn:ecm:422M2PLNT',
'urn:ecm:422M2PLNV',
'urn:ecm:422M2PLP5',
'urn:ecm:422M2PLP5',
'urn:ecm:422M2PLP5',
'urn:ecm:422M2PLP5',
'urn:ecm:422M2PLP7',
'urn:ecm:422M2PLP8',
'urn:ecm:422M2PLP9',
'urn:ecm:422M2PLPB',
'urn:ecm:422M2PLQ3',
'urn:ecm:422M2PLQ7',
'urn:ecm:422M2PLQD',
'urn:ecm:422M2PLQG',
'urn:ecm:422MGJWW6',
'urn:ecm:422MNTGK6',
'urn:ecm:422PW6246',
'urn:ecm:422PW624B',
'urn:ecm:424T63WG6',
'urn:ecm:424XGJ839',
'urn:ecm:424YBZN8P',
'urn:ecm:424YDG3RQ',
'urn:ecm:424YDG3RQ',
'urn:ecm:424YDG3RQ',
'urn:ecm:424YDG3RQ',
'urn:ecm:424YDG42Q',
'urn:ecm:424YDG52Z',
'urn:ecm:424YDG59W',
'urn:ecm:424YDG59W',
'urn:ecm:424ZQ4CLC',
'urn:ecm:42523V27S',
'urn:ecm:42523V27T',
'urn:ecm:42523V27X',
'urn:ecm:42523V27Z',
'urn:ecm:42523V283',
'urn:ecm:42523XCMT',
'urn:ecm:42523XCMV',
'urn:ecm:42523XCMW',
'urn:ecm:42523XCMX',
'urn:ecm:42523XCMY',
'urn:ecm:42523XCMZ',
'urn:ecm:42523XCN2',
'urn:ecm:42523XCN6',
'urn:ecm:42523XCN7',
'urn:ecm:425242HS3',
'urn:ecm:425242HS4',
'urn:ecm:42526GSD8')
order by oc.org_cust_pguid












select *   
from cmx_ors.c_legacy_user_subacc@PSGCM_LINK.ISPROD.LEXISNEXIS.COM lus  
join cmx_ors.c_legacy_subacc@PSGCM_LINK.ISPROD.LEXISNEXIS.COM lsa on lus.rowid_legacy_subacc=lsa.rowid_object and lus.end_Date is null and lus.hub_state_ind=1
join cmx_ors.c_legacy_user@PSGCM_LINK.ISPROD.LEXISNEXIS.COM lu on lus.rowid_legacy_user=lu.rowid_object and lus.end_Date is null and lus.hub_state_ind=1
join cmx_ors.c_org_customer@PSGCM_LINK.ISPROD.LEXISNEXIS.COM oc on oc.rowid_object=lsa.rowid_org_cust
left outer join cmx_ors.c_affiliated_person@PSGCM_LINK.ISPROD.LEXISNEXIS.COM ap on ap.rowid_object=lu.rowid_aff_per
left outer join cmx_ors.c_ap_pob appob@PSGCM_LINK.ISPROD.LEXISNEXIS.COM on appob.rowid_aff_per=ap.rowid_object and appob.end_date is null and appob.hub_state_ind=1
left outer join cmx_ors.c_pob@PSGCM_LINK.ISPROD.LEXISNEXIS.COM pob on pob.rowid_object=appob.rowid_pob and appob.end_date is null and appob.hub_state_ind=1
left outer join cmx_ors.c_address@PSGCM_LINK.ISPROD.LEXISNEXIS.COM ad on ad.rowid_object=pob.rowid_address 




select b.* from cmx_ors.c_legacy_subacc@PSGCM_LINK.ISPROD.LEXISNEXIS.COM A, 
CMX_ORS.C_ORG_CUSTOMER@PSGCM_LINK.ISPROD.LEXISNEXIS.COM B
WHERE B.ROWID_OBJECT = A.ROWID_ORG_CUST
AND SOURCE_ID = 'IDMS'
AND ORG_CUST_PGUID IN ( 'urn:ecm:1000022XX',
'urn:ecm:1000022XX',
'urn:ecm:10000QZLH',
'urn:ecm:10001IAGK',
'urn:ecm:10001JE4K',
'urn:ecm:10001LTVT',
'urn:ecm:10001LTVT',
'urn:ecm:10001LTVT',
'urn:ecm:10001LTVT',
'urn:ecm:10001XS55',
'urn:ecm:10002FSDB',
'urn:ecm:10002TH2R',
'urn:ecm:1000WVSWX',
'urn:ecm:1000WVSWX',
'urn:ecm:1000WVSWX',
'urn:ecm:422K3XTYM',
'urn:ecm:422M2PLNT',
'urn:ecm:422M2PLNV',
'urn:ecm:422M2PLP5',
'urn:ecm:422M2PLP5',
'urn:ecm:422M2PLP5',
'urn:ecm:422M2PLP5',
'urn:ecm:422M2PLP7',
'urn:ecm:422M2PLP8',
'urn:ecm:422M2PLP9',
'urn:ecm:422M2PLPB',
'urn:ecm:422M2PLQ3',
'urn:ecm:422M2PLQ7',
'urn:ecm:422M2PLQD',
'urn:ecm:422M2PLQG',
'urn:ecm:422MGJWW6',
'urn:ecm:422MNTGK6',
'urn:ecm:422PW6246',
'urn:ecm:422PW624B',
'urn:ecm:424T63WG6',
'urn:ecm:424XGJ839',
'urn:ecm:424YBZN8P',
'urn:ecm:424YDG3RQ',
'urn:ecm:424YDG3RQ',
'urn:ecm:424YDG3RQ',
'urn:ecm:424YDG3RQ',
'urn:ecm:424YDG42Q',
'urn:ecm:424YDG52Z',
'urn:ecm:424YDG59W',
'urn:ecm:424YDG59W',
'urn:ecm:424ZQ4CLC',
'urn:ecm:42523V27S',
'urn:ecm:42523V27T',
'urn:ecm:42523V27X',
'urn:ecm:42523V27Z',
'urn:ecm:42523V283',
'urn:ecm:42523XCMT',
'urn:ecm:42523XCMV',
'urn:ecm:42523XCMW',
'urn:ecm:42523XCMX',
'urn:ecm:42523XCMY',
'urn:ecm:42523XCMZ',
'urn:ecm:42523XCN2',
'urn:ecm:42523XCN6',
'urn:ecm:42523XCN7',
'urn:ecm:425242HS3',
'urn:ecm:425242HS4',
'urn:ecm:42526GSD8')



select * from cmx_ors.t_cscm_oc@PSGCM_LINK.ISPROD.LEXISNEXIS.COM

select * from cmx_ors.t_cscm_ap@PSGCM_LINK.ISPROD.LEXISNEXIS.COM

select * from cmx_ors.t_cscm_fa@PSGCM_LINK.ISPROD.LEXISNEXIS.COM

select * from cmx_ors.t_cscm_legacy@PSGCM_LINK.ISPROD.LEXISNEXIS.COM

select * from cmx_ors.ln_agreement_load_scope_new@PSGCM_LINK.ISPROD.LEXISNEXIS.COM


select *  from cmx_ors.c_legacy_subacc@PSGCM_LINK.ISPROD.LEXISNEXIS.COM where source_id='VISTA'  
and  legacy_subacc_id in ('99575854',
'99535744',
'0099516119',
'0099829493',
'0099512374',
'0099712073',
'8800007916',
'8800007369',
'8800004216',
'8800007192',
'8800005035',
'8800007790',
'0099752316',
'0099534304',
'0099766042',
'0099550043',
'0099513708',
'0099508792')

