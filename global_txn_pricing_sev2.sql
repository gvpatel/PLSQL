SELECT PHEAD.NAME,PHEAD.X_SELL_TYPE,C.NAME, STD_PRI_UNIT AS PRICE, PHEAD.EFF_START_DT, PHEAD.EFF_END_DT,
PLINE.EFF_START_DT LINE_START, PLINE.EFF_END_DT LINE_END
FROM SIEBEL.S_PRI_LST PHEAD, SIEBEL.S_PRI_LST_ITEM PLINE,
SIEBEL.S_PROD_INT C
WHERE PHEAD.ROW_ID = PLINE.PRI_LST_ID
AND PLINE.PROD_ID = C.ROW_ID
AND PHEAD.X_SELL_TYPE = 'Transaction'
AND PHEAD.EFF_END_DT IS NULL -- Pricelist HEADER is END DATED
AND PLINE.EFF_END_DT IS NULL  -- Pricelist Line item IS NOT END DATED
--AND PHEAD.NAME = 'BIS Academic Australia Transactional'
AND C.NAME IN (
'Lexis Advance Access Charge for Cost Recovery - AUS 1524234',
'Lexis Advance Access Charge for Cost Recovery - CAN 1524233',
'Lexis Advance Access Charge for Cost Recovery - HKG 1524589',
'Lexis Advance Access Charge for Cost Recovery - India 1524590',
'Lexis Advance Access Charge for Cost Recovery - MYL 1524236',
'Lexis Advance Access Charge for Cost Recovery - NZ 1524235',
'Lexis Advance Access Charge for Cost Recovery - SYP 1524237',
'Lexis Advance Access Charge for Cost Recovery - UK 1524588',
'Lexis Advance® Access Charge for Cost Recovery 1000604')
ORDER BY phead.name
