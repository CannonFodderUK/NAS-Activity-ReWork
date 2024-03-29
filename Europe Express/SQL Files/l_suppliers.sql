SET DEFINE OFF;
CREATE TABLE L_SUPPLIERS
(
  SUPPLIERID         VARCHAR2(50 BYTE),
  SUPPLIERNAME       VARCHAR2(255 BYTE),
  DOCADDRESS1        VARCHAR2(100 BYTE),
  DOCADDRESS2        VARCHAR2(100 BYTE),
  DOCADDRESS3        VARCHAR2(100 BYTE),
  DOCCOUNTRY         VARCHAR2(20 BYTE),
  BILLADDRESS1       VARCHAR2(100 BYTE),
  BILLADDRESS2       VARCHAR2(100 BYTE),
  BILLADDRESS3       VARCHAR2(100 BYTE),
  BILLCOUNTRY        VARCHAR2(20 BYTE),
  DOCCONTACT         VARCHAR2(255 BYTE),
  DOCPHONE           VARCHAR2(30 BYTE),
  DOCFAX             VARCHAR2(30 BYTE),
  DOCEMAIL           VARCHAR2(100 BYTE),
  DOCEMERGENCYPHONE  VARCHAR2(30 BYTE),
  CONTRACTTHRU       VARCHAR2(20 BYTE),
  PAYCURRENCY        VARCHAR2(3 BYTE),
  COMMMETHOD         VARCHAR2(40 BYTE),
  SUPPLIERRATING     VARCHAR2(20 BYTE),
  LOCATIONZONE       VARCHAR2(500 BYTE),
  LOCATIONGROUP      VARCHAR2(100 BYTE),
  WEBSITE            VARCHAR2(140 BYTE),
  BILLINFO           VARCHAR2(250 BYTE),
  VCHRDESC           VARCHAR2(300 BYTE),
  DESCRIPTION        VARCHAR2(1000 BYTE),
  OPSCONTACT         VARCHAR2(255 BYTE),
  OPSPHONE           VARCHAR2(30 BYTE),
  OPSFAX             VARCHAR2(30 BYTE),
  OPSEMAIL           VARCHAR2(80 BYTE),
  TOURCONTACT        VARCHAR2(255 BYTE),
  TOURPHONE          VARCHAR2(30 BYTE),
  TOURFAX            VARCHAR2(30 BYTE),
  TOUREMAIL          VARCHAR2(80 BYTE),
  GROUPCONTACT       VARCHAR2(255 BYTE),
  GROUPPHONE         VARCHAR2(30 BYTE),
  GROUPFAX           VARCHAR2(30 BYTE),
  GROUPEMAIL         VARCHAR2(80 BYTE),
  ACCCONTACT         VARCHAR2(255 BYTE),
  ACCPHONE           VARCHAR2(30 BYTE),
  ACCFAX             VARCHAR2(30 BYTE),
  ACCEMAIL           VARCHAR2(80 BYTE),
  CONTRACTCONTACT    VARCHAR2(255 BYTE),
  CONTRACTPHONE      VARCHAR2(30 BYTE),
  CONTRACTFAX        VARCHAR2(30 BYTE),
  CONTRACTEMAIL      VARCHAR2(80 BYTE),
  EMERGENCYPHONE     VARCHAR2(30 BYTE),
  PREPAY             VARCHAR2(6 BYTE),
  TAXID              VARCHAR2(20 BYTE),
  TYPE               VARCHAR2(10 BYTE),
  BILLNAME           VARCHAR2(255 BYTE),
  DEFAULTGL          VARCHAR2(20 BYTE),
  ADDITIONALINFO     CLOB,
  BANKACCTNUM        VARCHAR2(20 BYTE),
  BANKCODE           VARCHAR2(50 BYTE),
  BANKNAME           VARCHAR2(30 BYTE),
  BANKBRANCH         VARCHAR2(15 BYTE),
  BANKIBAN           VARCHAR2(20 BYTE),
  BANKIC             VARCHAR2(20 BYTE),
  TAXCERTNUM         VARCHAR2(20 BYTE),
  TAXCERTEXP         DATE,
  PAYTYPE            VARCHAR2(1 BYTE),
  WHOSTAMP           VARCHAR2(50 BYTE),
  DATESTAMP          DATE
)
LOB (ADDITIONALINFO) STORE AS (
  TABLESPACE  DTW_ADV_TABLES
  ENABLE      STORAGE IN ROW
  CHUNK       16384
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          80K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                  FLASH_CACHE      DEFAULT
                  CELL_FLASH_CACHE DEFAULT
                 ))
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
