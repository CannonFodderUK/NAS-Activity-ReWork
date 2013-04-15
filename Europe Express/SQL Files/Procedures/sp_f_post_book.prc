SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:34 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_f_post_book
AS
   -- DECLARE /*****  D E C L A R E  S E C T I O N  *****/
   --===========================================================
   -- SP_F_POST_BOOK - which takes the contents of f_booking
   -- and populates the F_BOOKING table
   --
   --===========================================================
   -- Change History
   --===========================================================
   -- Date          Ver Who Comment
   -- 08-Jan-13     1.0 tthap6  Original Version
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
   --
   CURSOR c002 (
      p_book    VARCHAR2,
      p_upd     NUMBER)
   IS
        SELECT booking_ref,
               SUM (
                  CASE st.GROUPING
                     WHEN 'Accommodation'
                     THEN
                          (ttl_quote_price * cost_exch)
                        + (ttl_quote_price_tax * cost_exch)
                     ELSE
                        0
                  END)
                  quote_Accom,
               SUM (
                  CASE st.GROUPING
                     WHEN 'Ancillary'
                     THEN
                          (ttl_quote_price * cost_exch)
                        + (ttl_quote_price_tax * cost_exch)
                     ELSE
                        0
                  END)
                  quote_anc,
               SUM (
                  CASE st.GROUPING
                     WHEN 'Insurance'
                     THEN
                          (ttl_quote_price * cost_exch)
                        + (ttl_quote_price_tax * cost_exch)
                     ELSE
                        0
                  END)
                  Quote_ins,
               SUM (
                  CASE st.GROUPING
                     WHEN 'Land'
                     THEN
                          (ttl_quote_price * cost_exch)
                        + (ttl_quote_price_tax * cost_exch)
                     ELSE
                        0
                  END)
                  Quote_land,
               SUM (
                  CASE st.GROUPING
                     WHEN 'Miscellaneous'
                     THEN
                          (ttl_quote_price * cost_exch)
                        + (ttl_quote_price_tax * cost_exch)
                     ELSE
                        0
                  END)
                  Quote_misc,
               SUM (
                  CASE st.GROUPING
                     WHEN 'Package'
                     THEN
                          (ttl_quote_price * cost_exch)
                        + (ttl_quote_price_tax * cost_exch)
                     ELSE
                        0
                  END)
                  Quote_pkg,
               SUM (
                  CASE st.GROUPING
                     WHEN 'Air'
                     THEN
                          (ttl_quote_price * cost_exch)
                        + (ttl_quote_price_tax * cost_exch)
                     ELSE
                        0
                  END)
                  Quote_air,
               SUM (
                  CASE st.GROUPING
                     WHEN 'Promotion'
                     THEN
                          (ttl_quote_price * cost_exch)
                        + (ttl_quote_price_tax * cost_exch)
                     ELSE
                        0
                  END)
                  Quote_promo,
               SUM (
                  CASE st.GROUPING
                     WHEN 'Extras'
                     THEN
                          (ttl_quote_price * cost_exch)
                        + (ttl_quote_price_tax * cost_exch)
                     ELSE
                        0
                  END)
                  Quote_ext,
               SUM (
                  CASE st.GROUPING
                     WHEN 'Accommodation'
                     THEN
                          (ttl_local_cost * cost_exch)
                        + (ttl_local_cost_tax * cost_exch)
                     ELSE
                        0
                  END)
                  local_Accom,
               SUM (
                  CASE st.GROUPING
                     WHEN 'Ancillary'
                     THEN
                          (ttl_local_cost * cost_exch)
                        + (ttl_local_cost_tax * cost_exch)
                     ELSE
                        0
                  END)
                  local_anc,
               SUM (
                  CASE st.GROUPING
                     WHEN 'Insurance'
                     THEN
                          (ttl_local_cost * cost_exch)
                        + (ttl_local_cost_tax * cost_exch)
                     ELSE
                        0
                  END)
                  local_ins,
               SUM (
                  CASE st.GROUPING
                     WHEN 'Land'
                     THEN
                          (ttl_local_cost * cost_exch)
                        + (ttl_local_cost_tax * cost_exch)
                     ELSE
                        0
                  END)
                  local_land,
               SUM (
                  CASE st.GROUPING
                     WHEN 'Miscellaneous'
                     THEN
                          (ttl_local_cost * cost_exch)
                        + (ttl_local_cost_tax * cost_exch)
                     ELSE
                        0
                  END)
                  local_misc,
               SUM (
                  CASE st.GROUPING
                     WHEN 'Package'
                     THEN
                          (ttl_local_cost * cost_exch)
                        + (ttl_local_cost_tax * cost_exch)
                     ELSE
                        0
                  END)
                  local_pkg,
               SUM (
                  CASE st.GROUPING
                     WHEN 'Air'
                     THEN
                          (ttl_local_cost * cost_exch)
                        + (ttl_local_cost_tax * cost_exch)
                     ELSE
                        0
                  END)
                  local_air,
               SUM (
                  CASE st.GROUPING
                     WHEN 'Promotion'
                     THEN
                          (ttl_local_cost * cost_exch)
                        + (ttl_local_cost_tax * cost_exch)
                     ELSE
                        0
                  END)
                  local_promo,
               SUM (
                  CASE st.GROUPING
                     WHEN 'Extras'
                     THEN
                          (ttl_local_cost * cost_exch)
                        + (ttl_local_cost_tax * cost_exch)
                     ELSE
                        0
                  END)
                  local_ext
          FROM f_booking_component mv, d_service_type st
         WHERE     mv.service_type = ST.SERVICE_TYPE
               AND booking_ref = p_book
               AND details_updated_date = p_upd
      --  and rev_ind = 'Y'
      GROUP BY booking_ref;

   CURSOR c001
   IS
      SELECT book_ref FROM l_book_diff;

