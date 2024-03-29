SET DEFINE OFF;
CREATE TABLE L_ACCBEGBAL
(
  COMPANYID  VARCHAR2(10 BYTE),
  ACCOUNTID  VARCHAR2(15 BYTE),
  ACCTNAME   VARCHAR2(80 BYTE),
  BEGYEAR    NUMBER(4),
  BEGMONTH   NUMBER(4),
  BEGBAL     NUMBER(18,2),
  CHANGE     NUMBER(18,2),
  ENDBAL     NUMBER(18,2),
  WHOSTAMP   VARCHAR2(50 BYTE),
  DATESTAMP  DATE
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
