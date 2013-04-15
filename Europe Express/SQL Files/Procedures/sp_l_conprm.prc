SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:36 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_l_conprm
AS
   -- DECLARE /*****  D E C L A R E  S E C T I O N  *****/
   --===========================================================
   -- SP_L_CONPRM - which takes the contents of L_MRKCONTACTPROMOTION
   -- and populates the D_CONTACT_PROMOTION table
   --
   --===========================================================
   -- Change History
   --===========================================================
   -- Date          Ver Who Comment
   -- 07-Jan-13     1.0 tthmlx  Original Version
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
   v_contact_promo_id     D_CONTACT_PROMOTION.CONTACT_PROMO_ID%TYPE;
   v_contact_id           D_CONTACT_PROMOTION.CONTACT_ID%TYPE;
   v_promotion_id         D_CONTACT_PROMOTION.PROMOTION_ID%TYPE;
   v_book_date            D_CONTACT_PROMOTION.BOOK_DATE%TYPE;
   v_price                D_CONTACT_PROMOTION.PRICE%TYPE;
   v_begin_book           D_CONTACT_PROMOTION.BEGIN_BOOK%TYPE;
   v_end_book             D_CONTACT_PROMOTION.END_BOOK%TYPE;
   v_status               D_CONTACT_PROMOTION.STATUS%TYPE;
   v_for_res_no           D_CONTACT_PROMOTION.FOR_RES_NO%TYPE;
   v_whostamp             D_CONTACT_PROMOTION.WHOSTAMP%TYPE;
   v_datestamp            D_CONTACT_PROMOTION.DATESTAMP%TYPE;
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
      SELECT CONTPROMOID CONTACT_PROMO_ID,
             CONTACTID CONTACT_ID,
             PROMOTIONID PROMOTION_ID,
             BOOKDATE BOOK_DATE,
             PRICE,
             BEGBOOK BEGIN_BOOK,
             ENDBOOK END_BOOK,
             STATUS,
             SUBSTR (ADDITIONALDATA,
                     15,
                       INSTR (ADDITIONALDATA,
                              '<',
                              1,
                              2)
                     - 15)
                FOR_RES_NO,
             WHOSTAMP,
             DATESTAMP
        FROM L_MRKCONTACTPROMOTIONS;

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
            INTO v_contact_promo_id,
                 v_contact_id,
                 v_promotion_id,
                 v_book_date,
                 v_price,
                 v_begin_book,
                 v_end_book,
                 v_status,
                 v_for_res_no,
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
                  INSERT INTO d_contact_promotion (contact_promo_id,
                                                   contact_id,
                                                   promotion_id,
                                                   book_date,
                                                   price,
                                                   begin_book,
                                                   end_book,
                                                   status,
                                                   for_res_no,
                                                   whostamp,
                                                   datestamp)
                       VALUES (v_contact_promo_id,
                               v_contact_id,
                               v_promotion_id,
                               v_book_date,
                               v_price,
                               v_begin_book,
                               v_end_book,
                               v_status,
                               v_for_res_no,
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
                     UPDATE D_CONTACT_PROMOTION
                        SET CONTACT_ID = V_CONTACT_ID,
                            PROMOTION_ID = V_PROMOTION_ID,
                            BOOK_DATE = V_BOOK_DATE,
                            PRICE = V_PRICE,
                            BEGIN_BOOK = V_BEGIN_BOOK,
                            END_BOOK = V_END_BOOK,
                            STATUS = V_STATUS,
                            FOR_RES_NO = V_FOR_RES_NO,
                            WHOSTAMP = V_WHOSTAMP,
                            DATESTAMP = V_DATESTAMP
                      WHERE CONTACT_PROMO_ID = V_CONTACT_PROMO_ID;

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
                  INSERT INTO R_conprm_rej_rec (contact_promo_id,
                                                contact_id,
                                                promotion_id,
                                                book_date,
                                                price,
                                                begin_book,
                                                end_book,
                                                status,
                                                for_res_no,
                                                whostamp,
                                                datestamp)
                       VALUES (v_contact_promo_id,
                               v_contact_id,
                               v_promotion_id,
                               v_book_date,
                               v_price,
                               v_begin_book,
                               v_end_book,
                               v_status,
                               v_for_res_no,
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
                    VALUES ('L_CONPRM',
                            'D_CONTACT_PROMOTION',
                            SYSDATE,
                            SUBSTR (v_code, 1, 50),
                            SUBSTR (v_error_message, 1, 250));

               --
               -- Write error record
               INSERT INTO R_conprm_rej_rec (contact_promo_id,
                                             contact_id,
                                             promotion_id,
                                             book_date,
                                             price,
                                             begin_book,
                                             end_book,
                                             status,
                                             for_res_no,
                                             whostamp,
                                             datestamp)
                    VALUES (v_contact_promo_id,
                            v_contact_id,
                            v_promotion_id,
                            v_book_date,
                            v_price,
                            v_begin_book,
                            v_end_book,
                            v_status,
                            v_for_res_no,
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
              VALUES ('L_CONPRM',
                      'D_CONTACT_PROMOTION',
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
           VALUES ('L_CONPRM',
                   'D_CONTACT_PROMOTION',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));

      --
      COMMIT;
--
END;                                        /**** < OPEN Cursor Block  > ****/
/
SHOW ERRORS;