BEGIN
   /**** < OPEN Cursor Block > ****/
   --
   v_primary_key_error := 'N';
   v_foreign_key_error := 'N';

   UPDATE f_booking
      SET current_ind = 'N'
    WHERE     details_updated_date < TO_CHAR (TRUNC (SYSDATE), 'yyyymmdd')
          AND booking_ref IN (SELECT DISTINCT book_ref FROM l_book_diff)
          AND current_ind = 'Y';

   COMMIT;

   UPDATE f_booking_component
      SET current_ind = 'N'
    WHERE     details_updated_date < TO_CHAR (TRUNC (SYSDATE), 'yyyymmdd')
          AND booking_ref IN (SELECT DISTINCT book_ref FROM l_book_diff)
          AND current_ind = 'Y';

   COMMIT;

   UPDATE f_booking
      SET current_ind = 'Y'
    WHERE     details_updated_date = TO_CHAR (TRUNC (SYSDATE), 'yyyymmdd')
          AND booking_ref IN (SELECT DISTINCT book_ref FROM l_book_diff)
          AND transaction_date_id = TO_CHAR (TRUNC (SYSDATE), 'yyyymmdd');

   COMMIT;

   UPDATE f_booking_component
      SET current_ind = 'Y'
    WHERE     details_updated_date < TO_CHAR (TRUNC (SYSDATE), 'yyyymmdd')
          AND booking_ref IN (SELECT DISTINCT book_ref FROM l_book_diff)
          AND transaction_date_id = TO_CHAR (TRUNC (SYSDATE), 'yyyymmdd');

   COMMIT;

   OPEN C001;

   --
   BEGIN
      /**** < FETCH Cursor Block >  ****/
      --
      LOOP
         /**** < FETCH LOOP      >  ****/
         FETCH C001 INTO v_booking_ref;

         EXIT WHEN C001%NOTFOUND;

         --
         FOR rec
            IN c002 (v_booking_ref, TO_CHAR (TRUNC (SYSDATE), 'yyyymmdd'))
         LOOP
            UPDATE f_booking
               SET LOCAL_ACCOM = rec.local_accom,
                   QUOTE_ACCOM = rec.QUOTE_ACCOM,
                   LOCAL_AIR = rec.LOCAL_AIR,
                   QUOTE_AIR = rec.QUOTE_AIR,
                   LOCAL_ANC = rec.LOCAL_ANC,
                   QUOTE_ANC = rec.QUOTE_ANC,
                   LOCAL_EXTRA = rec.LOCAL_EXT,
                   QUOTE_EXTRA = rec.QUOTE_EXT,
                   LOCAL_INSUR = rec.LOCAL_INS,
                   QUOTE_INSUR = rec.QUOTE_INS,
                   LOCAL_LAND = rec.LOCAL_LAND,
                   QUOTE_LAND = rec.QUOTE_LAND,
                   LOCAL_MISC = rec.LOCAL_MISC,
                   QUOTE_MISC = rec.QUOTE_MISC,
                   LOCAL_PKG = rec.LOCAL_PKG,
                   QUOTE_PKG = rec.LOCAL_PKG,
                   LOCAL_PROMO = rec.LOCAL_PROMO,
                   QUOTE_PROMO = rec.QUOTE_PROMO
             WHERE     booking_ref = v_booking_ref
                   AND details_updated_date =
                          TO_CHAR (TRUNC (SYSDATE), 'yyyymmdd');
         END LOOP;
      END LOOP;
   END;

   CLOSE c001;
END;
/
SHOW ERRORS;
