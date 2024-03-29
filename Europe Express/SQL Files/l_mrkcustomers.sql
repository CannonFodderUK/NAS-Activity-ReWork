SET DEFINE OFF;
CREATE TABLE L_MRKCUSTOMERS
(
  CUSTOMERID             VARCHAR2(15 BYTE),
  CUSTOMERNAME           VARCHAR2(100 BYTE),
  CUSTOMERTYPE           VARCHAR2(50 BYTE),
  ADDRESSID              NUMBER(12),
  PHONE                  VARCHAR2(30 BYTE),
  MOBILEPHONE            VARCHAR2(30 BYTE),
  FAX                    VARCHAR2(30 BYTE),
  EMAIL                  VARCHAR2(50 BYTE),
  AFFILIATIONID          VARCHAR2(20 BYTE),
  COMMCODE               VARCHAR2(20 BYTE),
  TERRITORY              VARCHAR2(50 BYTE),
  STATUS                 VARCHAR2(10 BYTE),
  ORIGIN                 VARCHAR2(255 BYTE),
  TAXID                  VARCHAR2(20 BYTE),
  GSTPER                 VARCHAR2(10 BYTE),
  COMMPAYPER             VARCHAR2(10 BYTE),
  QCURRENCY              VARCHAR2(3 BYTE),
  MRKCUSTOMERS_PROFILE   VARCHAR2(50 BYTE),
  DEFAULTBRAND           VARCHAR2(10 BYTE),
  MRKCUSTOMERS_PASSWORD  VARCHAR2(20 BYTE),
  HINT                   VARCHAR2(30 BYTE),
  MRKCUSTOMERS_COMMENT   VARCHAR2(1000 BYTE),
  LASTBROCHURES          VARCHAR2(250 BYTE),
  CREDITSTATUS           VARCHAR2(40 BYTE),
  CREATEDBY              VARCHAR2(30 BYTE),
  CREATEDDATE            DATE,
  WHOSTAMP               VARCHAR2(50 BYTE),
  DATESTAMP              DATE
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
