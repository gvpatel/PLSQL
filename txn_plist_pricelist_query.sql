-- EXPORT PRICES FOR Txn pricelist's assemblies
SELECT * FROM (
SELECT C.NAME, C.INTEGRATION_ID as PROD_PGUID,STD_PRI_UNIT AS PRICE, D.VAL AS CURRENCY,
A.X_LN_PRILST_PGUID AS PRICELIST_PGUID,  A.X_SYSTEM_ACCESS
,ROW_NUMBER() OVER ( PARTITION BY A.X_LN_PRILST_PGUID, C.INTEGRATION_ID ORDER BY B.EFF_START_DT DESC) AS R
FROM  SIEBEL.S_PRI_LST A, SIEBEL.S_PRI_LST_ITEM B,
SIEBEL.S_PROD_INT C, SIEBEL.S_LST_OF_VAL D
WHERE A.ROW_ID = B.PRI_LST_ID
AND B.PROD_ID = C.ROW_ID
AND D.TYPE = 'LN_LEGAL_OWNER_CURRENCY'
AND D.NAME = C.X_LEGAL_OWNER
AND A.X_SELL_TYPE = 'Transaction'
AND C.X_PKG_LVL = 'Assembly'
AND a.eff_end_dt is NULL
AND B.eff_end_dt is NULL )
WHERE R = 1
--AND A.X_LN_PRILST_PGUID = 'urn:ncrm:pl:1000001201'
ORDER BY PRICELIST_PGUID

-- Export Txn pricelist --> Pricing segment mappings


SELECT DISTINCT A.NAME PRICELIST_NAME, A. X_LN_PRILST_PGUID PRICELIST_PGUID,  B.NAME, C.INTEGRATION_ID PRICING_SEGMENT_PGUID,
A.X_SYSTEM_ACCESS ACCESS_FLAG
FROM  SIEBEL.S_PRI_LST A, SIEBEL.CX_LN_PRC_SGMNT B,
SIEBEL.S_LST_OF_VAL C
WHERE A.ROW_ID = B.PAR_ROW_ID
AND B.TYPE = 'Pricing_Segment'
AND B.NAME = C.NAME
AND C.TYPE = 'LN_PRICING_SEGMENT'
AND A.X_SELL_TYPE = 'Transaction'
AND a.eff_end_dt is NULL
ORDER BY X_LN_PRILST_PGUID



SELECT DISTINCT A.NAME PRICELIST_NAME, A. X_LN_PRILST_PGUID PRICELIST_PGUID,  B.NAME, C.INTEGRATION_ID PRICING_SEGMENT_PGUID,
A.X_SYSTEM_ACCESS ACCESS_FLAG
FROM  SIEBEL.S_PRI_LST A, SIEBEL.CX_LN_PRC_SGMNT B,
SIEBEL.S_LST_OF_VAL C
WHERE A.ROW_ID = B.PAR_ROW_ID
AND B.TYPE = 'Pricing_Segment'
AND B.NAME = C.NAME
AND C.TYPE = 'LN_PRICING_SEGMENT'
AND A.X_SELL_TYPE = 'Transaction'
AND a.eff_end_dt is NULL
ORDER BY X_LN_PRILST_PGUID

SELECT * FROM SIEBEL.S_PRI_LST

SELECT DISTINCT A.NAME PRICELIST_NAME, A. X_LN_PRILST_PGUID PRICELIST_PGUID,  B.NAME, C.INTEGRATION_ID PRICING_SEGMENT_PGUID,
A.CURCY_CD CURRENCY
FROM  SIEBEL.S_PRI_LST A, SIEBEL.CX_LN_PRC_SGMNT B,
SIEBEL.S_LST_OF_VAL C
WHERE A.ROW_ID = B.PAR_ROW_ID
AND B.TYPE = 'Pricing_Segment'
AND B.NAME = C.NAME
AND C.TYPE = 'LN_PRICING_SEGMENT'
AND A.X_SELL_TYPE = 'Print Transaction'
AND a.eff_end_dt is NULL
ORDER BY X_LN_PRILST_PGUID



-------------Sync Print Txn Assemblies/Components ------------

SELECT C.NAME, C.INTEGRATION_ID as PROD_PGUID, '*'||substr(C.INTEGRATION_ID, length(C.INTEGRATION_ID)- 6) ||' OR ' ITEM_ID,
STD_PRI_UNIT AS PRICE,
A.X_LN_PRILST_PGUID AS PRICELIST_PGUID,  A.X_SYSTEM_ACCESS
--,ROW_NUMBER() OVER ( PARTITION BY A.X_LN_PRILST_PGUID, C.INTEGRATION_ID ORDER BY B.EFF_START_DT DESC) AS R
FROM  SIEBEL.S_PRI_LST A, SIEBEL.S_PRI_LST_ITEM B,
SIEBEL.S_PROD_INT C
WHERE A.ROW_ID = B.PRI_LST_ID
AND B.PROD_ID = C.ROW_ID
AND A.X_SELL_TYPE = 'Print Transaction'
AND C.X_PKG_LVL = 'Assembly'
AND a.eff_end_dt is NULL
AND B.eff_end_dt is NULL 










