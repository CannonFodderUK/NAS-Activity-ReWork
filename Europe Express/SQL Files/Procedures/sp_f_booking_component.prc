SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:34 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_f_booking_component
AS
   --DECLARE /*****  D E C L A R E  S E C T I O N  *****/
   --===========================================================
   -- SP_F_BOOKING_COMPONENT - which takes the contents of F_BOOKING_COMPONENT
   -- and populates the F_BOOKING_COMPONENT table
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
   primary_key_error           EXCEPTION;
   PRAGMA EXCEPTION_INIT (primary_key_error, -00001);
   foreign_key_error           EXCEPTION;
   PRAGMA EXCEPTION_INIT (foreign_key_error, -02291);
   --
   --
   v_commit_at        CONSTANT PLS_INTEGER := 1000;
   --
   -- VARIABLES HOLDING DATA FROM CURSOR
   --
   v_bref_sk                   f_booking_component.bref_sk%TYPE;
   v_details_updated_date      f_booking_component.details_updated_date%TYPE;
   v_booking_ref               f_booking_component.booking_ref%TYPE;
   v_service_seq               f_booking_component.service_seq%TYPE;
   v_product_code              f_booking_component.product_code%TYPE;
   v_service_type              f_booking_component.service_type%TYPE;
   v_service_date_id           f_booking_component.service_date_id%TYPE;
   v_service_id                f_booking_component.service_id%TYPE;
   v_service_duration          f_booking_component.service_duration%TYPE;
   v_market_code               f_booking_component.market_code%TYPE;
   v_block_code                f_booking_component.block_code%TYPE;
   v_supplier_comm_form        f_booking_component.supplier_comm_form%TYPE;
   v_local_supplier_comm       f_booking_component.local_supplier_comm%TYPE;
   v_local_supplier_comm_rec   f_booking_component.local_supplier_comm_rec%TYPE;
   v_quantity                  f_booking_component.quantity%TYPE;
   v_cost_exch                 f_booking_component.cost_exch%TYPE;
   v_local_cost                f_booking_component.local_cost%TYPE;
   v_local_cost_tax            f_booking_component.local_cost_tax%TYPE;
   v_local_cost_gst            f_booking_component.local_cost_gst%TYPE;
   v_quote_price               f_booking_component.quote_price%TYPE;
   v_quote_display_price       f_booking_component.quote_display_price%TYPE;
   v_quote_price_tax           f_booking_component.quote_price_tax%TYPE;
   v_quote_price_gst           f_booking_component.quote_price_gst%TYPE;
   v_quote_price_enc           f_booking_component.quote_price_enc%TYPE;
   v_comm_per                  f_booking_component.comm_per%TYPE;
   v_max_comm                  f_booking_component.max_comm%TYPE;
   v_transaction_date_id       f_booking_component.transaction_date_id%TYPE;
   v_rev_ind                   f_booking_component.rev_ind%TYPE;
   v_current_ind               f_booking_component.current_ind%TYPE;
   --
   -- WORK VARIABLES
   --
   v_null                      CHAR (1);
   v_count                     CHAR (1);
   v_insert_ok                 CHAR (1);
   v_update_ok                 CHAR (1);
   v_fk_error                  CHAR (1);
   v_foreign_key_error         CHAR (1);
   v_primary_key_error         CHAR (1);
   --
   v_code                      NUMBER (5);
   v_error_message             VARCHAR2 (512);

   --
   CURSOR C001
   IS
      SELECT 0,
             TO_NUMBER (TO_CHAR (TRUNC (SYSDATE), 'yyyymmdd')) upd,
             RESNUMBER bk_ref,
             SERVICESEQ,
             PRODUCTCODE,
             SERVICETYPE,
             TO_NUMBER (TO_CHAR (TRUNC (SERVICEDATE), 'yyyymmdd')) serdate,
             SERVICEDURATION,
             SERVICEID,
             REPLACE (REPLACE (SUPPLIERCOMMFORM, '<SupplierCommPer>', ''),
                      '</SupplierCommPer>',
                      '')
                supcomform,
             LOCALSUPPLIERCOMM,
             LOCALSUPPLIERCOMMREC,
             MARKETCODE,
             BLOCKCODE,
             QTY,
             NVL (costexch, 1),
             NVL (LOCALCOST, 0) lcst,
             NVL (LOCALCOSTTAX, 0) lcsttax,
             NVL (LOCALCOSTGST, 0) lcstgst,
             NVL (QUOTEPRICE, 0) quoteprce,
             NVL (QUOTEDISPLAYPRICE, 0) qtdisprice,
             NVL (QUOTEPRICETAX, 0) qtpricetax,
             NVL (QUOTEPRICEGST, 0) qgst,
             NVL (QUOTEPRICENC, 0) qenc,
             NVL (commper, 0) comper,
             NVL (maxcomm, 0) maxcom,
             TO_NUMBER (TO_CHAR (TRUNC (SYSDATE), 'yyyymmdd')) transdate,
             'Y'
        FROM L_RESITINERARY
       WHERE deleted = 'N';

