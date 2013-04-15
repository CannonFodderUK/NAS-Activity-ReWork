SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:37 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE SP_L_exrate
AS
   --
   v_code            NUMBER (5);
   v_error_message   VARCHAR2 (512);
--

BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE D_EXCHANGE_RATES';

   INSERT INTO D_EXCHANGE_RATES
      (SELECT BASECURRENCY,
              TYPE,
              CODE,
              EXCHRATE,
              BEGDDATE,
              ENDDDATE,
              PRODUCTCODE,
              WHOSTAMP,
              DATESTAMP
         FROM L_EXCHRATES);

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
           VALUES ('EXRATE',
                   'D_EXCHANGE_RATES',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));
--


END;
/
SHOW ERRORS;