----------------------------------------

SELECT * FROM (
SELECT DISTINCT SPI.NAME, SPI.INTEGRATION_ID as PROD_PGUID,SPLI.STD_PRI_UNIT AS PRICE, LOV.VAL AS CURRENCY,
SPL.X_LN_PRILST_PGUID AS PRICELIST_PGUID,  SPL.X_SYSTEM_ACCESS,
ROW_NUMBER() OVER ( PARTITION BY SPL.X_LN_PRILST_PGUID, SPI.INTEGRATION_ID ORDER BY SPLI.EFF_START_DT DESC) AS R
FROM SIEBEL.S_ISS_SUB_OBJ BUN
JOIN SIEBEL.S_VOD SV ON SV.OBJECT_NUM=BUN.SUB_OBJ_ID
JOIN SIEBEL.S_PROD_INT SPI ON SPI.CFG_MODEL_ID=SV.OBJECT_NUM
JOIN SIEBEL.S_VOD PARVOD ON PARVOD.ROW_ID=BUN.VOD_ID
JOIN SIEBEL.S_PROD_INT PAR ON PAR.CFG_MODEL_ID=PARVOD.OBJECT_NUM
JOIN SIEBEL.S_PRI_LST_ITEM SPLI ON SPLI.PROD_ID=SPI.ROW_ID
join SIEBEL.S_PRI_LST SPL ON SPL.ROW_ID=SPLI.PRI_LST_ID
JOIN SIEBEL.S_LST_OF_VAL LOV ON LOV.TYPE = 'LN_LEGAL_OWNER_CURRENCY' AND LOV.NAME = PAR.X_LEGAL_OWNER
WHERE SPL.X_SELL_TYPE = 'Transaction' AND SPI.X_PKG_LVL = 'Component'
and spli.eff_end_dt is NULL AND spl.eff_end_dt is NULL )
WHERE R = 1
ORDER BY PRICELIST_PGUID
--AND spl.X_LN_PRILST_PGUID = 'urn:ncrm:pl:1000001201';

------








SELECT C.NAME, C.INTEGRATION_ID as PROD_PGUID,STD_PRI_UNIT AS PRICE, D.VAL AS CURRENCY,
A.X_LN_PRILST_PGUID AS PRICELIST_PGUID,  A.X_SYSTEM_ACCESS, C.X_ITEM_TYPE
FROM  SIEBEL.S_PRI_LST A, SIEBEL.S_PRI_LST_ITEM B,
SIEBEL.S_PROD_INT C, SIEBEL.S_LST_OF_VAL D
WHERE A.ROW_ID = B.PRI_LST_ID
AND B.PROD_ID = C.ROW_ID
AND D.TYPE(+) = 'LN_LEGAL_OWNER_CURRENCY'
AND D.NAME(+) = C.X_LEGAL_OWNER
AND A.X_SELL_TYPE = 'Transaction'
AND C.X_PKG_LVL = 'Component'
AND a.eff_end_dt is NULL
AND B.eff_end_dt is NULL
ORDER BY X_LN_PRILST_PGUID


SELECT C.NAME, C.INTEGRATION_ID as PROD_PGUID,STD_PRI_UNIT AS PRICE, D.VAL AS CURRENCY,
A.X_LN_PRILST_PGUID AS PRICELIST_PGUID,  A.X_SYSTEM_ACCESS 
FROM  SIEBEL.S_PRI_LST A, SIEBEL.S_PRI_LST_ITEM B,
SIEBEL.S_PROD_INT C, SIEBEL.S_LST_OF_VAL D, TEMP_PROD_CHILD E
WHERE A.ROW_ID = B.PRI_LST_ID
AND B.PROD_ID = C.ROW_ID
AND C.CFG_MODEL_ID = e.sub_obj_id
AND D.TYPE(+) = 'LN_LEGAL_OWNER_CURRENCY'
AND D.NAME(+) = E.X_LEGAL_OWNER
AND A.X_SELL_TYPE = 'Transaction'
AND C.X_PKG_LVL = 'Component'
AND a.eff_end_dt is NULL
AND B.eff_end_dt is NULL
ORDER BY X_LN_PRILST_PGUID






SELECT 
S_PROD_INT.NAME, S_PROD_INT.INTEGRATION_ID ,S_PROD_INT.X_PKG_LVL
FROM
SIEBEL.S_PROD_INT S_PROD_INT,
SIEBEL.S_PROD_INT_LANG S_PROD_INT_LANG,
SIEBEL.S_VOD S_VOD, 
SIEBEL.S_VOD_VER S_VOD_VER
where S_PROD_INT.CFG_MODEL_ID = S_VOD.OBJECT_NUM
AND S_PROD_INT_LANG.PAR_ROW_ID(+) = S_PROD_INT.ROW_ID AND S_PROD_INT_LANG.LANG_ID (+) = 'ENU'
and S_Vod.Row_Id = S_Vod_Ver.Vod_Id 
And S_Vod_Ver.Curr_Ver_Flg = 'Y' 
and prod_type_cd in ('None','Customizable','Bundle')
And Orderable_Flg = 'Y'
AND SALES_PROD_FLG <> 'N'
AND CRT_INST_FLG = 'Y'
AND PRICE_TYPE_CD IS NOT NULL
AND S_PROD_INT.ROW_ID = '1-4HKYL'


