SET DEFINE OFF;
CREATE TABLE L_MRKSURVEY
(
  SURVEYID        VARCHAR2(80 BYTE),
  NAME            VARCHAR2(250 BYTE),
  DESCRIPTION     VARCHAR2(500 BYTE),
  PROMOTIONID     VARCHAR2(20 BYTE),
  BRANDS          VARCHAR2(250 BYTE),
  ADDITIONALDATA  VARCHAR2(4000 BYTE),
  WHOSTAMP        VARCHAR2(250 BYTE),
  DATESTAMP       DATE
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
