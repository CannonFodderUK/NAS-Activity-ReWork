SET DEFINE OFF;
CREATE TABLE L_MARKETING
(
  BORA            CHAR(20 BYTE),
  GLCODE          CHAR(20 BYTE),
  FISCALYEAR      CHAR(20 BYTE),
  CALENDAR_MONTH  CHAR(15 BYTE),
  MPERIOD         CHAR(15 BYTE),
  WEEK            CHAR(15 BYTE),
  DIVISION        CHAR(10 BYTE),
  CHANNEL         CHAR(50 BYTE),
  BRAND           CHAR(10 BYTE),
  SUPPLIER        CHAR(50 BYTE),
  ACTUAL          CHAR(50 BYTE),
  DESCRIPTION     CHAR(100 BYTE),
  OFFERDATE       CHAR(50 BYTE),
  OFFER           CHAR(100 BYTE),
  PRICE           CHAR(50 BYTE),
  MARKETCODE      CHAR(50 BYTE),
  CLICKS          CHAR(50 BYTE),
  IMPRESSIONS     CHAR(50 BYTE),
  CTR             CHAR(50 BYTE),
  AVGCPC          CHAR(50 BYTE),
  COSTPERGOOGLE   CHAR(50 BYTE),
  AVGPOSITION     CHAR(50 BYTE),
  SOURCE_TYPE     CHAR(50 BYTE),
  MEDIUM          CHAR(50 BYTE),
  BUDGET          CHAR(50 BYTE),
  AFFILIATE       CHAR(50 BYTE),
  CUSTOMER        CHAR(50 BYTE),
  GROUPTYPE       CHAR(50 BYTE)
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
