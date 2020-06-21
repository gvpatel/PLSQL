
select * from ( 
SELECT
       TO_DATE(TO_CHAR(SYSDATE - 11, 'MM/DD/YYYY'), 'MM/DD/YYYY') + seq AS day_date
        ,      TO_CHAR( SYSDATE -11 + seq , 'D') day_of_week
      ,   DECODE(TO_CHAR(SYSDATE -11 + seq,'D'),2,11,3, 11,4,9, 5,9,6,9,7,9,1,10 ) days_back
      , DECODE(TO_CHAR(SYSDATE -11 + seq,'D'),2,9,3,9,4,9,5,11,6, 11, 7, 10, 1,9 ) days_forward
      
FROM
(
    SELECT ROWNUM-1 seq
    FROM   ( SELECT 1
             FROM   dual
             CONNECT BY LEVEL <= 365 * 100 --100 years
           )           
)
) 

select created, TODO_PLAN_START_DT, todo_cd,
DECODE(TO_CHAR(SYSDATE,'D'),2,11,3, 11,4,9, 5,9,6,9,7,9,1,10 ) days_back
, DECODE(TO_CHAR(SYSDATE,'D'),2,9,3,9,4,9,5,11,6, 11, 7, 10, 1,9 ) days_forward
from siebel.s_evt_act 
where TODO_PLAN_START_DT  BETWEEN sysdate - DECODE(TO_CHAR(SYSDATE,'D'),2,11,3, 11,4,9, 5,9,6,9,7,9,1,10 )
and  sysdate + DECODE(TO_CHAR(SYSDATE,'D'),2,9,3,9,4,9,5,11,6, 11, 7, 10, 1,9 ) 
ORDER BY TODO_PLAN_START_DT ASC


---------------



 
SELECT CREATED, TODO_PLAN_START_DT, TODO_CD,OWNER_PER_ID, OWNER_LOGIN,
DECODE(TO_CHAR(SYSDATE,'D'),2,11,3, 11,4,9, 5,9,6,9,7,9,1,10 ) days_back
, DECODE(TO_CHAR(SYSDATE,'D'),2,9,3,9,4,9,5,11,6, 11, 7, 10, 1,9 ) days_forward
FROM siebel.s_evt_act 
WHERE TODO_PLAN_START_DT  BETWEEN SYSDATE - DECODE(TO_CHAR(SYSDATE,'D'),2,11,3, 11,4,9, 5,9,6,9,7,9,1,10 )
AND SYSDATE + DECODE(TO_CHAR(SYSDATE,'D'),2,9,3,9,4,9,5,11,6,11,7,10,1,9 ) 
AND OWNER_LOGIN = 'PAETET'
ORDER BY TODO_PLAN_START_DT ASC

SELECT * FROM (
SELECT
    created,
    todo_plan_start_dt,
    todo_cd,
    owner_per_id,
    owner_login,
    DECODE(TO_CHAR(SYSDATE,'D'),2,11,3, 11,4,9, 5,9,6,9,7,9,1,10 ) days_back,
    DECODE(TO_CHAR(SYSDATE,'D'),2,9,3,9,4,9,5,11,6, 11, 7, 10, 1,9 ) days_forward,
    TO_CHAR(todo_plan_start_dt, 'DY') day
FROM
    siebel.s_evt_act
WHERE   todo_plan_start_dt BETWEEN SYSDATE - DECODE(TO_CHAR(SYSDATE,'D'),2,11,3, 11,4,9, 5,9,6,9,7,9,1,10 )
                               AND SYSDATE + DECODE(TO_CHAR(SYSDATE,'D'),2,9,3,9,4,9,5,11,6,11,7,10,1,9 )               
        AND owner_login = 'PAETET' 
         )
WHERE DAY NOT IN ('SAT', 'SUN')  
ORDER BY todo_plan_start_dt


