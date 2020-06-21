SET SERVEROUTPUT ON;

set define off

DECLARE
    req              utl_http.req;
    res              utl_http.resp;
    --'http://datalake.content.aws.lexis.com/objects/v1/testobject1?collection-id=ProductMasterTestCollection'
    base_url         VARCHAR2(400) := 'http://datalake-staging-proxy.lexis.com/objects/v1/';
    end_url          VARCHAR2(400) := '?collection-id=ProductMasterTestCollection';
    --url              VARCHAR2(800):='http://datalake-staging-proxy.lexis.com/objects/v1/Testobject1?collection-id=ProductMasterTestCollection';
    url varchar2(1000) := 'http://dev1-ecm.lexisnexis.com/RealTimeOutbound/retention/publishEngagementRecords?contactLogin=patelgv&contactEmail=gaurang.patel@lexisnexis.com&engagementSource=GCRM';
    
    name             VARCHAR2(4000);
  --  buffer           VARCHAR2(4000);
    content          CLOB;
    content_blob     BLOB;
    content_length   NUMBER;
    respond          VARCHAR2(4000);
     my_clob clob;
    l_count number:=0;
  --  l_obj JSON_OBJECT_T;
  
    buffer          RAW(32767);
    amount          NUMBER := 25000;
    offset          NUMBER := 1;
    i number := 1;
    compressed_blob BLOB;
    
     lco_boundary constant varchar2(30) := 'gc0p4Jq0M2Yt08jU534c0p';
     l_newline varchar2(50) := chr(13) || chr(10);
   l_http_response utl_http.resp;
  l_response_header_name varchar2(256);
  l_response_header_value varchar2(1024);
  l_response_body varchar2(32767);
 
 
BEGIN
   
  -- SELECT APEX_UTIL.URL_ENCODE('http://int1-ecm.lexisnexis.com/RealTimeOutbound/retention/publishEngagementRecords?contactLogin=patelgv&contactEmail=gaurang.patel@lexisnexis.com&engagementSource=GCRM')
