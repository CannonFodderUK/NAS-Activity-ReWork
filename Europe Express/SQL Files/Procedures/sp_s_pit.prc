SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:40 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_S_PIT
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
   v_bref_sk              f_booking.bref_sk%TYPE;
   v_booking_ref          f_booking.booking_ref%TYPE;
   v_transaction_date     f_booking.details_updated_date%TYPE;


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
   --
   CURSOR C001
   IS
      SELECT book_ref, TO_CHAR (TRUNC (SYSDATE), 'yyyymmdd') FROM l_book_diff;

   CURSOR C002 (p_booking VARCHAR2, p_upd NUMBER)
   IS
      SELECT bref_sk
        FROM f_booking
       WHERE booking_ref = p_booking AND details_updated_date = p_upd;

   CURSOR C003 (p_booking VARCHAR2, p_upd NUMBER)
   IS
      SELECT bref_sk, service_seq
        FROM f_booking_component
       WHERE booking_ref = p_booking AND details_updated_date = p_upd;

BEGIN
   /**** < OPEN Cursor Block > ****/
   --
   v_primary_key_error := 'N';
   v_foreign_key_error := 'N';

   OPEN C001;

   --
   BEGIN
      /**** < FETCH Cursor Block >  ****/
      --
      LOOP
         /**** < FETCH LOOP      >  ****/
         FETCH C001
            INTO v_booking_ref, v_transaction_date;

         EXIT WHEN C001%NOTFOUND;

         --
         FOR rec IN c002 (v_booking_ref, v_transaction_date)
         LOOP
            UPDATE f_booking
               SET bref_sk = rec.bref_sk,
                   transaction_date_id = v_transaction_date,
                   rev_ind = 'Y'
             WHERE     details_updated_date = 29992131
                   AND rev_ind = 'N'
                   AND booking_ref = v_booking_ref;
         END LOOP;

         COMMIT;

         FOR rec IN c003 (v_booking_ref, v_transaction_date)
         LOOP
            UPDATE f_booking_component
               SET bref_sk = rec.bref_sk,
                   transaction_date_id = v_transaction_date,
                   rev_ind = 'Y'
             WHERE     details_updated_date = 29992131
                   AND rev_ind = 'N'
                   AND booking_ref = v_booking_ref
                   AND service_seq = rec.service_seq;
         END LOOP;

         COMMIT;
      END LOOP;
   END;

   CLOSE c001;
END;
/
SHOW ERRORS;
