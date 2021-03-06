CREATE OR REPLACE PROCEDURE SP_LSP_DATALAKE_PUBLISH
AS

    req              utl_http.req;
    res              utl_http.resp;   
    base_url         VARCHAR2(400); 
    end_url          VARCHAR2(400); 
    v_chgSetBaseURL  VARCHAR2(800); 
    v_chgSetURL      VARCHAR2(800);
    vChangeSetID     VARCHAR2(500);
    url              VARCHAR2(800); 
    v_collection     VARCHAR2(100);
    v_apikey         VARCHAR2(100); 
    name             VARCHAR2(4000);
    buffer           VARCHAR2(4000);
    content          CLOB;
    content_blob     BLOB;
    content_length   NUMBER;
    respond          VARCHAR2(4000);
    l_count number:=0;
    v_xml          XMLTYPE;
    i NUMBER := 0;
    l_cursor SYS_REFCURSOR;
    v_epoch     NUMBER;
    v_publish_type   CHAR(1);
 

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

   SELECT DL_URL,DL_COLLECTION,DL_API_KEY,EPOCH_NUM,FULL_PUBLISH
     INTO  base_url,v_collection,v_apikey,v_epoch, v_publish_type
    FROM LN_DATALAKE_REFERENCE 
    WHERE DL_PROCESS_NAME = 'LSP_PUBLISH';    
         

--Create ChangeSet ID
        v_chgSetURL := base_url||'changeset?description='||'GCRM'||TO_CHAR(SYSDATE,'MMDDYYYYHH24MISS');
        dbms_output.put_line (' URL :' || v_chgSetURL);
        utl_http.set_response_error_check(enable => false);
        utl_http.set_detailed_excp_support(enable => true);
        req := utl_http.begin_request(v_chgSetURL, 'POST');   
        utl_http.set_header(r => req, name => 'x-api-key', value => v_apikey);
        res := utl_http.get_response(req);
        utl_http.read_text(res, respond);
        utl_http.end_response(res);
        dbms_output.put_line(respond);
        APEX_JSON.parse(respond);    
        vChangeSetID := APEX_JSON.get_varchar2(p_path => 'changeset."changeset-id"');
        DBMS_OUTPUT.put_line('Request Id   : ' || APEX_JSON.get_varchar2(p_path => 'changeset."changeset-id"')); 
        DBMS_OUTPUT.put_line('Request Id   : ' || APEX_JSON.get_varchar2(p_path => 'changeset."changeset-state"')); 

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
        
       
        url := base_url||Y.OCPGUID||'?collection-id='||v_collection;
   
        content_length := length(y.v_xml.getStringVal());
        utl_http.set_response_error_check(enable => false);
        utl_http.set_detailed_excp_support(enable => true);
        req := utl_http.begin_request(url, 'PUT');
        utl_http.set_header(r => req, name => 'collection-id', value => v_collection);
        utl_http.set_header(r => req, name => 'x-api-key', value => v_apikey);--'HY0xYkNF2K7wmHPKZYi1iAXaeunZhXQ5dhv0VQ5c');
        utl_http.set_header(r => req, name => 'changeset-id', value => vChangeSetID);
        utl_http.set_header(r => req, name => 'Content-Type', value => 'application/xml');--'text/plain');
        utl_http.set_header(r => req, name => 'x-dl-meta-title', value => 'publish');
        utl_http.set_header(r => req, name => 'x-dl-meta-id', value => 'NACRM.'||Y.OCPGUID||'.'||Y.OCPGUID);
        utl_http.set_header(r => req, name => 'x-dl-meta-action', value => 'add');
        utl_http.set_header(r => req, name => 'x-dl-meta-contenttype', value => 'application/x-account-team+xml;version=1');
        utl_http.set_header(r => req, name => 'x-dl-meta-contenttypesrc', value => 'cid:NACRM.'||Y.OCPGUID||'.'||Y.OCPGUID||'@master.lexisnexis.com');
        utl_http.set_header(r => req, name => 'x-dl-meta-updated',  value => TO_CHAR(SYSDATE,'YYYY-MM-DD')||'T'||TO_CHAR(SYSDATE,'HH24:MI:SS'));
        
        utl_http.set_header(req, 'Content-Length', content_length);
        utl_http.write_text(req, content);
        res := utl_http.get_response(req);
        utl_http.read_text(res, respond);
        utl_http.end_response(res);
        dbms_output.put_line(respond);
        APEX_JSON.parse(respond);
    
       DBMS_OUTPUT.put_line('Request Id   : ' || APEX_JSON.get_varchar2(p_path => 'object."object-state"'));      
    END LOOP;
   
  END LOOP;   

-- Create atom feed (JSON)  
      OPEN l_cursor FOR
        SELECT  
          'GCRM LSP Publish' AS "title"
          , EPOCH_NUM||'-' ||(EPOCH_NUM + 1)  AS "subtitle"
          ,'urn:uuid:'||LOWER(regexp_replace(rawtohex(sys_guid()),   '([A-F0-9]{8})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{12})',   '\1-\2-\3-\4-\5')) as "id"
          , TO_CHAR(SYSDATE,'YYYY-MM-DD')||'T'||TO_CHAR(SYSDATE,'HH24:MI:SS') AS "updated"
          , 'incremental' as "lnpub:publishType"    
            FROM LN_DATALAKE_REFERENCE 
         WHERE DL_PROCESS_NAME = 'LSP_PUBLISH'; 
    
    
       APEX_JSON.initialize_clob_output;
       APEX_JSON.open_object;
       APEX_JSON.write('changeset-metadata', l_cursor);
       APEX_JSON.close_object;
       DBMS_OUTPUT.put_line(APEX_JSON.get_clob_output);
       APEX_JSON.free_output;  
       
       content_length := length(APEX_JSON.get_clob_output);
-- Close ChangeSet
       v_chgSetURL := NULL;
--Create ChangeSet ID
        v_chgSetURL := base_url||'changeset/'||vChangeSetID;
        dbms_output.put_line (' URL :' || v_chgSetURL);
        
      --  utl_http.set_header(req, 'Content-Length', content_length);
        utl_http.set_response_error_check(enable => false);
        utl_http.set_detailed_excp_support(enable => true);
        req := utl_http.begin_request(v_chgSetURL, 'POST');
        utl_http.set_header(r => req, name => 'Content-Type', value => 'application/json');--'text/plain');
        utl_http.set_header(r => req, name => 'x-api-key', value => v_apikey);        
        utl_http.write_text(req, APEX_JSON.get_clob_output);
        res := utl_http.get_response(req);
        utl_http.read_text(res, respond);
        utl_http.end_response(res);
        dbms_output.put_line(respond);
        APEX_JSON.parse(respond);    
       -- vChangeSetID := APEX_JSON.get_varchar2(p_path => 'changeset."changeset-id"');
        DBMS_OUTPUT.put_line('ChangeSet   : ' || APEX_JSON.get_varchar2(p_path => 'changeset."changeset-state"')); 

        UPDATE LN_DATALAKE_REFERENCE SET  EPOCH_NUM = EPOCH_NUM + 1
        WHERE  DL_PROCESS_NAME = 'LSP_PUBLISH';
        
        COMMIT;


DBMS_OUTPUT.PUT_LINE ('Number :'|| to_char(i));

EXCEPTION
    WHEN OTHERS THEN
    
       DBMS_OUTPUT.PUT_LINE ('Number :'|| to_char(i));
       utl_http.end_response(res);
        dbms_output.put_line(sqlerrm);
END;


