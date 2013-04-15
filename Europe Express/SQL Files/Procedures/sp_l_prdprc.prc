SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:38 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_l_prdprc
AS
   -- DECLARE /*****  D E C L A R E  S E C T I O N  *****/
   --===========================================================
   -- SP_L_PRDPRC - which takes the contents of L_PRODUCTPRICES
   -- and populates the D_PRODUCT_PRICES table
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
   primary_key_error         EXCEPTION;
   PRAGMA EXCEPTION_INIT (primary_key_error, -00001);
   foreign_key_error         EXCEPTION;
   PRAGMA EXCEPTION_INIT (foreign_key_error, -02291);
   --
   --
   v_commit_at      CONSTANT PLS_INTEGER := 1000;
   --
   -- VARIABLES HOLDING DATA FROM CURSOR
   --
   v_product_code            D_PRODUCT_PRICES.PRODUCT_CODE%TYPE;
   v_prod_code_seq           D_PRODUCT_PRICES.PROD_CODE_SEQ%TYPE;
   v_brand_id                D_PRODUCT_PRICES.BRAND_ID%TYPE;
   v_sell_method             D_PRODUCT_PRICES.SELL_METHOD%TYPE;
   v_qcurrency               D_PRODUCT_PRICES.QCURRENCY%TYPE;
   v_supplier_id             D_PRODUCT_PRICES.SUPPLIER_ID%TYPE;
   v_service_id              D_PRODUCT_PRICES.SERVICE_ID%TYPE;
   v_sale_status             D_PRODUCT_PRICES.SALE_STATUS%TYPE;
   v_match_req_mask          D_PRODUCT_PRICES.MATCH_REQ_MASK%TYPE;
   v_mask                    D_PRODUCT_PRICES.MASK%TYPE;
   v_pax_range_label         D_PRODUCT_PRICES.PAX_RANGE_LABEL%TYPE;
   v_pax_range_from          D_PRODUCT_PRICES.PAX_RANGE_FROM%TYPE;
   v_pax_range_to            D_PRODUCT_PRICES.PAX_RANGE_TO%TYPE;
   v_duration                D_PRODUCT_PRICES.DURATION%TYPE;
   v_begin_date              D_PRODUCT_PRICES.BEGIN_DATE%TYPE;
   v_end_date                D_PRODUCT_PRICES.END_DATE%TYPE;
   v_begin_book_date         D_PRODUCT_PRICES.BEGIN_BOOK_DATE%TYPE;
   v_end_book_date           D_PRODUCT_PRICES.END_BOOK_DATE%TYPE;
   v_weekday                 D_PRODUCT_PRICES.WEEKDAY%TYPE;
   v_fp_type                 D_PRODUCT_PRICES.FP_TYPE%TYPE;
   v_use_duration            D_PRODUCT_PRICES.USE_DURATION%TYPE;
   v_from_adult_price        D_PRODUCT_PRICES.FROM_ADULT_PRICE%TYPE;
   v_to_adult_price          D_PRODUCT_PRICES.TO_ADULT_PRICE%TYPE;
   v_adult_price             D_PRODUCT_PRICES.ADULT_PRICE%TYPE;
   v_adult_tax               D_PRODUCT_PRICES.ADULT_TAX%TYPE;
   v_adult_gst               D_PRODUCT_PRICES.ADULT_GST%TYPE;
   v_child_price             D_PRODUCT_PRICES.CHILD_PRICE%TYPE;
   v_child_tax               D_PRODUCT_PRICES.CHILD_TAX%TYPE;
   v_child_gst               D_PRODUCT_PRICES.CHILD_GST%TYPE;
   v_add_pax_price           D_PRODUCT_PRICES.ADD_PAX_PRICE%TYPE;
   v_air_adult_allow         D_PRODUCT_PRICES.AIR_ADULT_ALLOW%TYPE;
   v_air_child_allow         D_PRODUCT_PRICES.AIR_CHILD_ALLOW%TYPE;
   v_inner_air_adult_allow   D_PRODUCT_PRICES.INNER_AIR_ADULT_ALLOW%TYPE;
   v_inner_air_child_allow   D_PRODUCT_PRICES.INNER_AIR_CHILD_ALLOW%TYPE;
   v_land_cost               D_PRODUCT_PRICES.LAND_COST%TYPE;
   v_air_cost                D_PRODUCT_PRICES.AIR_COST%TYPE;
   v_display_status          D_PRODUCT_PRICES.DISPLAY_STATUS%TYPE;
   v_fuel_surcharge          D_PRODUCT_PRICES.FUEL_SURCHARGE%TYPE;
   v_air_tax                 D_PRODUCT_PRICES.AIR_TAX%TYPE;
   v_whostamp                D_PRODUCT_PRICES.WHOSTAMP%TYPE;
   v_datestamp               D_PRODUCT_PRICES.DATESTAMP%TYPE;
   --
   -- WORK VARIABLES
   --
   v_null                    CHAR (1);
   v_count                   CHAR (1);
   v_insert_ok               CHAR (1);
   v_update_ok               CHAR (1);
   v_fk_error                CHAR (1);
   v_foreign_key_error       CHAR (1);
   v_primary_key_error       CHAR (1);
   --
   v_code                    NUMBER (5);
   v_error_message           VARCHAR2 (512);

   --
   CURSOR C001
   IS
      SELECT PRODUCTCODE PRODUCT_CODE,
             SEQ PROD_CODE_SEQ,
             BRANDID BRAND_ID,
             SELLMETHOD SELL_METHOD,
             QCURRENCY,
             SUPPLIERID SUPPLIER_ID,
             SERVICEID SERVICE_ID,
             SALESTATUS SALE_STATUS,
             MATCHREQMASK MATCH_REQ_MASK,
             MASK,
             PAXRANGE PAX_RANGE_LABEL,
             NVL (
                TO_NUMBER (SUBSTR (PAXRANGE, 1, INSTR (PAXRANGE, '-') - 1)),
                0)
                PAX_RANGE_FROM,
             NVL (
                TO_NUMBER (
                   SUBSTR (PAXRANGE,
                           INSTR (PAXRANGE, '-') + 2,
                           LENGTH (PAXRANGE))),
                0)
                PAX_RANGE_TO,
             DURATION,
             BEGINDDATE BEGIN_DATE,
             ENDDDATE END_DATE,
             BEGINBDATE BEGIN_BOOK_DATE,
             ENDBDATE END_BOOK_DATE,
             WEEKDAY,
             FPTYPE FP_TYPE,
             USEDURATION USE_DURATION,
             FROMADTPRICE FROM_ADULT_PRICE,
             TOADTPRICE TO_ADULT_PRICE,
             ADTPRICE ADULT_PRICE,
             ADTTAX ADULT_TAX,
             ADTGST ADULT_GST,
             CHDPRICE CHILD_PRICE,
             CHDTAX CHILD_TAX,
             CHDGST CHILD_GST,
             ADDPAXPRICE ADD_PAX_PRICE,
             AIRADTALLOW AIR_ADULT_ALLOW,
             AIRCHDALLOW AIR_CHILD_ALLOW,
             INNERAIRADTALLOW INNER_AIR_ADULT_ALLOW,
             INNERAIRCHDALLOW INNER_AIR_CHILD_ALLOW,
             LANDCOST LAND_COST,
             AIRCOST AIR_COST,
             DISPLAYSTATUS DISPLAY_STATUS,
             NVL (SUBSTR (ADDITIONALDATA,
                            INSTR (ADDITIONALDATA,
                                   '<FuelSurcharge>',
                                   1,
                                   1)
                          + 15,
                          (  INSTR (ADDITIONALDATA,
                                    '</FuelSurcharge>',
                                    1,
                                    1)
                           - (  INSTR (ADDITIONALDATA,
                                       '<FuelSurcharge>',
                                       1,
                                       1)
                              + 15))),
                  0)
                fuel_surcharge,
             NVL (SUBSTR (ADDITIONALDATA,
                            INSTR (ADDITIONALDATA,
                                   '<Tax>',
                                   1,
                                   1)
                          + 5,
                          (  INSTR (ADDITIONALDATA,
                                    '</Tax>',
                                    1,
                                    1)
                           - (  INSTR (ADDITIONALDATA,
                                       '<Tax>',
                                       1,
                                       1)
                              + 5))),
                  0)
                air_tax,
             WHOSTAMP,
             DATESTAMP
        FROM L_PRODUCTPRICES
       WHERE PRODUCTCODE IN (SELECT PRODUCTCODE FROM L_PRODUCT);

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
                 v_prod_code_seq,
                 v_brand_id,
                 v_sell_method,
                 v_qcurrency,
                 v_supplier_id,
                 v_service_id,
                 v_sale_status,
                 v_match_req_mask,
                 v_mask,
                 v_pax_range_label,
                 v_pax_range_from,
                 v_pax_range_to,
                 v_duration,
                 v_begin_date,
                 v_end_date,
                 v_begin_book_date,
                 v_end_book_date,
                 v_weekday,
                 v_fp_type,
                 v_use_duration,
                 v_from_adult_price,
                 v_to_adult_price,
                 v_adult_price,
                 v_adult_tax,
                 v_adult_gst,
                 v_child_price,
                 v_child_tax,
                 v_child_gst,
                 v_add_pax_price,
                 v_air_adult_allow,
                 v_air_child_allow,
                 v_inner_air_adult_allow,
                 v_inner_air_child_allow,
                 v_land_cost,
                 v_air_cost,
                 v_display_status,
                 v_fuel_surcharge,
                 v_air_tax,
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
                  INSERT INTO d_product_prices (product_code,
                                                prod_code_seq,
                                                brand_id,
                                                sell_method,
                                                qcurrency,
                                                supplier_id,
                                                service_id,
                                                sale_status,
                                                match_req_mask,
                                                mask,
                                                pax_range_label,
                                                pax_range_from,
                                                pax_range_to,
                                                duration,
                                                begin_date,
                                                end_date,
                                                begin_book_date,
                                                end_book_date,
                                                weekday,
                                                fp_type,
                                                use_duration,
                                                from_adult_price,
                                                to_adult_price,
                                                adult_price,
                                                adult_tax,
                                                adult_gst,
                                                child_price,
                                                child_tax,
                                                child_gst,
                                                add_pax_price,
                                                air_adult_allow,
                                                air_child_allow,
                                                inner_air_adult_allow,
                                                inner_air_child_allow,
                                                land_cost,
                                                air_cost,
                                                display_status,
                                                fuel_surcharge,
                                                air_tax,
                                                whostamp,
                                                datestamp)
                       VALUES (v_product_code,
                               v_prod_code_seq,
                               v_brand_id,
                               v_sell_method,
                               v_qcurrency,
                               v_supplier_id,
                               v_service_id,
                               v_sale_status,
                               v_match_req_mask,
                               v_mask,
                               v_pax_range_label,
                               v_pax_range_from,
                               v_pax_range_to,
                               v_duration,
                               v_begin_date,
                               v_end_date,
                               v_begin_book_date,
                               v_end_book_date,
                               v_weekday,
                               v_fp_type,
                               v_use_duration,
                               v_from_adult_price,
                               v_to_adult_price,
                               v_adult_price,
                               v_adult_tax,
                               v_adult_gst,
                               v_child_price,
                               v_child_tax,
                               v_child_gst,
                               v_add_pax_price,
                               v_air_adult_allow,
                               v_air_child_allow,
                               v_inner_air_adult_allow,
                               v_inner_air_child_allow,
                               v_land_cost,
                               v_air_cost,
                               v_display_status,
                               v_fuel_surcharge,
                               v_air_tax,
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
                     UPDATE D_PRODUCT_PRICES
                        SET BRAND_ID = V_BRAND_ID,
                            SELL_METHOD = V_SELL_METHOD,
                            QCURRENCY = V_QCURRENCY,
                            SUPPLIER_ID = V_SUPPLIER_ID,
                            SERVICE_ID = V_SERVICE_ID,
                            SALE_STATUS = V_SALE_STATUS,
                            MATCH_REQ_MASK = V_MATCH_REQ_MASK,
                            MASK = V_MASK,
                            PAX_RANGE_LABEL = V_PAX_RANGE_LABEL,
                            PAX_RANGE_FROM = V_PAX_RANGE_FROM,
                            PAX_RANGE_TO = V_PAX_RANGE_TO,
                            DURATION = V_DURATION,
                            BEGIN_DATE = V_BEGIN_DATE,
                            END_DATE = V_END_DATE,
                            BEGIN_BOOK_DATE = V_BEGIN_BOOK_DATE,
                            END_BOOK_DATE = V_END_BOOK_DATE,
                            WEEKDAY = V_WEEKDAY,
                            FP_TYPE = V_FP_TYPE,
                            USE_DURATION = V_USE_DURATION,
                            FROM_ADULT_PRICE = V_FROM_ADULT_PRICE,
                            TO_ADULT_PRICE = V_TO_ADULT_PRICE,
                            ADULT_PRICE = V_ADULT_PRICE,
                            ADULT_TAX = V_ADULT_TAX,
                            ADULT_GST = V_ADULT_GST,
                            CHILD_PRICE = V_CHILD_PRICE,
                            CHILD_TAX = V_CHILD_TAX,
                            CHILD_GST = V_CHILD_GST,
                            ADD_PAX_PRICE = V_ADD_PAX_PRICE,
                            AIR_ADULT_ALLOW = V_AIR_ADULT_ALLOW,
                            AIR_CHILD_ALLOW = V_AIR_CHILD_ALLOW,
                            INNER_AIR_ADULT_ALLOW = V_INNER_AIR_ADULT_ALLOW,
                            INNER_AIR_CHILD_ALLOW = V_INNER_AIR_CHILD_ALLOW,
                            LAND_COST = V_LAND_COST,
                            AIR_COST = V_AIR_COST,
                            DISPLAY_STATUS = V_DISPLAY_STATUS,
                            FUEL_SURCHARGE = V_FUEL_SURCHARGE,
                            AIR_TAX = V_AIR_TAX,
                            WHOSTAMP = V_WHOSTAMP,
                            DATESTAMP = V_DATESTAMP
                      WHERE     PRODUCT_CODE = V_PRODUCT_CODE
                            AND PROD_CODE_SEQ = V_PROD_CODE_SEQ;

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
                  INSERT INTO R_prdprc_rej_rec (product_code,
                                                prod_code_seq,
                                                brand_id,
                                                sell_method,
                                                qcurrency,
                                                supplier_id,
                                                service_id,
                                                sale_status,
                                                match_req_mask,
                                                mask,
                                                pax_range_label,
                                                pax_range_from,
                                                pax_range_to,
                                                duration,
                                                begin_date,
                                                end_date,
                                                begin_book_date,
                                                end_book_date,
                                                weekday,
                                                fp_type,
                                                use_duration,
                                                from_adult_price,
                                                to_adult_price,
                                                adult_price,
                                                adult_tax,
                                                adult_gst,
                                                child_price,
                                                child_tax,
                                                child_gst,
                                                add_pax_price,
                                                air_adult_allow,
                                                air_child_allow,
                                                inner_air_adult_allow,
                                                inner_air_child_allow,
                                                land_cost,
                                                air_cost,
                                                display_status,
                                                fuel_surcharge,
                                                air_tax,
                                                whostamp,
                                                datestamp)
                       VALUES (v_product_code,
                               v_prod_code_seq,
                               v_brand_id,
                               v_sell_method,
                               v_qcurrency,
                               v_supplier_id,
                               v_service_id,
                               v_sale_status,
                               v_match_req_mask,
                               v_mask,
                               v_pax_range_label,
                               v_pax_range_from,
                               v_pax_range_to,
                               v_duration,
                               v_begin_date,
                               v_end_date,
                               v_begin_book_date,
                               v_end_book_date,
                               v_weekday,
                               v_fp_type,
                               v_use_duration,
                               v_from_adult_price,
                               v_to_adult_price,
                               v_adult_price,
                               v_adult_tax,
                               v_adult_gst,
                               v_child_price,
                               v_child_tax,
                               v_child_gst,
                               v_add_pax_price,
                               v_air_adult_allow,
                               v_air_child_allow,
                               v_inner_air_adult_allow,
                               v_inner_air_child_allow,
                               v_land_cost,
                               v_air_cost,
                               v_display_status,
                               v_fuel_surcharge,
                               v_air_tax,
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
                    VALUES ('L_PRDPRC',
                            'D_PRODUCT_PRICES',
                            SYSDATE,
                            SUBSTR (v_code, 1, 50),
                            SUBSTR (v_error_message, 1, 250));

               --
               -- Write error record
               INSERT INTO R_prdprc_rej_rec (product_code,
                                             prod_code_seq,
                                             brand_id,
                                             sell_method,
                                             qcurrency,
                                             supplier_id,
                                             service_id,
                                             sale_status,
                                             match_req_mask,
                                             mask,
                                             pax_range_label,
                                             pax_range_from,
                                             pax_range_to,
                                             duration,
                                             begin_date,
                                             end_date,
                                             begin_book_date,
                                             end_book_date,
                                             weekday,
                                             fp_type,
                                             use_duration,
                                             from_adult_price,
                                             to_adult_price,
                                             adult_price,
                                             adult_tax,
                                             adult_gst,
                                             child_price,
                                             child_tax,
                                             child_gst,
                                             add_pax_price,
                                             air_adult_allow,
                                             air_child_allow,
                                             inner_air_adult_allow,
                                             inner_air_child_allow,
                                             land_cost,
                                             air_cost,
                                             display_status,
                                             fuel_surcharge,
                                             air_tax,
                                             whostamp,
                                             datestamp)
                    VALUES (v_product_code,
                            v_prod_code_seq,
                            v_brand_id,
                            v_sell_method,
                            v_qcurrency,
                            v_supplier_id,
                            v_service_id,
                            v_sale_status,
                            v_match_req_mask,
                            v_mask,
                            v_pax_range_label,
                            v_pax_range_from,
                            v_pax_range_to,
                            v_duration,
                            v_begin_date,
                            v_end_date,
                            v_begin_book_date,
                            v_end_book_date,
                            v_weekday,
                            v_fp_type,
                            v_use_duration,
                            v_from_adult_price,
                            v_to_adult_price,
                            v_adult_price,
                            v_adult_tax,
                            v_adult_gst,
                            v_child_price,
                            v_child_tax,
                            v_child_gst,
                            v_add_pax_price,
                            v_air_adult_allow,
                            v_air_child_allow,
                            v_inner_air_adult_allow,
                            v_inner_air_child_allow,
                            v_land_cost,
                            v_air_cost,
                            v_display_status,
                            v_fuel_surcharge,
                            v_air_tax,
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
              VALUES ('L_PRDPRC',
                      'D_PRODUCT_PRICES',
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
           VALUES ('L_PRDPRC',
                   'D_PRODUCT_PRICES',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));

      --
      COMMIT;
--
END;                                        /**** < OPEN Cursor Block  > ****/
/
SHOW ERRORS;
