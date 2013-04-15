SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:38 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_L_market
AS
   -- DECLARE /*****  D E C L A R E  S E C T I O N  *****/
   --===========================================================
   -- SP_MARKET - which takes the contents of L_MARKETS
   -- and populates the D_MARKET table
   --
   --===========================================================
   -- Change History
   --===========================================================
   -- Date          Ver Who Comment
   -- 17-Dec-12     1.0 tthmlx  Original Version
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
   v_market_code          D_MARKET.MARKET_CODE%TYPE;
   v_description          D_MARKET.DESCRIPTION%TYPE;
   v_company_id           D_MARKET.COMPANY_ID%TYPE;
   v_division             D_MARKET.DIVISION%TYPE;
   v_gl_sales             D_MARKET.GL_SALES%TYPE;
   v_gl_sales_name        D_MARKET.GL_SALES_NAME%TYPE;
   v_gl_commission        D_MARKET.GL_COMMISSION%TYPE;
   v_gl_commission_name   D_MARKET.GL_COMMISSION_NAME%TYPE;
   v_gl_costs             D_MARKET.GL_COSTS%TYPE;
   v_gl_costs_name        D_MARKET.GL_COSTS_NAME%TYPE;
   v_expoptrule           D_MARKET.EXPOPTRULE%TYPE;
   v_finalpayrule         D_MARKET.FINALPAYRULE%TYPE;
   v_deposit              D_MARKET.DEPOSIT%TYPE;
   v_comm_journal         D_MARKET.COMM_JOURNAL%TYPE;
   v_whostamp             D_MARKET.WHOSTAMP%TYPE;
   v_datestamp            D_MARKET.DATESTAMP%TYPE;
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
      SELECT MARKETCODE MARKET_CODE,
             DESCRIPTION,
             COMPANYID COMPANY_ID,
             CASE
                WHEN REGEXP_COUNT (MARKETCODE, '-') = 2
                THEN
                   SUBSTR (MARKETCODE,
                             INSTR (MARKETCODE,
                                    '-',
                                    1,
                                    2)
                           + 1,
                           LENGTH (MARKETCODE))
                WHEN REGEXP_COUNT (MARKETCODE, '-') = 1
                THEN
                   SUBSTR (MARKETCODE,
                             INSTR (MARKETCODE,
                                    '-',
                                    1,
                                    1)
                           + 1,
                           LENGTH (MARKETCODE))
                WHEN REGEXP_COUNT (MARKETCODE, '-') = 0
                THEN
                   MARKETCODE
             END
                AS DIVISION,
             GLSALES GL_SALES,
             GLSALESNAME GL_SALES_NAME,
             GLCOMM GL_COMMISSION,
             GLCOMMNAME GL_COMMISSION_NAME,
             GLCOSTS GL_COSTS,
             GLCOSTSNAME GL_COSTS_NAME,
             EXPOPTRULE,
             FINALPAYRULE,
             DEPOSIT,
             COMMJOURNAL COMM_JOURNAL,
             WHOSTAMP,
             DATESTAMP
        FROM L_MARKETS;

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
            INTO v_market_code,
                 v_description,
                 v_company_id,
                 v_division,
                 v_gl_sales,
                 v_gl_sales_name,
                 v_gl_commission,
                 v_gl_commission_name,
                 v_gl_costs,
                 v_gl_costs_name,
                 v_expoptrule,
                 v_finalpayrule,
                 v_deposit,
                 v_comm_journal,
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
                  INSERT INTO d_market (market_code,
                                        description,
                                        company_id,
                                        division,
                                        gl_sales,
                                        gl_sales_name,
                                        gl_commission,
                                        gl_commission_name,
                                        gl_costs,
                                        gl_costs_name,
                                        expoptrule,
                                        finalpayrule,
                                        deposit,
                                        comm_journal,
                                        whostamp,
                                        datestamp)
                       VALUES (v_market_code,
                               v_description,
                               v_company_id,
                               v_division,
                               v_gl_sales,
                               v_gl_sales_name,
                               v_gl_commission,
                               v_gl_commission_name,
                               v_gl_costs,
                               v_gl_costs_name,
                               v_expoptrule,
                               v_finalpayrule,
                               v_deposit,
                               v_comm_journal,
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
                     UPDATE D_MARKET
                        SET DESCRIPTION = V_DESCRIPTION,
                            COMPANY_ID = V_COMPANY_ID,
                            DIVISION = V_DIVISION,
                            GL_SALES = V_GL_SALES,
                            GL_SALES_NAME = V_GL_SALES_NAME,
                            GL_COMMISSION = V_GL_COMMISSION,
                            GL_COMMISSION_NAME = V_GL_COMMISSION_NAME,
                            GL_COSTS = V_GL_COSTS,
                            GL_COSTS_NAME = V_GL_COSTS_NAME,
                            EXPOPTRULE = V_EXPOPTRULE,
                            FINALPAYRULE = V_FINALPAYRULE,
                            DEPOSIT = V_DEPOSIT,
                            COMM_JOURNAL = V_COMM_JOURNAL,
                            WHOSTAMP = V_WHOSTAMP,
                            DATESTAMP = V_DATESTAMP
                      WHERE MARKET_CODE = V_MARKET_CODE;

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
                  INSERT INTO R_market_rej_rec (market_code,
                                                description,
                                                company_id,
                                                division,
                                                gl_sales,
                                                gl_sales_name,
                                                gl_commission,
                                                gl_commission_name,
                                                gl_costs,
                                                gl_costs_name,
                                                expoptrule,
                                                finalpayrule,
                                                deposit,
                                                comm_journal,
                                                whostamp,
                                                datestamp)
                       VALUES (v_market_code,
                               v_description,
                               v_company_id,
                               v_division,
                               v_gl_sales,
                               v_gl_sales_name,
                               v_gl_commission,
                               v_gl_commission_name,
                               v_gl_costs,
                               v_gl_costs_name,
                               v_expoptrule,
                               v_finalpayrule,
                               v_deposit,
                               v_comm_journal,
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
                    VALUES ('MARKET',
                            'D_MARKET',
                            SYSDATE,
                            SUBSTR (v_code, 1, 50),
                            SUBSTR (v_error_message, 1, 250));

               --
               -- Write error record
               INSERT INTO R_market_rej_rec (market_code,
                                             description,
                                             company_id,
                                             division,
                                             gl_sales,
                                             gl_sales_name,
                                             gl_commission,
                                             gl_commission_name,
                                             gl_costs,
                                             gl_costs_name,
                                             expoptrule,
                                             finalpayrule,
                                             deposit,
                                             comm_journal,
                                             whostamp,
                                             datestamp)
                    VALUES (v_market_code,
                            v_description,
                            v_company_id,
                            v_division,
                            v_gl_sales,
                            v_gl_sales_name,
                            v_gl_commission,
                            v_gl_commission_name,
                            v_gl_costs,
                            v_gl_costs_name,
                            v_expoptrule,
                            v_finalpayrule,
                            v_deposit,
                            v_comm_journal,
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
              VALUES ('MARKET',
                      'D_MARKET',
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
           VALUES ('MARKET',
                   'D_MARKET',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));

      --
      COMMIT;
--
END;                                        /**** < OPEN Cursor Block  > ****/
/
SHOW ERRORS;
