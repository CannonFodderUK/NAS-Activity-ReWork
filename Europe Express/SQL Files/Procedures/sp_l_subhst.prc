SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:39 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_l_subhst
AS
   -- DECLARE /*****  D E C L A R E  S E C T I O N  *****/
   --===========================================================
   -- SP_L_SUBHST - which takes the contents of L_MRKSUBSCRIPTIONHISTORY
   -- and populates the F_SUBSCRIPTION_HISTORY table
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
   v_history_id           F_SUBSCRIPTION_HISTORY.HISTORY_ID%TYPE;
   v_list_id              F_SUBSCRIPTION_HISTORY.LIST_ID%TYPE;
   v_recipient            F_SUBSCRIPTION_HISTORY.RECIPIENT%TYPE;
   v_sub_date             F_SUBSCRIPTION_HISTORY.SUB_DATE%TYPE;
   v_sub_process          F_SUBSCRIPTION_HISTORY.SUB_PROCESS%TYPE;
   v_sub_event            F_SUBSCRIPTION_HISTORY.SUB_EVENT%TYPE;
   v_sub_origin           F_SUBSCRIPTION_HISTORY.SUB_ORIGIN%TYPE;
   v_unsub_date           F_SUBSCRIPTION_HISTORY.UNSUB_DATE%TYPE;
   v_unsub_process        F_SUBSCRIPTION_HISTORY.UNSUB_PROCESS%TYPE;
   v_unsub_event          F_SUBSCRIPTION_HISTORY.UNSUB_EVENT%TYPE;
   v_unsub_origin         F_SUBSCRIPTION_HISTORY.UNSUB_ORIGIN%TYPE;
   v_sub_ip_address       F_SUBSCRIPTION_HISTORY.SUB_IP_ADDRESS%TYPE;
   v_unsub_ip_address     F_SUBSCRIPTION_HISTORY.UNSUB_IP_ADDRESS%TYPE;
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
      SELECT HISTORYID HISTORY_ID,
             LISTID LIST_ID,
             SUBSTR (RECIPIENT,
                     8,
                       INSTR (RECIPIENT,
                              '<',
                              1,
                              2)
                     - 8)
                RECIPIENT,
             SUBDATE SUB_DATE,
             SUBPROCESS SUB_PROCESS,
             SUBEVENT SUB_EVENT,
             SUBORIGIN SUB_ORIGIN,
             UNSUBDATE UNSUB_DATE,
             UNSUBPROCESS UNSUB_PROCESS,
             UNSUBEVENT UNSUB_EVENT,
             UNSUBORIGIN UNSUB_ORIGIN,
             SUBIP SUB_IP_ADDRESS,
             UNSUBIP UNSUB_IP_ADDRESS
        FROM L_MRKSUBSCRIPTIONHISTORY;

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
            INTO v_history_id,
                 v_list_id,
                 v_recipient,
                 v_sub_date,
                 v_sub_process,
                 v_sub_event,
                 v_sub_origin,
                 v_unsub_date,
                 v_unsub_process,
                 v_unsub_event,
                 v_unsub_origin,
                 v_sub_ip_address,
                 v_unsub_ip_address;

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
                  INSERT INTO f_subscription_history (history_id,
                                                      list_id,
                                                      recipient,
                                                      sub_date,
                                                      sub_process,
                                                      sub_event,
                                                      sub_origin,
                                                      unsub_date,
                                                      unsub_process,
                                                      unsub_event,
                                                      unsub_origin,
                                                      sub_ip_address,
                                                      unsub_ip_address)
                       VALUES (v_history_id,
                               v_list_id,
                               v_recipient,
                               v_sub_date,
                               v_sub_process,
                               v_sub_event,
                               v_sub_origin,
                               v_unsub_date,
                               v_unsub_process,
                               v_unsub_event,
                               v_unsub_origin,
                               v_sub_ip_address,
                               v_unsub_ip_address);

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
                     UPDATE F_SUBSCRIPTION_HISTORY
                        SET LIST_ID = V_LIST_ID,
                            RECIPIENT = V_RECIPIENT,
                            SUB_DATE = V_SUB_DATE,
                            SUB_PROCESS = V_SUB_PROCESS,
                            SUB_EVENT = V_SUB_EVENT,
                            SUB_ORIGIN = V_SUB_ORIGIN,
                            UNSUB_DATE = V_UNSUB_DATE,
                            UNSUB_PROCESS = V_UNSUB_PROCESS,
                            UNSUB_EVENT = V_UNSUB_EVENT,
                            UNSUB_ORIGIN = V_UNSUB_ORIGIN,
                            SUB_IP_ADDRESS = V_SUB_IP_ADDRESS,
                            UNSUB_IP_ADDRESS = V_UNSUB_IP_ADDRESS
                      WHERE HISTORY_ID = V_HISTORY_ID;

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
                  INSERT INTO R_subhst_rej_rec (history_id,
                                                list_id,
                                                recipient,
                                                sub_date,
                                                sub_process,
                                                sub_event,
                                                sub_origin,
                                                unsub_date,
                                                unsub_process,
                                                unsub_event,
                                                unsub_origin,
                                                sub_ip_address,
                                                unsub_ip_address)
                       VALUES (v_history_id,
                               v_list_id,
                               v_recipient,
                               v_sub_date,
                               v_sub_process,
                               v_sub_event,
                               v_sub_origin,
                               v_unsub_date,
                               v_unsub_process,
                               v_unsub_event,
                               v_unsub_origin,
                               v_sub_ip_address,
                               v_unsub_ip_address);

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
                    VALUES ('L_SUBHST',
                            'F_SUBSCRIPTION_HISTORY',
                            SYSDATE,
                            SUBSTR (v_code, 1, 50),
                            SUBSTR (v_error_message, 1, 250));

               --
               -- Write error record
               INSERT INTO R_subhst_rej_rec (history_id,
                                             list_id,
                                             recipient,
                                             sub_date,
                                             sub_process,
                                             sub_event,
                                             sub_origin,
                                             unsub_date,
                                             unsub_process,
                                             unsub_event,
                                             unsub_origin,
                                             sub_ip_address,
                                             unsub_ip_address)
                    VALUES (v_history_id,
                            v_list_id,
                            v_recipient,
                            v_sub_date,
                            v_sub_process,
                            v_sub_event,
                            v_sub_origin,
                            v_unsub_date,
                            v_unsub_process,
                            v_unsub_event,
                            v_unsub_origin,
                            v_sub_ip_address,
                            v_unsub_ip_address);
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
              VALUES ('L_SUBHST',
                      'F_SUBSCRIPTION_HISTORY',
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
           VALUES ('L_SUBHST',
                   'F_SUBSCRIPTION_HISTORY',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));

      --
      COMMIT;
--
END;                                        /**** < OPEN Cursor Block  > ****/
/
SHOW ERRORS;
