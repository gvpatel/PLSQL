SET SERVEROUTPUT ON;

DECLARE
   
    content          CLOB;
    content_blob     BLOB;
    content_length   NUMBER;
    respond          VARCHAR2(4000);
    i number := 1;
    
     l_compressed_blob    BLOB;
    l_uncompressed_blob  BLOB;

BEGIN
   
     
       delete from TEMP_BLOB;
       COMMIT;
       dbms_lob.createtemporary(content_blob, TRUE);
        for C1 in (select * from TEMP_AP_ENGAGEMENT_CCPA_VW )
        loop
         dbms_lob.append(content_blob,  UTL_RAW.CAST_TO_RAW( '"'||C1.AFF_PER_ID||'","'||C1.PREFIX||'","'||C1.FIRST_NAME||'","'||C1.MIDDLE_NAME||'","'||C1.LAST_NAME||'","'||C1.EMAIL||'","'||C1.ADDR1||'","'||C1.ADDR2||'","'||C1.City||'","'||C1.State||'","'||C1.PostalCode||'","'||C1.Country||'","'||C1.ENGAGEMENT_DATE||'","'||C1.ENGAGEMENT_TYPE||'","'||C1.CUSTOMER_FLAG||'"'|| chr(13) || chr(10)));
         i := i + 1; 
      end loop;
      
         INSERT INTO TEMP_BLOB(A,B) VALUES (content_blob, UTL_COMPRESS.LZ_COMPRESS(content_blob,9) );
       COMMIT;
 END;      