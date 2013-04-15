SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:35 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_l_acchrt
AS
   -- DECLARE /*****  D E C L A R E  S E C T I O N  *****/
   --===========================================================
   -- SP_L_ACCHRT - which takes the contents of L_ACCCHART
   -- and populates the D_ACC_CHART table
   --
   --===========================================================
   -- Change History
   --===========================================================
   -- Date          Ver Who Comment
   -- 07-Jan-13     1.0 tthmlx  Original Version
   --
   --
   -- EXCEPTION DEFINITIONS
   --
   primary_key_error      EXCEPTION;
   PRAGMA EXCEPTION_INIT (primary_key_error, -00001);
   foreign_key_error      EXCEPTION;
   PRAGMA EXCEPTION_INIT (foreign_key_error, -02291);
   --
   --
   v_commit_at   CONSTANT PLS_INTEGER := 1000;
   --
   -- VARIABLES HOLDING DATA FROM CURSOR
   --
   v_company_id           D_ACC_CHART.COMPANY_ID%TYPE;
   v_account_id           D_ACC_CHART.ACCOUNT_ID%TYPE;
   v_account_name         D_ACC_CHART.ACCOUNT_NAME%TYPE;
   v_statement_id         D_ACC_CHART.STATEMENT_ID%TYPE;
   v_balance_type         D_ACC_CHART.BALANCE_TYPE%TYPE;
   v_export_account       D_ACC_CHART.EXPORT_ACCOUNT%TYPE;
   v_active_flag          D_ACC_CHART.ACTIVE_FLAG%TYPE;
   v_whostamp             D_ACC_CHART.WHOSTAMP%TYPE;
   v_datestamp            D_ACC_CHART.DATESTAMP%TYPE;
   --
   -- WORK VARIABLES
   --
   v_null                 CHAR (1);
   v_count                CHAR (1);
   v_insert_ok            CHAR (1);
   v_update_ok            CHAR (1);
   v_fk_error             CHAR (1);
   v_foreign_key_error    CHAR (1);
   v_primary_key_error    CHAR (1);
   --
   v_code                 NUMBER (5);
   v_error_message        VARCHAR2 (512);

   --
   CURSOR C001
   IS
      SELECT COMPANYID COMPANY_ID,
             ACCOUNTID ACCOUNT_ID,
             ACCOUNTNAME ACCOUNT_NAME,
             STATEMENTID STATEMENT_ID,
             BALTYPE BALANCE_TYPE,
             EXPORTACCOUNT EXPORT_ACCOUNT,
             ACTIVE ACTIVE_FLAG,
             WHOSTAMP,
             DATESTAMP
        FROM L_ACCCHART;

