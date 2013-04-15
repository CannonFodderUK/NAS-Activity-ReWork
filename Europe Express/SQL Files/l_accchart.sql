SET DEFINE OFF;
CREATE TABLE L_ACCCHART
(
  COMPANYID      VARCHAR2(10 BYTE),
  ACCOUNTID      VARCHAR2(15 BYTE),
  ACCOUNTNAME    VARCHAR2(85 BYTE),
  STATEMENTID    VARCHAR2(3 BYTE),
  BALTYPE        VARCHAR2(1 BYTE),
  EXPORTACCOUNT  VARCHAR2(20 BYTE),
  ACTIVE         VARCHAR2(1 BYTE),
  WHOSTAMP       VARCHAR2(50 BYTE),
  DATESTAMP      DATE
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
