SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:40 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE SP_L_WEBANA
AS
   --
   v_code            NUMBER (5);
   v_error_message   VARCHAR2 (512);
--

BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE F_WEB_ANALYTICS';

   INSERT INTO F_WEB_ANALYTICS
      (SELECT DATAID,
              BRAND,
              AD_SOURCE,
              AD_MEDIUM,
              PAGEVIEWS,
              UNIQUE_VISITS,
              NEW_VISITS,
              VISITS,
              BOUNCES,
              TIME_ON_SITE,
              RUNDATE
         FROM L_ANALYTICS_DATA);

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
           VALUES ('WEBANA',
                   'F_WEB_ANALYTICS',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));
--


END;
/
SHOW ERRORS;
