SET DEFINE OFF;
CREATE TABLE L_ANALYTICS_DATA
(
  DATAID         NUMBER,
  BRAND          VARCHAR2(50 BYTE),
  AD_SOURCE      VARCHAR2(50 BYTE),
  AD_MEDIUM      VARCHAR2(50 BYTE),
  PAGEVIEWS      NUMBER,
  UNIQUE_VISITS  NUMBER,
  NEW_VISITS     NUMBER,
  VISITS         NUMBER,
  BOUNCES        NUMBER,
  TIME_ON_SITE   NUMBER,
  RUNDATE        DATE
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
