SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:40 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_L_user
AS
   -- DECLARE /*****  D E C L A R E  S E C T I O N  *****/
   --===========================================================
   -- SP_USER - which takes the contents of D_USER
   -- and populates the D_USER table
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
   v_userid               D_USER.USERID%TYPE;
   v_username             D_USER.USERNAME%TYPE;
   v_agentname            D_USER.AGENTNAME%TYPE;
   v_teamname             D_USER.TEAMNAME%TYPE;
   v_agenttype            D_USER.AGENTTYPE%TYPE;
   v_leaderid             D_USER.LEADERID%TYPE;
   v_leadername           D_USER.LEADERNAME%TYPE;
   v_email                D_USER.EMAIL%TYPE;
   v_address1             D_USER.ADDRESS1%TYPE;
   v_address2             D_USER.ADDRESS2%TYPE;
   v_city                 D_USER.CITY%TYPE;
   v_state                D_USER.STATE%TYPE;
   v_zip                  D_USER.ZIP%TYPE;
   v_phone                D_USER.PHONE%TYPE;
   v_mobile_phone         D_USER.MOBILE_PHONE%TYPE;
   v_phoneext             D_USER.PHONEEXT%TYPE;
   v_birthdate            D_USER.BIRTHDATE%TYPE;
   v_ssnum                D_USER.SSNUM%TYPE;
   v_hiredate             D_USER.HIREDATE%TYPE;
   v_terminationdate      D_USER.TERMINATIONDATE%TYPE;
   v_userhoursorig        D_USER.USERHOURSORIG%TYPE;
   v_userhoursused        D_USER.USERHOURSUSED%TYPE;
   v_salarytype           D_USER.SALARYTYPE%TYPE;
   v_department           D_USER.DEPARTMENT%TYPE;
   v_useractive           D_USER.USERACTIVE%TYPE;
   v_defaultbrand         D_USER.DEFAULTBRAND%TYPE;
   v_user_comment         D_USER.USER_COMMENT%TYPE;
   v_subsystems           D_USER.SUBSYSTEMS%TYPE;
   v_brands               D_USER.BRANDS%TYPE;
   v_user_profile         D_USER.USER_PROFILE%TYPE;
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
      SELECT DISTINCT lu.USERID,
                      lu.USERNAME,
                      rtm.AGENTNAME,
                      rtm.TEAMNAME,
                      rtm.AGENTTYPE,
                      rt.LEADERID,
                      rt.LEADERNAME,
                      lu.EMAIL,
                      lu.ADDRESS1,
                      lu.ADDRESS2,
                      lu.CITY,
                      lu.STATE,
                      lu.ZIP,
                      lu.PHONE,
                      lu.MOBILE_PHONE,
                      lu.PHONEEXT,
                      lu.BIRTHDATE,
                      lu.SSNUM,
                      lu.HIREDATE,
                      lu.TERMINATIONDATE,
                      lu.USERHOURSORIG,
                      lu.USERHOURSUSED,
                      lu.SALARYTYPE,
                      lu.DEPARTMENT,
                      lu.USERACTIVE,
                      lu.DEFAULTBRAND,
                      lu.USER_COMMENT,
                      lu.SUBSYSTEMS,
                      lu.BRANDS,
                      lu.USER_PROFILE
        FROM l_users lu, l_ResTeamMembers rtm, l_ResTeams rt
       WHERE lu.UserID = rtm.AgentID(+) AND rtm.TeamName = rt.TeamName(+);

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
            INTO v_userid,
                 v_username,
                 v_agentname,
                 v_teamname,
                 v_agenttype,
                 v_leaderid,
                 v_leadername,
                 v_email,
                 v_address1,
                 v_address2,
                 v_city,
                 v_state,
                 v_zip,
                 v_phone,
                 v_mobile_phone,
                 v_phoneext,
                 v_birthdate,
                 v_ssnum,
                 v_hiredate,
                 v_terminationdate,
                 v_userhoursorig,
                 v_userhoursused,
                 v_salarytype,
                 v_department,
                 v_useractive,
                 v_defaultbrand,
                 v_user_comment,
                 v_subsystems,
                 v_brands,
                 v_user_profile;

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
                  INSERT INTO d_user (userid,
                                      username,
                                      agentname,
                                      teamname,
                                      agenttype,
                                      leaderid,
                                      leadername,
                                      email,
                                      address1,
                                      address2,
                                      city,
                                      state,
                                      zip,
                                      phone,
                                      mobile_phone,
                                      phoneext,
                                      birthdate,
                                      ssnum,
                                      hiredate,
                                      terminationdate,
                                      userhoursorig,
                                      userhoursused,
                                      salarytype,
                                      department,
                                      useractive,
                                      defaultbrand,
                                      user_comment,
                                      subsystems,
                                      brands,
                                      user_profile)
                       VALUES (v_userid,
                               v_username,
                               v_agentname,
                               v_teamname,
                               v_agenttype,
                               v_leaderid,
                               v_leadername,
                               v_email,
                               v_address1,
                               v_address2,
                               v_city,
                               v_state,
                               v_zip,
                               v_phone,
                               v_mobile_phone,
                               v_phoneext,
                               v_birthdate,
                               v_ssnum,
                               v_hiredate,
                               v_terminationdate,
                               v_userhoursorig,
                               v_userhoursused,
                               v_salarytype,
                               v_department,
                               v_useractive,
                               v_defaultbrand,
                               v_user_comment,
                               v_subsystems,
                               v_brands,
                               v_user_profile);

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
                     UPDATE D_USER
                        SET USERNAME = V_USERNAME,
                            AGENTNAME = V_AGENTNAME,
                            TEAMNAME = V_TEAMNAME,
                            AGENTTYPE = V_AGENTTYPE,
                            LEADERID = V_LEADERID,
                            LEADERNAME = V_LEADERNAME,
                            EMAIL = V_EMAIL,
                            ADDRESS1 = V_ADDRESS1,
                            ADDRESS2 = V_ADDRESS2,
                            CITY = V_CITY,
                            STATE = V_STATE,
                            ZIP = V_ZIP,
                            PHONE = V_PHONE,
                            MOBILE_PHONE = V_MOBILE_PHONE,
                            PHONEEXT = V_PHONEEXT,
                            BIRTHDATE = V_BIRTHDATE,
                            SSNUM = V_SSNUM,
                            HIREDATE = V_HIREDATE,
                            TERMINATIONDATE = V_TERMINATIONDATE,
                            USERHOURSORIG = V_USERHOURSORIG,
                            USERHOURSUSED = V_USERHOURSUSED,
                            SALARYTYPE = V_SALARYTYPE,
                            DEPARTMENT = V_DEPARTMENT,
                            USERACTIVE = V_USERACTIVE,
                            DEFAULTBRAND = V_DEFAULTBRAND,
                            USER_COMMENT = V_USER_COMMENT,
                            SUBSYSTEMS = V_SUBSYSTEMS,
                            BRANDS = V_BRANDS,
                            USER_PROFILE = V_USER_PROFILE
                      WHERE USERID = V_USERID;

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
                  INSERT INTO R_user_rej_rec (userid,
                                              username,
                                              agentname,
                                              teamname,
                                              agenttype,
                                              leaderid,
                                              leadername,
                                              email,
                                              address1,
                                              address2,
                                              city,
                                              state,
                                              zip,
                                              phone,
                                              mobile_phone,
                                              phoneext,
                                              birthdate,
                                              ssnum,
                                              hiredate,
                                              terminationdate,
                                              userhoursorig,
                                              userhoursused,
                                              salarytype,
                                              department,
                                              useractive,
                                              defaultbrand,
                                              user_comment,
                                              subsystems,
                                              brands,
                                              user_profile)
                       VALUES (v_userid,
                               v_username,
                               v_agentname,
                               v_teamname,
                               v_agenttype,
                               v_leaderid,
                               v_leadername,
                               v_email,
                               v_address1,
                               v_address2,
                               v_city,
                               v_state,
                               v_zip,
                               v_phone,
                               v_mobile_phone,
                               v_phoneext,
                               v_birthdate,
                               v_ssnum,
                               v_hiredate,
                               v_terminationdate,
                               v_userhoursorig,
                               v_userhoursused,
                               v_salarytype,
                               v_department,
                               v_useractive,
                               v_defaultbrand,
                               v_user_comment,
                               v_subsystems,
                               v_brands,
                               v_user_profile);

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
                    VALUES ('USER',
                            'D_USER',
                            SYSDATE,
                            SUBSTR (v_code, 1, 50),
                            SUBSTR (v_error_message, 1, 250));

               --
               -- Write error record
               INSERT INTO R_user_rej_rec (userid,
                                           username,
                                           agentname,
                                           teamname,
                                           agenttype,
                                           leaderid,
                                           leadername,
                                           email,
                                           address1,
                                           address2,
                                           city,
                                           state,
                                           zip,
                                           phone,
                                           mobile_phone,
                                           phoneext,
                                           birthdate,
                                           ssnum,
                                           hiredate,
                                           terminationdate,
                                           userhoursorig,
                                           userhoursused,
                                           salarytype,
                                           department,
                                           useractive,
                                           defaultbrand,
                                           user_comment,
                                           subsystems,
                                           brands,
                                           user_profile)
                    VALUES (v_userid,
                            v_username,
                            v_agentname,
                            v_teamname,
                            v_agenttype,
                            v_leaderid,
                            v_leadername,
                            v_email,
                            v_address1,
                            v_address2,
                            v_city,
                            v_state,
                            v_zip,
                            v_phone,
                            v_mobile_phone,
                            v_phoneext,
                            v_birthdate,
                            v_ssnum,
                            v_hiredate,
                            v_terminationdate,
                            v_userhoursorig,
                            v_userhoursused,
                            v_salarytype,
                            v_department,
                            v_useractive,
                            v_defaultbrand,
                            v_user_comment,
                            v_subsystems,
                            v_brands,
                            v_user_profile);
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
              VALUES ('USER',
                      'D_USER',
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
           VALUES ('USER',
                   'D_USER',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));

      --
      COMMIT;
--
END;                                        /**** < OPEN Cursor Block  > ****/
/
SHOW ERRORS;
