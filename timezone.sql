ALTER SESSION SET time_zone= 'Australia/Melbourne';
select GetDSTDates(2017,1) DSTStart,
       GetDSTDates(2017,2) DSTEnd,
       SessionTimeZone TZ from dual;
       
       select * from siebel.s_order_item
       
        SELECT to_date('01/01/' || to_char(sysdate-365,'YYYY') || '12:00:00','MM/DD/YYYYHH24:MI:SS')+rownum-1 
   FROM dual CONNECT BY rownum<=365
   
   select dbtimezone from dual;
   
   select 12-to_number(to_char(LocalTimeZone at time zone '+00:00','HH24')) offset,
    min(to_char(LocalTimeZone at time zone '+00:00','DD/MM/YYYY')) fromdate,
    max(to_char(LocalTimeZone at time zone '+00:00','DD/MM/YYYY')) todate 
        from (
        SELECT cast((to_date('01/01/'||to_char(2017)||'12:00:00','MM/DD/YYYYHH24:MI:SS')+rownum-1) as timestamp with local time zone) LocalTimeZone
        FROM dual CONNECT BY rownum<=365
        )
    group by 12-to_number(to_char(LocalTimeZone at time zone '+00:00','HH24'));
    
    
      SELECT cast((to_date('01/01/'||to_char(2017)||'12:00:00','MM/DD/YYYYHH24:MI:SS')+rownum-1) as timestamp with local time zone) LocalTimeZone
        FROM dual CONNECT BY  rownum<=365
    
    SELECT x.*,
       CASE WHEN dst_offset = std_offset THEN 'In Standard Time' ELSE 'Currently Observing DST' END
           dststatus
  FROM (SELECT tz,
                  TO_CHAR(EXTRACT(HOUR FROM dst_offset), 'sfm09')
               || ':'
               || TO_CHAR(EXTRACT(MINUTE FROM dst_offset), 'fm09')
                   dst_offset,
                  TO_CHAR(EXTRACT(HOUR FROM std_offset), 'sfm09')
               || ':'
               || TO_CHAR(EXTRACT(MINUTE FROM std_offset), 'fm09')
                   std_offset,
               curr_offset
          FROM (SELECT   tz,
                         MIN(offset) dst_offset,
                         MAX(offset) std_offset,
                         RTRIM(TZ_OFFSET(tz), CHR(0)) curr_offset
                    FROM (SELECT CAST(t AT TIME ZONE tz AS TIMESTAMP) - CAST(t AS TIMESTAMP) offset,
                                 tz
                            FROM (SELECT       TO_TIMESTAMP_TZ('2017-01-01 GMT', 'yyyy-mm-dd tzr')
                                             + NUMTOYMINTERVAL(LEVEL - 1, 'MONTH')
                                                 t
                                        FROM DUAL
                                  CONNECT BY LEVEL <= 12),
                                 (SELECT tzname tz FROM v$timezone_names))
                GROUP BY tz)) x
                order by 1
                
             
                                 
                
                
                
                SELECT MIN(offset) dst_offset, MAX(offset) std_offset, TZ_OFFSET('US/Eastern')
  FROM (SELECT CAST(t AT TIME ZONE 'US/Eastern' AS TIMESTAMP) - CAST(t AS TIMESTAMP) offset
          FROM (SELECT       TO_TIMESTAMP_TZ('2011-01-01 GMT', 'yyyy-mm-dd tzr')
                           + NUMTOYMINTERVAL(LEVEL - 1, 'MONTH')
                               t
                      FROM DUAL
                CONNECT BY LEVEL <= 12))
                
                
select to_timestamp_tz('2017-05-1 00:00:00 US/Eastern',
     'yyyy-mm-dd hh24:mi:ss tzr') at time zone '00:00' from dual;     
     
  select to_timestamp_tz(to_date('01/01/'||to_char(2017)||'00:00:00','MM/DD/YYYYHH24:MI:SS')+rownum-1||' US/Eastern', 
   'yyyy-mm-dd hh24:mi:ss tzr') at time zone '00:00' from dual CONNECT BY rownum<=365     
   
    select to_timestamp_tz( LocalTimeZone||'America/Winnipeg',  'yyyy-mm-dd hh24:mi:ss tzr') at time zone '00:00' from          
    ( SELECT cast((to_date('01/01/'||to_char(2017)||'00:00:00','MM/DD/YYYYHH24:MI:SS')+rownum-1) as timestamp with local time zone) LocalTimeZone
        FROM dual CONNECT BY rownum<=365        
        ) 
        
     America/Regina” instead of “America/Winnipeg 
      
      
 ---------------------------
SELECT A.NAME,A.DST_ABBREV,A.X_PGUID,  EFF_START_DT, B.UTC_OFFSET, B.DST_BIAS, B.DST_START_TM,B.DST_END_TM, 
B.DST_START_DAY_CD, B.DST_END_DAY_CD,B.DST_START_MONTH_CD, B.DST_END_MONTH_CD,  
B.DST_START_ORD_CD, B.DST_END_ORD_CD FROM SIEBEL.S_TIMEZONE A,
 SIEBEL.S_TIMEZONE_DTL B
 WHERE A.ROW_ID = B.TIMEZONE_ID
 AND A.X_PGUID = 'US/Eastern'

 
  SELECT * FROM SIEBEL.S_TIMEZONE A,
 SIEBEL.S_TIMEZONE_DTL B
 WHERE A.ROW_ID = B.TIMEZONE_ID
 AND A.X_PGUID = 'US/Eastern'
 
 SELECT * fROM SIEBEL.S_TIMEZONE_DTL where timezone_id = '0-1OBMH'
 
 SELECT * FROM SIEBEL.S_TIMEZONE where X_PGUID = 'US/Eastern'
 
 
 SELECT A.ENTITY_ID, A.ENTITY_NAME AS ENTITY,A.STORED_PROC AS STORED_PROC, B.ID AS GUID_ID, B.SUB_GUID AS GUID, 
