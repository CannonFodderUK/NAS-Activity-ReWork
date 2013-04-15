SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:38 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_l_fprod
AS
   -- DECLARE /*****  D E C L A R E  S E C T I O N  *****/
   --===========================================================
   -- SP_L_FPROD - which takes the contents of D_PRODUCT
   -- and populates the F_PRODUCT table
   -- The table contains the latest product and related prices
   -- used mainly for the Trip Fill PIT
   --
   --===========================================================
   -- Change History
   --===========================================================
   -- Date          Ver Who Comment
   -- 11-Jan-13     1.0 tthmlx  Original Version
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
   v_product_code         F_PRODUCT.PRODUCT_CODE%TYPE;
   v_product_name         F_PRODUCT.PRODUCT_NAME%TYPE;
   v_description          F_PRODUCT.DESCRIPTION%TYPE;
   v_product_status       F_PRODUCT.PRODUCT_STATUS%TYPE;
   v_begin_date           F_PRODUCT.BEGIN_DATE%TYPE;
   v_end_date             F_PRODUCT.END_DATE%TYPE;
   v_begin_book_date      F_PRODUCT.BEGIN_BOOK_DATE%TYPE;
   v_end_book_date        F_PRODUCT.END_BOOK_DATE%TYPE;
   v_default_market       F_PRODUCT.DEFAULT_MARKET%TYPE;
   v_product_type         F_PRODUCT.PRODUCT_TYPE%TYPE;
   v_active_pax_range     F_PRODUCT.ACTIVE_PAX_RANGE%TYPE;
   v_pax_range_from       F_PRODUCT.PAX_RANGE_FROM%TYPE;
   v_pax_range_to         F_PRODUCT.PAX_RANGE_TO%TYPE;
   v_adult_price          F_PRODUCT.ADULT_PRICE%TYPE;
   v_adult_tax            F_PRODUCT.ADULT_TAX%TYPE;
   v_air_adult_allow      F_PRODUCT.AIR_ADULT_ALLOW%TYPE;
   v_land_cost            F_PRODUCT.LAND_COST%TYPE;
   v_air_cost             F_PRODUCT.AIR_COST%TYPE;
   v_fuel_surcharge       F_PRODUCT.FUEL_SURCHARGE%TYPE;
   v_air_tax              F_PRODUCT.AIR_TAX%TYPE;
   v_mask                 F_PRODUCT.MASK%TYPE;
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
      SELECT PROD.PRODUCT_CODE,
             PROD.PRODUCT_NAME,
             PROD.DESCRIPTION,
             PROD.PRODUCT_STATUS,
             PROD.BEGIN_DATE,
             PROD.END_DATE,
             PROD.BEGIN_BOOK_DATE,
             PROD.END_BOOK_DATE,
             PROD.DEFAULT_MARKET,
             PROD.PRODUCT_TYPE,
             PROD.ACTIVE_PAX_RANGE,
             PP.PAX_RANGE_FROM,
             PP.PAX_RANGE_TO,
             PP.ADULT_PRICE,
             PP.ADULT_TAX,
             PP.AIR_ADULT_ALLOW,
             PP.LAND_COST,
             PP.AIR_COST,
             PP.FUEL_SURCHARGE,
             PP.AIR_TAX,
             PP.MASK
        FROM (SELECT DP.PRODUCT_CODE,
                     DP.PRODUCT_NAME,
                     DP.DESCRIPTION,
                     DP.PRODUCT_STATUS,
                     DP.BEGIN_DATE,
                     DP.END_DATE,
                     DP.BEGIN_BOOK_DATE,
                     DP.END_BOOK_DATE,
                     DP.DEFAULT_MARKET,
                     DP.PRODUCT_TYPE,
                     DP.ACTIVE_PAX_RANGE,
                     PPL.MASK,
                     PPL.PROD_CODE_SEQ
                FROM D_PRODUCT DP,
                     (  SELECT PPF.PRODUCT_CODE, PPF.MASK, PPF.PROD_CODE_SEQ
                          FROM (  SELECT PP.PRODUCT_CODE,
                                         PP.MASK,
                                         PP.POS,
                                         PP.PROD_CODE_SEQ,
                                         LAG (
                                            PP.POS,
                                            1)
                                         OVER (PARTITION BY PP.PRODUCT_CODE
                                               ORDER BY PP.PRODUCT_CODE, PP.POS)
                                            TT
                                    FROM (  SELECT PRODUCT_CODE,
                                                   MASK,
                                                   MAX (PROD_CODE_SEQ)
                                                      PROD_CODE_SEQ,
                                                   DECODE (MASK,
                                                           'AA', 1,
                                                           'A', 2,
                                                           'AAA', 3)
                                                      POS
                                              FROM D_PRODUCT_PRICES
                                             WHERE     PAX_RANGE_FROM IS NOT NULL
                                                   AND MASK IN ('A', 'AA', 'AAA')
                                          GROUP BY PRODUCT_CODE, MASK
                                          ORDER BY PRODUCT_CODE,
                                                   DECODE (MASK,
                                                           'AA', 1,
                                                           'A', 2,
                                                           'AAA', 3)) PP
                                ORDER BY PP.PRODUCT_CODE, PP.POS) PPF
                         WHERE PPF.TT IS NULL
                      ORDER BY 2 ASC) PPL
               WHERE     DP.ACTIVE_PAX_RANGE IS NOT NULL
                     AND DP.PRODUCT_CODE = PPL.PRODUCT_CODE) PROD,
             D_PRODUCT_PRICES PP
       WHERE     PROD.PRODUCT_CODE = PP.PRODUCT_CODE
             AND PROD.MASK = PP.MASK
             AND PROD.PROD_CODE_SEQ = PP.PROD_CODE_SEQ
             AND PROD.ACTIVE_PAX_RANGE BETWEEN PP.PAX_RANGE_FROM
                                           AND PP.PAX_RANGE_TO
      UNION
      SELECT DP.PRODUCT_CODE,
             DP.PRODUCT_NAME,
             DP.DESCRIPTION,
             DP.PRODUCT_STATUS,
             DP.BEGIN_DATE,
             DP.END_DATE,
             DP.BEGIN_BOOK_DATE,
             DP.END_BOOK_DATE,
             DP.DEFAULT_MARKET,
             DP.PRODUCT_TYPE,
             DP.ACTIVE_PAX_RANGE,
             NULL PAX_RANGE_FROM,
             NULL PAX_RANGE_TO,
             NULL ADULT_PRICE,
             NULL ADULT_TAX,
             NULL AIR_ADULT_ALLOW,
             NULL LAND_COST,
             NULL AIR_COST,
             NULL FUEL_SURCHARGE,
             NULL AIR_TAX,
             NULL MASK
        FROM D_PRODUCT DP
       WHERE DP.ACTIVE_PAX_RANGE IS NULL
      UNION
      SELECT DP.PRODUCT_CODE,
             DP.PRODUCT_NAME,
             DP.DESCRIPTION,
             DP.PRODUCT_STATUS,
             DP.BEGIN_DATE,
             DP.END_DATE,
             DP.BEGIN_BOOK_DATE,
             DP.END_BOOK_DATE,
             DP.DEFAULT_MARKET,
             DP.PRODUCT_TYPE,
             DP.ACTIVE_PAX_RANGE,
             NULL PAX_RANGE_FROM,
             NULL PAX_RANGE_TO,
             NULL ADULT_PRICE,
             NULL ADULT_TAX,
             NULL AIR_ADULT_ALLOW,
             NULL LAND_COST,
             NULL AIR_COST,
             NULL FUEL_SURCHARGE,
             NULL AIR_TAX,
             NULL MASK
        FROM D_PRODUCT DP
       WHERE DP.PRODUCT_CODE NOT IN
                (SELECT PRODUCT_CODE
                   FROM (SELECT PROD.PRODUCT_CODE,
                                PROD.PRODUCT_NAME,
                                PROD.DESCRIPTION,
                                PROD.PRODUCT_STATUS,
                                PROD.BEGIN_DATE,
                                PROD.END_DATE,
                                PROD.BEGIN_BOOK_DATE,
                                PROD.END_BOOK_DATE,
                                PROD.DEFAULT_MARKET,
                                PROD.PRODUCT_TYPE,
                                PROD.ACTIVE_PAX_RANGE,
                                PP.PAX_RANGE_FROM,
                                PP.PAX_RANGE_TO,
                                PP.ADULT_PRICE,
                                PP.ADULT_TAX,
                                PP.AIR_ADULT_ALLOW,
                                PP.LAND_COST,
                                PP.AIR_COST,
                                PP.FUEL_SURCHARGE,
                                PP.AIR_TAX,
                                PP.MASK
                           FROM (SELECT DP.PRODUCT_CODE,
                                        DP.PRODUCT_NAME,
                                        DP.DESCRIPTION,
                                        DP.PRODUCT_STATUS,
                                        DP.BEGIN_DATE,
                                        DP.END_DATE,
                                        DP.BEGIN_BOOK_DATE,
                                        DP.END_BOOK_DATE,
                                        DP.DEFAULT_MARKET,
                                        DP.PRODUCT_TYPE,
                                        DP.ACTIVE_PAX_RANGE,
                                        PPL.MASK,
                                        PPL.PROD_CODE_SEQ
                                   FROM D_PRODUCT DP,
                                        (  SELECT PPF.PRODUCT_CODE,
                                                  PPF.MASK,
                                                  PPF.PROD_CODE_SEQ
                                             FROM (  SELECT PP.PRODUCT_CODE,
                                                            PP.MASK,
                                                            PP.POS,
                                                            PP.PROD_CODE_SEQ,
                                                            LAG (
                                                               PP.POS,
                                                               1)
                                                            OVER (
                                                               PARTITION BY PP.PRODUCT_CODE
                                                               ORDER BY
                                                                  PP.PRODUCT_CODE,
                                                                  PP.POS)
                                                               TT
                                                       FROM (  SELECT PRODUCT_CODE,
                                                                      MASK,
                                                                      MAX (
                                                                         PROD_CODE_SEQ)
                                                                         PROD_CODE_SEQ,
                                                                      DECODE (
                                                                         MASK,
                                                                         'AA', 1,
                                                                         'A', 2,
                                                                         'AAA', 3)
                                                                         POS
                                                                 FROM D_PRODUCT_PRICES
                                                                WHERE     PAX_RANGE_FROM
                                                                             IS NOT NULL
                                                                      AND MASK IN
                                                                             ('A',
                                                                              'AA',
                                                                              'AAA')
                                                             GROUP BY PRODUCT_CODE,
                                                                      MASK
                                                             ORDER BY PRODUCT_CODE,
                                                                      DECODE (
                                                                         MASK,
                                                                         'AA', 1,
                                                                         'A', 2,
                                                                         'AAA', 3)) PP
                                                   ORDER BY PP.PRODUCT_CODE,
                                                            PP.POS) PPF
                                            WHERE PPF.TT IS NULL
                                         ORDER BY 2 ASC) PPL
                                  WHERE     DP.ACTIVE_PAX_RANGE IS NOT NULL
                                        AND DP.PRODUCT_CODE =
                                               PPL.PRODUCT_CODE) PROD,
                                D_PRODUCT_PRICES PP
                          WHERE     PROD.PRODUCT_CODE = PP.PRODUCT_CODE
                                AND PROD.MASK = PP.MASK
                                AND PROD.PROD_CODE_SEQ = PP.PROD_CODE_SEQ
                                AND PROD.ACTIVE_PAX_RANGE BETWEEN PP.PAX_RANGE_FROM
                                                              AND PP.PAX_RANGE_TO
                         UNION
                         SELECT DP.PRODUCT_CODE,
                                DP.PRODUCT_NAME,
                                DP.DESCRIPTION,
                                DP.PRODUCT_STATUS,
                                DP.BEGIN_DATE,
                                DP.END_DATE,
                                DP.BEGIN_BOOK_DATE,
                                DP.END_BOOK_DATE,
                                DP.DEFAULT_MARKET,
                                DP.PRODUCT_TYPE,
                                DP.ACTIVE_PAX_RANGE,
                                NULL PAX_RANGE_FROM,
                                NULL PAX_RANGE_TO,
                                NULL ADULT_PRICE,
                                NULL ADULT_TAX,
                                NULL AIR_ADULT_ALLOW,
                                NULL LAND_COST,
                                NULL AIR_COST,
                                NULL FUEL_SURCHARGE,
                                NULL AIR_TAX,
                                NULL MASK
                           FROM D_PRODUCT DP
                          WHERE DP.ACTIVE_PAX_RANGE IS NULL));

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
                 v_product_status,
                 v_begin_date,
                 v_end_date,
                 v_begin_book_date,
                 v_end_book_date,
                 v_default_market,
                 v_product_type,
                 v_active_pax_range,
                 v_pax_range_from,
                 v_pax_range_to,
                 v_adult_price,
                 v_adult_tax,
                 v_air_adult_allow,
                 v_land_cost,
                 v_air_cost,
                 v_fuel_surcharge,
                 v_air_tax,
                 v_mask;

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
                  INSERT INTO f_product (product_code,
                                         product_name,
                                         description,
                                         product_status,
                                         begin_date,
                                         end_date,
                                         begin_book_date,
                                         end_book_date,
                                         default_market,
                                         product_type,
                                         active_pax_range,
                                         pax_range_from,
                                         pax_range_to,
                                         adult_price,
                                         adult_tax,
                                         air_adult_allow,
                                         land_cost,
                                         air_cost,
                                         fuel_surcharge,
                                         air_tax,
                                         mask)
                       VALUES (v_product_code,
                               v_product_name,
                               v_description,
                               v_product_status,
                               v_begin_date,
                               v_end_date,
                               v_begin_book_date,
                               v_end_book_date,
                               v_default_market,
                               v_product_type,
                               v_active_pax_range,
                               v_pax_range_from,
                               v_pax_range_to,
                               v_adult_price,
                               v_adult_tax,
                               v_air_adult_allow,
                               v_land_cost,
                               v_air_cost,
                               v_fuel_surcharge,
                               v_air_tax,
                               v_mask);

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
                     UPDATE F_PRODUCT
                        SET PRODUCT_NAME = V_PRODUCT_NAME,
                            DESCRIPTION = V_DESCRIPTION,
                            PRODUCT_STATUS = V_PRODUCT_STATUS,
                            BEGIN_DATE = V_BEGIN_DATE,
                            END_DATE = V_END_DATE,
                            BEGIN_BOOK_DATE = V_BEGIN_BOOK_DATE,
                            END_BOOK_DATE = V_END_BOOK_DATE,
                            DEFAULT_MARKET = V_DEFAULT_MARKET,
                            PRODUCT_TYPE = V_PRODUCT_TYPE,
                            ACTIVE_PAX_RANGE = V_ACTIVE_PAX_RANGE,
                            PAX_RANGE_FROM = V_PAX_RANGE_FROM,
                            PAX_RANGE_TO = V_PAX_RANGE_TO,
                            ADULT_PRICE = V_ADULT_PRICE,
                            ADULT_TAX = V_ADULT_TAX,
                            AIR_ADULT_ALLOW = V_AIR_ADULT_ALLOW,
                            LAND_COST = V_LAND_COST,
                            AIR_COST = V_AIR_COST,
                            FUEL_SURCHARGE = V_FUEL_SURCHARGE,
                            AIR_TAX = V_AIR_TAX,
                            MASK = V_MASK
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
                  INSERT INTO R_fprod_rej_rec (product_code,
                                               product_name,
                                               description,
                                               product_status,
                                               begin_date,
                                               end_date,
                                               begin_book_date,
                                               end_book_date,
                                               default_market,
                                               product_type,
                                               active_pax_range,
                                               pax_range_from,
                                               pax_range_to,
                                               adult_price,
                                               adult_tax,
                                               air_adult_allow,
                                               land_cost,
                                               air_cost,
                                               fuel_surcharge,
                                               air_tax,
                                               mask)
                       VALUES (v_product_code,
                               v_product_name,
                               v_description,
                               v_product_status,
                               v_begin_date,
                               v_end_date,
                               v_begin_book_date,
                               v_end_book_date,
                               v_default_market,
                               v_product_type,
                               v_active_pax_range,
                               v_pax_range_from,
                               v_pax_range_to,
                               v_adult_price,
                               v_adult_tax,
                               v_air_adult_allow,
                               v_land_cost,
                               v_air_cost,
                               v_fuel_surcharge,
                               v_air_tax,
                               v_mask);

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
                    VALUES ('L_FPROD',
                            'F_PRODUCT',
                            SYSDATE,
                            SUBSTR (v_code, 1, 50),
                            SUBSTR (v_error_message, 1, 250));

               --
               -- Write error record
               INSERT INTO R_fprod_rej_rec (product_code,
                                            product_name,
                                            description,
                                            product_status,
                                            begin_date,
                                            end_date,
                                            begin_book_date,
                                            end_book_date,
                                            default_market,
                                            product_type,
                                            active_pax_range,
                                            pax_range_from,
                                            pax_range_to,
                                            adult_price,
                                            adult_tax,
                                            air_adult_allow,
                                            land_cost,
                                            air_cost,
                                            fuel_surcharge,
                                            air_tax,
                                            mask)
                    VALUES (v_product_code,
                            v_product_name,
                            v_description,
                            v_product_status,
                            v_begin_date,
                            v_end_date,
                            v_begin_book_date,
                            v_end_book_date,
                            v_default_market,
                            v_product_type,
                            v_active_pax_range,
                            v_pax_range_from,
                            v_pax_range_to,
                            v_adult_price,
                            v_adult_tax,
                            v_air_adult_allow,
                            v_land_cost,
                            v_air_cost,
                            v_fuel_surcharge,
                            v_air_tax,
                            v_mask);
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
              VALUES ('L_FPROD',
                      'F_PRODUCT',
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
           VALUES ('L_FPROD',
                   'F_PRODUCT',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));

      --
      COMMIT;
--
END;                                        /**** < OPEN Cursor Block  > ****/
/
SHOW ERRORS;
