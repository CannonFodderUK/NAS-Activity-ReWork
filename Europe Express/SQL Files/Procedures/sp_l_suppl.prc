SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:40 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_L_suppl
AS
   -- DECLARE /*****  D E C L A R E  S E C T I O N  *****/
   --===========================================================
   -- SP_SUPPL - which takes the contents of L_SUPPLIERS
   -- and populates the D_SUPPLIER table
   --
   --===========================================================
   -- Change History
   --===========================================================
   -- Date          Ver Who Comment
   -- 14-Dec-12     1.0 tthmlx  Original Version
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
   v_supplier_id           D_SUPPLIER.SUPPLIER_ID%TYPE;
   v_supplier_name         D_SUPPLIER.SUPPLIER_NAME%TYPE;
   v_doc_address1          D_SUPPLIER.DOC_ADDRESS1%TYPE;
   v_doc_address2          D_SUPPLIER.DOC_ADDRESS2%TYPE;
   v_doc_address3          D_SUPPLIER.DOC_ADDRESS3%TYPE;
   v_doc_country           D_SUPPLIER.DOC_COUNTRY%TYPE;
   v_bill_address1         D_SUPPLIER.BILL_ADDRESS1%TYPE;
   v_bill_address2         D_SUPPLIER.BILL_ADDRESS2%TYPE;
   v_bill_address3         D_SUPPLIER.BILL_ADDRESS3%TYPE;
   v_bill_country          D_SUPPLIER.BILL_COUNTRY%TYPE;
   v_doc_contact           D_SUPPLIER.DOC_CONTACT%TYPE;
   v_doc_phone             D_SUPPLIER.DOC_PHONE%TYPE;
   v_doc_fax               D_SUPPLIER.DOC_FAX%TYPE;
   v_doc_email             D_SUPPLIER.DOC_EMAIL%TYPE;
   v_doc_emergency_phone   D_SUPPLIER.DOC_EMERGENCY_PHONE%TYPE;
   v_contract_thru         D_SUPPLIER.CONTRACT_THRU%TYPE;
   v_pay_currency          D_SUPPLIER.PAY_CURRENCY%TYPE;
   v_comm_method           D_SUPPLIER.COMM_METHOD%TYPE;
   v_supplier_rating       D_SUPPLIER.SUPPLIER_RATING%TYPE;
   v_location_zone         D_SUPPLIER.LOCATION_ZONE%TYPE;
   v_location_group        D_SUPPLIER.LOCATION_GROUP%TYPE;
   v_website               D_SUPPLIER.WEBSITE%TYPE;
   v_bill_info             D_SUPPLIER.BILL_INFO%TYPE;
   v_ops_contact           D_SUPPLIER.OPS_CONTACT%TYPE;
   v_ops_phone             D_SUPPLIER.OPS_PHONE%TYPE;
   v_ops_fax               D_SUPPLIER.OPS_FAX%TYPE;
   v_ops_email             D_SUPPLIER.OPS_EMAIL%TYPE;
   v_tour_contact          D_SUPPLIER.TOUR_CONTACT%TYPE;
   v_tour_phone            D_SUPPLIER.TOUR_PHONE%TYPE;
   v_tour_fax              D_SUPPLIER.TOUR_FAX%TYPE;
   v_tour_email            D_SUPPLIER.TOUR_EMAIL%TYPE;
   v_group_contact         D_SUPPLIER.GROUP_CONTACT%TYPE;
   v_group_phone           D_SUPPLIER.GROUP_PHONE%TYPE;
   v_group_fax             D_SUPPLIER.GROUP_FAX%TYPE;
   v_group_email           D_SUPPLIER.GROUP_EMAIL%TYPE;
   v_acc_contact           D_SUPPLIER.ACC_CONTACT%TYPE;
   v_acc_phone             D_SUPPLIER.ACC_PHONE%TYPE;
   v_acc_fax               D_SUPPLIER.ACC_FAX%TYPE;
   v_acc_email             D_SUPPLIER.ACC_EMAIL%TYPE;
   v_contract_contact      D_SUPPLIER.CONTRACT_CONTACT%TYPE;
   v_contract_phone        D_SUPPLIER.CONTRACT_PHONE%TYPE;
   v_contract_fax          D_SUPPLIER.CONTRACT_FAX%TYPE;
   v_contract_email        D_SUPPLIER.CONTRACT_EMAIL%TYPE;
   v_emergency_phone       D_SUPPLIER.EMERGENCY_PHONE%TYPE;
   v_prepay                D_SUPPLIER.PREPAY%TYPE;
   v_taxid                 D_SUPPLIER.TAXID%TYPE;
   v_supplier_type         D_SUPPLIER.SUPPLIER_TYPE%TYPE;
   v_billname              D_SUPPLIER.BILLNAME%TYPE;
   v_defaultgl             D_SUPPLIER.DEFAULTGL%TYPE;
   v_tax_cert_num          D_SUPPLIER.TAX_CERT_NUM%TYPE;
   v_tax_cert_exp          D_SUPPLIER.TAX_CERT_EXP%TYPE;
   v_pay_type              D_SUPPLIER.PAY_TYPE%TYPE;
   v_whostamp              D_SUPPLIER.WHOSTAMP%TYPE;
   v_datestamp             D_SUPPLIER.DATESTAMP%TYPE;
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
      SELECT SUPPLIERID SUPPLIER_ID,
             SUPPLIERNAME SUPPLIER_NAME,
             DOCADDRESS1 DOC_ADDRESS1,
             DOCADDRESS2 DOC_ADDRESS2,
             DOCADDRESS3 DOC_ADDRESS3,
             DOCCOUNTRY DOC_COUNTRY,
             BILLADDRESS1 BILL_ADDRESS1,
             BILLADDRESS2 BILL_ADDRESS2,
             BILLADDRESS3 BILL_ADDRESS3,
             BILLCOUNTRY BILL_COUNTRY,
             DOCCONTACT DOC_CONTACT,
             DOCPHONE DOC_PHONE,
             DOCFAX DOC_FAX,
             DOCEMAIL DOC_EMAIL,
             DOCEMERGENCYPHONE DOC_EMERGENCY_PHONE,
             CONTRACTTHRU CONTRACT_THRU,
             PAYCURRENCY PAY_CURRENCY,
             COMMMETHOD COMM_METHOD,
             SUPPLIERRATING SUPPLIER_RATING,
             LOCATIONZONE LOCATION_ZONE,
             LOCATIONGROUP LOCATION_GROUP,
             WEBSITE,
             BILLINFO BILL_INFO,
             OPSCONTACT OPS_CONTACT,
             OPSPHONE OPS_PHONE,
             OPSFAX OPS_FAX,
             OPSEMAIL OPS_EMAIL,
             TOURCONTACT TOUR_CONTACT,
             TOURPHONE TOUR_PHONE,
             TOURFAX TOUR_FAX,
             TOUREMAIL TOUR_EMAIL,
             GROUPCONTACT GROUP_CONTACT,
             GROUPPHONE GROUP_PHONE,
             GROUPFAX GROUP_FAX,
             GROUPEMAIL GROUP_EMAIL,
             ACCCONTACT ACC_CONTACT,
             ACCPHONE ACC_PHONE,
             ACCFAX ACC_FAX,
             ACCEMAIL ACC_EMAIL,
             CONTRACTCONTACT CONTRACT_CONTACT,
             CONTRACTPHONE CONTRACT_PHONE,
             CONTRACTFAX CONTRACT_FAX,
             CONTRACTEMAIL CONTRACT_EMAIL,
             EMERGENCYPHONE EMERGENCY_PHONE,
             PREPAY,
             TAXID,
             TYPE SUPPLIER_TYPE,
             BILLNAME,
             DEFAULTGL,
             TAXCERTNUM TAX_CERT_NUM,
             TAXCERTEXP TAX_CERT_EXP,
             PAYTYPE PAY_TYPE,
             WHOSTAMP,
             DATESTAMP
        FROM L_SUPPLIERS;

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
            INTO v_supplier_id,
                 v_supplier_name,
                 v_doc_address1,
                 v_doc_address2,
                 v_doc_address3,
                 v_doc_country,
                 v_bill_address1,
                 v_bill_address2,
                 v_bill_address3,
                 v_bill_country,
                 v_doc_contact,
                 v_doc_phone,
                 v_doc_fax,
                 v_doc_email,
                 v_doc_emergency_phone,
                 v_contract_thru,
                 v_pay_currency,
                 v_comm_method,
                 v_supplier_rating,
                 v_location_zone,
                 v_location_group,
                 v_website,
                 v_bill_info,
                 v_ops_contact,
                 v_ops_phone,
                 v_ops_fax,
                 v_ops_email,
                 v_tour_contact,
                 v_tour_phone,
                 v_tour_fax,
                 v_tour_email,
                 v_group_contact,
                 v_group_phone,
                 v_group_fax,
                 v_group_email,
                 v_acc_contact,
                 v_acc_phone,
                 v_acc_fax,
                 v_acc_email,
                 v_contract_contact,
                 v_contract_phone,
                 v_contract_fax,
                 v_contract_email,
                 v_emergency_phone,
                 v_prepay,
                 v_taxid,
                 v_supplier_type,
                 v_billname,
                 v_defaultgl,
                 v_tax_cert_num,
                 v_tax_cert_exp,
                 v_pay_type,
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
                  INSERT INTO d_supplier (supplier_id,
                                          supplier_name,
                                          doc_address1,
                                          doc_address2,
                                          doc_address3,
                                          doc_country,
                                          bill_address1,
                                          bill_address2,
                                          bill_address3,
                                          bill_country,
                                          doc_contact,
                                          doc_phone,
                                          doc_fax,
                                          doc_email,
                                          doc_emergency_phone,
                                          contract_thru,
                                          pay_currency,
                                          comm_method,
                                          supplier_rating,
                                          location_zone,
                                          location_group,
                                          website,
                                          bill_info,
                                          ops_contact,
                                          ops_phone,
                                          ops_fax,
                                          ops_email,
                                          tour_contact,
                                          tour_phone,
                                          tour_fax,
                                          tour_email,
                                          group_contact,
                                          group_phone,
                                          group_fax,
                                          group_email,
                                          acc_contact,
                                          acc_phone,
                                          acc_fax,
                                          acc_email,
                                          contract_contact,
                                          contract_phone,
                                          contract_fax,
                                          contract_email,
                                          emergency_phone,
                                          prepay,
                                          taxid,
                                          supplier_type,
                                          billname,
                                          defaultgl,
                                          tax_cert_num,
                                          tax_cert_exp,
                                          pay_type,
                                          whostamp,
                                          datestamp)
                       VALUES (v_supplier_id,
                               v_supplier_name,
                               v_doc_address1,
                               v_doc_address2,
                               v_doc_address3,
                               v_doc_country,
                               v_bill_address1,
                               v_bill_address2,
                               v_bill_address3,
                               v_bill_country,
                               v_doc_contact,
                               v_doc_phone,
                               v_doc_fax,
                               v_doc_email,
                               v_doc_emergency_phone,
                               v_contract_thru,
                               v_pay_currency,
                               v_comm_method,
                               v_supplier_rating,
                               v_location_zone,
                               v_location_group,
                               v_website,
                               v_bill_info,
                               v_ops_contact,
                               v_ops_phone,
                               v_ops_fax,
                               v_ops_email,
                               v_tour_contact,
                               v_tour_phone,
                               v_tour_fax,
                               v_tour_email,
                               v_group_contact,
                               v_group_phone,
                               v_group_fax,
                               v_group_email,
                               v_acc_contact,
                               v_acc_phone,
                               v_acc_fax,
                               v_acc_email,
                               v_contract_contact,
                               v_contract_phone,
                               v_contract_fax,
                               v_contract_email,
                               v_emergency_phone,
                               v_prepay,
                               v_taxid,
                               v_supplier_type,
                               v_billname,
                               v_defaultgl,
                               v_tax_cert_num,
                               v_tax_cert_exp,
                               v_pay_type,
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
                     UPDATE D_SUPPLIER
                        SET SUPPLIER_NAME = V_SUPPLIER_NAME,
                            DOC_ADDRESS1 = V_DOC_ADDRESS1,
                            DOC_ADDRESS2 = V_DOC_ADDRESS2,
                            DOC_ADDRESS3 = V_DOC_ADDRESS3,
                            DOC_COUNTRY = V_DOC_COUNTRY,
                            BILL_ADDRESS1 = V_BILL_ADDRESS1,
                            BILL_ADDRESS2 = V_BILL_ADDRESS2,
                            BILL_ADDRESS3 = V_BILL_ADDRESS3,
                            BILL_COUNTRY = V_BILL_COUNTRY,
                            DOC_CONTACT = V_DOC_CONTACT,
                            DOC_PHONE = V_DOC_PHONE,
                            DOC_FAX = V_DOC_FAX,
                            DOC_EMAIL = V_DOC_EMAIL,
                            DOC_EMERGENCY_PHONE = V_DOC_EMERGENCY_PHONE,
                            CONTRACT_THRU = V_CONTRACT_THRU,
                            PAY_CURRENCY = V_PAY_CURRENCY,
                            COMM_METHOD = V_COMM_METHOD,
                            SUPPLIER_RATING = V_SUPPLIER_RATING,
                            LOCATION_ZONE = V_LOCATION_ZONE,
                            LOCATION_GROUP = V_LOCATION_GROUP,
                            WEBSITE = V_WEBSITE,
                            BILL_INFO = V_BILL_INFO,
                            OPS_CONTACT = V_OPS_CONTACT,
                            OPS_PHONE = V_OPS_PHONE,
                            OPS_FAX = V_OPS_FAX,
                            OPS_EMAIL = V_OPS_EMAIL,
                            TOUR_CONTACT = V_TOUR_CONTACT,
                            TOUR_PHONE = V_TOUR_PHONE,
                            TOUR_FAX = V_TOUR_FAX,
                            TOUR_EMAIL = V_TOUR_EMAIL,
                            GROUP_CONTACT = V_GROUP_CONTACT,
                            GROUP_PHONE = V_GROUP_PHONE,
                            GROUP_FAX = V_GROUP_FAX,
                            GROUP_EMAIL = V_GROUP_EMAIL,
                            ACC_CONTACT = V_ACC_CONTACT,
                            ACC_PHONE = V_ACC_PHONE,
                            ACC_FAX = V_ACC_FAX,
                            ACC_EMAIL = V_ACC_EMAIL,
                            CONTRACT_CONTACT = V_CONTRACT_CONTACT,
                            CONTRACT_PHONE = V_CONTRACT_PHONE,
                            CONTRACT_FAX = V_CONTRACT_FAX,
                            CONTRACT_EMAIL = V_CONTRACT_EMAIL,
                            EMERGENCY_PHONE = V_EMERGENCY_PHONE,
                            PREPAY = V_PREPAY,
                            TAXID = V_TAXID,
                            SUPPLIER_TYPE = V_SUPPLIER_TYPE,
                            BILLNAME = V_BILLNAME,
                            DEFAULTGL = V_DEFAULTGL,
                            TAX_CERT_NUM = V_TAX_CERT_NUM,
                            TAX_CERT_EXP = V_TAX_CERT_EXP,
                            PAY_TYPE = V_PAY_TYPE,
                            WHOSTAMP = V_WHOSTAMP,
                            DATESTAMP = V_DATESTAMP
                      WHERE SUPPLIER_ID = V_SUPPLIER_ID;

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
                  INSERT INTO R_suppl_rej_rec (supplier_id,
                                               supplier_name,
                                               doc_address1,
                                               doc_address2,
                                               doc_address3,
                                               doc_country,
                                               bill_address1,
                                               bill_address2,
                                               bill_address3,
                                               bill_country,
                                               doc_contact,
                                               doc_phone,
                                               doc_fax,
                                               doc_email,
                                               doc_emergency_phone,
                                               contract_thru,
                                               pay_currency,
                                               comm_method,
                                               supplier_rating,
                                               location_zone,
                                               location_group,
                                               website,
                                               bill_info,
                                               ops_contact,
                                               ops_phone,
                                               ops_fax,
                                               ops_email,
                                               tour_contact,
                                               tour_phone,
                                               tour_fax,
                                               tour_email,
                                               group_contact,
                                               group_phone,
                                               group_fax,
                                               group_email,
                                               acc_contact,
                                               acc_phone,
                                               acc_fax,
                                               acc_email,
                                               contract_contact,
                                               contract_phone,
                                               contract_fax,
                                               contract_email,
                                               emergency_phone,
                                               prepay,
                                               taxid,
                                               supplier_type,
                                               billname,
                                               defaultgl,
                                               tax_cert_num,
                                               tax_cert_exp,
                                               pay_type,
                                               whostamp,
                                               datestamp)
                       VALUES (v_supplier_id,
                               v_supplier_name,
                               v_doc_address1,
                               v_doc_address2,
                               v_doc_address3,
                               v_doc_country,
                               v_bill_address1,
                               v_bill_address2,
                               v_bill_address3,
                               v_bill_country,
                               v_doc_contact,
                               v_doc_phone,
                               v_doc_fax,
                               v_doc_email,
                               v_doc_emergency_phone,
                               v_contract_thru,
                               v_pay_currency,
                               v_comm_method,
                               v_supplier_rating,
                               v_location_zone,
                               v_location_group,
                               v_website,
                               v_bill_info,
                               v_ops_contact,
                               v_ops_phone,
                               v_ops_fax,
                               v_ops_email,
                               v_tour_contact,
                               v_tour_phone,
                               v_tour_fax,
                               v_tour_email,
                               v_group_contact,
                               v_group_phone,
                               v_group_fax,
                               v_group_email,
                               v_acc_contact,
                               v_acc_phone,
                               v_acc_fax,
                               v_acc_email,
                               v_contract_contact,
                               v_contract_phone,
                               v_contract_fax,
                               v_contract_email,
                               v_emergency_phone,
                               v_prepay,
                               v_taxid,
                               v_supplier_type,
                               v_billname,
                               v_defaultgl,
                               v_tax_cert_num,
                               v_tax_cert_exp,
                               v_pay_type,
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
                    VALUES ('SUPPL',
                            'D_SUPPLIER',
                            SYSDATE,
                            SUBSTR (v_code, 1, 50),
                            SUBSTR (v_error_message, 1, 250));

               --
               -- Write error record
               INSERT INTO R_suppl_rej_rec (supplier_id,
                                            supplier_name,
                                            doc_address1,
                                            doc_address2,
                                            doc_address3,
                                            doc_country,
                                            bill_address1,
                                            bill_address2,
                                            bill_address3,
                                            bill_country,
                                            doc_contact,
                                            doc_phone,
                                            doc_fax,
                                            doc_email,
                                            doc_emergency_phone,
                                            contract_thru,
                                            pay_currency,
                                            comm_method,
                                            supplier_rating,
                                            location_zone,
                                            location_group,
                                            website,
                                            bill_info,
                                            ops_contact,
                                            ops_phone,
                                            ops_fax,
                                            ops_email,
                                            tour_contact,
                                            tour_phone,
                                            tour_fax,
                                            tour_email,
                                            group_contact,
                                            group_phone,
                                            group_fax,
                                            group_email,
                                            acc_contact,
                                            acc_phone,
                                            acc_fax,
                                            acc_email,
                                            contract_contact,
                                            contract_phone,
                                            contract_fax,
                                            contract_email,
                                            emergency_phone,
                                            prepay,
                                            taxid,
                                            supplier_type,
                                            billname,
                                            defaultgl,
                                            tax_cert_num,
                                            tax_cert_exp,
                                            pay_type,
                                            whostamp,
                                            datestamp)
                    VALUES (v_supplier_id,
                            v_supplier_name,
                            v_doc_address1,
                            v_doc_address2,
                            v_doc_address3,
                            v_doc_country,
                            v_bill_address1,
                            v_bill_address2,
                            v_bill_address3,
                            v_bill_country,
                            v_doc_contact,
                            v_doc_phone,
                            v_doc_fax,
                            v_doc_email,
                            v_doc_emergency_phone,
                            v_contract_thru,
                            v_pay_currency,
                            v_comm_method,
                            v_supplier_rating,
                            v_location_zone,
                            v_location_group,
                            v_website,
                            v_bill_info,
                            v_ops_contact,
                            v_ops_phone,
                            v_ops_fax,
                            v_ops_email,
                            v_tour_contact,
                            v_tour_phone,
                            v_tour_fax,
                            v_tour_email,
                            v_group_contact,
                            v_group_phone,
                            v_group_fax,
                            v_group_email,
                            v_acc_contact,
                            v_acc_phone,
                            v_acc_fax,
                            v_acc_email,
                            v_contract_contact,
                            v_contract_phone,
                            v_contract_fax,
                            v_contract_email,
                            v_emergency_phone,
                            v_prepay,
                            v_taxid,
                            v_supplier_type,
                            v_billname,
                            v_defaultgl,
                            v_tax_cert_num,
                            v_tax_cert_exp,
                            v_pay_type,
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
              VALUES ('SUPPL',
                      'D_SUPPLIER',
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
           VALUES ('SUPPL',
                   'D_SUPPLIER',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));

      --
      COMMIT;
--
END;                                        /**** < OPEN Cursor Block  > ****/
/
SHOW ERRORS;
