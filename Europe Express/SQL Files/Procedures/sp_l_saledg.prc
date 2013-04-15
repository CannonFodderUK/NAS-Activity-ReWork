SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:39 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_L_saledg
AS
   -- DECLARE /*****  D E C L A R E  S E C T I O N  *****/
   --===========================================================
   -- SP_SALEDG - which takes the contents of L_ACCTRANS
   -- and populates the F_SALES_LEDGER table
   --
   --===========================================================
   -- Change History
   --===========================================================
   -- Date          Ver Who Comment
   -- 02-Jan-13     1.0 TTHMLX  Original Version
   --
   --
   -- EXCEPTION DEFINITIONS
   --
   primary_key_error            EXCEPTION;
   PRAGMA EXCEPTION_INIT (primary_key_error, -00001);
   foreign_key_error            EXCEPTION;
   PRAGMA EXCEPTION_INIT (foreign_key_error, -02291);
   --
   --
   v_commit_at         CONSTANT PLS_INTEGER := 1000;
   --
   -- VARIABLES HOLDING DATA FROM CURSOR
   --
   v_trans_number               F_SALES_LEDGER.TRANS_NUMBER%TYPE;
   v_company_id                 F_SALES_LEDGER.COMPANY_ID%TYPE;
   v_journal_id                 F_SALES_LEDGER.JOURNAL_ID%TYPE;
   v_journal_name               F_SALES_LEDGER.JOURNAL_NAME%TYPE;
   v_journal_type               F_SALES_LEDGER.JOURNAL_TYPE%TYPE;
   v_transaction_date           F_SALES_LEDGER.TRANSACTION_DATE%TYPE;
   v_transaction_status         F_SALES_LEDGER.TRANSACTION_STATUS%TYPE;
   v_ref_number                 F_SALES_LEDGER.REF_NUMBER%TYPE;
   v_invoice_date               F_SALES_LEDGER.INVOICE_DATE%TYPE;
   v_transaction_currency       F_SALES_LEDGER.TRANSACTION_CURRENCY%TYPE;
   v_exchange_rates             F_SALES_LEDGER.EXCHANGE_RATES%TYPE;
   v_local_amount               F_SALES_LEDGER.LOCAL_AMOUNT%TYPE;
   v_base_amount                F_SALES_LEDGER.BASE_AMOUNT%TYPE;
   v_res_number                 F_SALES_LEDGER.RES_NUMBER%TYPE;
   v_transaction_type           F_SALES_LEDGER.TRANSACTION_TYPE%TYPE;
   v_apply_local                F_SALES_LEDGER.APPLY_LOCAL%TYPE;
   v_apply_base                 F_SALES_LEDGER.APPLY_BASE%TYPE;
   v_source_id                  F_SALES_LEDGER.SOURCE_ID%TYPE;
   v_source_name                F_SALES_LEDGER.SOURCE_NAME%TYPE;
   v_source_type                F_SALES_LEDGER.SOURCE_TYPE%TYPE;
   v_pay_to                     F_SALES_LEDGER.PAY_TO%TYPE;
   v_description                F_SALES_LEDGER.DESCRIPTION%TYPE;
   v_processed_by_transaction   F_SALES_LEDGER.PROCESSED_BY_TRANSACTION%TYPE;
   v_processed_by_check         F_SALES_LEDGER.PROCESSED_BY_CHECK%TYPE;
   v_due_date                   F_SALES_LEDGER.DUE_DATE%TYPE;
   v_ticket_fare                F_SALES_LEDGER.TICKET_FARE%TYPE;
   v_ticket_tax                 F_SALES_LEDGER.TICKET_TAX%TYPE;
   v_ticket_commission_person   F_SALES_LEDGER.TICKET_COMMISSION_PERSON%TYPE;
   v_ticket_commission_amount   F_SALES_LEDGER.TICKET_COMMISSION_AMOUNT%TYPE;
   v_contracted_for             F_SALES_LEDGER.CONTRACTED_FOR%TYPE;
   v_whostamp                   F_SALES_LEDGER.WHOSTAMP%TYPE;
   v_datestamp                  F_SALES_LEDGER.DATESTAMP%TYPE;
   --
   -- WORK VARIABLES
   --
   v_null                       CHAR (1);
   v_count                      CHAR (1);
   v_insert_ok                  CHAR (1);
   v_update_ok                  CHAR (1);
   v_fk_error                   CHAR (1);
   v_foreign_key_error          CHAR (1);
   v_primary_key_error          CHAR (1);
   --
   v_code                       NUMBER (5);
   v_error_message              VARCHAR2 (512);

   --
   CURSOR C001
   IS
      SELECT TRANSNUMBER TRANS_NUMBER,
             COMPANYID COMPANY_ID,
             JOURNALID JOURNAL_ID,
             JOURNALNAME JOURNAL_NAME,
             JOURNALTYPE JOURNAL_TYPE,
             TRANSDATE TRANSACTION_DATE,
             TRANSSTATUS TRANSACTION_STATUS,
             REFNUM REF_NUMBER,
             INVOICEDATE INVOICE_DATE,
             TCURRENCY TRANSACTION_CURRENCY,
             EXCHRATE EXCHANGE_RATES,
             LOCALAMOUNT LOCAL_AMOUNT,
             BASEAMOUNT BASE_AMOUNT,
             RESNUMBER RES_NUMBER,
             TRANSTYPE TRANSACTION_TYPE,
             APPLYLOCAL APPLY_LOCAL,
             APPLYBASE APPLY_BASE,
             SOURCEID SOURCE_ID,
             SOURCENAME SOURCE_NAME,
             SOURCETYPE SOURCE_TYPE,
             PAYTO PAY_TO,
             DESCRIPTION,
             PROCESSEDBYTRANS PROCESSED_BY_TRANSACTION,
             PROCESSEDBYCHECK PROCESSED_BY_CHECK,
             DUEDATE DUE_DATE,
             TKTFARE TICKET_FARE,
             TKTTAX TICKET_TAX,
             TKTCOMMPER TICKET_COMMISSION_PERSON,
             TKTCOMMAMT TICKET_COMMISSION_AMOUNT,
             CONTRACTEDFOR CONTRACTED_FOR,
             WHOSTAMP,
             DATESTAMP
        FROM L_ACCTRANS;

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
            INTO v_trans_number,
                 v_company_id,
                 v_journal_id,
                 v_journal_name,
                 v_journal_type,
                 v_transaction_date,
                 v_transaction_status,
                 v_ref_number,
                 v_invoice_date,
                 v_transaction_currency,
                 v_exchange_rates,
                 v_local_amount,
                 v_base_amount,
                 v_res_number,
                 v_transaction_type,
                 v_apply_local,
                 v_apply_base,
                 v_source_id,
                 v_source_name,
                 v_source_type,
                 v_pay_to,
                 v_description,
                 v_processed_by_transaction,
                 v_processed_by_check,
                 v_due_date,
                 v_ticket_fare,
                 v_ticket_tax,
                 v_ticket_commission_person,
                 v_ticket_commission_amount,
                 v_contracted_for,
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
                  INSERT INTO f_sales_ledger (trans_number,
                                              company_id,
                                              journal_id,
                                              journal_name,
                                              journal_type,
                                              transaction_date,
                                              transaction_status,
                                              ref_number,
                                              invoice_date,
                                              transaction_currency,
                                              exchange_rates,
                                              local_amount,
                                              base_amount,
                                              res_number,
                                              transaction_type,
                                              apply_local,
                                              apply_base,
                                              source_id,
                                              source_name,
                                              source_type,
                                              pay_to,
                                              description,
                                              processed_by_transaction,
                                              processed_by_check,
                                              due_date,
                                              ticket_fare,
                                              ticket_tax,
                                              ticket_commission_person,
                                              ticket_commission_amount,
                                              contracted_for,
                                              whostamp,
                                              datestamp)
                       VALUES (v_trans_number,
                               v_company_id,
                               v_journal_id,
                               v_journal_name,
                               v_journal_type,
                               v_transaction_date,
                               v_transaction_status,
                               v_ref_number,
                               v_invoice_date,
                               v_transaction_currency,
                               v_exchange_rates,
                               v_local_amount,
                               v_base_amount,
                               v_res_number,
                               v_transaction_type,
                               v_apply_local,
                               v_apply_base,
                               v_source_id,
                               v_source_name,
                               v_source_type,
                               v_pay_to,
                               v_description,
                               v_processed_by_transaction,
                               v_processed_by_check,
                               v_due_date,
                               v_ticket_fare,
                               v_ticket_tax,
                               v_ticket_commission_person,
                               v_ticket_commission_amount,
                               v_contracted_for,
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
                     UPDATE F_SALES_LEDGER
                        SET COMPANY_ID = V_COMPANY_ID,
                            JOURNAL_ID = V_JOURNAL_ID,
                            JOURNAL_NAME = V_JOURNAL_NAME,
                            JOURNAL_TYPE = V_JOURNAL_TYPE,
                            TRANSACTION_DATE = V_TRANSACTION_DATE,
                            TRANSACTION_STATUS = V_TRANSACTION_STATUS,
                            REF_NUMBER = V_REF_NUMBER,
                            INVOICE_DATE = V_INVOICE_DATE,
                            TRANSACTION_CURRENCY = V_TRANSACTION_CURRENCY,
                            EXCHANGE_RATES = V_EXCHANGE_RATES,
                            LOCAL_AMOUNT = V_LOCAL_AMOUNT,
                            BASE_AMOUNT = V_BASE_AMOUNT,
                            RES_NUMBER = V_RES_NUMBER,
                            TRANSACTION_TYPE = V_TRANSACTION_TYPE,
                            APPLY_LOCAL = V_APPLY_LOCAL,
                            APPLY_BASE = V_APPLY_BASE,
                            SOURCE_ID = V_SOURCE_ID,
                            SOURCE_NAME = V_SOURCE_NAME,
                            SOURCE_TYPE = V_SOURCE_TYPE,
                            PAY_TO = V_PAY_TO,
                            DESCRIPTION = V_DESCRIPTION,
                            PROCESSED_BY_TRANSACTION =
                               V_PROCESSED_BY_TRANSACTION,
                            PROCESSED_BY_CHECK = V_PROCESSED_BY_CHECK,
                            DUE_DATE = V_DUE_DATE,
                            TICKET_FARE = V_TICKET_FARE,
                            TICKET_TAX = V_TICKET_TAX,
                            TICKET_COMMISSION_PERSON =
                               V_TICKET_COMMISSION_PERSON,
                            TICKET_COMMISSION_AMOUNT =
                               V_TICKET_COMMISSION_AMOUNT,
                            CONTRACTED_FOR = V_CONTRACTED_FOR,
                            WHOSTAMP = V_WHOSTAMP,
                            DATESTAMP = V_DATESTAMP
                      WHERE TRANS_NUMBER = V_TRANS_NUMBER;

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
                  INSERT INTO R_saledg_rej_rec (trans_number,
                                                company_id,
                                                journal_id,
                                                journal_name,
                                                journal_type,
                                                transaction_date,
                                                transaction_status,
                                                ref_number,
                                                invoice_date,
                                                transaction_currency,
                                                exchange_rates,
                                                local_amount,
                                                base_amount,
                                                res_number,
                                                transaction_type,
                                                apply_local,
                                                apply_base,
                                                source_id,
                                                source_name,
                                                source_type,
                                                pay_to,
                                                description,
                                                processed_by_transaction,
                                                processed_by_check,
                                                due_date,
                                                ticket_fare,
                                                ticket_tax,
                                                ticket_commission_person,
                                                ticket_commission_amount,
                                                contracted_for,
                                                whostamp,
                                                datestamp)
                       VALUES (v_trans_number,
                               v_company_id,
                               v_journal_id,
                               v_journal_name,
                               v_journal_type,
                               v_transaction_date,
                               v_transaction_status,
                               v_ref_number,
                               v_invoice_date,
                               v_transaction_currency,
                               v_exchange_rates,
                               v_local_amount,
                               v_base_amount,
                               v_res_number,
                               v_transaction_type,
                               v_apply_local,
                               v_apply_base,
                               v_source_id,
                               v_source_name,
                               v_source_type,
                               v_pay_to,
                               v_description,
                               v_processed_by_transaction,
                               v_processed_by_check,
                               v_due_date,
                               v_ticket_fare,
                               v_ticket_tax,
                               v_ticket_commission_person,
                               v_ticket_commission_amount,
                               v_contracted_for,
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
                    VALUES ('SALEDG',
                            'F_SALES_LEDGER',
                            SYSDATE,
                            SUBSTR (v_code, 1, 50),
                            SUBSTR (v_error_message, 1, 250));

               --
               -- Write error record
               INSERT INTO R_saledg_rej_rec (trans_number,
                                             company_id,
                                             journal_id,
                                             journal_name,
                                             journal_type,
                                             transaction_date,
                                             transaction_status,
                                             ref_number,
                                             invoice_date,
                                             transaction_currency,
                                             exchange_rates,
                                             local_amount,
                                             base_amount,
                                             res_number,
                                             transaction_type,
                                             apply_local,
                                             apply_base,
                                             source_id,
                                             source_name,
                                             source_type,
                                             pay_to,
                                             description,
                                             processed_by_transaction,
                                             processed_by_check,
                                             due_date,
                                             ticket_fare,
                                             ticket_tax,
                                             ticket_commission_person,
                                             ticket_commission_amount,
                                             contracted_for,
                                             whostamp,
                                             datestamp)
                    VALUES (v_trans_number,
                            v_company_id,
                            v_journal_id,
                            v_journal_name,
                            v_journal_type,
                            v_transaction_date,
                            v_transaction_status,
                            v_ref_number,
                            v_invoice_date,
                            v_transaction_currency,
                            v_exchange_rates,
                            v_local_amount,
                            v_base_amount,
                            v_res_number,
                            v_transaction_type,
                            v_apply_local,
                            v_apply_base,
                            v_source_id,
                            v_source_name,
                            v_source_type,
                            v_pay_to,
                            v_description,
                            v_processed_by_transaction,
                            v_processed_by_check,
                            v_due_date,
                            v_ticket_fare,
                            v_ticket_tax,
                            v_ticket_commission_person,
                            v_ticket_commission_amount,
                            v_contracted_for,
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
              VALUES ('SALEDG',
                      'F_SALES_LEDGER',
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
           VALUES ('SALEDG',
                   'F_SALES_LEDGER',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));

      --
      COMMIT;
--
END;                                        /**** < OPEN Cursor Block  > ****/
/
SHOW ERRORS;