--INTO url FROM DUAL;


    
      --  content := 'Welcome';
       DELETE from TEMP_BLOB;
       COMMIT;
       dbms_lob.createtemporary(content_blob, TRUE);
       
           dbms_lob.append(content_blob, UTL_RAW.CAST_TO_RAW ( l_newline
|| '--' || lco_boundary || l_newline
|| 'Content-Disposition: form-data; name="file"; filename="file.zip"' || l_newline
|| 'Content-Type: application/zip' || l_newline
|| l_newline ) );

       
       dbms_lob.append(content_blob,  UTL_RAW.CAST_TO_RAW( 'AFF_PER_ID,SRC_PK,PREFIX,FIRST_NAME,MIDDLE_NAME,LAST_NAME,WORK_PHONE,MOBILE_PHONE,EMAIL,ADDRESS_LINE1,ADDRESS_LINE2,CITY,STATE,POSTAL_CODE,COUNTRY,ENGAGEMENT_DATE,ENGAGEMENT_TYPE,CUSTOMER_FLAG'|| chr(13) || chr(10)));  
       
        for C1 in (select * from TEMP_AP_ENGAGEMENT_CCPA_VW1 where rownum < 15 )
        loop
         dbms_lob.append(content_blob,  UTL_RAW.CAST_TO_RAW( '"'||C1.AFF_PER_ID||'","'||C1.AFF_PER_ID||'","'||C1.PREFIX||'","'||C1.FIRST_NAME||'","'||C1.MIDDLE_NAME||'","'||C1.LAST_NAME||'","'||C1.EMAIL||'","'||C1.ADDRESS_LINE1||'","'||C1.ADDRESS_LINE2||'","'||C1.City||'","'||C1.State||'","'||C1.Postal_Code||'","'||C1.Country||'","'||C1.ENGAGEMENT_DATE||'","'||C1.ENGAGEMENT_TYPE||'","'||C1.CUSTOMER_FLAG||'"'|| chr(13) || chr(10)));
         i := i + 1; 
      end loop;
      
     dbms_lob.append(content_blob, UTL_RAW.CAST_TO_RAW(    l_newline
|| '--' || lco_boundary || '--'));

 /*dbms_lob.append(content_blob, UTL_RAW.CAST_TO_RAW(
  l_newline
 || l_newline
|| '--' || lco_boundary || l_newline
|| 'Content-Disposition: form-data; name="payload"' || l_newline
|| l_newline
|| '{"name":"transaction created from Oracle","documents":[{"name":"file.zip"}]}' || l_newline
|| '--' || lco_boundary || '--'));
 

 
 
/*
  dbms_lob.append(content_blob, UTL_RAW.CAST_TO_RAW(    l_newline
|| '--' || lco_boundary || l_newline
|| 'Content-Disposition: form-data; name="filename"' || l_newline
|| l_newline
|| 'file' || l_newline
|| '--' || lco_boundary || '--'));

/*
l_newline
|| 'Content-Disposition: form-data; name="MAX_FILE_SIZE"' || l_newline
|| l_newline
|| '4000000' || l_newline
|| '--' || lco_boundary || '--'));
 */
 
      
       INSERT INTO TEMP_BLOB(A,B) VALUES (content_blob, UTL_COMPRESS.LZ_COMPRESS(content_blob,9) );
       COMMIT;
       
       
       
       compressed_blob := UTL_COMPRESS.LZ_COMPRESS(content_blob,9);                 
       
             
       
          
        content_length := DBMS_LOB.getlength(compressed_blob);
        dbms_output.put_line('Content Length :'||content_length);
        utl_http.set_response_error_check(enable => false);
        utl_http.set_detailed_excp_support(enable => true);
        req := utl_http.begin_request(url, 'POST');
      --  utl_http.set_header(r => req, name => 'collection-id', value => 'ProductMasterTestCollection');
      --  utl_http.set_header(r => req, name => 'x-api-key', value => '9Ps9jBw2dj87epSD1FH9X1GHtJfQXLTh9vcVWRa0');--'HY0xYkNF2K7wmHPKZYi1iAXaeunZhXQ5dhv0VQ5c');
      --  utl_http.set_header(r => req, name => 'Content-Type', value => 'application/zip');--'text/plain');
        
         utl_http.set_header(r => req, name => 'Content-Type', value => 'multipart/form-data; boundary="' || lco_boundary || '"');
         
         UTL_HTTP.set_header (req , 'Transfer-Encoding', 'chunked');
   
       WHILE (offset < content_length)
       LOOP
       BEGIN
          DBMS_LOB.read (compressed_blob,
                         amount,
                         offset,
                         buffer);
       --  dbms_output.put_line('Buffer  :' || buffer);                
        EXCEPTION
        WHEN OTHERS THEN
           dbms_output.put_line('IN CLOB BLOCK');
         --  dbms_output.put_line(' EXCE Buffer  :' || buffer);
            dbms_output.put_line(sqlerrm);
        END;    
        
          begin               
          UTL_HTTP.write_raw(req, buffer);
          exception
          when others then
            dbms_output.put_line('IN BLOCK');
            dbms_output.put_line(sqlerrm);
          end;  
       --   dbms_output.put_line('WRITING :' ||offset ); 
          offset := offset + amount;
         
       END LOOP;
  
 --  end if;
              
          dbms_output.put_line('END WRITING');    
  /*
    --    utl_http.write_text(req, content);
        res := utl_http.get_response(req);
        utl_http.read_text(res, respond);
        utl_http.end_response(res);
        dbms_output.put_line(respond);
       -- dbms_output.put_line('Published: '||r1.item_number);
      --  l_count:=l_count+1;
  */    
      
      l_http_response := utl_http.get_response(req);
  dbms_output.put_line('Response> Status Code: ' || l_http_response.status_code);
  dbms_output.put_line('Response> Reason Phrase: ' || l_http_response.reason_phrase);
  dbms_output.put_line('Response> HTTP Version: ' || l_http_response.http_version);
 
  for i in 1 .. utl_http.get_header_count(l_http_response) loop
    utl_http.get_header(l_http_response, i, l_response_header_name, l_response_header_value);
    dbms_output.put_line('Response> ' || l_response_header_name || ': ' || l_response_header_value);
  end loop;
 
  utl_http.read_text(l_http_response, l_response_body, 32767);
  dbms_output.put_line('Response body>');
  dbms_output.put_line(l_response_body);
 

EXCEPTION
    when utl_http.end_of_body then
        utl_http.end_response(res);
        dbms_output.put_line(sqlerrm);
    WHEN OTHERS THEN
        dbms_output.put_line(sqlerrm);
        utl_http.end_response(res);
               
END;


