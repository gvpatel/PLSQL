SELECT * FROM SIEBEL.S_LST_OF_VAL A , SIEBEL.S_LST_OF_VAL_BU B,
WHERE A.ROW_ID = 

WHERE ROW_ID = '1-ONJYKE'

AND TYPE = 'LN_CUST_CLASS'
SELECT * FROM SIEBEL.S_LST_OF_VAL_BU WHERE LST_OF_VAL_ID = '1-ONJY2C'

SELECT C.NAME AS ORG, A.NAME, A.VAL, A.INTEGRATION_ID, A.HIGH, A.LOW, A.DESC_TEXT
FROM SIEBEL.S_LST_OF_VAL  A,
SIEBEL.S_LST_OF_VAL_BU B,
SIEBEL.S_BU C WHERE 
A.ROW_ID = B.LST_OF_VAL_ID
AND B.BU_ID = C.ROW_ID
 AND TYPE = 'LN_CUST_CLASS'