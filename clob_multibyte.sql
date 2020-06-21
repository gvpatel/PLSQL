   CREATE TABLE TEMP_LOB (A CLOB);
   
   DECLARE
    content          CLOB;
    i number := 1;
   BEGIN
   
    dbms_lob.createtemporary(content, TRUE);
        for C1 in (select * from TEMP_AP_ENGAGEMENT_CCPA_VW )
        loop
        
         dbms_lob.append(content, i||','||C1.AFF_PER_ID||','||C1.PREFIX||','||C1.FIRST_NAME||','||C1.MIDDLE_NAME||','||C1.LAST_NAME||','||C1.EMAIL||','||C1.ADDR1||','||C1.ADDR2||','||C1.City||','||C1.State||','||C1.PostalCode||','||C1.Country||','||C1.ENGAGEMENT_DATE||','||C1.ENGAGEMENT_TYPE||','||C1.CUSTOMER_FLAG|| chr(13) || chr(10) );
          i :=  i + 1; 
      end loop;
      INSERT INTO TEMP_LOB VALUES (content);
      COMMIT;
   END;   
   
   SELECT * FROM TEMP_LOB
   delete from TEMP_LOB
      