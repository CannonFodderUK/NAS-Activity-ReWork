SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:35 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE SP_L_accode
AS
   --
   v_code            NUMBER (5);
   v_error_message   VARCHAR2 (512);
--

BEGIN
   -- INSERT ANY NEW ROWS READY FOR MAPPING THROUGH APEX

   INSERT INTO DREF_ACC_CODES (ACCOUNT_ID, ACCOUNT_NAME)
      SELECT DISTINCT AB.ACCOUNTID, TRIM (AB.ACCTNAME)
        FROM L_ACCBEGBAL AB
      MINUS
      SELECT ACCOUNT_ID, TRIM (ACCOUNT_NAME) FROM DREF_ACC_CODES;

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
           VALUES ('ACCODE',
                   'DREF_ACC_CODES',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));
--


END;
/
SHOW ERRORS;