--     and resnumber in (select book_ref from l_book_diff);
--
BEGIN
   /**** < OPEN Cursor Block > ****/
   --
   v_primary_key_error := 'N';
   v_foreign_key_error := 'N';

   brefsk_sequence.reset_brefsk_seq;

   brefsk_sequence.reset_brefsk ('F_BOOKING_COMPONENT');

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
                 v_details_updated_date,
                 v_booking_ref,
                 v_service_seq,
                 v_product_code,
                 v_service_type,
                 v_service_date_id,
                 v_service_duration,
                 v_service_id,
                 v_supplier_comm_form,
                 v_local_supplier_comm,
                 v_local_supplier_comm_rec,
                 v_market_code,
                 v_block_code,
                 v_quantity,
                 v_cost_exch,
                 v_local_cost,
                 v_local_cost_tax,
                 v_local_cost_gst,
                 v_quote_price,
                 v_quote_display_price,
                 v_quote_price_tax,
                 v_quote_price_gst,
                 v_quote_price_enc,
                 v_comm_per,
                 v_max_comm,
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
                  v_bref_sk := trek_dataw.bref_sk_seq.NEXTVAL;

                  --
                  INSERT INTO f_booking_component (bref_sk,
                                                   details_updated_date,
                                                   booking_ref,
                                                   service_seq,
                                                   product_code,
                                                   service_type,
                                                   service_date_id,
                                                   service_duration,
                                                   service_id,
                                                   supplier_comm_form,
                                                   local_supplier_comm,
                                                   local_supplier_comm_rec,
                                                   market_code,
                                                   block_code,
                                                   quantity,
                                                   cost_exch,
                                                   local_cost,
                                                   local_cost_tax,
                                                   local_cost_gst,
                                                   quote_price,
                                                   quote_display_price,
                                                   quote_price_tax,
                                                   quote_price_gst,
                                                   quote_price_enc,
                                                   comm_per,
                                                   max_comm,
                                                   ttl_local_cost,
                                                   ttl_Local_cost_tax,
                                                   ttl_local_cost_gst,
                                                   ttl_quote_price,
                                                   ttl_quote_display_price,
                                                   ttl_quote_price_tax,
                                                   transaction_date_id,
                                                   rev_ind)
                       VALUES (v_bref_sk,
                               v_details_updated_date,
                               v_booking_ref,
                               v_service_seq,
                               v_product_code,
                               v_service_type,
                               v_service_date_id,
                               v_service_duration,
                               v_service_id,
                               v_supplier_comm_form,
                               v_local_supplier_comm,
                               v_local_supplier_comm_rec,
                               v_market_code,
                               v_block_code,
                               v_quantity,
                               v_cost_exch,
                               v_local_cost,
                               v_local_cost_tax,
                               v_local_cost_gst,
                               v_quote_price,
                               v_quote_display_price,
                               v_quote_price_tax,
                               v_quote_price_gst,
                               v_quote_price_enc,
                               v_comm_per,
                               v_max_comm,
                               v_quantity * v_local_cost,
                               v_quantity * v_local_cost_tax,
                               v_quantity * v_local_cost_gst,
                               v_quantity * v_quote_price,
                               v_quantity * v_quote_display_price,
                               v_quantity * v_quote_price_tax,
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
                     UPDATE f_booking_component
                        SET (bref_sk,
                             details_updated_date,
                             booking_ref,
                             service_seq,
                             product_code,
                             service_type,
                             service_date_id,
                             service_duration,
                             service_id,
                             supplier_comm_form,
                             local_supplier_comm,
                             local_supplier_comm_rec,
                             market_code,
                             block_code,
                             quantity,
                             cost_exch,
                             local_cost,
                             local_cost_tax,
                             local_cost_gst,
                             quote_price,
                             quote_display_price,
                             quote_price_tax,
                             quote_price_gst,
                             quote_price_enc,
                             comm_per,
                             max_comm) =
                               (SELECT v_bref_sk,
                                       v_details_updated_date,
                                       v_booking_ref,
                                       v_service_seq,
                                       v_product_code,
                                       v_service_type,
                                       v_service_date_id,
                                       v_service_duration,
                                       v_service_id,
                                       v_supplier_comm_form,
                                       v_local_supplier_comm,
                                       v_local_supplier_comm_rec,
                                       v_market_code,
                                       v_block_code,
                                       v_quantity,
                                       v_cost_exch,
                                       v_local_cost,
                                       v_local_cost_tax,
                                       v_local_cost_gst,
                                       v_quote_price,
                                       v_quote_display_price,
                                       v_quote_price_tax,
                                       v_quote_price_gst,
                                       v_quote_price_enc,
                                       v_comm_per,
                                       v_max_comm
                                  FROM DUAL)
                      WHERE     details_updated_date =
                                   TO_CHAR (TRUNC (SYSDATE), 'yyyymmdd')
                            AND booking_ref = v_booking_ref
                            AND service_seq = v_service_seq;

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
                  INSERT INTO r_booking_component (booking_ref,
                                                   service_seq,
                                                   product_code,
                                                   service_type,
                                                   service_date_id,
                                                   service_duration,
                                                   service_id,
                                                   supplier_comm_form,
                                                   local_supplier_comm,
                                                   local_supplier_comm_rec,
                                                   market_code,
                                                   block_code,
                                                   quantity,
                                                   local_cost,
                                                   local_cost_tax,
                                                   local_cost_gst,
                                                   quote_price,
                                                   quote_display_price,
                                                   quote_price_tax,
                                                   comm_per,
                                                   max_comm)
                       VALUES (v_booking_ref,
                               v_service_seq,
                               v_product_code,
                               v_service_type,
                               v_service_date_id,
                               v_service_duration,
                               v_service_id,
                               v_supplier_comm_form,
                               v_local_supplier_comm,
                               v_local_supplier_comm_rec,
                               v_market_code,
                               v_block_code,
                               v_quantity,
                               v_local_cost,
                               v_local_cost_tax,
                               v_local_cost_gst,
                               v_quote_price,
                               v_quote_display_price,
                               v_quote_price_tax,
                               v_comm_per,
                               v_max_comm);
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
                    VALUES ('F_BOOKING_COMPONENT',
                            'F_BOOKING_COMPONENT',
                            SYSDATE,
                            SUBSTR (v_code, 1, 50),
                            SUBSTR (v_error_message, 1, 250));

               --
               -- Write error record
               INSERT INTO r_booking_component (booking_ref,
                                                service_seq,
                                                product_code,
                                                service_type,
                                                service_date_id,
                                                service_duration,
                                                service_id,
                                                supplier_comm_form,
                                                local_supplier_comm,
                                                local_supplier_comm_rec,
                                                market_code,
                                                block_code,
                                                quantity,
                                                local_cost,
                                                local_cost_tax,
                                                local_cost_gst,
                                                quote_price,
                                                quote_display_price,
                                                quote_price_tax,
                                                comm_per,
                                                max_comm)
                    VALUES (v_booking_ref,
                            v_service_seq,
                            v_product_code,
                            v_service_type,
                            v_service_date_id,
                            v_service_duration,
                            v_service_id,
                            v_supplier_comm_form,
                            v_local_supplier_comm,
                            v_local_supplier_comm_rec,
                            v_market_code,
                            v_block_code,
                            v_quantity,
                            v_local_cost,
                            v_local_cost_tax,
                            v_local_cost_gst,
                            v_quote_price,
                            v_quote_display_price,
                            v_quote_price_tax,
                            v_comm_per,
                            v_max_comm);
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
              VALUES ('F_BOOKING_COMPONENT',
                      'F_BOOKING_COMPONENT',
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
           VALUES ('F_BOOKING_COMPONENT',
                   'F_BOOKING_COMPONENT',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));

      --
      COMMIT;
--
END;                                        /**** < OPEN Cursor Block  > ****/
/
SHOW ERRORS;
