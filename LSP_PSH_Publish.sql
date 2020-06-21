DECLARE
/* This procedure does the following
  1) Read Credentials from reference table for file publish.
  2) Calculate Last updated Successful Publish from history table.
  3) Create XML(output file) for Posting in to PSH.
  4) Do Table updation appropriately based on the error message whether
     the file publish is success or failure.
*/

    --PSH credentials
    v_partition_guid   VARCHAR2(100);
    v_psh_part_url     VARCHAR2(400);
    v_psh_username     VARCHAR2(50);
    v_psh_password     VARCHAR2(50);
    V_ESB_URL          VARCHAR2(400);
    v_esb_username     VARCHAR2(50);
    v_esb_password     VARCHAR2(50);


    --Variables for File Publish Process
    v_last_epoc       NUMBER;
    v_xml_per_epoc    NUMBER;
    v_end_epoc        NUMBER;
    v_process_seq_id  NUMBER;
    v_record_counter  NUMBER;


    --Variables for Output File creation
    V_OUTPUT_FILE     CLOB;
    v_entry           CLOB;
    V_ATOM_FEED       CLOB;
    V_STABLE_FEED     CLOB;
    V_XML_DATA        CLOB;
    V_ATOM_LENGTH     NUMBER;
    V_LOOP_DATA       varchar2(32000);
    V_XML_BLOB        BLOB;
    V_XML_LEN         NUMBER;
    v_pimuuid         VARCHAR2(40)    :=NULL;
    v_build_type      VARCHAR2(30);
    v_error_message   varchar2(400);
    ventcur           SYS_REFCURSOR;
    ventrec           ventcur%TYPE;
    v_counter         NUMBER;
    xmlFETCH          XMLTYPE;


    -- Variables to Calculate Last successful date
    c_datemask        CONSTANT VARCHAR2 (8) := 'YYYYMMDD';
    c_datelow         CONSTANT VARCHAR2 (8) := '11110101';
    g_debug_step      VARCHAR2 (100);


    /* Variables for Logging utility */
    l_stage                  number;
    l_msg                varchar2(8000);



        TYPE accnt_type IS RECORD
        (
           forcedown_entityid   ln_lsp_publish_force_down.ecm_id%TYPE,
           entity_id            SIEBEL.S_ORG_EXT.integration_id%TYPE

        );

        v_accnt_team      accnt_type;

        /* Exception Definition*/
        EE_PSH_INFO_NOT_FOUND EXCEPTION;
        ee_epoc_not_found     EXCEPTION;
        EE_EXCEPTION_IN_POST EXCEPTION;


    FUNCTION get_last_processed_date
    (entity_type_i IN VARCHAR2)
        RETURN DATE
        IS
           vlastprocesseddate   DATE := NULL;
        BEGIN
           g_debug_step := 'pk_bi_extract.get_last_processed_date';

           -- Get the last successful run date. All siebel transactions that have been
           -- modfied since then will be extracted.
           SELECT NVL (MAX (h.start_time),
                    TO_DATE (c_datelow, c_datemask))
           INTO vlastprocesseddate
           FROM ln_process_history h
           WHERE   h.process_type = 'LSP_PUBLISH'
                   AND status = 'C';

           RETURN vlastprocesseddate;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Oldest date I could think of.
            vlastprocesseddate := TO_DATE (c_datelow, c_datemask);
            RETURN vlastprocesseddate;
        END;




      PROCEDURE open_cursor_factory (entity_cur_io OUT SYS_REFCURSOR,
                         P_process_seq_id NUMBER,
                       p_end_epoc NUMBER)
        IS
           v_last_processed_time   DATE;
        BEGIN
           v_process_seq_id      :=P_process_seq_id;
           v_end_epoc         :=p_end_epoc;
           g_debug_step          :='open_cursor_factory';
           v_last_processed_time := get_last_processed_date ('LSP_PUBLISH');

       OPEN entity_cur_io FOR

         SELECT
                   NULL AS fdown_ecmId,
                      customer1.integration_id ecmpguid
           FROM  siebel.s_accnt_postn acctnpostn,
                 siebel.s_postn postn,
                 siebel.s_user userdb,
                 siebel.s_contact contactdtl,
                 siebel.s_org_ext customer1,
              siebel.s_sys_pref syp, -- Added as part of webstar#5602257  
                        ln_lsp_publish_force_down fdown
          WHERE postn.row_id = acctnpostn.position_id
                      AND userdb.row_id = postn.pr_emp_id
                      AND contactdtl.row_id = userdb.par_row_id
                      AND customer1.row_id = acctnpostn.ou_ext_id
                      AND customer1.x_cust_class = 'Academic'
                      AND customer1.x_customer_subclass = 'Law Schools'
                      AND customer1.integration_id = fdown.ecm_id(+)
                      AND fdown.status(+) = 'A'
                      AND fdown.process_type(+) = 'LSP_PUBLISH'
                       AND ( ACCTNPOSTN.last_upd > v_last_processed_time
                             OR POSTN.last_upd > v_last_processed_time )
                      AND customer1.integration_id IS NOT NULL
                 AND customer1.accnt_type_cd = 'Customer'
                 AND syp.val=postn.x_postn_year AND syp.sys_pref_cd='LN Current Year' -- Added as part of webstar#5602257  
         UNION
         SELECT
               fdown.ecm_id AS fdown_ecmId ,
                      customer1.integration_id ecmpguid
          FROM   siebel.s_accnt_postn acctnpostn,
                      siebel.s_postn postn,
                      siebel.s_user userdb,
                      siebel.s_contact contactdtl,
                      siebel.s_org_ext customer1,
                 siebel.s_sys_pref syp, -- Added as part of webstar#5602257  
                      ln_lsp_publish_force_down fdown
         WHERE  postn.row_id = acctnpostn.position_id
                      AND userdb.row_id = postn.pr_emp_id
                   AND contactdtl.row_id = userdb.par_row_id
                      AND customer1.row_id = acctnpostn.ou_ext_id
                      AND customer1.x_cust_class = 'Academic'
               AND customer1.x_customer_subclass = 'Law Schools'
                      AND customer1.integration_id = fdown.ecm_id
               AND fdown.status = 'A'
               AND fdown.process_type = 'LSP_PUBLISH'
                       AND customer1.integration_id IS NOT NULL
                       AND customer1.accnt_type_cd = 'Customer'
           AND syp.val=postn.x_postn_year AND syp.sys_pref_cd='LN Current Year'; -- Added as part of webstar#5602257 

    EXCEPTION WHEN OTHERS
    THEN
       L_STAGE :=51;
       l_msg   :='-Exception While Querying Records.Error Message:'||SQLERRM;
           SP_LSP_PSH_LOG(v_process_seq_id,v_end_epoc,L_STAGE,l_msg);
           RAISE;
    END open_cursor_factory;

    PROCEDURE update_forcedown_status
    (forcedown_entityid_i     IN ln_lsp_publish_force_down.ecm_id%TYPE,
         forcedown_entitytype_i   IN ln_lsp_publish_force_down.process_type%TYPE)
        IS
        BEGIN
          IF forcedown_entityid_i IS NOT NULL
          THEN
            UPDATE
                  ln_lsp_publish_force_down f
            SET
                  f.status =  'I', f.last_modified = SYSDATE
            WHERE ecm_id = forcedown_entityid_i
                  AND UPPER (process_type) = forcedown_entitytype_i
                  AND STATUS='A';
          END IF;
        END update_forcedown_status;

