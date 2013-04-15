SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:39 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_L_prodtl
AS
   -- DECLARE /*****  D E C L A R E  S E C T I O N  *****/
   --===========================================================
   -- SP_PRODTL - which takes the contents of L_PRODUCTDETAIL
   -- and populates the D_PRODUCT_DETAIL table
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
   v_reference_number     D_PRODUCT_DETAIL.REFERENCE_NUMBER%TYPE;
   v_product_code         D_PRODUCT_DETAIL.PRODUCT_CODE%TYPE;
   v_pd_sequence          D_PRODUCT_DETAIL.PD_SEQUENCE%TYPE;
   v_i_seq                D_PRODUCT_DETAIL.I_SEQ%TYPE;
   v_rec_type             D_PRODUCT_DETAIL.REC_TYPE%TYPE;
   v_item_role            D_PRODUCT_DETAIL.ITEM_ROLE%TYPE;
   v_supplier_id          D_PRODUCT_DETAIL.SUPPLIER_ID%TYPE;
   v_service_id           D_PRODUCT_DETAIL.SERVICE_ID%TYPE;
   v_description          D_PRODUCT_DETAIL.DESCRIPTION%TYPE;
   v_from_date            D_PRODUCT_DETAIL.FROM_DATE%TYPE;
   v_to_date              D_PRODUCT_DETAIL.TO_DATE%TYPE;
   v_week_days            D_PRODUCT_DETAIL.WEEK_DAYS%TYPE;
   v_on_day               D_PRODUCT_DETAIL.ON_DAY%TYPE;
   v_on_time              D_PRODUCT_DETAIL.ON_TIME%TYPE;
   v_duration             D_PRODUCT_DETAIL.DURATION%TYPE;
   v_flex_duration        D_PRODUCT_DETAIL.FLEX_DURATION%TYPE;
   v_min_nights           D_PRODUCT_DETAIL.MIN_NIGHTS%TYPE;
   v_link_code            D_PRODUCT_DETAIL.LINK_CODE%TYPE;
   v_auto_select          D_PRODUCT_DETAIL.AUTO_SELECT%TYPE;
   v_divisible_pax        D_PRODUCT_DETAIL.DIVISIBLE_PAX%TYPE;
   v_invoice_flag         D_PRODUCT_DETAIL.INVOICE_FLAG%TYPE;
   v_additional_data      D_PRODUCT_DETAIL.ADDITIONAL_DATA%TYPE;
   v_whostamp             D_PRODUCT_DETAIL.WHOSTAMP%TYPE;
   v_datestamp            D_PRODUCT_DETAIL.DATESTAMP%TYPE;
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
      SELECT REFERENCENUMBER REFERENCE_NUMBER,
             PRODUCTCODE PRODUCT_CODE,
             SEQ PD_SEQUENCE,
             ISEQ I_SEQ,
             RECTYPE REC_TYPE,
             ITEMROLE ITEM_ROLE,
             SUPPLIERID SUPPLIER_ID,
             SERVICEID SERVICE_ID,
             DESCRIPTION,
             FROMDATE FROM_DATE,
             TODATE TO_DATE,
             WEEKDAYS WEEK_DAYS,
             ONDAY ON_DAY,
             ONTIME ON_TIME,
             DURATION,
             FLEXDURATION FLEX_DURATION,
             MINNTS MIN_NIGHTS,
             LINKCODE LINK_CODE,
             AUTOSELECT AUTO_SELECT,
             DIVISIBLEPAX DIVISIBLE_PAX,
             INVOICEFLAG INVOICE_FLAG,
             ADDITIONALDATA ADDITIONAL_DATA,
             WHOSTAMP,
             DATESTAMP
        FROM L_PRODUCTDETAIL
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
            INTO v_reference_number,
                 v_product_code,
                 v_pd_sequence,
                 v_i_seq,
                 v_rec_type,
                 v_item_role,
                 v_supplier_id,
                 v_service_id,
                 v_description,
                 v_from_date,
                 v_to_date,
                 v_week_days,
                 v_on_day,
                 v_on_time,
                 v_duration,
                 v_flex_duration,
                 v_min_nights,
                 v_link_code,
                 v_auto_select,
                 v_divisible_pax,
                 v_invoice_flag,
                 v_additional_data,
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
                  INSERT INTO d_product_detail (reference_number,
                                                product_code,
                                                pd_sequence,
                                                i_seq,
                                                rec_type,
                                                item_role,
                                                supplier_id,
                                                service_id,
                                                description,
                                                from_date,
                                                TO_DATE,
                                                week_days,
                                                on_day,
                                                on_time,
                                                duration,
                                                flex_duration,
                                                min_nights,
                                                link_code,
                                                auto_select,
                                                divisible_pax,
                                                invoice_flag,
                                                additional_data,
                                                whostamp,
                                                datestamp)
                       VALUES (v_reference_number,
                               v_product_code,
                               v_pd_sequence,
                               v_i_seq,
                               v_rec_type,
                               v_item_role,
                               v_supplier_id,
                               v_service_id,
                               v_description,
                               v_from_date,
                               v_to_date,
                               v_week_days,
                               v_on_day,
                               v_on_time,
                               v_duration,
                               v_flex_duration,
                               v_min_nights,
                               v_link_code,
                               v_auto_select,
                               v_divisible_pax,
                               v_invoice_flag,
                               v_additional_data,
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
                     UPDATE D_PRODUCT_DETAIL
                        SET PRODUCT_CODE = V_PRODUCT_CODE,
                            PD_SEQUENCE = V_PD_SEQUENCE,
                            I_SEQ = V_I_SEQ,
                            REC_TYPE = V_REC_TYPE,
                            ITEM_ROLE = V_ITEM_ROLE,
                            SUPPLIER_ID = V_SUPPLIER_ID,
                            SERVICE_ID = V_SERVICE_ID,
                            DESCRIPTION = V_DESCRIPTION,
                            FROM_DATE = V_FROM_DATE,
                            TO_DATE = V_TO_DATE,
                            WEEK_DAYS = V_WEEK_DAYS,
                            ON_DAY = V_ON_DAY,
                            ON_TIME = V_ON_TIME,
                            DURATION = V_DURATION,
                            FLEX_DURATION = V_FLEX_DURATION,
                            MIN_NIGHTS = V_MIN_NIGHTS,
                            LINK_CODE = V_LINK_CODE,
                            AUTO_SELECT = V_AUTO_SELECT,
                            DIVISIBLE_PAX = V_DIVISIBLE_PAX,
                            INVOICE_FLAG = V_INVOICE_FLAG,
                            ADDITIONAL_DATA = V_ADDITIONAL_DATA,
                            WHOSTAMP = V_WHOSTAMP,
                            DATESTAMP = V_DATESTAMP
                      WHERE REFERENCE_NUMBER = V_REFERENCE_NUMBER;

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
                  INSERT INTO R_prodtl_rej_rec (reference_number,
                                                product_code,
                                                pd_sequence,
                                                i_seq,
                                                rec_type,
                                                item_role,
                                                supplier_id,
                                                service_id,
                                                description,
                                                from_date,
                                                TO_DATE,
                                                week_days,
                                                on_day,
                                                on_time,
                                                duration,
                                                flex_duration,
                                                min_nights,
                                                link_code,
                                                auto_select,
                                                divisible_pax,
                                                invoice_flag,
                                                additional_data,
                                                whostamp,
                                                datestamp)
                       VALUES (v_reference_number,
                               v_product_code,
                               v_pd_sequence,
                               v_i_seq,
                               v_rec_type,
                               v_item_role,
                               v_supplier_id,
                               v_service_id,
                               v_description,
                               v_from_date,
                               v_to_date,
                               v_week_days,
                               v_on_day,
                               v_on_time,
                               v_duration,
                               v_flex_duration,
                               v_min_nights,
                               v_link_code,
                               v_auto_select,
                               v_divisible_pax,
                               v_invoice_flag,
                               v_additional_data,
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
                    VALUES ('PRODTL',
                            'D_PRODUCT_DETAIL',
                            SYSDATE,
                            SUBSTR (v_code, 1, 50),
                            SUBSTR (v_error_message, 1, 250));

               --
               -- Write error record
               INSERT INTO R_prodtl_rej_rec (reference_number,
                                             product_code,
                                             pd_sequence,
                                             i_seq,
                                             rec_type,
                                             item_role,
                                             supplier_id,
                                             service_id,
                                             description,
                                             from_date,
                                             TO_DATE,
                                             week_days,
                                             on_day,
                                             on_time,
                                             duration,
                                             flex_duration,
                                             min_nights,
                                             link_code,
                                             auto_select,
                                             divisible_pax,
                                             invoice_flag,
                                             additional_data,
                                             whostamp,
                                             datestamp)
                    VALUES (v_reference_number,
                            v_product_code,
                            v_pd_sequence,
                            v_i_seq,
                            v_rec_type,
                            v_item_role,
                            v_supplier_id,
                            v_service_id,
                            v_description,
                            v_from_date,
                            v_to_date,
                            v_week_days,
                            v_on_day,
                            v_on_time,
                            v_duration,
                            v_flex_duration,
                            v_min_nights,
                            v_link_code,
                            v_auto_select,
                            v_divisible_pax,
                            v_invoice_flag,
                            v_additional_data,
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
              VALUES ('PRODTL',
                      'D_PRODUCT_DETAIL',
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
           VALUES ('PRODTL',
                   'D_PRODUCT_DETAIL',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));

      --
      COMMIT;
--
END;                                        /**** < OPEN Cursor Block  > ****/
/
SHOW ERRORS;
