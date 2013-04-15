SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:36 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_L_brand
AS
   -- DECLARE /*****  D E C L A R E  S E C T I O N  *****/
   --===========================================================
   -- SP_BRAND - which takes the contents of L_BRANDS
   -- and populates the D_BRAND table
   --
   --===========================================================
   -- Change History
   --===========================================================
   -- Date          Ver Who Comment
   -- 14-Dec-12     1.0 tthmlx  Original Version
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
   v_brand_id             D_BRAND.BRAND_ID%TYPE;
   v_brand_name           D_BRAND.BRAND_NAME%TYPE;
   v_selling_methods      D_BRAND.SELLING_METHODS%TYPE;
   v_fmmarket             D_BRAND.FMMARKET%TYPE;
   v_qcurrency            D_BRAND.QCURRENCY%TYPE;
   v_created_by           D_BRAND.CREATED_BY%TYPE;
   v_created_datetime     D_BRAND.CREATED_DATETIME%TYPE;
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
      SELECT DISTINCT BRANDID,
                      BRANDNAME,
                      SELLMETHODS,
                      FMMARKET,
                      QCURRENCY,
                      WHOSTAMP,
                      DATESTAMP
        FROM L_BRANDS;

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
            INTO v_brand_id,
                 v_brand_name,
                 v_selling_methods,
                 v_fmmarket,
                 v_qcurrency,
                 v_created_by,
                 v_created_datetime;

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
                  INSERT INTO d_brand (brand_id,
                                       brand_name,
                                       selling_methods,
                                       fmmarket,
                                       qcurrency,
                                       created_by,
                                       created_datetime)
                       VALUES (v_brand_id,
                               v_brand_name,
                               v_selling_methods,
                               v_fmmarket,
                               v_qcurrency,
                               v_created_by,
                               v_created_datetime);

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
                     UPDATE D_BRAND
                        SET BRAND_NAME = V_BRAND_NAME,
                            SELLING_METHODS = V_SELLING_METHODS,
                            FMMARKET = V_FMMARKET,
                            QCURRENCY = V_QCURRENCY,
                            CREATED_BY = V_CREATED_BY,
                            CREATED_DATETIME = V_CREATED_DATETIME
                      WHERE BRAND_ID = V_BRAND_ID;

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
                  INSERT INTO R_brand_rej_rec (brand_id,
                                               brand_name,
                                               selling_methods,
                                               fmmarket,
                                               qcurrency,
                                               created_by,
                                               created_datetime)
                       VALUES (v_brand_id,
                               v_brand_name,
                               v_selling_methods,
                               v_fmmarket,
                               v_qcurrency,
                               v_created_by,
                               v_created_datetime);

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
                    VALUES ('BRAND',
                            'D_BRAND',
                            SYSDATE,
                            SUBSTR (v_code, 1, 50),
                            SUBSTR (v_error_message, 1, 250));

               --
               -- Write error record
               INSERT INTO R_brand_rej_rec (brand_id,
                                            brand_name,
                                            selling_methods,
                                            fmmarket,
                                            qcurrency,
                                            created_by,
                                            created_datetime)
                    VALUES (v_brand_id,
                            v_brand_name,
                            v_selling_methods,
                            v_fmmarket,
                            v_qcurrency,
                            v_created_by,
                            v_created_datetime);
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
              VALUES ('BRAND',
                      'D_BRAND',
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
           VALUES ('BRAND',
                   'D_BRAND',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));

      --
      COMMIT;
--
END;                                        /**** < OPEN Cursor Block  > ****/
/
SHOW ERRORS;
