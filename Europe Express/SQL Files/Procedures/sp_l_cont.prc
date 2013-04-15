SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:37 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_l_cont
AS
   -- DECLARE /*****  D E C L A R E  S E C T I O N  *****/
   --===========================================================
   -- SP_L_CONT - which takes the contents of L_MRKCONTACTS
   -- and populates the D_CONTACT table
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
   primary_key_error         EXCEPTION;
   PRAGMA EXCEPTION_INIT (primary_key_error, -00001);
   foreign_key_error         EXCEPTION;
   PRAGMA EXCEPTION_INIT (foreign_key_error, -02291);
   --
   --
   v_commit_at      CONSTANT PLS_INTEGER := 1000;
   --
   -- VARIABLES HOLDING DATA FROM CURSOR
   --
   v_customer_id             D_CONTACT.CUSTOMER_ID%TYPE;
   v_addressid               D_CONTACT.ADDRESSID%TYPE;
   v_customer_type           D_CONTACT.CUSTOMER_TYPE%TYPE;
   v_mrkcontacts_profile     D_CONTACT.MRKCONTACTS_PROFILE%TYPE;
   v_mrkcontacts_comment     D_CONTACT.MRKCONTACTS_COMMENT%TYPE;
   v_defaultbrand            D_CONTACT.DEFAULTBRAND%TYPE;
   v_taxid                   D_CONTACT.TAXID%TYPE;
   v_gstper                  D_CONTACT.GSTPER%TYPE;
   v_qcurrency               D_CONTACT.QCURRENCY%TYPE;
   v_phone                   D_CONTACT.PHONE%TYPE;
   v_phone_ext               D_CONTACT.PHONE_EXT%TYPE;
   v_mobile_phone            D_CONTACT.MOBILE_PHONE%TYPE;
   v_fax                     D_CONTACT.FAX%TYPE;
   v_email                   D_CONTACT.EMAIL%TYPE;
   v_territory               D_CONTACT.TERRITORY%TYPE;
   v_status                  D_CONTACT.STATUS%TYPE;
   v_origin                  D_CONTACT.ORIGIN%TYPE;
   v_last_name               D_CONTACT.LAST_NAME%TYPE;
   v_first_name              D_CONTACT.FIRST_NAME%TYPE;
   v_care_of                 D_CONTACT.CARE_OF%TYPE;
   v_household_name          D_CONTACT.HOUSEHOLD_NAME%TYPE;
   v_gender                  D_CONTACT.GENDER%TYPE;
   v_title                   D_CONTACT.TITLE%TYPE;
   v_mrkcontacts_broadcast   D_CONTACT.MRKCONTACTS_BROADCAST%TYPE;
   v_mail_broadcast          D_CONTACT.MAIL_BROADCAST%TYPE;
   v_customerid              D_CONTACT.CUSTOMERID%TYPE;
   v_useok                   D_CONTACT.USEOK%TYPE;
   v_copyok                  D_CONTACT.COPYOK%TYPE;
   v_manageok                D_CONTACT.MANAGEOK%TYPE;
   v_birthdate               D_CONTACT.BIRTHDATE%TYPE;
   v_birthplace              D_CONTACT.BIRTHPLACE%TYPE;
   v_age                     D_CONTACT.AGE%TYPE;
   v_passport_number         D_CONTACT.PASSPORT_NUMBER%TYPE;
   v_passport_expiration     D_CONTACT.PASSPORT_EXPIRATION%TYPE;
   v_passport_authority      D_CONTACT.PASSPORT_AUTHORITY%TYPE;
   v_passport_issue_date     D_CONTACT.PASSPORT_ISSUE_DATE%TYPE;
   v_nationality             D_CONTACT.NATIONALITY%TYPE;
   v_pax_type                D_CONTACT.PAX_TYPE%TYPE;
   v_emergency_contact       D_CONTACT.EMERGENCY_CONTACT%TYPE;
   v_emergency_phone         D_CONTACT.EMERGENCY_PHONE%TYPE;
   v_created_by              D_CONTACT.CREATED_BY%TYPE;
   v_created_date            D_CONTACT.CREATED_DATE%TYPE;
   v_whostamp                D_CONTACT.WHOSTAMP%TYPE;
   v_datestamp               D_CONTACT.DATESTAMP%TYPE;
   --
   -- WORK VARIABLES
   --
   v_null                    CHAR (1);
   v_count                   CHAR (1);
   v_insert_ok               CHAR (1);
   v_update_ok               CHAR (1);
   v_fk_error                CHAR (1);
   v_foreign_key_error       CHAR (1);
   v_primary_key_error       CHAR (1);
   --
   v_code                    NUMBER (5);
   v_error_message           VARCHAR2 (512);

   --
   CURSOR C001
   IS
      SELECT CONTACTID CUSTOMER_ID,
             ADDRESSID,
             CONTACTTYPE CUSTOMER_TYPE,
             MRKCONTACTS_PROFILE,
             MRKCONTACTS_COMMENT,
             DEFAULTBRAND,
             TAXID,
             GSTPER,
             QCURRENCY,
             PHONE,
             PHONEEXT PHONE_EXT,
             MOBILEPHONE MOBILE_PHONE,
             FAX,
             EMAIL,
             TERRITORY,
             STATUS,
             ORIGIN,
             LASTNAME LAST_NAME,
             FIRSTNAME FIRST_NAME,
             CAREOF CARE_OF,
             HOUSEHOLDNAME HOUSEHOLD_NAME,
             GENDER,
             TITLE,
             MRKCONTACTS_BROADCAST,
             MAILBROADCAST MAIL_BROADCAST,
             CUSTOMERID,
             USEOK,
             COPYOK,
             MANAGEOK,
             BIRTHDATE,
             BIRTHPLACE,
             AGE,
             PASSPORTNUMBER PASSPORT_NUMBER,
             PASSPORTEXPIRATION PASSPORT_EXPIRATION,
             PASSPORTAUTHORITY PASSPORT_AUTHORITY,
             PASSPORTISSUEDATE PASSPORT_ISSUE_DATE,
             NATIONALITY,
             PAXTYPE PAX_TYPE,
             EMERGENCYCONTACT EMERGENCY_CONTACT,
             EMERGENCYPHONE EMERGENCY_PHONE,
             CREATEDBY CREATED_BY,
             CREATEDDATE CREATED_DATE,
             WHOSTAMP,
             DATESTAMP
        FROM L_MRKCONTACTS;

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
                 v_customer_type,
                 v_mrkcontacts_profile,
                 v_mrkcontacts_comment,
                 v_defaultbrand,
                 v_taxid,
                 v_gstper,
                 v_qcurrency,
                 v_phone,
                 v_phone_ext,
                 v_mobile_phone,
                 v_fax,
                 v_email,
                 v_territory,
                 v_status,
                 v_origin,
                 v_last_name,
                 v_first_name,
                 v_care_of,
                 v_household_name,
                 v_gender,
                 v_title,
                 v_mrkcontacts_broadcast,
                 v_mail_broadcast,
                 v_customerid,
                 v_useok,
                 v_copyok,
                 v_manageok,
                 v_birthdate,
                 v_birthplace,
                 v_age,
                 v_passport_number,
                 v_passport_expiration,
                 v_passport_authority,
                 v_passport_issue_date,
                 v_nationality,
                 v_pax_type,
                 v_emergency_contact,
                 v_emergency_phone,
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
                  INSERT INTO d_contact (customer_id,
                                         addressid,
                                         customer_type,
                                         mrkcontacts_profile,
                                         mrkcontacts_comment,
                                         defaultbrand,
                                         taxid,
                                         gstper,
                                         qcurrency,
                                         phone,
                                         phone_ext,
                                         mobile_phone,
                                         fax,
                                         email,
                                         territory,
                                         status,
                                         origin,
                                         last_name,
                                         first_name,
                                         care_of,
                                         household_name,
                                         gender,
                                         title,
                                         mrkcontacts_broadcast,
                                         mail_broadcast,
                                         customerid,
                                         useok,
                                         copyok,
                                         manageok,
                                         birthdate,
                                         birthplace,
                                         age,
                                         passport_number,
                                         passport_expiration,
                                         passport_authority,
                                         passport_issue_date,
                                         nationality,
                                         pax_type,
                                         emergency_contact,
                                         emergency_phone,
                                         created_by,
                                         created_date,
                                         whostamp,
                                         datestamp)
                       VALUES (v_customer_id,
                               v_addressid,
                               v_customer_type,
                               v_mrkcontacts_profile,
                               v_mrkcontacts_comment,
                               v_defaultbrand,
                               v_taxid,
                               v_gstper,
                               v_qcurrency,
                               v_phone,
                               v_phone_ext,
                               v_mobile_phone,
                               v_fax,
                               v_email,
                               v_territory,
                               v_status,
                               v_origin,
                               v_last_name,
                               v_first_name,
                               v_care_of,
                               v_household_name,
                               v_gender,
                               v_title,
                               v_mrkcontacts_broadcast,
                               v_mail_broadcast,
                               v_customerid,
                               v_useok,
                               v_copyok,
                               v_manageok,
                               v_birthdate,
                               v_birthplace,
                               v_age,
                               v_passport_number,
                               v_passport_expiration,
                               v_passport_authority,
                               v_passport_issue_date,
                               v_nationality,
                               v_pax_type,
                               v_emergency_contact,
                               v_emergency_phone,
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
                     UPDATE D_CONTACT
                        SET ADDRESSID = V_ADDRESSID,
                            CUSTOMER_TYPE = V_CUSTOMER_TYPE,
                            MRKCONTACTS_PROFILE = V_MRKCONTACTS_PROFILE,
                            MRKCONTACTS_COMMENT = V_MRKCONTACTS_COMMENT,
                            DEFAULTBRAND = V_DEFAULTBRAND,
                            TAXID = V_TAXID,
                            GSTPER = V_GSTPER,
                            QCURRENCY = V_QCURRENCY,
                            PHONE = V_PHONE,
                            PHONE_EXT = V_PHONE_EXT,
                            MOBILE_PHONE = V_MOBILE_PHONE,
                            FAX = V_FAX,
                            EMAIL = V_EMAIL,
                            TERRITORY = V_TERRITORY,
                            STATUS = V_STATUS,
                            ORIGIN = V_ORIGIN,
                            LAST_NAME = V_LAST_NAME,
                            FIRST_NAME = V_FIRST_NAME,
                            CARE_OF = V_CARE_OF,
                            HOUSEHOLD_NAME = V_HOUSEHOLD_NAME,
                            GENDER = V_GENDER,
                            TITLE = V_TITLE,
                            MRKCONTACTS_BROADCAST = V_MRKCONTACTS_BROADCAST,
                            MAIL_BROADCAST = V_MAIL_BROADCAST,
                            CUSTOMERID = V_CUSTOMERID,
                            USEOK = V_USEOK,
                            COPYOK = V_COPYOK,
                            MANAGEOK = V_MANAGEOK,
                            BIRTHDATE = V_BIRTHDATE,
                            BIRTHPLACE = V_BIRTHPLACE,
                            AGE = V_AGE,
                            PASSPORT_NUMBER = V_PASSPORT_NUMBER,
                            PASSPORT_EXPIRATION = V_PASSPORT_EXPIRATION,
                            PASSPORT_AUTHORITY = V_PASSPORT_AUTHORITY,
                            PASSPORT_ISSUE_DATE = V_PASSPORT_ISSUE_DATE,
                            NATIONALITY = V_NATIONALITY,
                            PAX_TYPE = V_PAX_TYPE,
                            EMERGENCY_CONTACT = V_EMERGENCY_CONTACT,
                            EMERGENCY_PHONE = V_EMERGENCY_PHONE,
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
                  INSERT INTO R_cont_rej_rec (customer_id,
                                              addressid,
                                              customer_type,
                                              mrkcontacts_profile,
                                              mrkcontacts_comment,
                                              defaultbrand,
                                              taxid,
                                              gstper,
                                              qcurrency,
                                              phone,
                                              phone_ext,
                                              mobile_phone,
                                              fax,
                                              email,
                                              territory,
                                              status,
                                              origin,
                                              last_name,
                                              first_name,
                                              care_of,
                                              household_name,
                                              gender,
                                              title,
                                              mrkcontacts_broadcast,
                                              mail_broadcast,
                                              customerid,
                                              useok,
                                              copyok,
                                              manageok,
                                              birthdate,
                                              birthplace,
                                              age,
                                              passport_number,
                                              passport_expiration,
                                              passport_authority,
                                              passport_issue_date,
                                              nationality,
                                              pax_type,
                                              emergency_contact,
                                              emergency_phone,
                                              created_by,
                                              created_date,
                                              whostamp,
                                              datestamp)
                       VALUES (v_customer_id,
                               v_addressid,
                               v_customer_type,
                               v_mrkcontacts_profile,
                               v_mrkcontacts_comment,
                               v_defaultbrand,
                               v_taxid,
                               v_gstper,
                               v_qcurrency,
                               v_phone,
                               v_phone_ext,
                               v_mobile_phone,
                               v_fax,
                               v_email,
                               v_territory,
                               v_status,
                               v_origin,
                               v_last_name,
                               v_first_name,
                               v_care_of,
                               v_household_name,
                               v_gender,
                               v_title,
                               v_mrkcontacts_broadcast,
                               v_mail_broadcast,
                               v_customerid,
                               v_useok,
                               v_copyok,
                               v_manageok,
                               v_birthdate,
                               v_birthplace,
                               v_age,
                               v_passport_number,
                               v_passport_expiration,
                               v_passport_authority,
                               v_passport_issue_date,
                               v_nationality,
                               v_pax_type,
                               v_emergency_contact,
                               v_emergency_phone,
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
                    VALUES ('L_CONT',
                            'D_CONTACT',
                            SYSDATE,
                            SUBSTR (v_code, 1, 50),
                            SUBSTR (v_error_message, 1, 250));

               --
               -- Write error record
               INSERT INTO R_cont_rej_rec (customer_id,
                                           addressid,
                                           customer_type,
                                           mrkcontacts_profile,
                                           mrkcontacts_comment,
                                           defaultbrand,
                                           taxid,
                                           gstper,
                                           qcurrency,
                                           phone,
                                           phone_ext,
                                           mobile_phone,
                                           fax,
                                           email,
                                           territory,
                                           status,
                                           origin,
                                           last_name,
                                           first_name,
                                           care_of,
                                           household_name,
                                           gender,
                                           title,
                                           mrkcontacts_broadcast,
                                           mail_broadcast,
                                           customerid,
                                           useok,
                                           copyok,
                                           manageok,
                                           birthdate,
                                           birthplace,
                                           age,
                                           passport_number,
                                           passport_expiration,
                                           passport_authority,
                                           passport_issue_date,
                                           nationality,
                                           pax_type,
                                           emergency_contact,
                                           emergency_phone,
                                           created_by,
                                           created_date,
                                           whostamp,
                                           datestamp)
                    VALUES (v_customer_id,
                            v_addressid,
                            v_customer_type,
                            v_mrkcontacts_profile,
                            v_mrkcontacts_comment,
                            v_defaultbrand,
                            v_taxid,
                            v_gstper,
                            v_qcurrency,
                            v_phone,
                            v_phone_ext,
                            v_mobile_phone,
                            v_fax,
                            v_email,
                            v_territory,
                            v_status,
                            v_origin,
                            v_last_name,
                            v_first_name,
                            v_care_of,
                            v_household_name,
                            v_gender,
                            v_title,
                            v_mrkcontacts_broadcast,
                            v_mail_broadcast,
                            v_customerid,
                            v_useok,
                            v_copyok,
                            v_manageok,
                            v_birthdate,
                            v_birthplace,
                            v_age,
                            v_passport_number,
                            v_passport_expiration,
                            v_passport_authority,
                            v_passport_issue_date,
                            v_nationality,
                            v_pax_type,
                            v_emergency_contact,
                            v_emergency_phone,
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
              VALUES ('L_CONT',
                      'D_CONTACT',
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
           VALUES ('L_CONT',
                   'D_CONTACT',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));

      --
      COMMIT;
--
END;                                        /**** < OPEN Cursor Block  > ****/
/
SHOW ERRORS;
