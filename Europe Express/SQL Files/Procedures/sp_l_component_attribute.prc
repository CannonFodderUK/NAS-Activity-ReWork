SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:36 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_l_component_attribute
AS
   -- DECLARE /*****  D E C L A R E  S E C T I O N  *****/
   --===========================================================
   -- SP_D_BOOKING_COMPONENT - which takes the contents of D_BOOKING_COMPONENT
   -- and populates the D_BOOKING_COMPONENT table
   --
   --===========================================================
   -- Change History
   --===========================================================
   -- Date          Ver Who Comment
   -- 14-Jan-13     1.0 tthap6  Original Version
   --
   --
   -- EXCEPTION DEFINITIONS
   --
   primary_key_error             EXCEPTION;
   PRAGMA EXCEPTION_INIT (primary_key_error, -00001);
   foreign_key_error             EXCEPTION;
   PRAGMA EXCEPTION_INIT (foreign_key_error, -02291);
   --
   --
   v_commit_at          CONSTANT PLS_INTEGER := 1000;
   --
   -- VARIABLES HOLDING DATA FROM CURSOR
   --
   v_booking_ref                 D_Component_att.BOOKING_REF%TYPE;
   v_service_seq                 D_Component_att.SERVICE_SEQ%TYPE;
   v_seq                         D_Component_att.SEQ%TYPE;
   v_iseq                        D_Component_att.ISEQ%TYPE;
   v_deleted                     D_Component_att.DELETED%TYPE;
   v_per_duration                D_Component_att.PER_DURATION%TYPE;
   v_req_mask                    D_Component_att.REQ_MASK%TYPE;
   v_supplier_name               D_Component_att.SUPPLIER_NAME%TYPE;
   v_service_id                  D_Component_att.SERVICE_ID%TYPE;
   v_description                 D_Component_att.DESCRIPTION%TYPE;
   v_vchr_notes                  D_Component_att.VCHR_NOTES%TYPE;
   v_cost_code                   D_Component_att.COST_CODE%TYPE;
   v_vchr_type                   D_Component_att.VCHR_TYPE%TYPE;
   v_tour_code                   D_Component_att.TOUR_CODE%TYPE;
   v_manifest_code               D_Component_att.MANIFEST_CODE%TYPE;
   v_contract_thru               D_Component_att.CONTRACT_THRU%TYPE;
   v_comm_timing                 D_Component_att.COMM_TIMING%TYPE;
   v_block_type                  D_Component_att.BLOCK_TYPE%TYPE;
   v_inventay_map                D_Component_att.INVENTAY_MAP%TYPE;
   v_confirm_info                D_Component_att.CONFIRM_INFO%TYPE;
   v_share_with                  D_Component_att.SHARE_WITH%TYPE;
   v_destination                 D_Component_att.DESTINATION%TYPE;
   v_to_destination              D_Component_att.TO_DESTINATION%TYPE;
   v_location_code               D_Component_att.LOCATION_CODE%TYPE;
   v_service_order               D_Component_att.SERVICE_ORDER%TYPE;
   v_freent                      D_Component_att.FREENT%TYPE;
   v_supplier_meno               D_Component_att.SUPPLIER_MENO%TYPE;
   v_addtional_info              D_Component_att.ADDTIONAL_INFO%TYPE;
   v_xl_rule                     D_Component_att.XL_RULE%TYPE;
   v_ix                          D_Component_att.IX%TYPE;
   v_desig                       D_Component_att.DESIG%TYPE;
   v_mask                        D_Component_att.MASK%TYPE;
   v_quote_price_gst             D_Component_att.QUOTE_PRICE_GST%TYPE;
   v_quote_price_enc             D_Component_att.QUOTE_PRICE_ENC%TYPE;
   v_supplier_comm_form          D_Component_att.SUPPLIER_COMM_FORM%TYPE;
   v_local_supplier_comm         D_Component_att.LOCAL_SUPPLIER_COMM%TYPE;
   v_local_supplier_comm_rec     D_Component_att.LOCAL_SUPPLIER_COMM_REC%TYPE;
   v_rooms_assigned              D_Component_att.ROOMS_ASSIGNED%TYPE;
   v_data_prior_to_chg           D_Component_att.DATA_PRIOR_TO_CHG%TYPE;
   v_supplier_reported           D_Component_att.SUPPLIER_REPORTED%TYPE;
   v_supplier_reported_date_id   D_Component_att.SUPPLIER_REPORTED_DATE_ID%TYPE;
   v_need_to_report              D_Component_att.NEED_TO_REPORT%TYPE;
   v_paid_to_supplier            D_Component_att.PAID_TO_SUPPLIER%TYPE;
   v_added_by                    D_Component_att.ADDED_BY%TYPE;
   v_aded_by_date_id             D_Component_att.ADED_BY_DATE_ID%TYPE;
   v_p_user                      D_Component_att.P_USER%TYPE;
   v_last_update_id              D_Component_att.LAST_UPDATE_ID%TYPE;
   --
   -- WORK VARIABLES
   --
   v_null                        CHAR (1);
   v_count                       CHAR (1);
   v_insert_ok                   CHAR (1);
   v_update_ok                   CHAR (1);
   v_fk_error                    CHAR (1);
   v_foreign_key_error           CHAR (1);
   v_primary_key_error           CHAR (1);
   --
   v_code                        NUMBER (5);
   v_error_message               VARCHAR2 (512);

   --
   CURSOR C001
   IS
      SELECT DISTINCT RESNUMBER,
                      SERVICESEQ,
                      SEQ,
                      ISEQ,
                      DELETED,
                      PERDURATION,
                      REQMASK,
                      SUPPLIERNAME,
                      SERVICEID,
                      DESCRIPTION,
                      VCHRNOTES,
                      COSTCODE,
                      VCHRTYPE,
                      TOURCODE,
                      MANIFESTCODE,
                      CONTRACTTHRU,
                      COMMTIMING,
                      BLOCKTYPE,
                      INVENTORYMAP,
                      CONFINFO,
                      SHAREWITH,
                      DESTINATION,
                      TODESTINATION,
                      LOCATIONCODE,
                      SERVICEORDER,
                      FREENT,
                      SUPPLIERMEMO,
                      ADDITIONALINFO,
                      XLRULE,
                      IX,
                      DESIG,
                      MASK,
                      QUOTEPRICEGST,
                      QUOTEPRICENC,
                      SUPPLIERCOMMFORM,
                      LOCALSUPPLIERCOMM,
                      LOCALSUPPLIERCOMMREC,
                      ROOMSASSIGNED,
                      DATAPRIORTOCHANGE,
                      SUPPLIERREPORTED,
                      TO_CHAR (SUPPLIERREPORTEDDATE, 'yyyymmdd'),
                      NEEDTOREPORT,
                      PAIDTOSUPP,
                      CREATEDBY,
                      TO_CHAR (CREATEDDATE, 'yyymmdd'),
                      WHOSTAMP,
                      TO_CHAR (DATESTAMP, 'yyyymmd')
        FROM l_resitinerary;

