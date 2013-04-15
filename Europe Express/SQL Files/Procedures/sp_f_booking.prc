SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:34 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_f_booking
AS
   -- DECLARE /*****  D E C L A R E  S E C T I O N  *****/
   --===========================================================
   -- SP_F_BOOKING - which takes the contents of L_RESGENERAL
   -- and populates the F_BOOKING table
   --
   --===========================================================
   -- Change History
   --===========================================================
   -- Date          Ver Who Comment
   -- 04-Jan-13     1.0 Adrian Pinkus  Original Version
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
   v_bref_sk                  f_booking.bref_sk%TYPE;
   v_booking_ref              f_booking.booking_ref%TYPE;
   v_details_updated_date     f_booking.details_updated_date%TYPE;
   v_pax                      f_booking.pax%TYPE;
   v_company_id               f_booking.company_id%TYPE;
   v_brand_id                 f_booking.brand_id%TYPE;
   v_market_code              f_booking.market_code%TYPE;
   v_booking_product_code     f_booking.booking_product_code%TYPE;
   v_customer_id              f_booking.customer_id%TYPE;
   v_contact_id               f_booking.contact_id%TYPE;
   v_booking_status           f_booking.booking_status%TYPE;
   v_departure_date_id        f_booking.departure_date_id%TYPE;
   v_cancel_date_id           f_booking.cancel_date_id%TYPE;
   v_booking_date_id          f_booking.booking_date_id%TYPE;
   v_expired_option_date_id   f_booking.expired_option_date_id%TYPE;
   v_deposit                  f_booking.deposit%TYPE;
   v_final_payment_date_id    f_booking.final_payment_date_id%TYPE;
   v_currency                 f_booking.currency%TYPE;
   v_exchange_rate            f_booking.exchange_rate%TYPE;
   v_base_cost                f_booking.base_cost%TYPE;
   v_base_cost_tax            f_booking.base_cost_tax%TYPE;
   v_quote_price              f_booking.quote_price%TYPE;
   v_quote_price_tax          f_booking.quote_price_tax%TYPE;
   v_quote_price_gst          f_booking.quote_price_gst%TYPE;
   v_quote_comm               f_booking.quote_comm%TYPE;
   v_quote_net_due            f_booking.quote_net_due%TYPE;
   v_quote_recieved           f_booking.quote_recieved%TYPE;
   v_quote_balance_due        f_booking.quote_balance_due%TYPE;
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
   CURSOR c001
   IS
      SELECT rg.resnumber booking_ref,
             TO_CHAR (SYSDATE, 'yyyymmdd') upd,
             nopax pax,
             companyid company_id,
             brandid brand_id,
             marketcode,
             resproductcode,
             NVL (customerid, '-1') customer_id,
             contactid contact_id,
             resstatus booking_status,
             TO_CHAR (depdate, 'yyyymmdd') dep_date,
             TO_CHAR (
                TRUNC (
                   TO_TIMESTAMP (
                      SUBSTR (TO_CHAR (ADDITIONALDATA),
                                INSTR (TO_CHAR (ADDITIONALDATA),
                                       '<CancellationDate>',
                                       1,
                                       1)
                              + 18,
                              (  INSTR (TO_CHAR (ADDITIONALDATA),
                                        '</CancellationDate>',
                                        1,
                                        1)
                               - (  INSTR (TO_CHAR (ADDITIONALDATA),
                                           '<CancellationDate>',
                                           1,
                                           1)
                                  + 18))),
                      'yyyy-mm-dd hh24:mi:ss.ff9')),
                'yyyymmdd')
                canx_date,
             TO_CHAR (bookdate, 'yyyymmdd') book_date,
             TO_CHAR (expiredoption, 'yyyymmdd') opt_date,
             TO_CHAR (finalpayment, 'yyyymmdd') fin_pay_date,
             qcurrency,
             qexch,
             depositamount dep_amnt,
             NVL (ttlbasecost, 0),
             NVL (ttlbasecosttax, 0),
             NVL (ttlquoteprice, 0),
             NVL (ttlquotepricetax, 0),
             NVL (ttlquotepricegst, 0),
             NVL (ttlquotecomm, 0),
             NVL (ttlquotenetdue, 0),
             NVL (ttlquotereceived, 0),
             NVL (ttlquotebaldue, 0),
             TO_CHAR (SYSDATE, 'yyyymmdd') upd,
             'Y'
        FROM l_resgeneral rg
       WHERE resnumber IN (SELECT DISTINCT book_ref FROM l_book_diff);

