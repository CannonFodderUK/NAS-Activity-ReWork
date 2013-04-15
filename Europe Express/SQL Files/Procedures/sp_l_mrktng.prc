SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:38 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE SP_L_MRKTNG
AS
   --
   v_code            NUMBER (5);
   v_error_message   VARCHAR2 (512);
--

BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE DREF_MARKETING';

   INSERT INTO DREF_MARKETING
      (SELECT BORA,
              GLCODE,
              FISCALYEAR,
              CALENDAR_MONTH,
              MPERIOD,
              WEEK,
              DIVISION,
              CHANNEL,
              BRAND,
              SUPPLIER,
              ACTUAL,
              DESCRIPTION,
              OFFERDATE,
              OFFER,
              PRICE,
              MARKETCODE,
              CLICKS,
              IMPRESSIONS,
              CTR,
              AVGCPC,
              COSTPERGOOGLE,
              AVGPOSITION,
              SOURCE_TYPE,
              MEDIUM,
              BUDGET,
              AFFILIATE,
              CUSTOMER,
              GROUPTYPE
         FROM L_MARKETING);

   COMMIT;
EXCEPTION
   --
   -- A serious error has occured
   --
   WHEN OTHERS
   THEN
      --
      v_code := SQLCODE;
      v_error_message := SQLERRM;

      --
      INSERT INTO integration_errors (load_table_abbrev,
                                      target_table_name,
                                      error_date,
                                      ERROR_CODE,
                                      error_desc)
           VALUES ('MRKTNG',
                   'D_R_MARKETING',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));
--


END;
/
SHOW ERRORS;