--
BEGIN
   /**** < OPEN Cursor Block > ****/
   --
   v_primary_key_error := 'N';
   v_foreign_key_error := 'N';

   --
   OPEN C001;

   --
   BEGIN
      /**** < FETCH Cursor Block >  ****/
      --
      LOOP
         /**** < FETCH LOOP      >  ****/
         --
         v_insert_ok := 'N';
         v_update_ok := 'N';
         v_fk_error := 'N';

         --
         FETCH C001
            INTO v_company_id,
                 v_account_id,
                 v_account_name,
                 v_statement_id,
                 v_balance_type,
                 v_export_account,
                 v_active_flag,
                 v_whostamp,
                 v_datestamp;

         --
         EXIT WHEN C001%NOTFOUND;

         --
         BEGIN
            /**** < MAIN  Cursor Block >  ****/
            --
            WHILE     --
                      v_insert_ok = 'N'
                  AND v_update_ok = 'N'
                  AND v_fk_error = 'N'
            --
            LOOP
               /**** < RETRY LOOP      >  ****/
               --
               v_primary_key_error := 'N';
               v_foreign_key_error := 'N';

               --
               BEGIN
                  /**** < INSERT Cursor Block > ****/
                  --
                  INSERT INTO d_acc_chart (company_id,
                                           account_id,
                                           account_name,
                                           statement_id,
                                           balance_type,
                                           export_account,
                                           active_flag,
                                           whostamp,
                                           datestamp)
                       VALUES (v_company_id,
                               v_account_id,
                               v_account_name,
                               v_statement_id,
                               v_balance_type,
                               v_export_account,
                               v_active_flag,
                               v_whostamp,
                               v_datestamp);

                  --
                  v_insert_ok := 'Y';
               --
               EXCEPTION
                  --
                  -- A PRIMARY KEY or FOREIGN KEY error
                  --
                  WHEN primary_key_error
                  THEN
                     v_primary_key_error := 'Y';
                  WHEN foreign_key_error
                  THEN
                     v_foreign_key_error := 'Y';
               END;                        /**** < INSERT Cursor Block > ****/

               --
               IF v_primary_key_error = 'Y'
               THEN
                  --
                  BEGIN
                     /**** < UPDATE Cursor Block > ****/
                     --
                     UPDATE D_ACC_CHART
                        SET ACCOUNT_NAME = V_ACCOUNT_NAME,
                            STATEMENT_ID = V_STATEMENT_ID,
                            BALANCE_TYPE = V_BALANCE_TYPE,
                            EXPORT_ACCOUNT = V_EXPORT_ACCOUNT,
                            ACTIVE_FLAG = V_ACTIVE_FLAG,
                            WHOSTAMP = V_WHOSTAMP,
                            DATESTAMP = V_DATESTAMP
                      WHERE     COMPANY_ID = V_COMPANY_ID
                            AND ACCOUNT_ID = V_ACCOUNT_ID;

                     --
                     v_update_ok := 'Y';
                  --
                  EXCEPTION
                     --
                     -- A FOREIGN KEY error
                     --
                     WHEN foreign_key_error
                     THEN
                        v_foreign_key_error := 'Y';
                  --
                  END;                     /**** < UPDATE Cursor Block > ****/
               --
               END IF;

               -- FOREIGN KEY problem
               IF v_foreign_key_error = 'Y'
               THEN
                  -- write error record
                  INSERT INTO R_acchrt_rej_rec (company_id,
                                                account_id,
                                                account_name,
                                                statement_id,
                                                balance_type,
                                                export_account,
                                                active_flag,
                                                whostamp,
                                                datestamp)
                       VALUES (v_company_id,
                               v_account_id,
                               v_account_name,
                               v_statement_id,
                               v_balance_type,
                               v_export_account,
                               v_active_flag,
                               v_whostamp,
                               v_datestamp);

                  --
                  -- Now check which FOREIGN KEY is the problem
                  --
                  v_fk_error := 'Y';
               --
               END IF;
            --
            END LOOP;                      /**** < END RETRY LOOP     >  ****/
         --
         EXCEPTION
            --
            -- An error has occured that is not a PRIMARY or FOREIGN KEY error
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
                    VALUES ('L_ACCHRT',
                            'D_ACC_CHART',
                            SYSDATE,
                            SUBSTR (v_code, 1, 50),
                            SUBSTR (v_error_message, 1, 250));

               --
               -- Write error record
               INSERT INTO R_acchrt_rej_rec (company_id,
                                             account_id,
                                             account_name,
                                             statement_id,
                                             balance_type,
                                             export_account,
                                             active_flag,
                                             whostamp,
                                             datestamp)
                    VALUES (v_company_id,
                            v_account_id,
                            v_account_name,
                            v_statement_id,
                            v_balance_type,
                            v_export_account,
                            v_active_flag,
                            v_whostamp,
                            v_datestamp);
         --
         END;                               /**** < MAIN Cursor Block >  ****/

         --
         -- Commit at intervals
         --
         IF C001%ROWCOUNT MOD v_commit_at = 0
         THEN
            --
            COMMIT;
         --
         END IF;
      --
      END LOOP;                            /**** < END FETCH LOOP     >  ****/
   --
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
              VALUES ('L_ACCHRT',
                      'D_ACC_CHART',
                      SYSDATE,
                      SUBSTR (v_code, 1, 50),
                      SUBSTR (v_error_message, 1, 250));
   --
   --
   END;                                     /**** < FETCH Cursor Block > ****/

   --
   CLOSE C001;

   --
   -- Final commit
   COMMIT;
--
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
           VALUES ('L_ACCHRT',
                   'D_ACC_CHART',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));

      --
      COMMIT;
--
END;                                        /**** < OPEN Cursor Block  > ****/
/
SHOW ERRORS;
