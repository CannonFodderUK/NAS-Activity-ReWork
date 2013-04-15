SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:38 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE SP_L_HRDATA
AS
   --
   v_code            NUMBER (5);
   v_error_message   VARCHAR2 (512);
--

BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE D_HR_DATA';

   INSERT INTO D_HR_DATA
      (SELECT EMPLOYEENO,
              PAYDATE,
              DEPARTMENT,
              DEPARTMENTNAME,
              FIRSTNAME,
              LASTNAME,
              HOURLYRATE,
              ANNUALSALARY,
              INCDOLLARS,
              ADJUSTHOURS,
              BONUSDOLLARS,
              FUNERALHOURS,
              HOLIDAYHOURS,
              INCENTDOLLARS,
              JURYHOURS,
              MISCHOURS,
              MISCDOLLARS,
              OVERTIMEHOURS,
              PTOHOURS,
              REGHOURS,
              SALHOURS,
              WKNMGRHOURS,
              WKNMGROTHOURS,
              PAIDGROSSWAGES,
              USERID,
              HIRE,
              IS_TYPE,
              MANAGER,
              GENDER
         FROM L_HR);

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
           VALUES ('HRDATA',
                   'D_HR_DATA',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));
--


END;
/
SHOW ERRORS;
