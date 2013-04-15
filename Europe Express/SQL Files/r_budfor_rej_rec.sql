SET DEFINE OFF;
CREATE TABLE R_BUDFOR_REJ_REC
(
  FISCAL_YEAR      NUMBER(10),
  BF_PERIOD        NUMBER(3),
  BRAND_ID         VARCHAR2(10 BYTE),
  GL_NUMBER        VARCHAR2(50 BYTE),
  COMPANY          VARCHAR2(10 BYTE),
  BF_MONTH         VARCHAR2(15 BYTE),
  CHANNEL          VARCHAR2(10 BYTE),
  DIVISION         VARCHAR2(10 BYTE),
  CLASIFICATION    VARCHAR2(50 BYTE),
  GROUP_TYPE       VARCHAR2(100 BYTE),
  AFFILIATION_ID   VARCHAR2(50 BYTE),
  GL_NAME          VARCHAR2(100 BYTE),
  BUDGET_AMOUNT    NUMBER(19,4),
  BUDGET_PAX       NUMBER(10),
  FORECAST_AMOUNT  NUMBER(19,4),
  FORECAST_PAX     NUMBER(10)
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