--
BEGIN
   /**** < OPEN Cursor Block > ****/
   --
   v_primary_key_error := 'N';
   v_foreign_key_error := 'N';

   --
   OPEN c001;

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
         FETCH c001
            INTO v_booking_ref,
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
                 v_transaction_date_id,
                 v_rev_ind;

         --
         EXIT WHEN c001%NOTFOUND;

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
                  v_bref_sk := trek_dataw.bref_sk_seq.NEXTVAL;

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
                                         deposit,
                                         final_payment_date_id,
                                         currency,
                                         exchange_rate,
                                         base_cost,
                                         base_cost_tax,
                                         quote_price,
                                         quote_price_tax,
                                         quote_price_gst,
                                         quote_comm,
                                         quote_net_due,
                                         quote_recieved,
                                         quote_balance_due,
                                         transaction_date_id,
                                         rev_ind,
                                         current_ind)
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
                               v_deposit,
                               v_final_payment_date_id,
                               v_currency,
                               v_exchange_rate,
                               v_base_cost,
                               v_base_cost_tax,
                               v_quote_price,
                               v_quote_price_tax,
                               v_quote_price_gst,
                               v_quote_comm,
                               v_quote_net_due,
                               v_quote_recieved,
                               v_quote_balance_due,
                               v_transaction_date_id,
                               v_rev_ind,
                               'Y');

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
                     -- update f_booking set
                     -- INSERT UPDATE HERE
                     --  ;
                     --
                     v_update_ok := 'Y';
                     v_insert_ok := 'Y';
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
                  INSERT INTO r_booking (booking_ref,
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
                                         deposit,
                                         final_payment_date_id,
                                         currency,
                                         exchange_rate,
                                         base_cost,
                                         base_cost_tax,
                                         quote_price,
                                         quote_price_tax,
                                         quote_price_gst,
                                         quote_comm,
                                         quote_net_due,
                                         quote_recieved,
                                         quote_balance_due)
                       VALUES (v_booking_ref,
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
                               v_deposit,
                               v_final_payment_date_id,
                               v_currency,
                               v_exchange_rate,
                               v_base_cost,
                               v_base_cost_tax,
                               v_quote_price,
                               v_quote_price_tax,
                               v_quote_price_gst,
                               v_quote_comm,
                               v_quote_net_due,
                               v_quote_recieved,
                               v_quote_balance_due);
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
               INSERT INTO r_booking (booking_ref,
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
                                      deposit,
                                      final_payment_date_id,
                                      currency,
                                      exchange_rate,
                                      base_cost,
                                      base_cost_tax,
                                      quote_price,
                                      quote_price_tax,
                                      quote_price_gst,
                                      quote_comm,
                                      quote_net_due,
                                      quote_recieved,
                                      quote_balance_due)
                    VALUES (v_booking_ref,
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
                            v_deposit,
                            v_final_payment_date_id,
                            v_currency,
                            v_exchange_rate,
                            v_base_cost,
                            v_base_cost_tax,
                            v_quote_price,
                            v_quote_price_tax,
                            v_quote_price_gst,
                            v_quote_comm,
                            v_quote_net_due,
                            v_quote_recieved,
                            v_quote_balance_due);
         --
         END;                               /**** < MAIN Cursor Block >  ****/

         --
         -- Commit at intervals
         --
         IF c001%ROWCOUNT MOD v_commit_at = 0
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
   CLOSE c001;

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
