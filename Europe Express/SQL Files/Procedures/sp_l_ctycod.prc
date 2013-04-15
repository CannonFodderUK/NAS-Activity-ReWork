SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:37 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_L_ctycod
AS
   -- DECLARE /*****  D E C L A R E  S E C T I O N  *****/
   --===========================================================
   -- SP_CTYCOD - which takes the contents of L_CITYCODES
   -- and populates the D_CITY_CODES table
   --
   --===========================================================
   -- Change History
   --===========================================================
   -- Date          Ver Who Comment
   -- 29-Dec-12     1.0 TTHMLX  Original Version
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
   v_cc_code              D_CITY_CODES.CC_CODE%TYPE;
   v_description          D_CITY_CODES.DESCRIPTION%TYPE;
   v_countrycode          D_CITY_CODES.COUNTRYCODE%TYPE;
   v_outbound             D_CITY_CODES.OUTBOUND%TYPE;
   v_destination          D_CITY_CODES.DESTINATION%TYPE;
   v_city                 D_CITY_CODES.CITY%TYPE;
   v_country              D_CITY_CODES.COUNTRY%TYPE;
   v_gouping_level1       D_CITY_CODES.GOUPING_LEVEL1%TYPE;
   v_additional_data      D_CITY_CODES.ADDITIONAL_DATA%TYPE;
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
      SELECT CODE,
             DESCRIPTION,
             COUNTRYCODE,
             OUTBOUND,
             DESTINATION,
             CITY,
             COUNTRY,
             GROUPING GOUPING_LEVEL1,
             ADDITIONALDATA ADDITIONAL_DATA
        FROM L_CITYCODES;

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
            INTO v_cc_code,
                 v_description,
                 v_countrycode,
                 v_outbound,
                 v_destination,
                 v_city,
                 v_country,
                 v_gouping_level1,
                 v_additional_data;

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
                  INSERT INTO d_city_codes (cc_code,
                                            description,
                                            countrycode,
                                            outbound,
                                            destination,
                                            city,
                                            country,
                                            gouping_level1,
                                            additional_data)
                       VALUES (v_cc_code,
                               v_description,
                               v_countrycode,
                               v_outbound,
                               v_destination,
                               v_city,
                               v_country,
                               v_gouping_level1,
                               v_additional_data);

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
                     UPDATE D_CITY_CODES
                        SET DESCRIPTION = V_DESCRIPTION,
                            COUNTRYCODE = V_COUNTRYCODE,
                            OUTBOUND = V_OUTBOUND,
                            DESTINATION = V_DESTINATION,
                            CITY = V_CITY,
                            COUNTRY = V_COUNTRY,
                            GOUPING_LEVEL1 = V_GOUPING_LEVEL1,
                            ADDITIONAL_DATA = V_ADDITIONAL_DATA
                      WHERE CC_CODE = V_CC_CODE;

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
                  INSERT INTO R_ctycod_rej_rec (cc_code,
                                                description,
                                                countrycode,
                                                outbound,
                                                destination,
                                                city,
                                                country,
                                                gouping_level1,
                                                additional_data)
                       VALUES (v_cc_code,
                               v_description,
                               v_countrycode,
                               v_outbound,
                               v_destination,
                               v_city,
                               v_country,
                               v_gouping_level1,
                               v_additional_data);

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
                    VALUES ('CTYCOD',
                            'D_CITY_CODES',
                            SYSDATE,
                            SUBSTR (v_code, 1, 50),
                            SUBSTR (v_error_message, 1, 250));

               --
               -- Write error record
               INSERT INTO R_ctycod_rej_rec (cc_code,
                                             description,
                                             countrycode,
                                             outbound,
                                             destination,
                                             city,
                                             country,
                                             gouping_level1,
                                             additional_data)
                    VALUES (v_cc_code,
                            v_description,
                            v_countrycode,
                            v_outbound,
                            v_destination,
                            v_city,
                            v_country,
                            v_gouping_level1,
                            v_additional_data);
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
              VALUES ('CTYCOD',
                      'D_CITY_CODES',
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
           VALUES ('CTYCOD',
                   'D_CITY_CODES',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));

      --
      COMMIT;
--
END;                                        /**** < OPEN Cursor Block  > ****/
/
SHOW ERRORS;