CREATE OR REPLACE VIEW TEMP_PROD_CHILD AS
SELECT 
S_PROD_INT.NAME, S_PROD_INT.INTEGRATION_ID ,S_PROD_INT.X_PKG_LVL,
OBJ.SUB_OBJ_NAME, OBJ.SUB_OBJ_ID , S_PROD_INT.X_LEGAL_OWNER,
S_PROD_INT.X_PRODUCT_CLASS,S_PROD_INT.X_SOLUTION_LINE,
S_PROD_INT.X_LN_PRODUCT_SEGMENT,
S_PROD_INT.X_ITEM_TYPE
FROM
SIEBEL.S_PROD_INT S_PROD_INT,
SIEBEL.S_PROD_INT_LANG S_PROD_INT_LANG,
SIEBEL.S_VOD S_VOD, 
SIEBEL.S_VOD_VER S_VOD_VER,
SIEBEL.S_ISS_SUB_OBJ OBJ
where S_PROD_INT.CFG_MODEL_ID = S_VOD.OBJECT_NUM
AND S_PROD_INT_LANG.PAR_ROW_ID(+) = S_PROD_INT.ROW_ID AND S_PROD_INT_LANG.LANG_ID (+) = 'ENU'
and S_Vod.Row_Id = S_Vod_Ver.Vod_Id 
And S_Vod_Ver.Curr_Ver_Flg = 'Y' 
and prod_type_cd in ('None','Customizable','Bundle')
--And Orderable_Flg = 'Y'
AND S_PROD_INT.X_PKG_LVL = 'Assembly'
--AND SALES_PROD_FLG <> 'N'
--AND CRT_INST_FLG = 'Y'
--AND PRICE_TYPE_CD IS NOT NULL
AND OBJ.VOD_ID = S_VOD.ROW_ID
AND OBJ.last_vers = '999999999'
AND S_PROD_INT.X_ITEM_STATUS = 'Released'
AND S_PROD_INT.LIFE_CYCLE_CD = 'Sellable and Supported'
--AND S_PROD_INT.X_ITEM_TYPE = 'ONLINE CONTENT ASSEMBLY'
--AND  S_PROD_INT.ROW_ID = '1-447B1'

SELECT * FROM TEMP_PROD_CHILD

SELECT count(*), sub_obj_id FROM TEMP_PROD_CHILD
group by sub_obj_id
having count(*) > 1

SELECT * FROM SIEBEL.S_ISS_OBJ_DEF

SELECT  FROM SIEBEL.S_ISS_SUB_OBJ
where VOD_ID = '1-V6PIE'
and last_vers = '999999999'
order by created desc

'1-V6PIC'

select * From siebel.s_prod_int where row_id = '1-447B1'




--------------------------------------------------------------------------------








SELECT C.NAME, C.INTEGRATION_ID as PROD_PGUID,STD_PRI_UNIT AS PRICE, D.VAL AS CURRENCY,
A.X_LN_PRILST_PGUID AS PRICELIST_PGUID,  A.X_SYSTEM_ACCESS
FROM  SIEBEL.S_PRI_LST A, SIEBEL.S_PRI_LST_ITEM B,
SIEBEL.S_PROD_INT C, SIEBEL.S_LST_OF_VAL D
WHERE A.ROW_ID = B.PRI_LST_ID
AND B.PROD_ID = C.ROW_ID
AND D.TYPE = 'LN_LEGAL_OWNER_CURRENCY'
AND D.NAME = C.X_LEGAL_OWNER
AND A.X_SELL_TYPE = 'Transaction'
AND C.X_PKG_LVL = 'Assembly'
AND a.eff_end_dt is NULL
AND B.eff_end_dt is NULL
ORDER BY X_LN_PRILST_PGUID



SELECT count(*), A.NAME,  A.X_LN_PRILST_PGUID
FROM  SIEBEL.S_PRI_LST A, SIEBEL.S_PRI_LST_ITEM B,
SIEBEL.S_PROD_INT C, SIEBEL.S_LST_OF_VAL D
WHERE A.ROW_ID = B.PRI_LST_ID
AND B.PROD_ID = C.ROW_ID
AND D.TYPE = 'LN_LEGAL_OWNER_CURRENCY'
AND D.NAME = C.X_LEGAL_OWNER
AND A.X_SELL_TYPE = 'Transaction'
AND C.X_PKG_LVL = 'Assembly'
AND a.eff_end_dt is NULL
AND B.eff_end_dt is NULL
GROUP BY A.NAME, A.X_LN_PRILST_PGUID




SELECT * FROM SIEBEL.CX_LN_PRC_SGMNT 

SELECT * FROM SIEBEL.S_LST_OF_VAL WHERE TYPE = 'LN_LEGAL_OWNER_CURRENCY'
 
SELECT * FROM SIEBEL.S_PRI_LST A

SELECT * FROM SIEBEL.S_PRI_LST_ITEM A