B.START_EPOCH AS FROM_EPOCH,B.END_EPOCH AS TO_EPOCH, B.EPOCH_PROCESSED AS 
LAST_EPOCH, B.READ_EPOCH_RANGE, C.ENV_TYPE, C.PSH_URL AS PSH_URL, C.PSH_PWD, 
C.PSH_USR_NM, C.MAIL_HOSTNAME, C.MAIL_PORT, C.SENDER_USERNAME, 
C.SENDER_PASSWORD, C.RETRY, C.CRM_RECIPIENTS, C.PSH_RECIPIENTS FROM 
LN_PSH_ECM_ENTITY A JOIN LN_PSH_ECM_ENTITY_SUB_GUID B ON B.ENTITY_ID = 
A.ENTITY_ID JOIN LN_PSH_ECM_URL C ON B.ENV_ID = C.ENV_ID 


--------------------------------

   
SELECT EXTRACT (MONTH FROM T), EXTRACT (day FROM T), EXTRACT(TIMEZONE_HOUR  FROM t),
EXTRACT(TIMEZONE_region  FROM t),
(TO_CHAR(T,
         'YYYY-MM-DD HH:MI:SS.FF AM TZH:TZM TZR TZD')) FROM (
    SELECT  TO_TIMESTAMP_TZ('2017-01-01 2:00:00.123456789 US/Eastern', 'YYYY-MM-DD HH24:MI:SS.FF TZR')
 +  INTERVAL '1' DAY * (ROWNUM-1) t
   FROM DUAL CONNECT BY ROWNUM<=365)
   
---------------------------------------------   
SELECT * FROM  (     
SELECT EXTRACT (MONTH FROM T), EXTRACT (day FROM T), EXTRACT(TIMEZONE_HOUR  FROM t),
EXTRACT(TIMEZONE_region  FROM t), 
EXTRACT (TIMEZONE_HOUR FROM T) - lag(EXTRACT(TIMEZONE_HOUR FROM T), 1, EXTRACT (TIMEZONE_HOUR FROM T)) 

OVER (ORDER BY EXTRACT(TIMEZONE_region  FROM t), EXTRACT (MONTH FROM T)) AS DIFF,
(TO_CHAR(T,
         'YYYY-MM-DD HH:MI:SS.FF AM TZH:TZM TZR TZD')) FROM (
    SELECT  TO_TIMESTAMP_TZ('2017-01-01 2:00:00.123456789  America/Regina', 'YYYY-MM-DD HH24:MI:SS.FF TZR')
 +  INTERVAL '1' DAY * (ROWNUM-1) t
   FROM DUAL CONNECT BY ROWNUM<=365)
   order by t ) WHERE DIFF <> 0
   
   
   America/Regina
   America/Winnipeg
   
   select * from v$timezone_names where tzname like 'America/Re%'
   ------------------------------------------
   
   
SELECT * FROM  (     
SELECT EXTRACT (MONTH FROM T), EXTRACT (day FROM T), EXTRACT(TIMEZONE_HOUR  FROM t),
EXTRACT(TIMEZONE_region  FROM t), 
--LEAD(EXTRACT(TIMEZONE_HOUR FROM T), 1, 1)  OVER (ORDER BY EXTRACT(TIMEZONE_HOUR FROM T))) Z,
EXTRACT (TIMEZONE_HOUR FROM T) - lag(EXTRACT(TIMEZONE_HOUR FROM T), 1, EXTRACT (TIMEZONE_HOUR FROM T)) 

OVER (ORDER BY EXTRACT(TIMEZONE_region  FROM t), EXTRACT (MONTH FROM T)) AS DIFF,
(TO_CHAR(T,
         'YYYY-MM-DD HH:MI:SS.FF AM TZH:TZM TZR TZD')) FROM (
    SELECT  TO_TIMESTAMP_TZ('2017-01-01 2:00:00.123456789 US/Eastern', 'YYYY-MM-DD HH24:MI:SS.FF TZR')
 +  numtodsinterval(rownum-1,'DAY') t
   FROM DUAL CONNECT BY ROWNUM<=365)
   order by t ) WHERE DIFF <> 0
   

 SELECT  TO_TIMESTAMP_TZ('2017-01-01 2:00:00.123456789 US/Eastern', 'YYYY-MM-DD HH24:MI:SS.FF TZR')
 + numtodsinterval(rownum-1,'DAY')
   FROM dual CONNECT BY ROWNUM<=365

   SELECT  X_PGUID, TO_TIMESTAMP_TZ('2017-01-01 2:00:00.123456789 '||X_PGUID||'', 'YYYY-MM-DD HH24:MI:SS.FF TZR')
 + numtodsinterval(rownum-1,'DAY')
   FROM SIEBEL.S_TIMEZONE START WITH X_PGUID is not null  CONNECT BY ROWNUM<=365
    
   

   
 
   
   select * from (
   select tzname  from v$timezone_names where tzname in (
   SELECT X_PGUID FROM SIEBEL.S_TIMEZONE where X_PGUID is not null))
   start with tzname is not null CONNECT BY ROWNUM<=365
   