--
BEGIN
   -- <Toad_238481818_1> *** DO NOT REMOVE THE AUTO DEBUGGER START/END TAGS
   DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_1} ');
   DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_1}[--- 1 ---]');
   DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_1} ');
   DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_1}[1] v_null = ' || v_null);
   DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_1}[1] v_count = ' || v_count);
   DBMS_OUTPUT.PUT_LINE (
      '{Toad_238481818_1}[1] v_insert_ok = ' || v_insert_ok);
   DBMS_OUTPUT.PUT_LINE (
      '{Toad_238481818_1}[1] v_update_ok = ' || v_update_ok);
   DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_1}[1] v_fk_error = ' || v_fk_error);
   DBMS_OUTPUT.PUT_LINE (
      '{Toad_238481818_1}[1] v_foreign_key_error = ' || v_foreign_key_error);
   DBMS_OUTPUT.PUT_LINE (
      '{Toad_238481818_1}[1] v_primary_key_error = ' || v_primary_key_error);
   DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_1}[1] v_code = ' || v_code);
   DBMS_OUTPUT.PUT_LINE (
      '{Toad_238481818_1}[1] v_error_message = ' || v_error_message);
   -- </Toad_238481818_1>

   /**** < OPEN Cursor Block > ****/
   --
   v_primary_key_error := 'N';
   -- <Toad_238481818_2> *** DO NOT REMOVE THE AUTO DEBUGGER START/END TAGS
   DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_2} ');
   DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_2}[--- 2 ---]');
   DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_2} ');
   DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_2}[2] v_null = ' || v_null);
   DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_2}[2] v_count = ' || v_count);
   DBMS_OUTPUT.PUT_LINE (
      '{Toad_238481818_2}[2] v_insert_ok = ' || v_insert_ok);
   DBMS_OUTPUT.PUT_LINE (
      '{Toad_238481818_2}[2] v_update_ok = ' || v_update_ok);
   DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_2}[2] v_fk_error = ' || v_fk_error);
   DBMS_OUTPUT.PUT_LINE (
      '{Toad_238481818_2}[2] v_foreign_key_error = ' || v_foreign_key_error);
   DBMS_OUTPUT.PUT_LINE (
      '{Toad_238481818_2}[2] v_primary_key_error = ' || v_primary_key_error);
   DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_2}[2] v_code = ' || v_code);
   DBMS_OUTPUT.PUT_LINE (
      '{Toad_238481818_2}[2] v_error_message = ' || v_error_message);
   -- </Toad_238481818_2>

   v_foreign_key_error := 'N';
   -- <Toad_238481818_3> *** DO NOT REMOVE THE AUTO DEBUGGER START/END TAGS
   DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_3} ');
   DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_3}[--- 3 ---]');
   DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_3} ');
   DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_3}[3] v_null = ' || v_null);
   DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_3}[3] v_count = ' || v_count);
   DBMS_OUTPUT.PUT_LINE (
      '{Toad_238481818_3}[3] v_insert_ok = ' || v_insert_ok);
   DBMS_OUTPUT.PUT_LINE (
      '{Toad_238481818_3}[3] v_update_ok = ' || v_update_ok);
   DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_3}[3] v_fk_error = ' || v_fk_error);
   DBMS_OUTPUT.PUT_LINE (
      '{Toad_238481818_3}[3] v_foreign_key_error = ' || v_foreign_key_error);
   DBMS_OUTPUT.PUT_LINE (
      '{Toad_238481818_3}[3] v_primary_key_error = ' || v_primary_key_error);
   DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_3}[3] v_code = ' || v_code);
   DBMS_OUTPUT.PUT_LINE (
      '{Toad_238481818_3}[3] v_error_message = ' || v_error_message);

   -- </Toad_238481818_3>

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
         -- <Toad_238481818_4> *** DO NOT REMOVE THE AUTO DEBUGGER START/END TAGS
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_4} ');
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_4}[--- 4 ---]');
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_4} ');
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_4}[4] v_null = ' || v_null);
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_4}[4] v_count = ' || v_count);
         DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_4}[4] v_insert_ok = ' || v_insert_ok);
         DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_4}[4] v_update_ok = ' || v_update_ok);
         DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_4}[4] v_fk_error = ' || v_fk_error);
         DBMS_OUTPUT.PUT_LINE (
               '{Toad_238481818_4}[4] v_foreign_key_error = '
            || v_foreign_key_error);
         DBMS_OUTPUT.PUT_LINE (
               '{Toad_238481818_4}[4] v_primary_key_error = '
            || v_primary_key_error);
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_4}[4] v_code = ' || v_code);
         DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_4}[4] v_error_message = ' || v_error_message);
         -- </Toad_238481818_4>

         v_update_ok := 'N';
         -- <Toad_238481818_5> *** DO NOT REMOVE THE AUTO DEBUGGER START/END TAGS
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_5} ');
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_5}[--- 5 ---]');
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_5} ');
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_5}[5] v_null = ' || v_null);
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_5}[5] v_count = ' || v_count);
         DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_5}[5] v_insert_ok = ' || v_insert_ok);
         DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_5}[5] v_update_ok = ' || v_update_ok);
         DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_5}[5] v_fk_error = ' || v_fk_error);
         DBMS_OUTPUT.PUT_LINE (
               '{Toad_238481818_5}[5] v_foreign_key_error = '
            || v_foreign_key_error);
         DBMS_OUTPUT.PUT_LINE (
               '{Toad_238481818_5}[5] v_primary_key_error = '
            || v_primary_key_error);
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_5}[5] v_code = ' || v_code);
         DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_5}[5] v_error_message = ' || v_error_message);
         -- </Toad_238481818_5>

         v_fk_error := 'N';
         -- <Toad_238481818_6> *** DO NOT REMOVE THE AUTO DEBUGGER START/END TAGS
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_6} ');
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_6}[--- 6 ---]');
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_6} ');
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_6}[6] v_null = ' || v_null);
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_6}[6] v_count = ' || v_count);
         DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_6}[6] v_insert_ok = ' || v_insert_ok);
         DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_6}[6] v_update_ok = ' || v_update_ok);
         DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_6}[6] v_fk_error = ' || v_fk_error);
         DBMS_OUTPUT.PUT_LINE (
               '{Toad_238481818_6}[6] v_foreign_key_error = '
            || v_foreign_key_error);
         DBMS_OUTPUT.PUT_LINE (
               '{Toad_238481818_6}[6] v_primary_key_error = '
            || v_primary_key_error);
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_6}[6] v_code = ' || v_code);
         DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_6}[6] v_error_message = ' || v_error_message);

         -- </Toad_238481818_6>

         --
         FETCH C001
            INTO v_booking_ref,
                 v_service_seq,
                 v_seq,
                 v_iseq,
                 v_deleted,
                 v_per_duration,
                 v_req_mask,
                 v_supplier_name,
                 v_service_id,
                 v_description,
                 v_vchr_notes,
                 v_cost_code,
                 v_vchr_type,
                 v_tour_code,
                 v_manifest_code,
                 v_contract_thru,
                 v_comm_timing,
                 v_block_type,
                 v_inventay_map,
                 v_confirm_info,
                 v_share_with,
                 v_destination,
                 v_to_destination,
                 v_location_code,
                 v_service_order,
                 v_freent,
                 v_supplier_meno,
                 v_addtional_info,
                 v_xl_rule,
                 v_ix,
                 v_desig,
                 v_mask,
                 v_quote_price_gst,
                 v_quote_price_enc,
                 v_supplier_comm_form,
                 v_local_supplier_comm,
                 v_local_supplier_comm_rec,
                 v_rooms_assigned,
                 v_data_prior_to_chg,
                 v_supplier_reported,
                 v_supplier_reported_date_id,
                 v_need_to_report,
                 v_paid_to_supplier,
                 v_added_by,
                 v_aded_by_date_id,
                 v_p_user,
                 v_last_update_id;

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
               -- <Toad_238481818_7> *** DO NOT REMOVE THE AUTO DEBUGGER START/END TAGS
               DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_7} ');
               DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_7}[--- 7 ---]');
               DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_7} ');
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_7}[7] v_null = ' || v_null);
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_7}[7] v_count = ' || v_count);
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_7}[7] v_insert_ok = ' || v_insert_ok);
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_7}[7] v_update_ok = ' || v_update_ok);
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_7}[7] v_fk_error = ' || v_fk_error);
               DBMS_OUTPUT.PUT_LINE (
                     '{Toad_238481818_7}[7] v_foreign_key_error = '
                  || v_foreign_key_error);
               DBMS_OUTPUT.PUT_LINE (
                     '{Toad_238481818_7}[7] v_primary_key_error = '
                  || v_primary_key_error);
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_7}[7] v_code = ' || v_code);
               DBMS_OUTPUT.PUT_LINE (
                     '{Toad_238481818_7}[7] v_error_message = '
                  || v_error_message);
               -- </Toad_238481818_7>

               v_foreign_key_error := 'N';
               -- <Toad_238481818_8> *** DO NOT REMOVE THE AUTO DEBUGGER START/END TAGS
               DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_8} ');
               DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_8}[--- 8 ---]');
               DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_8} ');
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_8}[8] v_null = ' || v_null);
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_8}[8] v_count = ' || v_count);
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_8}[8] v_insert_ok = ' || v_insert_ok);
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_8}[8] v_update_ok = ' || v_update_ok);
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_8}[8] v_fk_error = ' || v_fk_error);
               DBMS_OUTPUT.PUT_LINE (
                     '{Toad_238481818_8}[8] v_foreign_key_error = '
                  || v_foreign_key_error);
               DBMS_OUTPUT.PUT_LINE (
                     '{Toad_238481818_8}[8] v_primary_key_error = '
                  || v_primary_key_error);
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_8}[8] v_code = ' || v_code);
               DBMS_OUTPUT.PUT_LINE (
                     '{Toad_238481818_8}[8] v_error_message = '
                  || v_error_message);

               -- </Toad_238481818_8>

               --
               BEGIN
                  /**** < INSERT Cursor Block > ****/
                  --
                  INSERT INTO D_Component_att (booking_ref,
                                               service_seq,
                                               seq,
                                               iseq,
                                               deleted,
                                               per_duration,
                                               req_mask,
                                               supplier_name,
                                               service_id,
                                               description,
                                               vchr_notes,
                                               cost_code,
                                               vchr_type,
                                               tour_code,
                                               manifest_code,
                                               contract_thru,
                                               comm_timing,
                                               block_type,
                                               inventay_map,
                                               confirm_info,
                                               share_with,
                                               destination,
                                               to_destination,
                                               location_code,
                                               service_order,
                                               freent,
                                               supplier_meno,
                                               addtional_info,
                                               xl_rule,
                                               ix,
                                               desig,
                                               mask,
                                               quote_price_gst,
                                               quote_price_enc,
                                               supplier_comm_form,
                                               local_supplier_comm,
                                               local_supplier_comm_rec,
                                               rooms_assigned,
                                               data_prior_to_chg,
                                               supplier_reported,
                                               supplier_reported_date_id,
                                               need_to_report,
                                               paid_to_supplier,
                                               added_by,
                                               aded_by_date_id,
                                               p_user,
                                               last_update_id)
                       VALUES (v_booking_ref,
                               v_service_seq,
                               v_seq,
                               v_iseq,
                               v_deleted,
                               v_per_duration,
                               v_req_mask,
                               v_supplier_name,
                               v_service_id,
                               v_description,
                               v_vchr_notes,
                               v_cost_code,
                               v_vchr_type,
                               v_tour_code,
                               v_manifest_code,
                               v_contract_thru,
                               v_comm_timing,
                               v_block_type,
                               v_inventay_map,
                               v_confirm_info,
                               v_share_with,
                               v_destination,
                               v_to_destination,
                               v_location_code,
                               v_service_order,
                               v_freent,
                               v_supplier_meno,
                               v_addtional_info,
                               v_xl_rule,
                               v_ix,
                               v_desig,
                               v_mask,
                               v_quote_price_gst,
                               v_quote_price_enc,
                               v_supplier_comm_form,
                               v_local_supplier_comm,
                               v_local_supplier_comm_rec,
                               v_rooms_assigned,
                               v_data_prior_to_chg,
                               v_supplier_reported,
                               v_supplier_reported_date_id,
                               v_need_to_report,
                               v_paid_to_supplier,
                               v_added_by,
                               v_aded_by_date_id,
                               v_p_user,
                               v_last_update_id);

                  --
                  v_insert_ok := 'Y';
                  -- <Toad_238481818_9> *** DO NOT REMOVE THE AUTO DEBUGGER START/END TAGS
                  DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_9} ');
                  DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_9}[--- 9 ---]');
                  DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_9} ');
                  DBMS_OUTPUT.PUT_LINE (
                     '{Toad_238481818_9}[9] v_null = ' || v_null);
                  DBMS_OUTPUT.PUT_LINE (
                     '{Toad_238481818_9}[9] v_count = ' || v_count);
                  DBMS_OUTPUT.PUT_LINE (
                     '{Toad_238481818_9}[9] v_insert_ok = ' || v_insert_ok);
                  DBMS_OUTPUT.PUT_LINE (
                     '{Toad_238481818_9}[9] v_update_ok = ' || v_update_ok);
                  DBMS_OUTPUT.PUT_LINE (
                     '{Toad_238481818_9}[9] v_fk_error = ' || v_fk_error);
                  DBMS_OUTPUT.PUT_LINE (
                        '{Toad_238481818_9}[9] v_foreign_key_error = '
                     || v_foreign_key_error);
                  DBMS_OUTPUT.PUT_LINE (
                        '{Toad_238481818_9}[9] v_primary_key_error = '
                     || v_primary_key_error);
                  DBMS_OUTPUT.PUT_LINE (
                     '{Toad_238481818_9}[9] v_code = ' || v_code);
                  DBMS_OUTPUT.PUT_LINE (
                        '{Toad_238481818_9}[9] v_error_message = '
                     || v_error_message);
               -- </Toad_238481818_9>

               --
               EXCEPTION
                  --
                  -- A PRIMARY KEY or FOREIGN KEY error
                  --
                  WHEN primary_key_error
                  THEN
                     v_primary_key_error := 'Y';
                     -- <Toad_238481818_10> *** DO NOT REMOVE THE AUTO DEBUGGER START/END TAGS
                     DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_10} ');
                     DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_10}[--- 10 ---]');
                     DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_10} ');
                     DBMS_OUTPUT.PUT_LINE (
                        '{Toad_238481818_10}[10] v_null = ' || v_null);
                     DBMS_OUTPUT.PUT_LINE (
                        '{Toad_238481818_10}[10] v_count = ' || v_count);
                     DBMS_OUTPUT.PUT_LINE (
                           '{Toad_238481818_10}[10] v_insert_ok = '
                        || v_insert_ok);
                     DBMS_OUTPUT.PUT_LINE (
                           '{Toad_238481818_10}[10] v_update_ok = '
                        || v_update_ok);
                     DBMS_OUTPUT.PUT_LINE (
                        '{Toad_238481818_10}[10] v_fk_error = ' || v_fk_error);
                     DBMS_OUTPUT.PUT_LINE (
                           '{Toad_238481818_10}[10] v_foreign_key_error = '
                        || v_foreign_key_error);
                     DBMS_OUTPUT.PUT_LINE (
                           '{Toad_238481818_10}[10] v_primary_key_error = '
                        || v_primary_key_error);
                     DBMS_OUTPUT.PUT_LINE (
                        '{Toad_238481818_10}[10] v_code = ' || v_code);
                     DBMS_OUTPUT.PUT_LINE (
                           '{Toad_238481818_10}[10] v_error_message = '
                        || v_error_message);
                  -- </Toad_238481818_10>

                  WHEN foreign_key_error
                  THEN
                     v_foreign_key_error := 'Y';
                     -- <Toad_238481818_11> *** DO NOT REMOVE THE AUTO DEBUGGER START/END TAGS
                     DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_11} ');
                     DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_11}[--- 11 ---]');
                     DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_11} ');
                     DBMS_OUTPUT.PUT_LINE (
                        '{Toad_238481818_11}[11] v_null = ' || v_null);
                     DBMS_OUTPUT.PUT_LINE (
                        '{Toad_238481818_11}[11] v_count = ' || v_count);
                     DBMS_OUTPUT.PUT_LINE (
                           '{Toad_238481818_11}[11] v_insert_ok = '
                        || v_insert_ok);
                     DBMS_OUTPUT.PUT_LINE (
                           '{Toad_238481818_11}[11] v_update_ok = '
                        || v_update_ok);
                     DBMS_OUTPUT.PUT_LINE (
                        '{Toad_238481818_11}[11] v_fk_error = ' || v_fk_error);
                     DBMS_OUTPUT.PUT_LINE (
                           '{Toad_238481818_11}[11] v_foreign_key_error = '
                        || v_foreign_key_error);
                     DBMS_OUTPUT.PUT_LINE (
                           '{Toad_238481818_11}[11] v_primary_key_error = '
                        || v_primary_key_error);
                     DBMS_OUTPUT.PUT_LINE (
                        '{Toad_238481818_11}[11] v_code = ' || v_code);
                     DBMS_OUTPUT.PUT_LINE (
                           '{Toad_238481818_11}[11] v_error_message = '
                        || v_error_message);
               -- </Toad_238481818_11>

               END;                        /**** < INSERT Cursor Block > ****/

               --
               IF v_primary_key_error = 'Y'
               THEN
                  --
                  BEGIN
                     /**** < UPDATE Cursor Block > ****/
                     --
                     UPDATE D_Component_att
                        SET (booking_ref,
                             service_seq,
                             seq,
                             iseq,
                             deleted,
                             per_duration,
                             req_mask,
                             supplier_name,
                             service_id,
                             description,
                             vchr_notes,
                             cost_code,
                             vchr_type,
                             tour_code,
                             manifest_code,
                             contract_thru,
                             comm_timing,
                             block_type,
                             inventay_map,
                             confirm_info,
                             share_with,
                             destination,
                             to_destination,
                             location_code,
                             service_order,
                             freent,
                             supplier_meno,
                             addtional_info,
                             xl_rule,
                             ix,
                             desig,
                             mask,
                             quote_price_gst,
                             quote_price_enc,
                             supplier_comm_form,
                             local_supplier_comm,
                             local_supplier_comm_rec,
                             rooms_assigned,
                             data_prior_to_chg,
                             supplier_reported,
                             supplier_reported_date_id,
                             need_to_report,
                             paid_to_supplier,
                             added_by,
                             aded_by_date_id,
                             p_user,
                             last_update_id) =
                               (SELECT v_booking_ref,
                                       v_service_seq,
                                       v_seq,
                                       v_iseq,
                                       v_deleted,
                                       v_per_duration,
                                       v_req_mask,
                                       v_supplier_name,
                                       v_service_id,
                                       v_description,
                                       v_vchr_notes,
                                       v_cost_code,
                                       v_vchr_type,
                                       v_tour_code,
                                       v_manifest_code,
                                       v_contract_thru,
                                       v_comm_timing,
                                       v_block_type,
                                       v_inventay_map,
                                       v_confirm_info,
                                       v_share_with,
                                       v_destination,
                                       v_to_destination,
                                       v_location_code,
                                       v_service_order,
                                       v_freent,
                                       v_supplier_meno,
                                       v_addtional_info,
                                       v_xl_rule,
                                       v_ix,
                                       v_desig,
                                       v_mask,
                                       v_quote_price_gst,
                                       v_quote_price_enc,
                                       v_supplier_comm_form,
                                       v_local_supplier_comm,
                                       v_local_supplier_comm_rec,
                                       v_rooms_assigned,
                                       v_data_prior_to_chg,
                                       v_supplier_reported,
                                       v_supplier_reported_date_id,
                                       v_need_to_report,
                                       v_paid_to_supplier,
                                       v_added_by,
                                       v_aded_by_date_id,
                                       v_p_user,
                                       v_last_update_id
                                  FROM DUAL)
                      WHERE     booking_ref = v_booking_ref
                            AND service_seq = service_seq;

                     --
                     v_update_ok := 'Y';
                     -- <Toad_238481818_12> *** DO NOT REMOVE THE AUTO DEBUGGER START/END TAGS
                     DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_12} ');
                     DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_12}[--- 12 ---]');
                     DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_12} ');
                     DBMS_OUTPUT.PUT_LINE (
                        '{Toad_238481818_12}[12] v_null = ' || v_null);
                     DBMS_OUTPUT.PUT_LINE (
                        '{Toad_238481818_12}[12] v_count = ' || v_count);
                     DBMS_OUTPUT.PUT_LINE (
                           '{Toad_238481818_12}[12] v_insert_ok = '
                        || v_insert_ok);
                     DBMS_OUTPUT.PUT_LINE (
                           '{Toad_238481818_12}[12] v_update_ok = '
                        || v_update_ok);
                     DBMS_OUTPUT.PUT_LINE (
                        '{Toad_238481818_12}[12] v_fk_error = ' || v_fk_error);
                     DBMS_OUTPUT.PUT_LINE (
                           '{Toad_238481818_12}[12] v_foreign_key_error = '
                        || v_foreign_key_error);
                     DBMS_OUTPUT.PUT_LINE (
                           '{Toad_238481818_12}[12] v_primary_key_error = '
                        || v_primary_key_error);
                     DBMS_OUTPUT.PUT_LINE (
                        '{Toad_238481818_12}[12] v_code = ' || v_code);
                     DBMS_OUTPUT.PUT_LINE (
                           '{Toad_238481818_12}[12] v_error_message = '
                        || v_error_message);
                  -- </Toad_238481818_12>

                  --
                  EXCEPTION
                     --
                     -- A FOREIGN KEY error
                     --
                     WHEN foreign_key_error
                     THEN
                        v_foreign_key_error := 'Y';
                        -- <Toad_238481818_13> *** DO NOT REMOVE THE AUTO DEBUGGER START/END TAGS
                        DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_13} ');
                        DBMS_OUTPUT.PUT_LINE (
                           '{Toad_238481818_13}[--- 13 ---]');
                        DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_13} ');
                        DBMS_OUTPUT.PUT_LINE (
                           '{Toad_238481818_13}[13] v_null = ' || v_null);
                        DBMS_OUTPUT.PUT_LINE (
                           '{Toad_238481818_13}[13] v_count = ' || v_count);
                        DBMS_OUTPUT.PUT_LINE (
                              '{Toad_238481818_13}[13] v_insert_ok = '
                           || v_insert_ok);
                        DBMS_OUTPUT.PUT_LINE (
                              '{Toad_238481818_13}[13] v_update_ok = '
                           || v_update_ok);
                        DBMS_OUTPUT.PUT_LINE (
                              '{Toad_238481818_13}[13] v_fk_error = '
                           || v_fk_error);
                        DBMS_OUTPUT.PUT_LINE (
                              '{Toad_238481818_13}[13] v_foreign_key_error = '
                           || v_foreign_key_error);
                        DBMS_OUTPUT.PUT_LINE (
                              '{Toad_238481818_13}[13] v_primary_key_error = '
                           || v_primary_key_error);
                        DBMS_OUTPUT.PUT_LINE (
                           '{Toad_238481818_13}[13] v_code = ' || v_code);
                        DBMS_OUTPUT.PUT_LINE (
                              '{Toad_238481818_13}[13] v_error_message = '
                           || v_error_message);
                  -- </Toad_238481818_13>

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
                                                   seq,
                                                   iseq,
                                                   deleted,
                                                   per_duration,
                                                   req_mask,
                                                   supplier_name,
                                                   service_id,
                                                   description,
                                                   vchr_notes,
                                                   cost_code,
                                                   vchr_type,
                                                   tour_code,
                                                   manifest_code,
                                                   contract_thru,
                                                   comm_timing,
                                                   block_type,
                                                   inventay_map,
                                                   confirm_info,
                                                   share_with,
                                                   destination,
                                                   to_destination,
                                                   location_code,
                                                   service_order,
                                                   freent,
                                                   supplier_meno,
                                                   addtional_info,
                                                   xl_rule,
                                                   ix,
                                                   desig,
                                                   mask,
                                                   quote_price_gst,
                                                   quote_price_enc,
                                                   supplier_comm_form,
                                                   local_supplier_comm,
                                                   local_supplier_comm_rec,
                                                   rooms_assigned,
                                                   data_prior_to_chg,
                                                   supplier_reported,
                                                   supplier_reported_date_id,
                                                   need_to_report,
                                                   paid_to_supplier,
                                                   added_by,
                                                   aded_by_date_id,
                                                   p_user,
                                                   last_update_id)
                       VALUES (v_booking_ref,
                               v_service_seq,
                               v_seq,
                               v_iseq,
                               v_deleted,
                               v_per_duration,
                               v_req_mask,
                               v_supplier_name,
                               v_service_id,
                               v_description,
                               v_vchr_notes,
                               v_cost_code,
                               v_vchr_type,
                               v_tour_code,
                               v_manifest_code,
                               v_contract_thru,
                               v_comm_timing,
                               v_block_type,
                               v_inventay_map,
                               v_confirm_info,
                               v_share_with,
                               v_destination,
                               v_to_destination,
                               v_location_code,
                               v_service_order,
                               v_freent,
                               v_supplier_meno,
                               v_addtional_info,
                               v_xl_rule,
                               v_ix,
                               v_desig,
                               v_mask,
                               v_quote_price_gst,
                               v_quote_price_enc,
                               v_supplier_comm_form,
                               v_local_supplier_comm,
                               v_local_supplier_comm_rec,
                               v_rooms_assigned,
                               v_data_prior_to_chg,
                               v_supplier_reported,
                               v_supplier_reported_date_id,
                               v_need_to_report,
                               v_paid_to_supplier,
                               v_added_by,
                               v_aded_by_date_id,
                               v_p_user,
                               v_last_update_id);
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
               -- <Toad_238481818_14> *** DO NOT REMOVE THE AUTO DEBUGGER START/END TAGS
               DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_14} ');
               DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_14}[--- 14 ---]');
               DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_14} ');
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_14}[14] v_null = ' || v_null);
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_14}[14] v_count = ' || v_count);
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_14}[14] v_insert_ok = ' || v_insert_ok);
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_14}[14] v_update_ok = ' || v_update_ok);
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_14}[14] v_fk_error = ' || v_fk_error);
               DBMS_OUTPUT.PUT_LINE (
                     '{Toad_238481818_14}[14] v_foreign_key_error = '
                  || v_foreign_key_error);
               DBMS_OUTPUT.PUT_LINE (
                     '{Toad_238481818_14}[14] v_primary_key_error = '
                  || v_primary_key_error);
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_14}[14] v_code = ' || v_code);
               DBMS_OUTPUT.PUT_LINE (
                     '{Toad_238481818_14}[14] v_error_message = '
                  || v_error_message);
               -- </Toad_238481818_14>

               v_error_message := SQLERRM;
               -- <Toad_238481818_15> *** DO NOT REMOVE THE AUTO DEBUGGER START/END TAGS
               DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_15} ');
               DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_15}[--- 15 ---]');
               DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_15} ');
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_15}[15] v_null = ' || v_null);
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_15}[15] v_count = ' || v_count);
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_15}[15] v_insert_ok = ' || v_insert_ok);
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_15}[15] v_update_ok = ' || v_update_ok);
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_15}[15] v_fk_error = ' || v_fk_error);
               DBMS_OUTPUT.PUT_LINE (
                     '{Toad_238481818_15}[15] v_foreign_key_error = '
                  || v_foreign_key_error);
               DBMS_OUTPUT.PUT_LINE (
                     '{Toad_238481818_15}[15] v_primary_key_error = '
                  || v_primary_key_error);
               DBMS_OUTPUT.PUT_LINE (
                  '{Toad_238481818_15}[15] v_code = ' || v_code);
               DBMS_OUTPUT.PUT_LINE (
                     '{Toad_238481818_15}[15] v_error_message = '
                  || v_error_message);

               -- </Toad_238481818_15>

               --
               INSERT INTO integration_errors (load_table_abbrev,
                                               target_table_name,
                                               error_date,
                                               ERROR_CODE,
                                               error_desc)
                    VALUES ('D_Component_att',
                            'D_Component_att',
                            SYSDATE,
                            SUBSTR (v_code, 1, 50),
                            SUBSTR (v_error_message, 1, 250));

               --
               -- Write error record
               INSERT INTO r_booking_component (booking_ref,
                                                service_seq,
                                                seq,
                                                iseq,
                                                deleted,
                                                per_duration,
                                                req_mask,
                                                supplier_name,
                                                service_id,
                                                description,
                                                vchr_notes,
                                                cost_code,
                                                vchr_type,
                                                tour_code,
                                                manifest_code,
                                                contract_thru,
                                                comm_timing,
                                                block_type,
                                                inventay_map,
                                                confirm_info,
                                                share_with,
                                                destination,
                                                to_destination,
                                                location_code,
                                                service_order,
                                                freent,
                                                supplier_meno,
                                                addtional_info,
                                                xl_rule,
                                                ix,
                                                desig,
                                                mask,
                                                quote_price_gst,
                                                quote_price_enc,
                                                supplier_comm_form,
                                                local_supplier_comm,
                                                local_supplier_comm_rec,
                                                rooms_assigned,
                                                data_prior_to_chg,
                                                supplier_reported,
                                                supplier_reported_date_id,
                                                need_to_report,
                                                paid_to_supplier,
                                                added_by,
                                                aded_by_date_id,
                                                p_user,
                                                last_update_id)
                    VALUES (v_booking_ref,
                            v_service_seq,
                            v_seq,
                            v_iseq,
                            v_deleted,
                            v_per_duration,
                            v_req_mask,
                            v_supplier_name,
                            v_service_id,
                            v_description,
                            v_vchr_notes,
                            v_cost_code,
                            v_vchr_type,
                            v_tour_code,
                            v_manifest_code,
                            v_contract_thru,
                            v_comm_timing,
                            v_block_type,
                            v_inventay_map,
                            v_confirm_info,
                            v_share_with,
                            v_destination,
                            v_to_destination,
                            v_location_code,
                            v_service_order,
                            v_freent,
                            v_supplier_meno,
                            v_addtional_info,
                            v_xl_rule,
                            v_ix,
                            v_desig,
                            v_mask,
                            v_quote_price_gst,
                            v_quote_price_enc,
                            v_supplier_comm_form,
                            v_local_supplier_comm,
                            v_local_supplier_comm_rec,
                            v_rooms_assigned,
                            v_data_prior_to_chg,
                            v_supplier_reported,
                            v_supplier_reported_date_id,
                            v_need_to_report,
                            v_paid_to_supplier,
                            v_added_by,
                            v_aded_by_date_id,
                            v_p_user,
                            v_last_update_id);
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
         -- <Toad_238481818_16> *** DO NOT REMOVE THE AUTO DEBUGGER START/END TAGS
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_16} ');
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_16}[--- 16 ---]');
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_16} ');
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_16}[16] v_null = ' || v_null);
         DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_16}[16] v_count = ' || v_count);
         DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_16}[16] v_insert_ok = ' || v_insert_ok);
         DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_16}[16] v_update_ok = ' || v_update_ok);
         DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_16}[16] v_fk_error = ' || v_fk_error);
         DBMS_OUTPUT.PUT_LINE (
               '{Toad_238481818_16}[16] v_foreign_key_error = '
            || v_foreign_key_error);
         DBMS_OUTPUT.PUT_LINE (
               '{Toad_238481818_16}[16] v_primary_key_error = '
            || v_primary_key_error);
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_16}[16] v_code = ' || v_code);
         DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_16}[16] v_error_message = ' || v_error_message);
         -- </Toad_238481818_16>

         v_error_message := SQLERRM;
         -- <Toad_238481818_17> *** DO NOT REMOVE THE AUTO DEBUGGER START/END TAGS
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_17} ');
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_17}[--- 17 ---]');
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_17} ');
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_17}[17] v_null = ' || v_null);
         DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_17}[17] v_count = ' || v_count);
         DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_17}[17] v_insert_ok = ' || v_insert_ok);
         DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_17}[17] v_update_ok = ' || v_update_ok);
         DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_17}[17] v_fk_error = ' || v_fk_error);
         DBMS_OUTPUT.PUT_LINE (
               '{Toad_238481818_17}[17] v_foreign_key_error = '
            || v_foreign_key_error);
         DBMS_OUTPUT.PUT_LINE (
               '{Toad_238481818_17}[17] v_primary_key_error = '
            || v_primary_key_error);
         DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_17}[17] v_code = ' || v_code);
         DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_17}[17] v_error_message = ' || v_error_message);

         -- </Toad_238481818_17>

         --
         INSERT INTO integration_errors (load_table_abbrev,
                                         target_table_name,
                                         error_date,
                                         ERROR_CODE,
                                         error_desc)
              VALUES ('D_Component_att',
                      'D_Component_att',
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
      -- <Toad_238481818_18> *** DO NOT REMOVE THE AUTO DEBUGGER START/END TAGS
      DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_18} ');
      DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_18}[--- 18 ---]');
      DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_18} ');
      DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_18}[18] v_null = ' || v_null);
      DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_18}[18] v_count = ' || v_count);
      DBMS_OUTPUT.PUT_LINE (
         '{Toad_238481818_18}[18] v_insert_ok = ' || v_insert_ok);
      DBMS_OUTPUT.PUT_LINE (
         '{Toad_238481818_18}[18] v_update_ok = ' || v_update_ok);
      DBMS_OUTPUT.PUT_LINE (
         '{Toad_238481818_18}[18] v_fk_error = ' || v_fk_error);
      DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_18}[18] v_foreign_key_error = '
         || v_foreign_key_error);
      DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_18}[18] v_primary_key_error = '
         || v_primary_key_error);
      DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_18}[18] v_code = ' || v_code);
      DBMS_OUTPUT.PUT_LINE (
         '{Toad_238481818_18}[18] v_error_message = ' || v_error_message);
      -- </Toad_238481818_18>

      v_error_message := SQLERRM;
      -- <Toad_238481818_19> *** DO NOT REMOVE THE AUTO DEBUGGER START/END TAGS
      DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_19} ');
      DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_19}[--- 19 ---]');
      DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_19} ');
      DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_19}[19] v_null = ' || v_null);
      DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_19}[19] v_count = ' || v_count);
      DBMS_OUTPUT.PUT_LINE (
         '{Toad_238481818_19}[19] v_insert_ok = ' || v_insert_ok);
      DBMS_OUTPUT.PUT_LINE (
         '{Toad_238481818_19}[19] v_update_ok = ' || v_update_ok);
      DBMS_OUTPUT.PUT_LINE (
         '{Toad_238481818_19}[19] v_fk_error = ' || v_fk_error);
      DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_19}[19] v_foreign_key_error = '
         || v_foreign_key_error);
      DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_19}[19] v_primary_key_error = '
         || v_primary_key_error);
      DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_19}[19] v_code = ' || v_code);
      DBMS_OUTPUT.PUT_LINE (
         '{Toad_238481818_19}[19] v_error_message = ' || v_error_message);

      -- </Toad_238481818_19>

      --
      INSERT INTO integration_errors (load_table_abbrev,
                                      target_table_name,
                                      error_date,
                                      ERROR_CODE,
                                      error_desc)
           VALUES ('D_Component_att',
                   'D_Component_att',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));

      --
      COMMIT;
      -- <Toad_238481818_20> *** DO NOT REMOVE THE AUTO DEBUGGER START/END TAGS
      DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_20} ');
      DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_20}[--- 20 ---]');
      DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_20} ');
      DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_20}[20] v_null = ' || v_null);
      DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_20}[20] v_count = ' || v_count);
      DBMS_OUTPUT.PUT_LINE (
         '{Toad_238481818_20}[20] v_insert_ok = ' || v_insert_ok);
      DBMS_OUTPUT.PUT_LINE (
         '{Toad_238481818_20}[20] v_update_ok = ' || v_update_ok);
      DBMS_OUTPUT.PUT_LINE (
         '{Toad_238481818_20}[20] v_fk_error = ' || v_fk_error);
      DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_20}[20] v_foreign_key_error = '
         || v_foreign_key_error);
      DBMS_OUTPUT.PUT_LINE (
            '{Toad_238481818_20}[20] v_primary_key_error = '
         || v_primary_key_error);
      DBMS_OUTPUT.PUT_LINE ('{Toad_238481818_20}[20] v_code = ' || v_code);
      DBMS_OUTPUT.PUT_LINE (
         '{Toad_238481818_20}[20] v_error_message = ' || v_error_message);
-- </Toad_238481818_20>

--
END;                                        /**** < OPEN Cursor Block  > ****/
/
SHOW ERRORS;
