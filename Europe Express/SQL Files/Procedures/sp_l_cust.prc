SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:37 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_l_cust
AS
   -- DECLARE /*****  D E C L A R E  S E C T I O N  *****/
   --===========================================================
   -- SP_L_CUST - which takes the contents of L_MRKCUSTOMERS
   -- and populates the D_CUSTOMER table
   --
   --===========================================================
   -- Change History
   --===========================================================
   -- Date          Ver Who Comment
   -- 14-Jan-13     1.0 tthmlx  Original Version
   --
   --
   -- EXCEPTION DEFINITIONS
   --
   primary_key_error        EXCEPTION;
   PRAGMA EXCEPTION_INIT (primary_key_error, -00001);
   foreign_key_error        EXCEPTION;
   PRAGMA EXCEPTION_INIT (foreign_key_error, -02291);
   --
   --
   v_commit_at     CONSTANT PLS_INTEGER := 1000;
   --
   -- VARIABLES HOLDING DATA FROM CURSOR
   --
   v_customer_id            D_CUSTOMER.CUSTOMER_ID%TYPE;
   v_addressid              D_CUSTOMER.ADDRESSID%TYPE;
   v_company_name           D_CUSTOMER.COMPANY_NAME%TYPE;
   v_customer_type          D_CUSTOMER.CUSTOMER_TYPE%TYPE;
   v_mrkcustomers_profile   D_CUSTOMER.MRKCUSTOMERS_PROFILE%TYPE;
   v_mrkcustomers_comment   D_CUSTOMER.MRKCUSTOMERS_COMMENT%TYPE;
   v_defaultbrand           D_CUSTOMER.DEFAULTBRAND%TYPE;
   v_taxid                  D_CUSTOMER.TAXID%TYPE;
   v_gstper                 D_CUSTOMER.GSTPER%TYPE;
   v_qcurrency              D_CUSTOMER.QCURRENCY%TYPE;
   v_phone                  D_CUSTOMER.PHONE%TYPE;
   v_mobile_phone           D_CUSTOMER.MOBILE_PHONE%TYPE;
   v_fax                    D_CUSTOMER.FAX%TYPE;
   v_email                  D_CUSTOMER.EMAIL%TYPE;
   v_territory              D_CUSTOMER.TERRITORY%TYPE;
   v_status                 D_CUSTOMER.STATUS%TYPE;
   v_origin                 D_CUSTOMER.ORIGIN%TYPE;
   v_affiliation_id         D_CUSTOMER.AFFILIATION_ID%TYPE;
   v_comm_code              D_CUSTOMER.COMM_CODE%TYPE;
   v_comm_payper            D_CUSTOMER.COMM_PAYPER%TYPE;
   v_last_brochures         D_CUSTOMER.LAST_BROCHURES%TYPE;
   v_credit_status          D_CUSTOMER.CREDIT_STATUS%TYPE;
   v_created_by             D_CUSTOMER.CREATED_BY%TYPE;
   v_created_date           D_CUSTOMER.CREATED_DATE%TYPE;
   v_whostamp               D_CUSTOMER.WHOSTAMP%TYPE;
   v_datestamp              D_CUSTOMER.DATESTAMP%TYPE;
   --
   -- WORK VARIABLES
   --
   v_null                   CHAR (1);
   v_count                  CHAR (1);
   v_insert_ok              CHAR (1);
   v_update_ok              CHAR (1);
   v_fk_error               CHAR (1);
   v_foreign_key_error      CHAR (1);
   v_primary_key_error      CHAR (1);
   --
   v_code                   NUMBER (5);
   v_error_message          VARCHAR2 (512);

   --
   CURSOR C001
   IS
      SELECT CUSTOMERID CUSTOMER_ID,
             ADDRESSID,
             CUSTOMERNAME COMPANY_NAME,
             UPPER (CUSTOMERTYPE) CUSTOMER_TYPE,
             MRKCUSTOMERS_PROFILE,
             MRKCUSTOMERS_COMMENT,
             DEFAULTBRAND,
             TAXID,
             GSTPER,
             QCURRENCY,
             PHONE,
             MOBILEPHONE MOBILE_PHONE,
             FAX,
             EMAIL,
             TERRITORY,
             STATUS,
             ORIGIN,
             AFFILIATIONID AFFILIATION_ID,
             COMMCODE COMM_CODE,
             COMMPAYPER COMM_PAYPER,
             LASTBROCHURES LAST_BROCHURES,
             CREDITSTATUS CREDIT_STATUS,
             CREATEDBY CREATED_BY,
             CREATEDDATE CREATED_DATE,
             WHOSTAMP,
             DATESTAMP
        FROM L_MRKCUSTOMERS;

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
            INTO v_customer_id,
                 v_addressid,
                 v_company_name,
                 v_customer_type,
                 v_mrkcustomers_profile,
                 v_mrkcustomers_comment,
                 v_defaultbrand,
                 v_taxid,
                 v_gstper,
                 v_qcurrency,
                 v_phone,
                 v_mobile_phone,
                 v_fax,
                 v_email,
                 v_territory,
                 v_status,
                 v_origin,
                 v_affiliation_id,
                 v_comm_code,
                 v_comm_payper,
                 v_last_brochures,
                 v_credit_status,
                 v_created_by,
                 v_created_date,
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
                  INSERT INTO d_customer (customer_id,
                                          addressid,
                                          company_name,
                                          customer_type,
                                          mrkcustomers_profile,
                                          mrkcustomers_comment,
                                          defaultbrand,
                                          taxid,
                                          gstper,
                                          qcurrency,
                                          phone,
                                          mobile_phone,
                                          fax,
                                          email,
                                          territory,
                                          status,
                                          origin,
                                          affiliation_id,
                                          comm_code,
                                          comm_payper,
                                          last_brochures,
                                          credit_status,
                                          created_by,
                                          created_date,
                                          whostamp,
                                          datestamp)
                       VALUES (v_customer_id,
                               v_addressid,
                               v_company_name,
                               v_customer_type,
                               v_mrkcustomers_profile,
                               v_mrkcustomers_comment,
                               v_defaultbrand,
                               v_taxid,
                               v_gstper,
                               v_qcurrency,
                               v_phone,
                               v_mobile_phone,
                               v_fax,
                               v_email,
                               v_territory,
                               v_status,
                               v_origin,
                               v_affiliation_id,
                               v_comm_code,
                               v_comm_payper,
                               v_last_brochures,
                               v_credit_status,
                               v_created_by,
                               v_created_date,
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
                     UPDATE D_CUSTOMER
                        SET ADDRESSID = V_ADDRESSID,
                            COMPANY_NAME = V_COMPANY_NAME,
                            CUSTOMER_TYPE = V_CUSTOMER_TYPE,
                            MRKCUSTOMERS_PROFILE = V_MRKCUSTOMERS_PROFILE,
                            MRKCUSTOMERS_COMMENT = V_MRKCUSTOMERS_COMMENT,
                            DEFAULTBRAND = V_DEFAULTBRAND,
                            TAXID = V_TAXID,
                            GSTPER = V_GSTPER,
                            QCURRENCY = V_QCURRENCY,
                            PHONE = V_PHONE,
                            MOBILE_PHONE = V_MOBILE_PHONE,
                            FAX = V_FAX,
                            EMAIL = V_EMAIL,
                            TERRITORY = V_TERRITORY,
                            STATUS = V_STATUS,
                            ORIGIN = V_ORIGIN,
                            AFFILIATION_ID = V_AFFILIATION_ID,
                            COMM_CODE = V_COMM_CODE,
                            COMM_PAYPER = V_COMM_PAYPER,
                            LAST_BROCHURES = V_LAST_BROCHURES,
                            CREDIT_STATUS = V_CREDIT_STATUS,
                            CREATED_BY = V_CREATED_BY,
                            CREATED_DATE = V_CREATED_DATE,
                            WHOSTAMP = V_WHOSTAMP,
                            DATESTAMP = V_DATESTAMP
                      WHERE CUSTOMER_ID = V_CUSTOMER_ID;

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
                  INSERT INTO R_cust_rej_rec (customer_id,
                                              addressid,
                                              company_name,
                                              customer_type,
                                              mrkcustomers_profile,
                                              mrkcustomers_comment,
                                              defaultbrand,
                                              taxid,
                                              gstper,
                                              qcurrency,
                                              phone,
                                              mobile_phone,
                                              fax,
                                              email,
                                              territory,
                                              status,
                                              origin,
                                              affiliation_id,
                                              comm_code,
                                              comm_payper,
                                              last_brochures,
                                              credit_status,
                                              created_by,
                                              created_date,
                                              whostamp,
                                              datestamp)
                       VALUES (v_customer_id,
                               v_addressid,
                               v_company_name,
                               v_customer_type,
                               v_mrkcustomers_profile,
                               v_mrkcustomers_comment,
                               v_defaultbrand,
                               v_taxid,
                               v_gstper,
                               v_qcurrency,
                               v_phone,
                               v_mobile_phone,
                               v_fax,
                               v_email,
                               v_territory,
                               v_status,
                               v_origin,
                               v_affiliation_id,
                               v_comm_code,
                               v_comm_payper,
                               v_last_brochures,
                               v_credit_status,
                               v_created_by,
                               v_created_date,
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
                    VALUES ('L_CUST',
                            'D_CUSTOMER',
                            SYSDATE,
                            SUBSTR (v_code, 1, 50),
                            SUBSTR (v_error_message, 1, 250));

               --
               -- Write error record
               INSERT INTO R_cust_rej_rec (customer_id,
                                           addressid,
                                           company_name,
                                           customer_type,
                                           mrkcustomers_profile,
                                           mrkcustomers_comment,
                                           defaultbrand,
                                           taxid,
                                           gstper,
                                           qcurrency,
                                           phone,
                                           mobile_phone,
                                           fax,
                                           email,
                                           territory,
                                           status,
                                           origin,
                                           affiliation_id,
                                           comm_code,
                                           comm_payper,
                                           last_brochures,
                                           credit_status,
                                           created_by,
                                           created_date,
                                           whostamp,
                                           datestamp)
                    VALUES (v_customer_id,
                            v_addressid,
                            v_company_name,
                            v_customer_type,
                            v_mrkcustomers_profile,
                            v_mrkcustomers_comment,
                            v_defaultbrand,
                            v_taxid,
                            v_gstper,
                            v_qcurrency,
                            v_phone,
                            v_mobile_phone,
                            v_fax,
                            v_email,
                            v_territory,
                            v_status,
                            v_origin,
                            v_affiliation_id,
                            v_comm_code,
                            v_comm_payper,
                            v_last_brochures,
                            v_credit_status,
                            v_created_by,
                            v_created_date,
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
              VALUES ('L_CUST',
                      'D_CUSTOMER',
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
           VALUES ('L_CUST',
                   'D_CUSTOMER',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));

      --
      COMMIT;
--
END;                                        /**** < OPEN Cursor Block  > ****/
/
SHOW ERRORS;
