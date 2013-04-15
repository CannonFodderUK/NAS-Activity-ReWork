SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:39 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_L_prodct
AS
   -- DECLARE /*****  D E C L A R E  S E C T I O N  *****/
   --===========================================================
   -- SP_PRODCT - which takes the contents of L_PRODUCT
   -- and populates the D_PRODUCT table
   --
   --===========================================================
   -- Change History
   --===========================================================
   -- Date          Ver Who Comment
   -- 10-Jan-13     1.0 tthmlx  Original Version
   --
   --
   -- EXCEPTION DEFINITIONS
   --
   primary_key_error        EXCEPTION;
   PRAGMA EXCEPTION_INIT (primary_key_error, -00001);
   foreign_key_error        EXCEPTION;
   PRAGMA EXCEPTION_INIT (foreign_key_error, -02291);
   --
   --
   v_commit_at     CONSTANT PLS_INTEGER := 1000;
   --
   -- VARIABLES HOLDING DATA FROM CURSOR
   --
   v_product_code           D_PRODUCT.PRODUCT_CODE%TYPE;
   v_product_name           D_PRODUCT.PRODUCT_NAME%TYPE;
   v_description            D_PRODUCT.DESCRIPTION%TYPE;
   v_begin_date             D_PRODUCT.BEGIN_DATE%TYPE;
   v_end_date               D_PRODUCT.END_DATE%TYPE;
   v_begin_book_date        D_PRODUCT.BEGIN_BOOK_DATE%TYPE;
   v_end_book_date          D_PRODUCT.END_BOOK_DATE%TYPE;
   v_default_market         D_PRODUCT.DEFAULT_MARKET%TYPE;
   v_product_type           D_PRODUCT.PRODUCT_TYPE%TYPE;
   v_num_days               D_PRODUCT.NUM_DAYS%TYPE;
   v_date_specific          D_PRODUCT.DATE_SPECIFIC%TYPE;
   v_rollup_air_allow       D_PRODUCT.ROLLUP_AIR_ALLOW%TYPE;
   v_share_ok               D_PRODUCT.SHARE_OK%TYPE;
   v_land_only_ok           D_PRODUCT.LAND_ONLY_OK%TYPE;
   v_air_included           D_PRODUCT.AIR_INCLUDED%TYPE;
   v_touid                  D_PRODUCT.TOUID%TYPE;
   v_tour_offset            D_PRODUCT.TOUR_OFFSET%TYPE;
   v_distribute_free_cost   D_PRODUCT.DISTRIBUTE_FREE_COST%TYPE;
   v_active_pax_range       D_PRODUCT.ACTIVE_PAX_RANGE%TYPE;
   v_search_by              D_PRODUCT.SEARCH_BY%TYPE;
   v_product_status         D_PRODUCT.PRODUCT_STATUS%TYPE;
   v_track_changes          D_PRODUCT.TRACK_CHANGES%TYPE;
   v_active_as_of           D_PRODUCT.ACTIVE_AS_OF%TYPE;
   v_created_by             D_PRODUCT.CREATED_BY%TYPE;
   v_created_date           D_PRODUCT.CREATED_DATE%TYPE;
   v_whostamp               D_PRODUCT.WHOSTAMP%TYPE;
   v_datestamp              D_PRODUCT.DATESTAMP%TYPE;
   --
   -- WORK VARIABLES
   --
   v_null                   CHAR (1);
   v_count                  CHAR (1);
   v_insert_ok              CHAR (1);
   v_update_ok              CHAR (1);
   v_fk_error               CHAR (1);
   v_foreign_key_error      CHAR (1);
   v_primary_key_error      CHAR (1);
   --
   v_code                   NUMBER (5);
   v_error_message          VARCHAR2 (512);

   --
   CURSOR C001
   IS
      SELECT PRODUCTCODE PRODUCT_CODE,
             PRODUCTNAME PRODUCT_NAME,
             DESCRIPTION,
             BEGDATE BEGIN_DATE,
             ENDDATE END_DATE,
             BEGBDATE BEGIN_BOOK_DATE,
             ENDBDATE END_BOOK_DATE,
             DEFAULTMARKET DEFAULT_MARKET,
             PRODUCTTYPE PRODUCT_TYPE,
             NUMDAYS NUM_DAYS,
             DATESPECIFIC DATE_SPECIFIC,
             ROLLUPAIRALLOW ROLLUP_AIR_ALLOW,
             SHAREOK SHARE_OK,
             LANDONLYOK LAND_ONLY_OK,
             AIRINCLUDED AIR_INCLUDED,
             TOUID,
             TOUROFFSET TOUR_OFFSET,
             DISTRIBUTEFREECOST DISTRIBUTE_FREE_COST,
             ACTIVEPAXRANGE ACTIVE_PAX_RANGE,
             SEARCHBY SEARCH_BY,
             PRODUCTSTATUS PRODUCT_STATUS,
             TRACKCHANGES TRACK_CHANGES,
             ACTIVEASOF ACTIVE_AS_OF,
             CREATEDBY CREATED_BY,
             CREATEDDATE CREATED_DATE,
             WHOSTAMP,
             DATESTAMP
        FROM L_PRODUCT;

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
            INTO v_product_code,
                 v_product_name,
                 v_description,
                 v_begin_date,
                 v_end_date,
                 v_begin_book_date,
                 v_end_book_date,
                 v_default_market,
                 v_product_type,
                 v_num_days,
                 v_date_specific,
                 v_rollup_air_allow,
                 v_share_ok,
                 v_land_only_ok,
                 v_air_included,
                 v_touid,
                 v_tour_offset,
                 v_distribute_free_cost,
                 v_active_pax_range,
                 v_search_by,
                 v_product_status,
                 v_track_changes,
                 v_active_as_of,
                 v_created_by,
                 v_created_date,
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
                  INSERT INTO d_product (product_code,
                                         product_name,
                                         description,
                                         begin_date,
                                         end_date,
                                         begin_book_date,
                                         end_book_date,
                                         default_market,
                                         product_type,
                                         num_days,
                                         date_specific,
                                         rollup_air_allow,
                                         share_ok,
                                         land_only_ok,
                                         air_included,
                                         touid,
                                         tour_offset,
                                         distribute_free_cost,
                                         active_pax_range,
                                         search_by,
                                         product_status,
                                         track_changes,
                                         active_as_of,
                                         created_by,
                                         created_date,
                                         whostamp,
                                         datestamp)
                       VALUES (v_product_code,
                               v_product_name,
                               v_description,
                               v_begin_date,
                               v_end_date,
                               v_begin_book_date,
                               v_end_book_date,
                               v_default_market,
                               v_product_type,
                               v_num_days,
                               v_date_specific,
                               v_rollup_air_allow,
                               v_share_ok,
                               v_land_only_ok,
                               v_air_included,
                               v_touid,
                               v_tour_offset,
                               v_distribute_free_cost,
                               v_active_pax_range,
                               v_search_by,
                               v_product_status,
                               v_track_changes,
                               v_active_as_of,
                               v_created_by,
                               v_created_date,
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
                     UPDATE D_PRODUCT
                        SET PRODUCT_NAME = V_PRODUCT_NAME,
                            DESCRIPTION = V_DESCRIPTION,
                            BEGIN_DATE = V_BEGIN_DATE,
                            END_DATE = V_END_DATE,
                            BEGIN_BOOK_DATE = V_BEGIN_BOOK_DATE,
                            END_BOOK_DATE = V_END_BOOK_DATE,
                            DEFAULT_MARKET = V_DEFAULT_MARKET,
                            PRODUCT_TYPE = V_PRODUCT_TYPE,
                            NUM_DAYS = V_NUM_DAYS,
                            DATE_SPECIFIC = V_DATE_SPECIFIC,
                            ROLLUP_AIR_ALLOW = V_ROLLUP_AIR_ALLOW,
                            SHARE_OK = V_SHARE_OK,
                            LAND_ONLY_OK = V_LAND_ONLY_OK,
                            AIR_INCLUDED = V_AIR_INCLUDED,
                            TOUID = V_TOUID,
                            TOUR_OFFSET = V_TOUR_OFFSET,
                            DISTRIBUTE_FREE_COST = V_DISTRIBUTE_FREE_COST,
                            ACTIVE_PAX_RANGE = V_ACTIVE_PAX_RANGE,
                            SEARCH_BY = V_SEARCH_BY,
                            PRODUCT_STATUS = V_PRODUCT_STATUS,
                            TRACK_CHANGES = V_TRACK_CHANGES,
                            ACTIVE_AS_OF = V_ACTIVE_AS_OF,
                            CREATED_BY = V_CREATED_BY,
                            CREATED_DATE = V_CREATED_DATE,
                            WHOSTAMP = V_WHOSTAMP,
                            DATESTAMP = V_DATESTAMP
                      WHERE PRODUCT_CODE = V_PRODUCT_CODE;

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
                  INSERT INTO R_prodct_rej_rec (product_code,
                                                product_name,
                                                description,
                                                begin_date,
                                                end_date,
                                                begin_book_date,
                                                end_book_date,
                                                default_market,
                                                product_type,
                                                num_days,
                                                date_specific,
                                                rollup_air_allow,
                                                share_ok,
                                                land_only_ok,
                                                air_included,
                                                touid,
                                                tour_offset,
                                                distribute_free_cost,
                                                active_pax_range,
                                                search_by,
                                                product_status,
                                                track_changes,
                                                active_as_of,
                                                created_by,
                                                created_date,
                                                whostamp,
                                                datestamp)
                       VALUES (v_product_code,
                               v_product_name,
                               v_description,
                               v_begin_date,
                               v_end_date,
                               v_begin_book_date,
                               v_end_book_date,
                               v_default_market,
                               v_product_type,
                               v_num_days,
                               v_date_specific,
                               v_rollup_air_allow,
                               v_share_ok,
                               v_land_only_ok,
                               v_air_included,
                               v_touid,
                               v_tour_offset,
                               v_distribute_free_cost,
                               v_active_pax_range,
                               v_search_by,
                               v_product_status,
                               v_track_changes,
                               v_active_as_of,
                               v_created_by,
                               v_created_date,
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
                    VALUES ('PRODCT',
                            'D_PRODUCT',
                            SYSDATE,
                            SUBSTR (v_code, 1, 50),
                            SUBSTR (v_error_message, 1, 250));

               --
               -- Write error record
               INSERT INTO R_prodct_rej_rec (product_code,
                                             product_name,
                                             description,
                                             begin_date,
                                             end_date,
                                             begin_book_date,
                                             end_book_date,
                                             default_market,
                                             product_type,
                                             num_days,
                                             date_specific,
                                             rollup_air_allow,
                                             share_ok,
                                             land_only_ok,
                                             air_included,
                                             touid,
                                             tour_offset,
                                             distribute_free_cost,
                                             active_pax_range,
                                             search_by,
                                             product_status,
                                             track_changes,
                                             active_as_of,
                                             created_by,
                                             created_date,
                                             whostamp,
                                             datestamp)
                    VALUES (v_product_code,
                            v_product_name,
                            v_description,
                            v_begin_date,
                            v_end_date,
                            v_begin_book_date,
                            v_end_book_date,
                            v_default_market,
                            v_product_type,
                            v_num_days,
                            v_date_specific,
                            v_rollup_air_allow,
                            v_share_ok,
                            v_land_only_ok,
                            v_air_included,
                            v_touid,
                            v_tour_offset,
                            v_distribute_free_cost,
                            v_active_pax_range,
                            v_search_by,
                            v_product_status,
                            v_track_changes,
                            v_active_as_of,
                            v_created_by,
                            v_created_date,
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
              VALUES ('PRODCT',
                      'D_PRODUCT',
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
           VALUES ('PRODCT',
                   'D_PRODUCT',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));

      --
      COMMIT;
--
END;                                        /**** < OPEN Cursor Block  > ****/
/
SHOW ERRORS;
