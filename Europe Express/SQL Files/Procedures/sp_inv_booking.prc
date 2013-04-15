SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:34 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_inv_booking
AS
   -- DECLARE /*****  D E C L A R E  S E C T I O N  *****/
   --===========================================================
   -- SP_F_BOOKING - which takes the contents of F_BOOKING
   -- and populates the F_BOOKING table
   --
   --===========================================================
   -- Change History
   --===========================================================
   -- Date          Ver Who Comment
   -- 11-Jan-13     1.0 tthap6  Original Version
   --
   --
   -- EXCEPTION DEFINITIONS
   --
   primary_key_error          EXCEPTION;
   PRAGMA EXCEPTION_INIT (primary_key_error, -00001);
   foreign_key_error          EXCEPTION;
   PRAGMA EXCEPTION_INIT (foreign_key_error, -02291);
   --
   --
   v_commit_at       CONSTANT PLS_INTEGER := 1000;
   --
   -- VARIABLES HOLDING DATA FROM CURSOR
   --
   v_bref_sk                  F_BOOKING.BREF_SK%TYPE;
   v_booking_ref              F_BOOKING.BOOKING_REF%TYPE;
   v_details_updated_date     F_BOOKING.DETAILS_UPDATED_DATE%TYPE;
   v_pax                      F_BOOKING.PAX%TYPE;
   v_company_id               F_BOOKING.COMPANY_ID%TYPE;
   v_brand_id                 F_BOOKING.BRAND_ID%TYPE;
   v_market_code              F_BOOKING.MARKET_CODE%TYPE;
   v_booking_product_code     F_BOOKING.BOOKING_PRODUCT_CODE%TYPE;
   v_customer_id              F_BOOKING.CUSTOMER_ID%TYPE;
   v_contact_id               F_BOOKING.CONTACT_ID%TYPE;
   v_booking_status           F_BOOKING.BOOKING_STATUS%TYPE;
   v_departure_date_id        F_BOOKING.DEPARTURE_DATE_ID%TYPE;
   v_cancel_date_id           F_BOOKING.CANCEL_DATE_ID%TYPE;
   v_booking_date_id          F_BOOKING.BOOKING_DATE_ID%TYPE;
   v_expired_option_date_id   F_BOOKING.EXPIRED_OPTION_DATE_ID%TYPE;
   v_final_payment_date_id    F_BOOKING.FINAL_PAYMENT_DATE_ID%TYPE;
   v_currency                 F_BOOKING.CURRENCY%TYPE;
   v_exchange_rate            F_BOOKING.EXCHANGE_RATE%TYPE;
   v_deposit                  F_BOOKING.DEPOSIT%TYPE;
   v_base_cost                F_BOOKING.BASE_COST%TYPE;
   v_base_cost_tax            F_BOOKING.BASE_COST_TAX%TYPE;
   v_quote_price              F_BOOKING.QUOTE_PRICE%TYPE;
   v_quote_price_tax          F_BOOKING.QUOTE_PRICE_TAX%TYPE;
   v_quote_price_gst          F_BOOKING.QUOTE_PRICE_GST%TYPE;
   v_quote_comm               F_BOOKING.QUOTE_COMM%TYPE;
   v_quote_net_due            F_BOOKING.QUOTE_NET_DUE%TYPE;
   v_quote_recieved           F_BOOKING.QUOTE_RECIEVED%TYPE;
   v_quote_balance_due        F_BOOKING.QUOTE_BALANCE_DUE%TYPE;
   v_local_accom              F_BOOKING.LOCAL_ACCOM%TYPE;
   v_quote_accom              F_BOOKING.QUOTE_ACCOM%TYPE;
   v_local_air                F_BOOKING.LOCAL_AIR%TYPE;
   v_quote_air                F_BOOKING.QUOTE_AIR%TYPE;
   v_local_anc                F_BOOKING.LOCAL_ANC%TYPE;
   v_quote_anc                F_BOOKING.QUOTE_ANC%TYPE;
   v_local_extra              F_BOOKING.LOCAL_EXTRA%TYPE;
   v_quote_extra              F_BOOKING.QUOTE_EXTRA%TYPE;
   v_local_insur              F_BOOKING.LOCAL_INSUR%TYPE;
   v_quote_insur              F_BOOKING.QUOTE_INSUR%TYPE;
   v_local_land               F_BOOKING.LOCAL_LAND%TYPE;
   v_quote_land               F_BOOKING.QUOTE_LAND%TYPE;
   v_local_misc               F_BOOKING.LOCAL_MISC%TYPE;
   v_quote_misc               F_BOOKING.QUOTE_MISC%TYPE;
   v_local_pkg                F_BOOKING.LOCAL_PKG%TYPE;
   v_quote_pkg                F_BOOKING.QUOTE_PKG%TYPE;
   v_local_promo              F_BOOKING.LOCAL_PROMO%TYPE;
   v_quote_promo              F_BOOKING.QUOTE_PROMO%TYPE;
   v_transaction_date_id      F_BOOKING.TRANSACTION_DATE_ID%TYPE;
   v_rev_ind                  F_BOOKING.REV_IND%TYPE;
   --
   -- WORK VARIABLES
   --
   v_null                     CHAR (1);
   v_count                    CHAR (1);
   v_insert_ok                CHAR (1);
   v_update_ok                CHAR (1);
   v_fk_error                 CHAR (1);
   v_foreign_key_error        CHAR (1);
   v_primary_key_error        CHAR (1);
   --
   v_code                     NUMBER (5);
   v_error_message            VARCHAR2 (512);

   --
   CURSOR C001
   IS
      SELECT DISTINCT 0 bref_sk,
                      booking_ref,
                      details_updated_date,
                      pax,
                      company_id,
                      brand_id,
                      market_code,
                      booking_product_code,
                      customer_id,
                      contact_id,
                      booking_status,
                      departure_date_id,
                      cancel_date_id,
                      booking_date_id,
                      expired_option_date_id,
                      final_payment_date_id,
                      currency,
                      exchange_rate,
                      deposit,
                      0 - base_cost,
                      0 - base_cost_tax,
                      0 - quote_price,
                      0 - quote_price_tax,
                      0 - quote_price_gst,
                      0 - quote_comm,
                      0 - quote_net_due,
                      0 - quote_recieved,
                      0 - quote_balance_due,
                      0 - local_accom,
                      0 - quote_accom,
                      0 - local_air,
                      0 - quote_air,
                      0 - local_anc,
                      0 - quote_anc,
                      0 - local_extra,
                      0 - quote_extra,
                      0 - local_insur,
                      0 - quote_insur,
                      0 - local_land,
                      0 - quote_land,
                      0 - local_misc,
                      0 - quote_misc,
                      0 - local_pkg,
                      0 - quote_pkg,
                      0 - local_promo,
                      0 - quote_promo,
                      29991231 transaction_date_id,
                      'N' rev_ind
        FROM F_BOOKING
       WHERE booking_ref IN (SELECT DISTINCT book_ref FROM l_book_diff);

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
            INTO v_bref_sk,
                 v_booking_ref,
                 v_details_updated_date,
                 v_pax,
                 v_company_id,
                 v_brand_id,
                 v_market_code,
                 v_booking_product_code,
                 v_customer_id,
                 v_contact_id,
                 v_booking_status,
                 v_departure_date_id,
                 v_cancel_date_id,
                 v_booking_date_id,
                 v_expired_option_date_id,
                 v_final_payment_date_id,
                 v_currency,
                 v_exchange_rate,
                 v_deposit,
                 v_base_cost,
                 v_base_cost_tax,
                 v_quote_price,
                 v_quote_price_tax,
                 v_quote_price_gst,
                 v_quote_comm,
                 v_quote_net_due,
                 v_quote_recieved,
                 v_quote_balance_due,
                 v_local_accom,
                 v_quote_accom,
                 v_local_air,
                 v_quote_air,
                 v_local_anc,
                 v_quote_anc,
                 v_local_extra,
                 v_quote_extra,
                 v_local_insur,
                 v_quote_insur,
                 v_local_land,
                 v_quote_land,
                 v_local_misc,
                 v_quote_misc,
                 v_local_pkg,
                 v_quote_pkg,
                 v_local_promo,
                 v_quote_promo,
                 v_transaction_date_id,
                 v_rev_ind;

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
                  INSERT INTO f_booking (bref_sk,
                                         booking_ref,
                                         details_updated_date,
                                         pax,
                                         company_id,
                                         brand_id,
                                         market_code,
                                         booking_product_code,
                                         customer_id,
                                         contact_id,
                                         booking_status,
                                         departure_date_id,
                                         cancel_date_id,
                                         booking_date_id,
                                         expired_option_date_id,
                                         final_payment_date_id,
                                         currency,
                                         exchange_rate,
                                         deposit,
                                         base_cost,
                                         base_cost_tax,
                                         quote_price,
                                         quote_price_tax,
                                         quote_price_gst,
                                         quote_comm,
                                         quote_net_due,
                                         quote_recieved,
                                         quote_balance_due,
                                         local_accom,
                                         quote_accom,
                                         local_air,
                                         quote_air,
                                         local_anc,
                                         quote_anc,
                                         local_extra,
                                         quote_extra,
                                         local_insur,
                                         quote_insur,
                                         local_land,
                                         quote_land,
                                         local_misc,
                                         quote_misc,
                                         local_pkg,
                                         quote_pkg,
                                         local_promo,
                                         quote_promo,
                                         transaction_date_id,
                                         rev_ind)
                       VALUES (v_bref_sk,
                               v_booking_ref,
                               v_details_updated_date,
                               v_pax,
                               v_company_id,
                               v_brand_id,
                               v_market_code,
                               v_booking_product_code,
                               v_customer_id,
                               v_contact_id,
                               v_booking_status,
                               v_departure_date_id,
                               v_cancel_date_id,
                               v_booking_date_id,
                               v_expired_option_date_id,
                               v_final_payment_date_id,
                               v_currency,
                               v_exchange_rate,
                               v_deposit,
                               v_base_cost,
                               v_base_cost_tax,
                               v_quote_price,
                               v_quote_price_tax,
                               v_quote_price_gst,
                               v_quote_comm,
                               v_quote_net_due,
                               v_quote_recieved,
                               v_quote_balance_due,
                               v_local_accom,
                               v_quote_accom,
                               v_local_air,
                               v_quote_air,
                               v_local_anc,
                               v_quote_anc,
                               v_local_extra,
                               v_quote_extra,
                               v_local_insur,
                               v_quote_insur,
                               v_local_land,
                               v_quote_land,
                               v_local_misc,
                               v_quote_misc,
                               v_local_pkg,
                               v_quote_pkg,
                               v_local_promo,
                               v_quote_promo,
                               v_transaction_date_id,
                               v_rev_ind);

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
                     --              UPDATE f_booking SET
                     ---- INSERT UPDATE HERE
                     --              ;
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
                  INSERT INTO r_booking (bref_sk,
                                         booking_ref,
                                         details_updated_date,
                                         pax,
                                         company_id,
                                         brand_id,
                                         market_code,
                                         booking_product_code,
                                         customer_id,
                                         contact_id,
                                         booking_status,
                                         departure_date_id,
                                         cancel_date_id,
                                         booking_date_id,
                                         expired_option_date_id,
                                         final_payment_date_id,
                                         currency,
                                         exchange_rate,
                                         deposit,
                                         base_cost,
                                         base_cost_tax,
                                         quote_price,
                                         quote_price_tax,
                                         quote_price_gst,
                                         quote_comm,
                                         quote_net_due,
                                         quote_recieved,
                                         quote_balance_due,
                                         local_accom,
                                         quote_accom,
                                         local_air,
                                         quote_air,
                                         local_anc,
                                         quote_anc,
                                         local_extra,
                                         quote_extra,
                                         local_insur,
                                         quote_insur,
                                         local_land,
                                         quote_land,
                                         local_misc,
                                         quote_misc,
                                         local_pkg,
                                         quote_pkg,
                                         local_promo,
                                         quote_promo,
                                         transaction_date,
                                         rev_ind)
                       VALUES (v_bref_sk,
                               v_booking_ref,
                               v_details_updated_date,
                               v_pax,
                               v_company_id,
                               v_brand_id,
                               v_market_code,
                               v_booking_product_code,
                               v_customer_id,
                               v_contact_id,
                               v_booking_status,
                               v_departure_date_id,
                               v_cancel_date_id,
                               v_booking_date_id,
                               v_expired_option_date_id,
                               v_final_payment_date_id,
                               v_currency,
                               v_exchange_rate,
                               v_deposit,
                               v_base_cost,
                               v_base_cost_tax,
                               v_quote_price,
                               v_quote_price_tax,
                               v_quote_price_gst,
                               v_quote_comm,
                               v_quote_net_due,
                               v_quote_recieved,
                               v_quote_balance_due,
                               v_local_accom,
                               v_quote_accom,
                               v_local_air,
                               v_quote_air,
                               v_local_anc,
                               v_quote_anc,
                               v_local_extra,
                               v_quote_extra,
                               v_local_insur,
                               v_quote_insur,
                               v_local_land,
                               v_quote_land,
                               v_local_misc,
                               v_quote_misc,
                               v_local_pkg,
                               v_quote_pkg,
                               v_local_promo,
                               v_quote_promo,
                               v_transaction_date_id,
                               v_rev_ind);
               --
               -- Now check which FOREIGN KEY is the problem
               --
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
                    VALUES ('F_BOOKING',
                            'F_BOOKING',
                            SYSDATE,
                            SUBSTR (v_code, 1, 50),
                            SUBSTR (v_error_message, 1, 250));

               --
               -- Write error record
               INSERT INTO r_booking (bref_sk,
                                      booking_ref,
                                      details_updated_date,
                                      pax,
                                      company_id,
                                      brand_id,
                                      market_code,
                                      booking_product_code,
                                      customer_id,
                                      contact_id,
                                      booking_status,
                                      departure_date_id,
                                      cancel_date_id,
                                      booking_date_id,
                                      expired_option_date_id,
                                      final_payment_date_id,
                                      currency,
                                      exchange_rate,
                                      deposit,
                                      base_cost,
                                      base_cost_tax,
                                      quote_price,
                                      quote_price_tax,
                                      quote_price_gst,
                                      quote_comm,
                                      quote_net_due,
                                      quote_recieved,
                                      quote_balance_due,
                                      local_accom,
                                      quote_accom,
                                      local_air,
                                      quote_air,
                                      local_anc,
                                      quote_anc,
                                      local_extra,
                                      quote_extra,
                                      local_insur,
                                      quote_insur,
                                      local_land,
                                      quote_land,
                                      local_misc,
                                      quote_misc,
                                      local_pkg,
                                      quote_pkg,
                                      local_promo,
                                      quote_promo,
                                      transaction_date,
                                      rev_ind)
                    VALUES (v_bref_sk,
                            v_booking_ref,
                            v_details_updated_date,
                            v_pax,
                            v_company_id,
                            v_brand_id,
                            v_market_code,
                            v_booking_product_code,
                            v_customer_id,
                            v_contact_id,
                            v_booking_status,
                            v_departure_date_id,
                            v_cancel_date_id,
                            v_booking_date_id,
                            v_expired_option_date_id,
                            v_final_payment_date_id,
                            v_currency,
                            v_exchange_rate,
                            v_deposit,
                            v_base_cost,
                            v_base_cost_tax,
                            v_quote_price,
                            v_quote_price_tax,
                            v_quote_price_gst,
                            v_quote_comm,
                            v_quote_net_due,
                            v_quote_recieved,
                            v_quote_balance_due,
                            v_local_accom,
                            v_quote_accom,
                            v_local_air,
                            v_quote_air,
                            v_local_anc,
                            v_quote_anc,
                            v_local_extra,
                            v_quote_extra,
                            v_local_insur,
                            v_quote_insur,
                            v_local_land,
                            v_quote_land,
                            v_local_misc,
                            v_quote_misc,
                            v_local_pkg,
                            v_quote_pkg,
                            v_local_promo,
                            v_quote_promo,
                            v_transaction_date_id,
                            v_rev_ind);
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
              VALUES ('F_BOOKING',
                      'F_BOOKING',
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
           VALUES ('F_BOOKING',
                   'F_BOOKING',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));

      --
      COMMIT;
--
END;                                        /**** < OPEN Cursor Block  > ****/
/
SHOW ERRORS;
