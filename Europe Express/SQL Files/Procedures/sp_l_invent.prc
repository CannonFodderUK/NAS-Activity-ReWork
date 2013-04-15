SET DEFINE OFF;
/* Formatted on 16/01/2013 11:25:38 (QP5 v5.227.12220.39724) */
CREATE OR REPLACE PROCEDURE sp_l_invent
AS
   -- DECLARE /*****  D E C L A R E  S E C T I O N  *****/
   --===========================================================
   -- SP_L_INVENT - which takes the contents of F_INVENTORY
   -- and populates the L_INVENTORY table
   --
   --===========================================================
   -- Change History
   --===========================================================
   -- Date          Ver Who Comment
   -- 11-Jan-13     1.0 tthmlx  Original Version
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
   v_block_code           F_INVENTORY.BLOCK_CODE%TYPE;
   v_inventory_date_id    F_INVENTORY.INVENTORY_DATE_ID%TYPE;
   v_contracted           F_INVENTORY.CONTRACTED%TYPE;
   v_allotted             F_INVENTORY.ALLOTTED%TYPE;
   v_available            F_INVENTORY.AVAILABLE%TYPE;
   v_state                F_INVENTORY.STATE%TYPE;
   v_release_day          F_INVENTORY.RELEASE_DAY%TYPE;
   v_rstate               F_INVENTORY.RSTATE%TYPE;
   v_assetid              F_INVENTORY.ASSETID%TYPE;
   v_shares               F_INVENTORY.SHARES%TYPE;
   v_block_cap            F_INVENTORY.BLOCK_CAP%TYPE;
   v_block_cap_type       F_INVENTORY.BLOCK_CAP_TYPE%TYPE;
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
      SELECT LI.BLOCKCODE BLOCK_CODE,
             TO_NUMBER (TO_CHAR (LI.IDATE, 'yyyymmdd'), '00000000')
                INVENTORY_DATE,
             LI.CONTRACTED,
             LI.ALLOTTED,
             LI.AVAILABLE,
             LI.STATE,
             LI.RELEASEDAY RELEASE_DAY,
             LI.RSTATE,
             LI.ASSETID,
             LI.SHARES,
             LI.BLOCKCAP BLOCK_CAP,
             LI.BLOCKCAPTYPE BLOCK_CAP_TYPE
        FROM L_INVENTORY LI, L_INVENTORY_DIFF LD
       WHERE LI.BLOCKCODE = LD.BLOCK_CODE AND LI.IDATE = LD.INVENTORY_DATE;

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
            INTO v_block_code,
                 v_inventory_date_id,
                 v_contracted,
                 v_allotted,
                 v_available,
                 v_state,
                 v_release_day,
                 v_rstate,
                 v_assetid,
                 v_shares,
                 v_block_cap,
                 v_block_cap_type;

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
                  INSERT INTO f_inventory (block_code,
                                           inventory_date_id,
                                           contracted,
                                           allotted,
                                           available,
                                           state,
                                           release_day,
                                           rstate,
                                           assetid,
                                           shares,
                                           block_cap,
                                           block_cap_type)
                       VALUES (v_block_code,
                               v_inventory_date_id,
                               v_contracted,
                               v_allotted,
                               v_available,
                               v_state,
                               v_release_day,
                               v_rstate,
                               v_assetid,
                               v_shares,
                               v_block_cap,
                               v_block_cap_type);

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
                     UPDATE F_INVENTORY
                        SET CONTRACTED = V_CONTRACTED,
                            ALLOTTED = V_ALLOTTED,
                            AVAILABLE = V_AVAILABLE,
                            STATE = V_STATE,
                            RELEASE_DAY = V_RELEASE_DAY,
                            RSTATE = V_RSTATE,
                            ASSETID = V_ASSETID,
                            SHARES = V_SHARES,
                            BLOCK_CAP = V_BLOCK_CAP,
                            BLOCK_CAP_TYPE = V_BLOCK_CAP_TYPE
                      WHERE     BLOCK_CODE = V_BLOCK_CODE
                            AND INVENTORY_DATE_ID = V_INVENTORY_DATE_ID;

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
                  INSERT INTO R_invent_rej_rec (block_code,
                                                inventory_date_id,
                                                contracted,
                                                allotted,
                                                available,
                                                state,
                                                release_day,
                                                rstate,
                                                assetid,
                                                shares,
                                                block_cap,
                                                block_cap_type)
                       VALUES (v_block_code,
                               v_inventory_date_id,
                               v_contracted,
                               v_allotted,
                               v_available,
                               v_state,
                               v_release_day,
                               v_rstate,
                               v_assetid,
                               v_shares,
                               v_block_cap,
                               v_block_cap_type);

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
                    VALUES ('L_INVENT',
                            'F_INVENTORY',
                            SYSDATE,
                            SUBSTR (v_code, 1, 50),
                            SUBSTR (v_error_message, 1, 250));

               --
               -- Write error record
               INSERT INTO R_invent_rej_rec (block_code,
                                             inventory_date_id,
                                             contracted,
                                             allotted,
                                             available,
                                             state,
                                             release_day,
                                             rstate,
                                             assetid,
                                             shares,
                                             block_cap,
                                             block_cap_type)
                    VALUES (v_block_code,
                            v_inventory_date_id,
                            v_contracted,
                            v_allotted,
                            v_available,
                            v_state,
                            v_release_day,
                            v_rstate,
                            v_assetid,
                            v_shares,
                            v_block_cap,
                            v_block_cap_type);
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
              VALUES ('L_INVENT',
                      'F_INVENTORY',
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
           VALUES ('L_INVENT',
                   'F_INVENTORY',
                   SYSDATE,
                   SUBSTR (v_code, 1, 50),
                   SUBSTR (v_error_message, 1, 250));

      --
      COMMIT;
--
END;                                        /**** < OPEN Cursor Block  > ****/
/
SHOW ERRORS;
