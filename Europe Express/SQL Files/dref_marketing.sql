SET DEFINE OFF;
CREATE TABLE DREF_MARKETING
(
  BORA            VARCHAR2(20 BYTE),
  GLCODE          VARCHAR2(20 BYTE),
  FISCALYEAR      VARCHAR2(20 BYTE),
  CALENDAR_MONTH  VARCHAR2(15 BYTE),
  MPERIOD         VARCHAR2(15 BYTE),
  WEEK            VARCHAR2(15 BYTE),
  DIVISION        VARCHAR2(10 BYTE),
  CHANNEL         VARCHAR2(50 BYTE),
  BRAND           VARCHAR2(10 BYTE),
  SUPPLIER        VARCHAR2(50 BYTE),
  ACTUAL          VARCHAR2(50 BYTE),
  DESCRIPTION     VARCHAR2(100 BYTE),
  OFFERDATE       VARCHAR2(50 BYTE),
  OFFER           VARCHAR2(100 BYTE),
  PRICE           VARCHAR2(50 BYTE),
  MARKETCODE      VARCHAR2(50 BYTE),
  CLICKS          VARCHAR2(50 BYTE),
  IMPRESSIONS     VARCHAR2(50 BYTE),
  CTR             VARCHAR2(50 BYTE),
  AVGCPC          VARCHAR2(50 BYTE),
  COSTPERGOOGLE   VARCHAR2(50 BYTE),
  AVGPOSITION     VARCHAR2(50 BYTE),
  SOURCE_TYPE     VARCHAR2(50 BYTE),
  MKT_MEDIUM      VARCHAR2(50 BYTE),
  BUDGET          VARCHAR2(50 BYTE),
  AFFILIATE       VARCHAR2(50 BYTE),
  CUSTOMER        VARCHAR2(50 BYTE),
  GROUPTYPE       VARCHAR2(50 BYTE)
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