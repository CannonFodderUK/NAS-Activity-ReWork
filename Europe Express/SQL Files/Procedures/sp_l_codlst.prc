SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:36 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE SP_L_CODLST
AS
   --
   v_code            NUMBER (5);
   v_error_message   VARCHAR2 (512);
--

BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE DREF_CODE_LIST';

   INSERT INTO DREF_CODE_LIST
      (SELECT CODEGROUP, CODE, DESCRIPTION FROM L_CODELIST);

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
           VALUES ('CODLST',
                   'DREF_CODE_LIST',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));
--


END;
/
SHOW ERRORS;
