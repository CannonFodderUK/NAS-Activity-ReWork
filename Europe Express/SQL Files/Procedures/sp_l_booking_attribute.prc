SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:35 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_l_booking_attribute
AS
   -- DECLARE /*****  D E C L A R E  S E C T I O N  *****/
   --===========================================================
   -- SP_D_BOOKING_ATT - which takes the contents of D_BOOKING_ATT
   -- and populates the D_BOOKING_ATT table
   --
   --===========================================================
   -- Change History
   --===========================================================
   -- Date          Ver Who Comment
   -- 15-Jan-13     1.0 tthap6  Original Version
   --
   --
   -- EXCEPTION DEFINITIONS
   --
   primary_key_error       EXCEPTION;
   PRAGMA EXCEPTION_INIT (primary_key_error, -00001);
   foreign_key_error       EXCEPTION;
   PRAGMA EXCEPTION_INIT (foreign_key_error, -02291);
   --
   --
   v_commit_at    CONSTANT PLS_INTEGER := 1000;
   --
   -- VARIABLES HOLDING DATA FROM CURSOR
   --
   v_booking_ref           D_BOOKING_ATT.booking_ref%TYPE;
   v_related_booking_ref   D_BOOKING_ATT.RELATED_booking_ref%TYPE;
   v_lead_name             D_BOOKING_ATT.LEAD_NAME%TYPE;
   v_res_tour_code         D_BOOKING_ATT.RES_TOUR_CODE%TYPE;
   v_sell_method           D_BOOKING_ATT.SELL_METHOD%TYPE;
   v_customer_type         D_BOOKING_ATT.CUSTOMER_TYPE%TYPE;
   v_affiliation_id        D_BOOKING_ATT.AFFILIATION_ID%TYPE;
   v_comm_code             D_BOOKING_ATT.COMM_CODE%TYPE;
   v_doc_status            D_BOOKING_ATT.DOC_STATUS%TYPE;
   v_correspondance_type   D_BOOKING_ATT.CORRESPONDANCE_TYPE%TYPE;
   v_book_by               D_BOOKING_ATT.BOOK_BY%TYPE;
   v_book_source           D_BOOKING_ATT.BOOK_SOURCE%TYPE;
   v_dep_required          D_BOOKING_ATT.DEP_REQUIRED%TYPE;
   v_payment_guarantee     D_BOOKING_ATT.PAYMENT_GUARANTEE%TYPE;
   v_remarks               D_BOOKING_ATT.REMARKS%TYPE;
   v_cc_per                D_BOOKING_ATT.CC_PER%TYPE;
   v_is_cc_bkg             D_BOOKING_ATT.IS_CC_BKG%TYPE;
   v_parent_res_number     D_BOOKING_ATT.PARENT_RES_NUMBER%TYPE;
   v_added_by              D_BOOKING_ATT.ADDED_BY%TYPE;
   --
   -- WORK VARIABLES
   --
   v_null                  CHAR (1);
   v_count                 CHAR (1);
   v_insert_ok             CHAR (1);
   v_update_ok             CHAR (1);
   v_fk_error              CHAR (1);
   v_foreign_key_error     CHAR (1);
   v_primary_key_error     CHAR (1);
   --
   v_code                  NUMBER (5);
   v_error_message         VARCHAR2 (512);

   --
   CURSOR C001
   IS
      SELECT DISTINCT RESNUMBER,
                      RELATEDRES,
                      LEADNAME,
                      RESTOURCODE,
                      SELLMETHOD,
                      CUSTOMERTYPE,
                      AFFILIATIONID,
                      COMMCODE,
                      DOCSTATUS,
                      CORRESPONDENCETYPE,
                      BOOKEDBY,
                      BOOKSOURCE,
                      DEPREQUIRED,
                      PAYMENTGUARANTEE,
                      REMARK,
                      CCPER,
                      ISCCBKG,
                      PARENTRESNUMBER,
                      WHOSTAMP
        FROM l_resgeneral;

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
            INTO v_booking_ref,
                 v_related_booking_ref,
                 v_lead_name,
                 v_res_tour_code,
                 v_sell_method,
                 v_customer_type,
                 v_affiliation_id,
                 v_comm_code,
                 v_doc_status,
                 v_correspondance_type,
                 v_book_by,
                 v_book_source,
                 v_dep_required,
                 v_payment_guarantee,
                 v_remarks,
                 v_cc_per,
                 v_is_cc_bkg,
                 v_parent_res_number,
                 v_added_by;

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
                  INSERT INTO d_booking_att (booking_ref,
                                             related_booking_ref,
                                             lead_name,
                                             res_tour_code,
                                             sell_method,
                                             customer_type,
                                             affiliation_id,
                                             comm_code,
                                             doc_status,
                                             correspondance_type,
                                             book_by,
                                             book_source,
                                             dep_required,
                                             payment_guarantee,
                                             remarks,
                                             cc_per,
                                             is_cc_bkg,
                                             parent_res_number,
                                             added_by)
                       VALUES (v_booking_ref,
                               v_related_booking_ref,
                               v_lead_name,
                               v_res_tour_code,
                               v_sell_method,
                               v_customer_type,
                               v_affiliation_id,
                               v_comm_code,
                               v_doc_status,
                               v_correspondance_type,
                               v_book_by,
                               v_book_source,
                               v_dep_required,
                               v_payment_guarantee,
                               v_remarks,
                               v_cc_per,
                               v_is_cc_bkg,
                               v_parent_res_number,
                               v_added_by);

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
                     UPDATE d_booking_att
                        SET (booking_ref,
                             related_booking_ref,
                             lead_name,
                             res_tour_code,
                             sell_method,
                             customer_type,
                             affiliation_id,
                             comm_code,
                             doc_status,
                             correspondance_type,
                             book_by,
                             book_source,
                             dep_required,
                             payment_guarantee,
                             remarks,
                             cc_per,
                             is_cc_bkg,
                             parent_res_number,
                             added_by) =
                               (SELECT v_booking_ref,
                                       v_related_booking_ref,
                                       v_lead_name,
                                       v_res_tour_code,
                                       v_sell_method,
                                       v_customer_type,
                                       v_affiliation_id,
                                       v_comm_code,
                                       v_doc_status,
                                       v_correspondance_type,
                                       v_book_by,
                                       v_book_source,
                                       v_dep_required,
                                       v_payment_guarantee,
                                       v_remarks,
                                       v_cc_per,
                                       v_is_cc_bkg,
                                       v_parent_res_number,
                                       v_added_by
                                  FROM DUAL)
                      WHERE booking_ref = v_booking_ref;

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
                  INSERT INTO r_booking_att (booking_ref,
                                             related_booking_ref,
                                             lead_name,
                                             res_tour_code,
                                             sell_method,
                                             customer_type,
                                             affiliation_id,
                                             comm_code,
                                             doc_status,
                                             correspondance_type,
                                             book_by,
                                             book_source,
                                             dep_required,
                                             payment_guarantee,
                                             remarks,
                                             cc_per,
                                             is_cc_bkg,
                                             parent_res_number,
                                             added_by)
                       VALUES (v_booking_ref,
                               v_related_booking_ref,
                               v_lead_name,
                               v_res_tour_code,
                               v_sell_method,
                               v_customer_type,
                               v_affiliation_id,
                               v_comm_code,
                               v_doc_status,
                               v_correspondance_type,
                               v_book_by,
                               v_book_source,
                               v_dep_required,
                               v_payment_guarantee,
                               v_remarks,
                               v_cc_per,
                               v_is_cc_bkg,
                               v_parent_res_number,
                               v_added_by);
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
                    VALUES ('D_BOOKING_ATT',
                            'D_BOOKING_ATT',
                            SYSDATE,
                            SUBSTR (v_code, 1, 50),
                            SUBSTR (v_error_message, 1, 250));

               --
               -- Write error record
               INSERT INTO r_booking_att (booking_ref,
                                          related_booking_ref,
                                          lead_name,
                                          res_tour_code,
                                          sell_method,
                                          customer_type,
                                          affiliation_id,
                                          comm_code,
                                          doc_status,
                                          correspondance_type,
                                          book_by,
                                          book_source,
                                          dep_required,
                                          payment_guarantee,
                                          remarks,
                                          cc_per,
                                          is_cc_bkg,
                                          parent_res_number,
                                          added_by)
                    VALUES (v_booking_ref,
                            v_related_booking_ref,
                            v_lead_name,
                            v_res_tour_code,
                            v_sell_method,
                            v_customer_type,
                            v_affiliation_id,
                            v_comm_code,
                            v_doc_status,
                            v_correspondance_type,
                            v_book_by,
                            v_book_source,
                            v_dep_required,
                            v_payment_guarantee,
                            v_remarks,
                            v_cc_per,
                            v_is_cc_bkg,
                            v_parent_res_number,
                            v_added_by);
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
              VALUES ('D_BOOKING_ATT',
                      'D_BOOKING_ATT',
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
           VALUES ('D_BOOKING_ATT',
                   'D_BOOKING_ATT',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));

      --
      COMMIT;
--
END;                                        /**** < OPEN Cursor Block  > ****/
/
SHOW ERRORS;