-------------------------------------------------------------------------------

BEGIN

    v_process_seq_id :=seq_process_id_lsp.nextval;
    v_counter        :=1;
    v_record_counter :=0;
    v_error_message  :='S';

    --Starting the job So inserting record in to process history table
    BEGIN
      insert into ln_process_history (process_seq_id,process_type,status,start_time) values
      (v_process_seq_id,'LSP_PUBLISH','R',systimestamp);
      commit;

      SELECT EPOC_NO,XML_PER_EPOC
      INTO v_last_epoc,v_xml_per_epoc
      FROM LN_LSP_REFERENCE_TABLE
      WHERE PROCESS_NAME = 'LSP_PUBLISH';

      IF(v_last_epoc IS NULL) OR(v_xml_per_epoc IS NULL) THEN
            RAISE ee_epoc_not_found;
      END IF;

      v_end_epoc :=v_last_epoc+1;
      IF v_last_epoc = 0 THEN
          v_build_type := 'full';
      ELSE
          v_build_type := 'incremental';
      END IF;

      L_STAGE :=1;
      l_msg   := '-Process '||v_process_seq_id||' Started';
      SP_LSP_PSH_LOG(v_process_seq_id,v_end_epoc,L_STAGE,l_msg);
    End;

    /*Fetch PSH credentials*/
    SELECT sub_guid,psh_url,psh_username,psh_password,esb_url,esb_username,esb_password
    INTO v_partition_guid,v_psh_part_url,v_psh_username,v_psh_password,V_ESB_URL,v_esb_username,v_esb_password
    FROM LN_LSP_REFERENCE_TABLE WHERE process_name = 'LSP_PUBLISH';

    IF (v_partition_guid IS NULL) or (v_psh_part_url IS NULL) or (v_psh_username IS NULL) or
       (v_psh_password IS NULL) or (V_ESB_URL IS NULL) or (v_esb_username IS NULL) or
       (v_esb_password IS NULL) THEN
            RAISE EE_PSH_INFO_NOT_FOUND;
    END IF;

    IF NOT ventcur%ISOPEN
       THEN
       open_cursor_factory (entity_cur_io   => ventcur,
                            P_process_seq_id=>v_process_seq_id,
                            p_end_epoc=>v_end_epoc);

    END IF;


  LOOP
     FETCH ventcur INTO v_accnt_team;

     IF ventcur%NOTFOUND THEN
      IF v_counter>1 THEN
        L_STAGE :=4;
    l_msg   :='-Number of Records to be posted is lesser than xml per epoc';
        SP_LSP_PSH_LOG(v_process_seq_id,v_end_epoc,L_STAGE,l_msg);


        V_ATOM_FEED :='<?xml version="1.0" encoding="utf-8"?>'||CHR(13)||CHR(10)
                       ||'<feed xmlns="http://www.w3.org/2005/Atom" xmlns:app="http://www.w3.org/2007/app" xmlns:lnpub="http://services.lexisnexis.com/interfaces/publish/lnpub/1">'||CHR(13)||CHR(10)
                       ||'<title>LSP PUBLISH</title>'||CHR(13)||CHR(10)
                       ||'<subtitle>'||v_last_epoc||'-'||v_end_epoc||'</subtitle>'||CHR(13)||CHR(10)
                       ||'<id>urn:uuid:'||TRIM(v_PIMUUID)||'</id>'||CHR(13)||CHR(10)
                       ||'<updated>'||TO_CHAR(SYSDATE,'YYYY-MM-DD')||'T'||TO_CHAR(SYSDATE,'HH24:MI:SS')||'</updated>'||CHR(13)||CHR(10)
                       ||'<lnpub:publishType>'||v_build_type||'</lnpub:publishType>'||CHR(13)||CHR(10)
                       ||v_entry||'</feed>'||CHR(13)||CHR(10)||CHR(13)||CHR(10);


        SELECT DBMS_LOB.GETLENGTH(V_ATOM_FEED) INTO V_ATOM_LENGTH from dual;
        V_STABLE_FEED :='--yytet00pubSubBoundary00tetyy'||CHR(13)||CHR(10)||
                        'Content-Type: application/x-account-team+xml;version=1'||CHR(13)||CHR(10)||
                'Content-Length: '||V_ATOM_LENGTH||CHR(13)||CHR(10)||CHR(13)||CHR(10)||V_ATOM_FEED;
        V_OUTPUT_FILE :=V_STABLE_FEED||V_XML_DATA||
                       '--yytet00pubSubBoundary00tetyy--'||CHR(13)||CHR(10);

        SP_LSP_POST_TO_PSH(v_partition_guid,v_psh_part_url,v_psh_username,v_psh_password,
    V_ESB_URL,v_esb_username,v_esb_password,v_pimuuid,v_build_type,v_process_seq_id,
    V_OUTPUT_FILE,v_last_epoc,v_end_epoc,V_XML_LEN,v_error_message);

    L_STAGE :=5;
    l_msg   :='-After File Publish Process.Error Message:'||v_error_message;
        SP_LSP_PSH_LOG(v_process_seq_id,v_end_epoc,L_STAGE,l_msg);

    IF v_error_message = 'F' THEN
       L_STAGE :=6;
       l_msg   :='-Rolling Back DML Processes';
           SP_LSP_PSH_LOG(v_process_seq_id,v_end_epoc,L_STAGE,l_msg);
       ROLLBACK TO SAVEPOINT SP1;
    ELSE
       update LN_LSP_REFERENCE_TABLE set EPOC_NO= v_end_epoc where PROCESS_NAME = 'LSP_PUBLISH';
       commit;
       L_STAGE :=7;
       l_msg   :='-Successfully Updated EPOC NO. in Reference Table after File Publish';
           SP_LSP_PSH_LOG(v_process_seq_id,v_end_epoc,L_STAGE,l_msg);
    END IF;
        EXIT;
      ELSE
        L_STAGE :=8;
    l_msg   :='-No Records returned by the Query';
        SP_LSP_PSH_LOG(v_process_seq_id,v_end_epoc,L_STAGE,l_msg);
        EXIT;
      END IF;
     END IF;

     v_pimuuid := LOWER(regexp_replace(rawtohex(sys_guid()),   '([A-F0-9]{8})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{12})',   '\1-\2-\3-\4-\5'));

     SELECT XMLAGG(
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
                   )
              ) INTO xmlFETCH
     FROM SIEBEL.S_ORG_EXT orgcust
     WHERE orgcust.integration_id = v_accnt_team.entity_id
     AND   rownum < 2;

     SELECT EPOC_NO,XML_PER_EPOC
     INTO v_last_epoc,v_xml_per_epoc
     FROM LN_LSP_REFERENCE_TABLE
     WHERE PROCESS_NAME = 'LSP_PUBLISH';

     IF(v_last_epoc IS NULL) OR(v_xml_per_epoc IS NULL) THEN
          RAISE ee_epoc_not_found;
     END IF;

     IF v_counter= 1 THEN
        v_end_epoc :=v_last_epoc+1;
        SAVEPOINT SP1;
     END IF;



     --entry will be created for each record
     v_entry :=v_entry||'<entry>'||CHR(13)||CHR(10)
               ||'<title>publish</title>'||CHR(13)||CHR(10)
           ||'<id>NACRM.'||v_accnt_team.entity_id||'.'||v_accnt_team.entity_id||'</id>'||CHR(13)||CHR(10)
           ||'<updated>'||TO_CHAR(SYSDATE,'YYYY-MM-DD')||'T'||TO_CHAR(SYSDATE,'HH24:MI:SS')||'</updated>'||CHR(13)||CHR(10)
           ||'<app:control>'||CHR(13)||CHR(10)
           ||'<lnpub:action>add</lnpub:action>'||CHR(13)||CHR(10)
           ||'</app:control>'||CHR(13)||CHR(10)
           ||'<lnpub:rights><!-- future ODRL --></lnpub:rights>'||CHR(13)||CHR(10)
           ||'<content type="application/x-account-team+xml;version=1" src="cid:NACRM.'||v_accnt_team.entity_id||'.'||v_accnt_team.entity_id||'@master.lexisnexis.com"/>'||CHR(13)||CHR(10)
           ||'</entry>'||CHR(13)||CHR(10);


    CONVERT_CLOB_TO_BLOB(xmlFETCH.getClobVal, v_xml_blob);

    SELECT DBMS_LOB.GETLENGTH(V_XML_BLOB)INTO V_XML_LEN from   dual;

    V_LOOP_DATA :='--yytet00pubSubBoundary00tetyy'||CHR(13)||CHR(10)||
              'Content-ID: NACRM.'||v_accnt_team.entity_id||'.'||v_accnt_team.entity_id||'@master.lexisnexis.com'||CHR(13)||CHR(10)||
              'Content-Type: application/x-account-team+xml;version=1'||CHR(13)||CHR(10)||
              'Content-Length: '||v_XML_LEN||CHR(13)||CHR(10)||CHR(13)||CHR(10)||
          xmlFETCH.getClobVal||chr(13)||chr(10)||chr(13)||chr(10);

    V_XML_DATA :=V_XML_DATA||V_LOOP_DATA;

    if v_counter =v_xml_per_epoc THEN
        V_ATOM_FEED :='<?xml version="1.0" encoding="utf-8"?>'||CHR(13)||CHR(10)
                     ||'<feed xmlns="http://www.w3.org/2005/Atom" xmlns:app="http://www.w3.org/2007/app" xmlns:lnpub="http://services.lexisnexis.com/interfaces/publish/lnpub/1">'||CHR(13)||CHR(10)
                 ||'<title>LSP PUBLISH</title>'||CHR(13)||CHR(10)
                 ||'<subtitle>'||v_last_epoc||'-'||v_end_epoc||'</subtitle>'||CHR(13)||CHR(10)
                 ||'<id>urn:uuid:'||TRIM(v_PIMUUID)||'</id>'||CHR(13)||CHR(10)

                 ||'<updated>'||TO_CHAR(SYSDATE,'YYYY-MM-DD')||'T'||TO_CHAR(SYSDATE,'HH24:MI:SS')||'</updated>'||CHR(13)||CHR(10)
                 ||'<lnpub:publishType>'||v_build_type||'</lnpub:publishType>'||CHR(13)||CHR(10)
                 ||v_entry||'</feed>'||CHR(13)||CHR(10)||CHR(13)||CHR(10);
    SELECT DBMS_LOB.GETLENGTH(V_ATOM_FEED) INTO V_ATOM_LENGTH from dual;
    V_STABLE_FEED :='--yytet00pubSubBoundary00tetyy'||CHR(13)||CHR(10)||
                    'Content-Type: application/x-account-team+xml;version=1'||CHR(13)||CHR(10)||
            'Content-Length: '||V_ATOM_LENGTH||CHR(13)||CHR(10)||CHR(13)||CHR(10)||V_ATOM_FEED;
    V_OUTPUT_FILE :=V_STABLE_FEED||V_XML_DATA||
                '--yytet00pubSubBoundary00tetyy--'||CHR(13)||CHR(10);



    SP_LSP_POST_TO_PSH(v_partition_guid,v_psh_part_url,v_psh_username,v_psh_password,
    V_ESB_URL,v_esb_username,v_esb_password,v_pimuuid,v_build_type,v_process_seq_id,
    V_OUTPUT_FILE,v_last_epoc,v_end_epoc,V_XML_LEN,v_error_message);


    L_STAGE :=9;
        l_msg   :='-After File Publish Process.Error Message:'||v_error_message;
        SP_LSP_PSH_LOG(v_process_seq_id,v_end_epoc,L_STAGE,l_msg);
        IF v_error_message = 'F' THEN
           L_STAGE :=10;
       l_msg   :='-Rolling Back DML Processes';
           SP_LSP_PSH_LOG(v_process_seq_id,v_end_epoc,L_STAGE,l_msg);
           ROLLBACK TO SAVEPOINT SP1;
        ELSE
          update LN_LSP_REFERENCE_TABLE set EPOC_NO= v_end_epoc where PROCESS_NAME = 'LSP_PUBLISH';
          commit;
          L_STAGE :=11;
      l_msg   :='-Successfully Updated EPOC NO. in Reference Table after File Publish';
          SP_LSP_PSH_LOG(v_process_seq_id,v_end_epoc,L_STAGE,l_msg);
        END IF;

        V_STABLE_FEED :=NULL;
        V_XML_DATA    :=NULL;
        V_LOOP_DATA   :=NULL;
        v_entry       :=NULL;
        v_counter     := 1;

    ELSE

       v_counter :=v_counter+1;

    END IF;

    update_forcedown_status(v_accnt_team.entity_id, 'LSP_PUBLISH');
    insert into LN_LSP_SUCCESS_TABLE (ECM_ID,EPOC_NO,PROCESS_SEQ_ID,CREATED_DATE)
    values(v_accnt_team.entity_id, v_end_epoc,v_process_seq_id,systimestamp);

    --Record Counter Used to Hold count of Number of Records
    v_record_counter :=v_record_counter+1;

  END LOOP;


  if v_error_message <>'F' THEN
    L_STAGE :=12;
    l_msg   :='-Total Number of Record Processed in '||v_process_seq_id||' process is:'||v_record_counter;
    SP_LSP_PSH_LOG(v_process_seq_id,v_end_epoc,L_STAGE,l_msg);

    --After Process completion Status is changed to 'Completed' from 'Running'
    UPDATE LN_PROCESS_HISTORY SET STATUS='C',END_TIME=systimestamp,RECORDS_PROCESSED_PER_PROCESS=v_record_counter WHERE PROCESS_SEQ_ID=v_process_seq_id;
    commit;

    L_STAGE :=13;
    l_msg   :='-'||v_process_seq_id||'Process Completed Successfully.';
    SP_LSP_PSH_LOG(v_process_seq_id,v_end_epoc,L_STAGE,l_msg);
  ELSE
     L_STAGE :=52;
     l_msg   :='-Exception Happened in SP_LSP_POST_TO_PSH Procedure';
     SP_LSP_PSH_LOG(v_process_seq_id,v_end_epoc,L_STAGE,l_msg);
     RAISE EE_EXCEPTION_IN_POST;
  END IF;
Exception
WHEN ee_epoc_not_found THEN
    L_STAGE :=2;
    l_msg   :='-Last or XML Per EPOC is null';
    SP_LSP_PSH_LOG(v_process_seq_id,v_end_epoc,L_STAGE,l_msg);
    RAISE;
WHEN EE_PSH_INFO_NOT_FOUND THEN
    L_STAGE :=3;
    l_msg   :='-One or more of the PSH Credential values is null';
    SP_LSP_PSH_LOG(v_process_seq_id,v_end_epoc,L_STAGE,l_msg);
    RAISE;
WHEN EE_EXCEPTION_IN_POST THEN
    RAISE;
When others then
    L_STAGE :=14;
    l_msg   :='-Error in Program Level.Error Message:'||SQLERRM;
    SP_LSP_PSH_LOG(v_process_seq_id,v_end_epoc,L_STAGE,l_msg);
    RAISE;
END;
