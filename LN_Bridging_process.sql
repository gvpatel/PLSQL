--SIEBELWORK table
select * from SIEBELWORK.LN_AUTOBRIDGING_HEADER

SELECT * FROM SIEBELWORK.LN_AUTOBRIDGING_LINEITEM 

select * from CX_LN_BRIDG_HR 

select * from  SIEBEL.CX_LN_BRIDG_LIN 

--Business service
LN Bridging Load New 

-- Stored proc called by Legacy system and insert data into SIEBELWORK staging tables
-- RCR calls WF (LN LDC LA Bridging Master)
-- WF calls BS 
-- BS scan sieblework table and insert into Siebel CX table
-- wf CALL ansother BS (LN Bridging Validation) and Validate data in Siebel table
-- Create order with Peidng status based on the header and line item data using Siebel EAI adaptor
-- WF policy submits all bridging orders
-- WF policy calls WF (LN LDC LA Submit Bridging Orders)

-- Content mapping from legacy to BPS -- Anjali/ Doug MILLER