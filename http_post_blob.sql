SET SERVEROUTPUT ON;

DECLARE
    req              utl_http.req;
    res              utl_http.resp;
    --'http://datalake.content.aws.lexis.com/objects/v1/testobject1?collection-id=ProductMasterTestCollection'
    base_url         VARCHAR2(400) := 'http://datalake-staging-proxy.lexis.com/objects/v1/';
    end_url          VARCHAR2(400) := '?collection-id=ProductMasterTestCollection';
    url              VARCHAR2(800):='http://datalake-staging-proxy.lexis.com/objects/v1/Testobject1?collection-id=ProductMasterTestCollection';
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

BEGIN
   
      --  content := 'Welcome';
       DELETE from TEMP_BLOB;
       COMMIT;
       dbms_lob.createtemporary(content_blob, TRUE);
        for C1 in (select * from TEMP_AP_ENGAGEMENT_CCPA_VW where rownum < 15 )
        loop
         dbms_lob.append(content_blob,  UTL_RAW.CAST_TO_RAW( '"'||C1.AFF_PER_ID||'","'||C1.PREFIX||'","'||C1.FIRST_NAME||'","'||C1.MIDDLE_NAME||'","'||C1.LAST_NAME||'","'||C1.EMAIL||'","'||C1.ADDR1||'","'||C1.ADDR2||'","'||C1.City||'","'||C1.State||'","'||C1.PostalCode||'","'||C1.Country||'","'||C1.ENGAGEMENT_DATE||'","'||C1.ENGAGEMENT_TYPE||'","'||C1.CUSTOMER_FLAG||'"'|| chr(13) || chr(10)));
         i := i + 1; 
      end loop;
      
         INSERT INTO TEMP_BLOB(A,B) VALUES (content_blob, UTL_COMPRESS.LZ_COMPRESS(content_blob,9) );
       COMMIT;
       
       compressed_blob := UTL_COMPRESS.LZ_COMPRESS(content_blob,9);
       
       
          
        content_length := DBMS_LOB.getlength(compressed_blob);
        dbms_output.put_line('Content Length :'||content_length);
        utl_http.set_response_error_check(enable => false);
        utl_http.set_detailed_excp_support(enable => true);
        req := utl_http.begin_request(url, 'PUT');
        utl_http.set_header(r => req, name => 'collection-id', value => 'ProductMasterTestCollection');
        utl_http.set_header(r => req, name => 'x-api-key', value => '9Ps9jBw2dj87epSD1FH9X1GHtJfQXLTh9vcVWRa0');--'HY0xYkNF2K7wmHPKZYi1iAXaeunZhXQ5dhv0VQ5c');
        utl_http.set_header(r => req, name => 'Content-Type', value => 'application/zip');--'text/plain');
     
      
      
  

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
    --    utl_http.write_text(req, content);
        res := utl_http.get_response(req);
        utl_http.read_text(res, respond);
        utl_http.end_response(res);
        dbms_output.put_line(respond);
       -- dbms_output.put_line('Published: '||r1.item_number);
      --  l_count:=l_count+1;

EXCEPTION
    when utl_http.end_of_body then
        utl_http.end_response(res);
        dbms_output.put_line(sqlerrm);
    WHEN OTHERS THEN
        dbms_output.put_line(sqlerrm);
        utl_http.end_response(res);
               
END;


