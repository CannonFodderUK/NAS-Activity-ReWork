SET DEFINE OFF;
CREATE TABLE R_ACTRDET_REJ_REC
(
  TRANS_NUMBER         NUMBER(18),
  LEG_NUMBER           NUMBER(10),
  GL_NUMBER            VARCHAR2(20 BYTE),
  GL_NAME              VARCHAR2(85 BYTE),
  AFFECT_ON_GL         VARCHAR2(1 BYTE),
  LOCAL_AMOUNT_DETAIL  NUMBER(18,2),
  BASE_AMOUNT_DETAIL   NUMBER(18,2),
  TD_REF               VARCHAR2(50 BYTE),
  CLEARED              VARCHAR2(1 BYTE),
  CLEARED_PERIOD       NUMBER(10)
)
TABLESPACE DTW_ADV_TABLES
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          80K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;
