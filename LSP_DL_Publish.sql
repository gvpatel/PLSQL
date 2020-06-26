SET SERVEROUTPUT ON;


DECLARE
    req              utl_http.req;
    res              utl_http.resp;
    --'http://datalake.content.aws.lexis.com/objects/v1/testobject1?collection-id=ProductMasterTestCollection'
    base_url         VARCHAR2(400) := 'http://datalake-staging-proxy.lexis.com/objects/v1/';
    end_url          VARCHAR2(400) := '?collection-id=ProductMasterTestCollection';
    url              VARCHAR2(800):='http://datalake-staging-proxy.lexis.com/objects/v1/Testobject1?collection-id=ProductMasterTestCollection';
    name             VARCHAR2(4000);
    buffer           VARCHAR2(4000);
    content          CLOB;
    content_blob     BLOB;
    content_length   NUMBER;
    respond          VARCHAR2(4000);
    l_count number:=0;
    v_xml          XMLTYPE;
    i NUMBER := 0;
 

cursor C1 IS
  SELECT /*+ parallel(auto) */ 
               customer1.integration_id ecmpguid
           FROM  siebel.s_accnt_postn acctnpostn,
                 siebel.s_postn postn,
                 siebel.s_user userdb,
                 siebel.s_contact contactdtl,
                 siebel.s_org_ext customer1,
                 siebel.s_sys_pref syp-- Added as part of webstar#5602257  
                      
          WHERE postn.row_id = acctnpostn.position_id
                      AND userdb.row_id = postn.pr_emp_id
                      AND contactdtl.row_id = userdb.par_row_id
                      AND customer1.row_id = acctnpostn.ou_ext_id
                      AND customer1.x_cust_class = 'Academic'
                      AND customer1.x_customer_subclass = 'Law Schools'
                      AND customer1.integration_id IS NOT NULL
                      AND customer1.accnt_type_cd = 'Customer' 
                      AND syp.val=postn.x_postn_year AND syp.sys_pref_cd='LN Current Year'
                      AND ROWNUM < 10;


BEGIN

--Create ChangeSet ID


FOR X in C1 LOOP
      FOR Y IN (  SELECT orgcust.INTEGRATION_ID AS OCPGUID, XMLAGG(
          XMLELEMENT("Account",
          XMLELEMENT ("OrgCustEcmId", orgcust.INTEGRATION_ID),
          XMLELEMENT ("AccountTeams",
                       (SELECT XMLAGG
                              ( XMLELEMENT ("Team",
                                XMLELEMENT ("EmployeeId", USERDB.LOGIN ),
                                XMLELEMENT ("EmployeeNum", CONTACTDTL.EMP_NUM),
                                XMLELEMENT ("Role", ACCTNPOSTN.ROLE_CD)
                               )
                       )
                   FROM   SIEBEL.S_ACCNT_POSTN ACCTNPOSTN,
                             SIEBEL.S_POSTN POSTN ,
                             SIEBEL.S_USER USERDB,
                             SIEBEL.S_CONTACT CONTACTDTL,
                      SIEBEL.S_SYS_PREF SYP, -- Added as part of webstar#5602257 
                             SIEBEL.S_ORG_EXT CUSTOMER1
                       WHERE POSTN.ROW_ID =ACCTNPOSTN.POSITION_ID
                        AND USERDB.ROW_ID = POSTN.PR_EMP_ID
                        AND CONTACTDTL.ROW_ID=USERDB.PAR_ROW_ID
                        AND CUSTOMER1.ROW_ID = ACCTNPOSTN.OU_EXT_ID
                        AND CUSTOMER1.ROW_ID = orgcust.ROW_ID
                 AND SYP.VAL=POSTN.X_POSTN_YEAR AND syp.sys_pref_cd='LN Current Year' -- Added as part of webstar#5602257 
                   )
                   )
                   ) )  AS v_xml
                FROM SIEBEL.S_ORG_EXT orgcust
     WHERE orgcust.integration_id = X.ecmpguid
     AND   rownum < 2
     group by orgcust.INTEGRATION_ID
     )    LOOP
     
        --   DBMS_OUTPUT.PUT_LINE (' Law School : ' || Y.v_xml.getStringVal());
          -- content_length := length(y.v_xml.getClobVal());
           DBMS_OUTPUT.PUT_LINE ('Length :' ||content_length);
        i := i + 1;
        -- content := 'Welcome';
        content := Y.v_xml.getStringVal();
        
        url  := 'http://datalake-staging-proxy.lexis.com/objects/v1/'||Y.OCPGUID||'?collection-id=ProductMasterTestCollection';
   
        content_length := length(y.v_xml.getStringVal());
        utl_http.set_response_error_check(enable => false);
        utl_http.set_detailed_excp_support(enable => true);
        req := utl_http.begin_request(url, 'PUT');
        utl_http.set_header(r => req, name => 'collection-id', value => 'ProductMasterTestCollection');
        utl_http.set_header(r => req, name => 'x-api-key', value => '9Ps9jBw2dj87epSD1FH9X1GHtJfQXLTh9vcVWRa0');--'HY0xYkNF2K7wmHPKZYi1iAXaeunZhXQ5dhv0VQ5c');
        utl_http.set_header(r => req, name => 'Content-Type', value => 'application/xml');--'text/plain');
        utl_http.set_header(req, 'Content-Length', content_length);
        utl_http.write_text(req, content);
        res := utl_http.get_response(req);
        utl_http.read_text(res, respond);
        utl_http.end_response(res);
        dbms_output.put_line(respond);
        APEX_JSON.parse(respond);
    
       DBMS_OUTPUT.put_line('Request Id   : ' || APEX_JSON.get_varchar2(p_path => 'object."object-state"'));


        
        
       -- dbms_output.put_line('Published: '||r1.item_number);
      --  l_count:=l_count+1;
      
   END LOOP;
   
 END LOOP;   

DBMS_OUTPUT.PUT_LINE ('Number :'|| to_char(i));

EXCEPTION
    WHEN OTHERS THEN
    
       DBMS_OUTPUT.PUT_LINE ('Number :'|| to_char(i));
       utl_http.end_response(res);
        dbms_output.put_line(sqlerrm);
END;


