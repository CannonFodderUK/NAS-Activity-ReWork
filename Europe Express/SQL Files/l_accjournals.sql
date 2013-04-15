SET DEFINE OFF;
CREATE TABLE L_ACCJOURNALS
(
  COMPANYID                 VARCHAR2(10 BYTE),
  JOURNALID                 VARCHAR2(15 BYTE),
  JOURNALTYPE               VARCHAR2(1 BYTE),
  JOURNALNAME               VARCHAR2(30 BYTE),
  POSTTOGL                  VARCHAR2(15 BYTE),
  POSTTOGLNAME              VARCHAR2(85 BYTE),
  POSTTOGLTYPE              VARCHAR2(1 BYTE),
  AFFECTONGL                VARCHAR2(1 BYTE),
  ACTIVE                    VARCHAR2(1 BYTE),
  GLADJUSTMENT              VARCHAR2(15 BYTE),
  GLADJUSTMENTNAME          VARCHAR2(85 BYTE),
  GLADJUSTMENTTYPE          VARCHAR2(1 BYTE),
  EXCHANGEADJUSTMENTGL      VARCHAR2(15 BYTE),
  EXCHANGEADJUSTMENTGLNAME  VARCHAR2(85 BYTE),
  EXCHANGEADJUSTMENTGLTYPE  VARCHAR2(1 BYTE),
  DISBURSEFROMGL            VARCHAR2(15 BYTE),
  DISBURSEFROMGLNAME        VARCHAR2(85 BYTE),
  DISBURSEFROMGLTYPE        VARCHAR2(1 BYTE),
  COMMPAY                   VARCHAR2(1 BYTE),
  INVPAY                    VARCHAR2(1 BYTE),
  ARCASPAYABLE              VARCHAR2(1 BYTE),
  CURRENCY                  VARCHAR2(3 BYTE),
  APPLYCASHDISCOUNT         VARCHAR2(1 BYTE),
  ADDITIONALDATA            VARCHAR2(2000 BYTE),
  WHOSTAMP                  VARCHAR2(50 BYTE),
  DATESTAMP                 DATE
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