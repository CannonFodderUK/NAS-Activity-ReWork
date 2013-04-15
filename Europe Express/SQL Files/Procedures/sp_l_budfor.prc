SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:36 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_l_budfor
AS
   -- DECLARE /*****  D E C L A R E  S E C T I O N  *****/
   --===========================================================
   -- SP_L_BUDFOR - which takes the contents of L_BUDGETFORECAST
   -- and populates the F_BUDGET_FORECAST table
   --
   --===========================================================
   -- Change History
   --===========================================================
   -- Date          Ver Who Comment
   -- 15-Jan-13     1.0 tthmlx  Original Version
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
   v_fiscal_year          F_BUDGET_FORECAST.FISCAL_YEAR%TYPE;
   v_bf_period            F_BUDGET_FORECAST.BF_PERIOD%TYPE;
   v_brand_id             F_BUDGET_FORECAST.BRAND_ID%TYPE;
   v_gl_number            F_BUDGET_FORECAST.GL_NUMBER%TYPE;
   v_company              F_BUDGET_FORECAST.COMPANY%TYPE;
   v_bf_month             F_BUDGET_FORECAST.BF_MONTH%TYPE;
   v_channel              F_BUDGET_FORECAST.CHANNEL%TYPE;
   v_division             F_BUDGET_FORECAST.DIVISION%TYPE;
   v_clasification        F_BUDGET_FORECAST.CLASIFICATION%TYPE;
   v_group_type           F_BUDGET_FORECAST.GROUP_TYPE%TYPE;
   v_affiliation_id       F_BUDGET_FORECAST.AFFILIATION_ID%TYPE;
   v_gl_name              F_BUDGET_FORECAST.GL_NAME%TYPE;
   v_budget_amount        F_BUDGET_FORECAST.BUDGET_AMOUNT%TYPE;
   v_budget_pax           F_BUDGET_FORECAST.BUDGET_PAX%TYPE;
   v_forecast_amount      F_BUDGET_FORECAST.FORECAST_AMOUNT%TYPE;
   v_forecast_pax         F_BUDGET_FORECAST.FORECAST_PAX%TYPE;
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
      SELECT FISCALYEAR FISCAL_YEAR,
             PERIOD BF_PERIOD,
             BRANDID BRAND_ID,
             GL_NUMBER,
             COMPANY,
             MONTH BF_MONTH,
             CHANNEL,
             DIVISION,
             CLASIFICATION,
             GROUPTYPE GROUP_TYPE,
             AFFILIATION_ID,
             GLNAME GL_NAME,
             BUDGETAMOUNT BUDGET_AMOUNT,
             BUDGET_PAX,
             FORECAST_AMOUNT,
             FORECAST_PAX
        FROM L_BUDGET_FORECAST;

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
            INTO v_fiscal_year,
                 v_bf_period,
                 v_brand_id,
                 v_gl_number,
                 v_company,
                 v_bf_month,
                 v_channel,
                 v_division,
                 v_clasification,
                 v_group_type,
                 v_affiliation_id,
                 v_gl_name,
                 v_budget_amount,
                 v_budget_pax,
                 v_forecast_amount,
                 v_forecast_pax;

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
                  INSERT INTO f_budget_forecast (fiscal_year,
                                                 bf_period,
                                                 brand_id,
                                                 gl_number,
                                                 company,
                                                 bf_month,
                                                 channel,
                                                 division,
                                                 clasification,
                                                 group_type,
                                                 affiliation_id,
                                                 gl_name,
                                                 budget_amount,
                                                 budget_pax,
                                                 forecast_amount,
                                                 forecast_pax)
                       VALUES (v_fiscal_year,
                               v_bf_period,
                               v_brand_id,
                               v_gl_number,
                               v_company,
                               v_bf_month,
                               v_channel,
                               v_division,
                               v_clasification,
                               v_group_type,
                               v_affiliation_id,
                               v_gl_name,
                               v_budget_amount,
                               v_budget_pax,
                               v_forecast_amount,
                               v_forecast_pax);

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
                     UPDATE F_BUDGET_FORECAST
                        SET COMPANY = V_COMPANY,
                            BF_MONTH = V_BF_MONTH,
                            CHANNEL = V_CHANNEL,
                            DIVISION = V_DIVISION,
                            CLASIFICATION = V_CLASIFICATION,
                            GROUP_TYPE = V_GROUP_TYPE,
                            AFFILIATION_ID = V_AFFILIATION_ID,
                            GL_NAME = V_GL_NAME,
                            BUDGET_AMOUNT = V_BUDGET_AMOUNT,
                            BUDGET_PAX = V_BUDGET_PAX,
                            FORECAST_AMOUNT = V_FORECAST_AMOUNT,
                            FORECAST_PAX = V_FORECAST_PAX
                      WHERE     FISCAL_YEAR = V_FISCAL_YEAR
                            AND BF_PERIOD = V_BF_PERIOD
                            AND BRAND_ID = V_BRAND_ID
                            AND GL_NUMBER = V_GL_NUMBER;

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
                  INSERT INTO R_budfor_rej_rec (fiscal_year,
                                                bf_period,
                                                brand_id,
                                                gl_number,
                                                company,
                                                bf_month,
                                                channel,
                                                division,
                                                clasification,
                                                group_type,
                                                affiliation_id,
                                                gl_name,
                                                budget_amount,
                                                budget_pax,
                                                forecast_amount,
                                                forecast_pax)
                       VALUES (v_fiscal_year,
                               v_bf_period,
                               v_brand_id,
                               v_gl_number,
                               v_company,
                               v_bf_month,
                               v_channel,
                               v_division,
                               v_clasification,
                               v_group_type,
                               v_affiliation_id,
                               v_gl_name,
                               v_budget_amount,
                               v_budget_pax,
                               v_forecast_amount,
                               v_forecast_pax);

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
                    VALUES ('L_BUDFOR',
                            'F_BUDGET_FORECAST',
                            SYSDATE,
                            SUBSTR (v_code, 1, 50),
                            SUBSTR (v_error_message, 1, 250));

               --
               -- Write error record
               INSERT INTO R_budfor_rej_rec (fiscal_year,
                                             bf_period,
                                             brand_id,
                                             gl_number,
                                             company,
                                             bf_month,
                                             channel,
                                             division,
                                             clasification,
                                             group_type,
                                             affiliation_id,
                                             gl_name,
                                             budget_amount,
                                             budget_pax,
                                             forecast_amount,
                                             forecast_pax)
                    VALUES (v_fiscal_year,
                            v_bf_period,
                            v_brand_id,
                            v_gl_number,
                            v_company,
                            v_bf_month,
                            v_channel,
                            v_division,
                            v_clasification,
                            v_group_type,
                            v_affiliation_id,
                            v_gl_name,
                            v_budget_amount,
                            v_budget_pax,
                            v_forecast_amount,
                            v_forecast_pax);
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
              VALUES ('L_BUDFOR',
                      'F_BUDGET_FORECAST',
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
           VALUES ('L_BUDFOR',
                   'F_BUDGET_FORECAST',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));

      --
      COMMIT;
--
END;                                        /**** < OPEN Cursor Block  > ****/
/
SHOW ERRORS;
